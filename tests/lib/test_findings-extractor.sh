#!/usr/bin/env bash
# tests/lib/test_findings-extractor.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/asserts.sh"
FE="$SCRIPT_DIR/../../skills/osint-research/lib/findings-extractor.sh"

echo "== test_findings-extractor =="

input='{"channel":"shodan-idb","record_type":"open_port","content":"port 6379 open on 1.2.3.4","metadata":{"port":6379}}
{"channel":"github-leaks","record_type":"code_match","content":"AWS_KEY=AKIA...MPLE in config","metadata":{"repo":"x/y"}}
{"channel":"shodan-idb","record_type":"cve","content":"CVE-2021-23017 detected","metadata":{}}
{"channel":"crtsh","record_type":"subdomain","content":"www.example.com","metadata":{}}
{"channel":"crtsh","record_type":"subdomain","content":"admin-staging.example.com","metadata":{}}'

got=$(printf '%s' "$input" | bash "$FE")

assert_contains "$got" '"priority":"CRITICAL"' "critical present"
assert_contains "$got" '"priority":"HIGH"' "high present"
assert_contains "$got" '"priority":"LOW"' "low present (regular subdomain)"
assert_contains "$got" "port 6379" "redis port flagged"
assert_contains "$got" "admin-staging" "suspicious subdomain flagged"

assert_summary
