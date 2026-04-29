#!/usr/bin/env bash
# tests/lib/test_inbound-filter.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/asserts.sh"
FILTER="$SCRIPT_DIR/../../skills/osint-research/lib/inbound-filter.sh"

echo "== test_inbound-filter =="

input='{"url":"https://example.com/page","content":"hello"}
{"url":"https://pastebin.com/abc123","content":"leak"}
{"url":"https://archive.pastebin.com/xyz","content":"leak2"}
{"url":"https://example.com/x","content":"go to dehashed.com for more"}
{"url":"https://safe.com/y","content":"plain content"}'

got_stdout=$(printf '%s' "$input" | bash "$FILTER" 2>/tmp/inbound-filter-err)
got_stderr=$(cat /tmp/inbound-filter-err)
rm -f /tmp/inbound-filter-err

assert_contains "$got_stdout" "example.com/page" "clean url passes"
assert_contains "$got_stdout" "safe.com/y" "another clean url passes"
assert_not_contains "$got_stdout" "pastebin.com/abc123" "blocklisted host dropped"
assert_not_contains "$got_stdout" "archive.pastebin.com" "blocklisted subdomain dropped"
assert_not_contains "$got_stdout" "dehashed.com for more" "blocklisted ref in content dropped"
assert_contains "$got_stderr" "filtered=3" "filter count reported"

# --- Fix #1 — malformed OSINT_EXTRA_BLOCKLIST does not disable filter ---
# Inject a token containing regex metacharacters. The filter MUST still block
# hardcoded defaults (pastebin.com).
got_stdout=$(printf '%s' '{"url":"https://pastebin.com/x","content":"y"}' \
    | OSINT_EXTRA_BLOCKLIST='evil.com; echo PWNED' bash "$FILTER" 2>/tmp/inbound-filter-err2)
got_stderr=$(cat /tmp/inbound-filter-err2)
rm -f /tmp/inbound-filter-err2
assert_eq "$got_stdout" "" "malformed extra-blocklist still blocks pastebin"
assert_contains "$got_stderr" "filtered=1" "malformed extra-blocklist reports filter count"

# --- Fix #2 — userinfo URLs are still blocked by host pattern ---
got_stdout=$(printf '%s' '{"url":"https://user:pass@pastebin.com/x","content":"y"}' \
    | bash "$FILTER" 2>/tmp/inbound-filter-err3)
got_stderr=$(cat /tmp/inbound-filter-err3)
rm -f /tmp/inbound-filter-err3
assert_eq "$got_stdout" "" "userinfo URL with blocklisted host is dropped"
assert_contains "$got_stderr" "filtered=1" "userinfo URL filter count"

# --- Fix #3 — escaped JSON quote in content does NOT hide blocklisted host ---
# Naive [^"]* extraction stops at the first " (including JSON-escaped \").
# An attacker controlling scraped content could prepend \"X to push a
# blocklisted reference past the truncation point. The fix uses proper
# JSON parsing to capture the full JSON string body.
input_escaped='{"url":"https://safe.com/x","content":"prefix \"injected\" then dehashed.com link"}'
got_stdout=$(printf '%s' "$input_escaped" | bash "$FILTER" 2>/tmp/inbound-filter-err4)
got_stderr=$(cat /tmp/inbound-filter-err4)
rm -f /tmp/inbound-filter-err4
assert_eq "$got_stdout" "" "blocklisted host after escaped \" in content is dropped"
assert_contains "$got_stderr" "filtered=1" "escaped-quote bypass filter count"

# Same defense for url field — escaped quote inside URL value should not
# prevent host extraction from the (still-correct) URL prefix.
input_url_esc='{"url":"https://pastebin.com/path\"weird","content":"safe text"}'
got_stdout=$(printf '%s' "$input_url_esc" | bash "$FILTER" 2>/tmp/inbound-filter-err5)
got_stderr=$(cat /tmp/inbound-filter-err5)
rm -f /tmp/inbound-filter-err5
assert_eq "$got_stdout" "" "url with escaped quote — host still extracted and blocked"

# --- Fix #4 — JSON-escaped slashes in URL (\/) do NOT hide blocklisted host ---
# JSON allows \/ as a valid escape for /. The naive perl ^https?:// regex
# fails on https:\/\/pastebin.com\/x, leaving host empty and the URL
# block check skipped. Proper JSON parsing decodes \/ before host
# extraction.
input_slash='{"url":"https:\/\/pastebin.com\/x","content":"y"}'
got_stdout=$(printf '%s' "$input_slash" | bash "$FILTER" 2>/tmp/inbound-filter-err6)
got_stderr=$(cat /tmp/inbound-filter-err6)
rm -f /tmp/inbound-filter-err6
assert_eq "$got_stdout" "" "url with escaped slashes — host still extracted and blocked"
assert_contains "$got_stderr" "filtered=1" "escaped-slash bypass filter count"

