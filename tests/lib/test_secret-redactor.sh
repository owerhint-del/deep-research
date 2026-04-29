#!/usr/bin/env bash
# tests/lib/test_secret-redactor.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/asserts.sh"
REDACT="$SCRIPT_DIR/../../skills/osint-research/lib/secret-redactor.sh"

echo "== test_secret-redactor =="

got=$(printf 'AKIAIOSFODNN7EXAMPLE in config' | bash "$REDACT")
assert_contains "$got" "AKIA...MPLE" "aws access key truncated"
assert_not_contains "$got" "IOSFODNN7EXA" "aws middle removed"

got=$(printf 'token=ghp_abcdefghijklmnopqrstuvwxyz0123456789' | bash "$REDACT")
assert_contains "$got" "ghp_...6789" "github pat truncated"
assert_not_contains "$got" "abcdefghij" "github pat middle removed"

got=$(printf '%s' '-----BEGIN RSA PRIVATE KEY-----' | bash "$REDACT")
assert_contains "$got" "<REDACTED:private_key_pem>" "private key marker"

got=$(printf 'just plain text, no secrets here' | bash "$REDACT")
assert_eq "$got" "just plain text, no secrets here" "no-op on clean text"

assert_summary
