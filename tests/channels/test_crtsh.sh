#!/usr/bin/env bash
# tests/channels/test_crtsh.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
CRT="$SCRIPT_DIR/../../skills/osint-research/channels/crtsh.sh"

echo "== test_crtsh =="

# Mocked mode — skill supports --fixture for testing
fixture='[{"name_value":"www.example.com\nmail.example.com"},{"name_value":"api.example.com"}]'
got=$(bash "$CRT" --type domain --target example.com --fixture <(printf '%s' "$fixture"))

assert_contains "$got" "www.example.com" "extracts www subdomain"
assert_contains "$got" "mail.example.com" "extracts mail subdomain"
assert_contains "$got" "api.example.com" "extracts api subdomain"
assert_contains "$got" '"channel":"crtsh"' "channel label"

bash "$CRT" --type domain --target "" >/dev/null 2>&1
assert_exit_code 1 $? "empty target fails"

# Critical regression: notexample.com must NOT match target example.com
bad_fixture='[{"name_value":"notexample.com\nlegit.example.com"}]'
bad_got=$(bash "$CRT" --type domain --target example.com --fixture <(printf '%s' "$bad_fixture"))
assert_not_contains "$bad_got" "notexample.com" "rejects suffix-but-not-subdomain"
assert_contains "$bad_got" "legit.example.com" "still extracts legitimate subdomain"

assert_summary
