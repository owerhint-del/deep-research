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

# Fix #1: bad pattern → exit 2, stderr message, NO stdout (fail-closed)
TMPDIR_BAD="$(mktemp -d)"
cat > "$TMPDIR_BAD/bad.txt" <<'EOF'
good_aws|AKIA[0-9A-Z]{16}
broken|[unclosed
EOF
got_stdout=$(printf 'AKIAIOSFODNN7EXAMPLE in config' | OSINT_SECRET_PATTERNS="$TMPDIR_BAD/bad.txt" bash "$REDACT" 2>/dev/null)
got_exit=$?
assert_exit_code 2 $got_exit "bad pattern exits 2"
assert_eq "$got_stdout" "" "bad pattern produces no stdout (fail-closed)"
got_stderr=$(printf 'AKIAIOSFODNN7EXAMPLE in config' | OSINT_SECRET_PATTERNS="$TMPDIR_BAD/bad.txt" bash "$REDACT" 2>&1 >/dev/null)
assert_contains "$got_stderr" "broken" "stderr mentions failing pattern label"
rm -rf "$TMPDIR_BAD"

# Fix #2: input containing old __SEP__ literal is preserved
got=$(printf 'before\n__SEP__\nafter' | bash "$REDACT")
assert_contains "$got" "__SEP__" "literal __SEP__ in input is preserved (boundary token changed)"
assert_contains "$got" "before" "before-line preserved"
assert_contains "$got" "after" "after-line preserved"

# Bonus: missing patterns file → exit 2
got_exit=0
OSINT_SECRET_PATTERNS=/nonexistent/path bash "$REDACT" </dev/null >/dev/null 2>&1 || got_exit=$?
assert_exit_code 2 $got_exit "missing patterns file exits 2"

assert_summary
