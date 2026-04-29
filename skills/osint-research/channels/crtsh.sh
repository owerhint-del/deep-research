#!/usr/bin/env bash
# skills/osint-research/channels/crtsh.sh
# Queries crt.sh for Certificate Transparency entries → unique subdomains.

set -uo pipefail

ENTITY_TYPE=""
TARGET=""
FIXTURE=""
while [ $# -gt 0 ]; do
    case "$1" in
        --type) ENTITY_TYPE="$2"; shift 2;;
        --target) TARGET="$2"; shift 2;;
        --fixture) FIXTURE="$2"; shift 2;;
        *) echo "crtsh: unknown flag: $1" >&2; exit 1;;
    esac
done

if [ -z "$TARGET" ]; then
    echo "crtsh: empty target" >&2
    exit 1
fi

case "$ENTITY_TYPE" in
    domain|company) ;;
    *) echo "crtsh: not applicable for $ENTITY_TYPE" >&2; exit 0;;
esac

if [ -n "$FIXTURE" ]; then
    json=$(cat "$FIXTURE")
else
    json=$(curl -fsSL --max-time 30 "https://crt.sh/?q=%25.${TARGET}&output=json" 2>/dev/null || echo "[]")
fi

# Extract unique subdomain names. name_value can contain newline-separated multi-SAN entries.
# Write python script to a temp file so we can feed json via stdin (heredoc conflicts with pipe).
_py_tmp=$(mktemp /tmp/crtsh_XXXXXX.py)
trap 'rm -f "$_py_tmp"' EXIT
cat > "$_py_tmp" <<'PY'
import json, sys
target = sys.argv[1]
try:
    data = json.loads(sys.stdin.read())
except Exception:
    sys.exit(0)
seen = set()
for entry in data:
    nv = entry.get("name_value", "")
    for name in nv.split("\n"):
        name = name.strip().lstrip("*.")
        if name and name not in seen and (name == target or name.endswith('.' + target)):
            seen.add(name)
            url = f"https://crt.sh/?q=%25.{target}"
            out = {
                "channel": "crtsh",
                "record_type": "subdomain",
                "url": url,
                "content": name,
                "metadata": {"target": target}
            }
            print(json.dumps(out, separators=(',', ':')))
PY
printf '%s' "$json" | python3 "$_py_tmp" "$TARGET"
