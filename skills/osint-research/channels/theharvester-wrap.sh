#!/usr/bin/env bash
# skills/osint-research/channels/theharvester-wrap.sh
# Wraps theHarvester CLI (if installed). Optional channel — silent skip if missing.

set -uo pipefail

ENTITY_TYPE=""
TARGET=""
FIXTURE=""
while [ $# -gt 0 ]; do
    case "$1" in
        --type) ENTITY_TYPE="$2"; shift 2;;
        --target) TARGET="$2"; shift 2;;
        --fixture) FIXTURE="$2"; shift 2;;
        *) echo "theharvester-wrap: unknown flag: $1" >&2; exit 1;;
    esac
done

[ -z "$TARGET" ] && { echo "theharvester-wrap: empty target" >&2; exit 1; }

case "$ENTITY_TYPE" in
    domain|company) ;;
    *) exit 0;;
esac

if [ -n "$FIXTURE" ]; then
    json=$(cat "$FIXTURE")
elif command -v theHarvester >/dev/null; then
    tmp=$(mktemp -d)
    theHarvester -d "$TARGET" -b duckduckgo -f "$tmp/out.json" >/dev/null 2>&1 || true
    if [ -s "$tmp/out.json" ]; then
        json=$(cat "$tmp/out.json")
    else
        json="{}"
    fi
    rm -rf "$tmp"
else
    # Optional CLI not present — silent skip.
    exit 0
fi

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
SEP = (',', ':')  # Plan defect #2 fix: compact JSON.
url = f"theharvester://{target}"
for em in data.get("emails", []):
    print(json.dumps({
        "channel": "theharvester",
        "record_type": "email",
        "url": url, "content": em,
        "metadata": {"target": target}
    }, separators=SEP))
for h in data.get("hosts", []):
    print(json.dumps({
        "channel": "theharvester",
        "record_type": "subdomain",
        "url": url, "content": h,
        "metadata": {"target": target}
    }, separators=SEP))
PY
printf '%s' "$json" | python3 "$_py_tmp" "$TARGET"
