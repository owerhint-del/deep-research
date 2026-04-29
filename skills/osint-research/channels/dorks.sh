#!/usr/bin/env bash
# skills/osint-research/channels/dorks.sh
# Emits one Google-dork query per line on stdout. Refuses blocklisted hosts.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Reuse the same blocklist source as inbound-filter.
DEFAULT_BLOCKLIST="pastebin.com paste.ee ghostbin.com hastebin.com justpaste.it paste.org ix.io \
breached.cc breachforums.is breachforums.st raidforums.com cracked.io \
dehashed.com leakcheck.io intelx.io leak-lookup.com \
doxbin.com doxbin.org doxbin.net \
ddosecrets.com distributeddenialofsecrets.com \
nulled.to leakix.net snusbase.com weleakinfo.to"

EXTRA="${OSINT_EXTRA_BLOCKLIST:-}"
EXTRA="${EXTRA//,/ }"

# Validate extra tokens (only hostname-shaped strings allowed); silently skip bad tokens.
# Lowercase user-supplied tokens so OSINT_EXTRA_BLOCKLIST=Foo.com matches target foo.com.
BLOCKLIST="$DEFAULT_BLOCKLIST"
for h in $EXTRA; do
    [ -z "$h" ] && continue
    h=$(printf '%s' "$h" | tr '[:upper:]' '[:lower:]')
    [[ "$h" =~ ^[a-zA-Z0-9.-]+$ ]] || continue
    BLOCKLIST="$BLOCKLIST $h"
done

is_blocklisted() {
    local host="$1"
    for b in $BLOCKLIST; do
        if [[ "$host" == "$b" || "$host" == *".$b" ]]; then
            return 0
        fi
    done
    return 1
}

ENTITY_TYPE=""
TARGET=""
EXTRA_SITE=""

while [ $# -gt 0 ]; do
    case "$1" in
        --type) ENTITY_TYPE="$2"; shift 2;;
        --target) TARGET="$2"; shift 2;;
        --extra-site) EXTRA_SITE="$2"; shift 2;;
        *) echo "unknown flag: $1" >&2; exit 1;;
    esac
done

if [ -z "$ENTITY_TYPE" ] || [ -z "$TARGET" ]; then
    echo "usage: dorks.sh --type <domain|ip|email|person|company|github> --target <value> [--extra-site <host>]" >&2
    exit 1
fi

# Reject targets/extra-sites containing characters that would break dork structure.
# (Quote injection would let an attacker inject arbitrary search operators.)
case "$TARGET" in
    *\"*|*\\*|*$'\n'*) echo "dorks: --target contains forbidden character (quote/backslash/newline)" >&2; exit 1;;
esac
case "$EXTRA_SITE" in
    *\"*|*\\*|*$'\n'*) echo "dorks: --extra-site contains forbidden character (quote/backslash/newline)" >&2; exit 1;;
esac

# Normalize for blocklist comparison (hostnames are case-insensitive).
# Use tr for bash 3.2 compatibility (macOS ships bash 3.2).
TARGET_LC=$(printf '%s' "$TARGET" | tr '[:upper:]' '[:lower:]')
EXTRA_SITE_LC=$(printf '%s' "$EXTRA_SITE" | tr '[:upper:]' '[:lower:]')

if is_blocklisted "$TARGET_LC"; then
    echo "dorks: target is blocklisted: $TARGET" >&2
    exit 2
fi

if [ -n "$EXTRA_SITE" ] && is_blocklisted "$EXTRA_SITE_LC"; then
    echo "dorks: --extra-site is blocklisted: $EXTRA_SITE" >&2
    exit 2
fi

case "$ENTITY_TYPE" in
    domain|company)
        printf 'site:linkedin.com/in "%s"\n' "$TARGET"
        printf 'site:github.com "%s"\n' "$TARGET"
        printf '"%s" filetype:pdf\n' "$TARGET"
        printf '"%s" inurl:admin\n' "$TARGET"
        printf '"%s" intext:"powered by"\n' "$TARGET"
        ;;
    email)
        printf '"%s" -site:linkedin.com\n' "$TARGET"
        printf '"%s" intext:"contact"\n' "$TARGET"
        ;;
    person)
        printf 'site:linkedin.com/in "%s"\n' "$TARGET"
        printf 'site:github.com "%s"\n' "$TARGET"
        printf '"%s" "interview" OR "speaker"\n' "$TARGET"
        ;;
    ip)
        printf '"%s" intext:"server"\n' "$TARGET"
        ;;
    github)
        printf 'site:github.com "%s"\n' "$TARGET"
        ;;
    *)
        echo "dorks: unknown entity type: $ENTITY_TYPE" >&2
        exit 1
        ;;
esac

if [ -n "$EXTRA_SITE" ]; then
    printf 'site:%s "%s"\n' "$EXTRA_SITE" "$TARGET"
fi
