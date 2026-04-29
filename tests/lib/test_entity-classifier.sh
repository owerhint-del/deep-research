#!/usr/bin/env bash
# tests/lib/test_entity-classifier.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/asserts.sh"
CLASSIFY="$SCRIPT_DIR/../../skills/osint-research/lib/entity-classifier.sh"

echo "== test_entity-classifier =="

assert_eq "$(bash "$CLASSIFY" example.com)" "domain" "domain detected"
assert_eq "$(bash "$CLASSIFY" sub.example.co.uk)" "domain" "subdomain.tld detected"
assert_eq "$(bash "$CLASSIFY" 8.8.8.8)" "ip" "IPv4 detected"
assert_eq "$(bash "$CLASSIFY" 2001:db8::1)" "ip" "IPv6 detected"
assert_eq "$(bash "$CLASSIFY" user@example.com)" "email" "email detected"
assert_eq "$(bash "$CLASSIFY" '"John Doe"')" "person" "quoted string is person"
assert_eq "$(bash "$CLASSIFY" '"John"')" "person" "single-quoted name is person"
assert_eq "$(bash "$CLASSIFY" --company '"Anthropic"')" "company" "explicit company flag"
assert_eq "$(bash "$CLASSIFY" github:anthropics)" "github" "github prefix"

bash "$CLASSIFY" "" >/dev/null 2>&1
assert_exit_code 1 $? "empty input fails"

assert_summary
