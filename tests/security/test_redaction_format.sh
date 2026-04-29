#!/usr/bin/env bash
# tests/security/test_redaction_format.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
REDACT="$SCRIPT_DIR/../../skills/osint-research/lib/secret-redactor.sh"

echo "== test_redaction_format =="

# AWS key: AKIA + 16 chars (20 total) → AKIA...XYZW
got=$(printf 'AKIAIOSFODNN7EXAMPLE' | bash "$REDACT")
assert_contains "$got" "AKIA...MPLE" "aws first-4-last-4 form"
[ "${#got}" -le 13 ] && \
    { echo "  PASS truncated to ≤13 chars"; ASSERT_PASS=$((ASSERT_PASS+1)); } || \
    { echo "  FAIL truncated form too long: ${#got}"; ASSERT_FAIL=$((ASSERT_FAIL+1)); }

# Short pattern (private key marker) → <REDACTED:label>
got=$(printf '%s' '-----BEGIN RSA PRIVATE KEY-----' | bash "$REDACT")
assert_contains "$got" "<REDACTED:private_key_pem>" "marker form for short patterns"

assert_summary
