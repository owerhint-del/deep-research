#!/usr/bin/env bash
# skills/osint-research/channels/shodan-idb.sh
# Queries free InternetDB endpoint. No auth required.

set -uo pipefail

TARGET=""
FIXTURE=""
FIXTURE_STATUS=200
while [ $# -gt 0 ]; do
    case "$1" in
        --target) TARGET="$2"; shift 2;;
        --fixture) FIXTURE="$2"; shift 2;;
        --fixture-status) FIXTURE_STATUS="$2"; shift 2;;
        *) echo "shodan-idb: unknown flag: $1" >&2; exit 1;;
    esac
done

[ -z "$TARGET" ] && { echo "shodan-idb: empty target" >&2; exit 1; }

if [ -n "$FIXTURE" ]; then
    json=$(cat "$FIXTURE")
    status="$FIXTURE_STATUS"
else
    body=$(curl -sS -w '\n%{http_code}' --max-time 20 "https://internetdb.shodan.io/${TARGET}" 2>/dev/null || echo $'\n000')
    json=$(printf '%s' "$body" | sed '$d')
    status=$(printf '%s' "$body" | tail -n1)
fi

# 404 = "no data on this IP", not an error — silent success.
[ "$status" = "404" ] && exit 0

# Plan defect #1 fix: heredoc + pipe conflict — write script to tmp file instead.
_py_tmp=$(mktemp)
trap 'rm -f "$_py_tmp"' EXIT
cat > "$_py_tmp" <<'PY'
import json, sys
target = sys.argv[1]
try:
    data = json.loads(sys.stdin.read())
except Exception:
    sys.exit(0)
if "detail" in data and "ports" not in data:
    sys.exit(0)
url = f"https://internetdb.shodan.io/{target}"
# Plan defect #2 fix: compact separators throughout to match test assertions.
SEP = (',', ':')
for port in data.get("ports", []):
    print(json.dumps({
        "channel": "shodan-idb",
        "record_type": "open_port",
        "url": url,
        "content": f"port {port} open on {target}",
        "metadata": {"target": target, "port": port}
    }, separators=SEP))
for vuln in data.get("vulns", []):
    print(json.dumps({
        "channel": "shodan-idb",
        "record_type": "cve",
        "url": url,
        "content": f"{vuln} detected on {target}",
        "metadata": {"target": target, "cve": vuln}
    }, separators=SEP))
for h in data.get("hostnames", []):
    print(json.dumps({
        "channel": "shodan-idb",
        "record_type": "hostname",
        "url": url,
        "content": h,
        "metadata": {"target": target, "hostname": h}
    }, separators=SEP))
PY
printf '%s' "$json" | python3 "$_py_tmp" "$TARGET"
