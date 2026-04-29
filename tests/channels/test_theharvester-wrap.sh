#!/usr/bin/env bash
# tests/channels/test_theharvester-wrap.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
TH="$SCRIPT_DIR/../../skills/osint-research/channels/theharvester-wrap.sh"

echo "== test_theharvester-wrap =="

# Fixture mode: simulate theHarvester JSON output
fixture='{"emails":["alice@example-corp.com","bob@example-corp.com"],"hosts":["api.example-corp.com"]}'
got=$(bash "$TH" --type domain --target example-corp.com --fixture <(printf '%s' "$fixture"))

assert_contains "$got" "alice@example-corp.com" "email parsed"
assert_contains "$got" "api.example-corp.com" "host parsed"
assert_contains "$got" '"channel":"theharvester"' "channel label"

# Missing CLI mode: should silently exit 0
# Use absolute /bin/bash so PATH=/nonexistent doesn't prevent launching bash itself.
got_missing=$(PATH=/nonexistent /bin/bash "$TH" --type domain --target example.com 2>&1 || true)
# Either silent or contains explicit not-installed message — but exit 0
PATH=/nonexistent /bin/bash "$TH" --type domain --target example.com >/dev/null 2>&1
assert_exit_code 0 $? "graceful skip when CLI missing"

assert_summary