# --- Fix #5 — JSON unicode escape (\u00XX) in content does NOT hide hostname ---
# pastebin.com is the JSON encoding of pastebin.com. Proper JSON parse
# decodes it before regex matching.
input_unicode='{"url":"https://safe.com/x","content":"see pastebin.com for leak"}'
got_stdout=$(printf '%s' "$input_unicode" | bash "$FILTER" 2>/tmp/inbound-filter-err7)
got_stderr=$(cat /tmp/inbound-filter-err7)
rm -f /tmp/inbound-filter-err7
assert_eq "$got_stdout" "" "content with \u escape — hostname still detected"
assert_contains "$got_stderr" "filtered=1" "unicode-escape bypass filter count"

# --- Fix #6 — same defense in url field via unicode escape ---
input_url_uni='{"url":"https://pastebin.com/x","content":"y"}'
got_stdout=$(printf '%s' "$input_url_uni" | bash "$FILTER" 2>/tmp/inbound-filter-err8)
got_stderr=$(cat /tmp/inbound-filter-err8)
rm -f /tmp/inbound-filter-err8
assert_eq "$got_stdout" "" "url with \u escape in host — still blocked"

# --- Malformed JSON is dropped (not passed through uninspectable) ---
input_bad='not valid json at all'
got_stdout=$(printf '%s' "$input_bad" | bash "$FILTER" 2>/tmp/inbound-filter-err9)
got_stderr=$(cat /tmp/inbound-filter-err9)
rm -f /tmp/inbound-filter-err9
assert_eq "$got_stdout" "" "malformed JSON line is dropped (cannot inspect)"
assert_contains "$got_stderr" "filtered=1" "malformed JSON counted as filtered"

# --- Fix #7 — URL host bypasses via port / query / fragment / trailing-dot ---
# Earlier [^/]+ host capture was anchored only on / so any non-slash trailing
# character (port, ?, #, ;, .) made the host_re $ anchor fail. Replaced with
# urllib.parse.urlparse which returns the canonical hostname stripped of all
# of these. Defensive: lowercase + strip trailing dot.

# Port number on host
got=$(printf '%s' '{"url":"https://pastebin.com:443/x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "host with port (:443) still blocked"

# Query string immediately after host
got=$(printf '%s' '{"url":"https://pastebin.com?q=foo","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "host with query string still blocked"

# Fragment immediately after host
got=$(printf '%s' '{"url":"https://pastebin.com#frag","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "host with fragment still blocked"

# Trailing dot (FQDN root)
got=$(printf '%s' '{"url":"https://pastebin.com./x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "host with trailing dot still blocked"

# Port on subdomain of blocklisted host
got=$(printf '%s' '{"url":"https://x.pastebin.com:8080/y","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "subdomain with port still blocked"

# Capitalised host (urlparse already lowercases hostname; defense-in-depth)
got=$(printf '%s' '{"url":"https://PASTEBIN.COM/x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "uppercase host still blocked"

# Capitalised scheme
got=$(printf '%s' '{"url":"HTTPS://pastebin.com/x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "uppercase scheme still blocked"

# --- Negative — non-blocklisted host with a port still passes ---
got=$(printf '%s' '{"url":"https://example.com:8080/x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_contains "$got" "example.com" "clean host with port passes through"

# --- Negative — string ending in blocklisted host but not a subdomain ---
# notexample.com vs example.com — ensure (?:^|\.) anchor still rejects.
# Replace example.com with pastebin.com to test against the actual blocklist.
got=$(printf '%s' '{"url":"https://notpastebin.com/x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_contains "$got" "notpastebin.com" "host that only suffix-matches blocklisted is NOT blocked"

# --- Fix #8 — RFC 3986 sub-delims in hostname must not bypass blocklist ---
# urlparse preserves sub-delims (;,=$+!*()) inside hostname per spec.
# Without the URL substring fallback, pastebin.com;params would yield
# captured host "pastebin.com;params" which fails the (?:^|\.)host$ anchor.
# The fallback content_re scan over the full URL string catches it via
# word boundaries (\b).

got=$(printf '%s' '{"url":"https://pastebin.com;params/x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "host with semicolon (;) still blocked"

got=$(printf '%s' '{"url":"https://pastebin.com,extra/x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "host with comma (,) still blocked"

got=$(printf '%s' '{"url":"https://pastebin.com=foo/x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "host with equals (=) still blocked"

got=$(printf '%s' '{"url":"https://pastebin.com$junk/x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "host with dollar (\$) still blocked"

got=$(printf '%s' '{"url":"https://pastebin.com;junk:443/y","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "host with semicolon and port still blocked"

# --- Fix #9 — non-http schemes containing blocklisted host are blocked ---
# extract_host returns '' for non-http(s). The URL substring fallback
# catches blocklisted host appearing anywhere in the URL string.
got=$(printf '%s' '{"url":"ftp://pastebin.com/x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "ftp:// scheme with blocklisted host blocked"

got=$(printf '%s' '{"url":"gopher://pastebin.com/x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "gopher:// scheme with blocklisted host blocked"

# --- Negative — substring without word boundary should NOT block ---
# Word-boundary semantics: pastebin.commodity.com has no \b between m and
# o (both word chars), so pastebin.com substring does NOT word-match.
got=$(printf '%s' '{"url":"https://pastebin.commodity.com/x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_contains "$got" "pastebin.commodity.com" "substring without \\b boundary is NOT blocked"

assert_summary
