#!/usr/bin/env bash
# tests/channels/test_dorks.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
DORKS="$SCRIPT_DIR/../../skills/osint-research/channels/dorks.sh"

echo "== test_dorks =="

got=$(bash "$DORKS" --type domain --target example.com 2>/dev/null)
assert_contains "$got" "site:linkedin.com" "produces linkedin dork for domain"
assert_contains "$got" "site:github.com" "produces github dork for domain"
assert_contains "$got" "example.com" "includes target in dorks"

bash "$DORKS" --type domain --target pastebin.com >/dev/null 2>&1
assert_exit_code 2 $? "rejects blocklisted target"

# Inject a blocklisted operator via custom flag (simulating malicious input)
bash "$DORKS" --type domain --target example.com --extra-site "dehashed.com" >/dev/null 2>&1
assert_exit_code 2 $? "rejects blocklisted --extra-site"

assert_summary
