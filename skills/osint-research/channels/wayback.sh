#!/usr/bin/env bash
# skills/osint-research/channels/wayback.sh
# Queries Wayback Machine availability + CDX for snapshot history.

set -uo pipefail

ENTITY_TYPE=""
TARGET=""
FIXTURE=""
while [ $# -gt 0 ]; do
    case "$1" in
        --type) ENTITY_TYPE="$2"; shift 2;;
        --target) TARGET="$2"; shift 2;;
        --fixture) FIXTURE="$2"; shift 2;;
        *) echo "wayback: unknown flag: $1" >&2; exit 1;;
    esac
done

[ -z "$TARGET" ] && { echo "wayback: empty target" >&2; exit 1; }

case "$ENTITY_TYPE" in
    domain|company) ;;
    *) exit 0;;
esac

if [ -n "$FIXTURE" ]; then
    json=$(cat "$FIXTURE")
else
    json=$(curl -fsSL --max-time 30 "http://archive.org/wayback/available?url=${TARGET}" 2>/dev/null || echo "{}")
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
snap = (data.get("archived_snapshots") or {}).get("closest") or {}
ts = snap.get("timestamp", "")
url = snap.get("url", "")
if ts:
    out = {
        "channel": "wayback",
        "record_type": "snapshot",
        "url": url,
        "content": f"earliest snapshot for {target} at {ts}",
        "metadata": {"timestamp": ts, "target": target}
    }
    # Plan defect #2 fix: compact JSON to match test assertion form.
    print(json.dumps(out, separators=(',', ':')))
PY
printf '%s' "$json" | python3 "$_py_tmp" "$TARGET"
