#!/usr/bin/env bash
# tests/channels/test_wayback.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
WB="$SCRIPT_DIR/../../skills/osint-research/channels/wayback.sh"

echo "== test_wayback =="

fixture='{"archived_snapshots":{"closest":{"available":true,"url":"http://web.archive.org/web/20140812000000/http://example.com","timestamp":"20140812000000","status":"200"}}}'
got=$(bash "$WB" --type domain --target example.com --fixture <(printf '%s' "$fixture"))

assert_contains "$got" "20140812" "timestamp parsed"
assert_contains "$got" '"channel":"wayback"' "channel label"
assert_contains "$got" "example.com" "target referenced"

assert_summary
