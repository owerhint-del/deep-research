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

# --- Fix C1 — case-insensitive blocklist ---
bash "$DORKS" --type domain --target PASTEBIN.COM >/dev/null 2>&1
assert_exit_code 2 $? "rejects uppercase blocklisted target"

bash "$DORKS" --type domain --target Archive.PasteBin.com >/dev/null 2>&1
assert_exit_code 2 $? "rejects mixed-case subdomain of blocklisted host"

# --- Fix C2 — OSINT_EXTRA_BLOCKLIST honored ---
OSINT_EXTRA_BLOCKLIST=evilcorp.test bash "$DORKS" --type domain --target evilcorp.test >/dev/null 2>&1
assert_exit_code 2 $? "honors OSINT_EXTRA_BLOCKLIST"

OSINT_EXTRA_BLOCKLIST=EvilCorp.Test bash "$DORKS" --type domain --target evilcorp.test >/dev/null 2>&1
assert_exit_code 2 $? "OSINT_EXTRA_BLOCKLIST is case-insensitive"

# Malformed extra-blocklist token doesn't disable defaults
OSINT_EXTRA_BLOCKLIST='evil.com; rm -rf /' bash "$DORKS" --type domain --target pastebin.com >/dev/null 2>&1
assert_exit_code 2 $? "malformed OSINT_EXTRA_BLOCKLIST does not disable default blocklist"

# --- Fix C3 — reject quote/backslash/newline in TARGET ---
bash "$DORKS" --type domain --target 'example.com" filetype:env' >/dev/null 2>&1
assert_exit_code 1 $? "rejects target with embedded quote"

bash "$DORKS" --type domain --target 'example.com\evil' >/dev/null 2>&1
assert_exit_code 1 $? "rejects target with embedded backslash"

bash "$DORKS" --type domain --target example.com --extra-site 'evil.com" intext:password' >/dev/null 2>&1
assert_exit_code 1 $? "rejects --extra-site with embedded quote"

assert_summary
