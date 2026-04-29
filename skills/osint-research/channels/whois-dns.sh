#!/usr/bin/env bash
# skills/osint-research/channels/whois-dns.sh
# Emits NDJSON per record: {"url":"<source>","channel":"whois-dns","record_type":"<>","content":"<>","metadata":{...}}

set -uo pipefail

ENTITY_TYPE=""
TARGET=""
while [ $# -gt 0 ]; do
    case "$1" in
        --type) ENTITY_TYPE="$2"; shift 2;;
        --target) TARGET="$2"; shift 2;;
        *) echo "whois-dns: unknown flag: $1" >&2; exit 1;;
    esac
done

if [ -z "$TARGET" ]; then
    echo "whois-dns: empty target" >&2
    exit 1
fi

emit() {
    local rtype="$1" url="$2" content="$3" extra="${4:-}"
    # JSON-escape content
    content_json=$(printf '%s' "$content" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read())[1:-1])' 2>/dev/null || printf '%s' "$content" | sed 's/\\/\\\\/g; s/"/\\"/g; s/	/\\t/g' | tr -d '\r' | tr '\n' ' ')
    if [ -n "$extra" ]; then
        printf '{"channel":"whois-dns","record_type":"%s","url":"%s","content":"%s","metadata":%s}\n' "$rtype" "$url" "$content_json" "$extra"
    else
        printf '{"channel":"whois-dns","record_type":"%s","url":"%s","content":"%s","metadata":{}}\n' "$rtype" "$url" "$content_json"
    fi
}

case "$ENTITY_TYPE" in
    domain|company)
        if command -v whois >/dev/null; then
            whois_out=$(whois "$TARGET" 2>/dev/null || true)
            [ -n "$whois_out" ] && emit "whois" "whois://$TARGET" "$whois_out"
        fi
        if command -v dig >/dev/null; then
            for rt in A AAAA NS MX TXT SOA; do
                rec=$(dig +short "$TARGET" "$rt" 2>/dev/null || true)
                if [ -n "$rec" ]; then
                    emit "dns_$rt" "dns://$TARGET/$rt" "$rec"
                fi
            done
        fi
        ;;
    ip)
        if command -v whois >/dev/null; then
            whois_out=$(whois "$TARGET" 2>/dev/null || true)
            [ -n "$whois_out" ] && emit "whois" "whois://$TARGET" "$whois_out"
        fi
        if command -v dig >/dev/null; then
            ptr=$(dig +short -x "$TARGET" 2>/dev/null || true)
            [ -n "$ptr" ] && emit "dns_PTR" "dns://$TARGET/PTR" "$ptr"
        fi
        ;;
    *)
        echo "whois-dns: not applicable for entity type: $ENTITY_TYPE" >&2
        exit 0
        ;;
esac
