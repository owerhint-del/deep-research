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

# --- Fix #10 — underscore-boundary bypasses + sibling-domain over-block ---
# After switching to extract_host (urlparse + LDH-prefix trim) for the URL
# check and dropping the full-URL substring fallback, two boundary bugs
# are gone:
#   1. \b in Python regex doesn't fire between word chars and underscore,
#      so a URL fallback scan would miss _pastebin.com / pastebin.com_evil.
#      The new path doesn't scan URL substrings — it parses the actual
#      hostname, which is _pastebin.com (different real host, not blocked).
#   2. The fallback over-blocked pastebin.com.au — a real Australian
#      domain — because \bpastebin\.com\b matched the substring. The new
#      path extracts hostname pastebin.com.au and host_re's $-anchor
#      correctly rejects it (suffix is .au not pastebin.com).

# Underscore-prefixed: actually different host, not pastebin.com — pass through
got=$(printf '%s' '{"url":"https://_pastebin.com/x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_contains "$got" "_pastebin.com" "underscore-prefixed host is NOT pastebin.com (passes)"

# Underscore-suffixed: different host (DNS-allowed) — pass through
got=$(printf '%s' '{"url":"https://x.pastebin.com_y/path","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_contains "$got" "pastebin.com_y" "underscore-suffixed host is NOT pastebin.com subdomain (passes)"

# Sibling domain pastebin.com.au is not a subdomain of pastebin.com — pass through
got=$(printf '%s' '{"url":"https://www.pastebin.com.au/blog","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_contains "$got" "pastebin.com.au" "pastebin.com.au is NOT a subdomain of pastebin.com (passes)"

# Different TLD entirely — pass through
got=$(printf '%s' '{"url":"https://pastebin.community/blog","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_contains "$got" "pastebin.community" "pastebin.community is a different domain (passes)"

# --- WS/WSS — websocket schemes with blocklisted host should still block ---
got=$(printf '%s' '{"url":"wss://pastebin.com/socket","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "wss:// scheme with blocklisted host blocked"

# --- Fix #11 — percent-encoded hostname must not bypass ---
# Most HTTP clients percent-decode the hostname before DNS lookup, so
# pastebin%2Ecom is the same target as pastebin.com. urlparse keeps the
# raw %-encoded form, so we explicitly unquote() before matching.
got=$(printf '%s' '{"url":"https://pastebin%2Ecom/x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "percent-encoded dot in host (%2E) blocked"

# Percent-encoded slash hiding the host/path boundary
got=$(printf '%s' '{"url":"https://pastebin%2Ecom%2Fpath","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "percent-encoded slash after host blocked"

# Percent-encoded sub-delim trying to push real hostname out of $ anchor
got=$(printf '%s' '{"url":"https://pastebin.com%3Bjunk/x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "percent-encoded sub-delim (%3B) trimmed and blocked"

# --- Fix #12 — embedded blocklisted URL in primary URL field is blocked ---
# Even when the primary URL points to a benign host (safe.com), if the URL
# contains an embedded blocklisted reference (in query, path, or after
# percent-decode), the orchestrator following such embedded refs would
# scrape the blocklisted target. Defense-in-depth: scan the unquote()-d
# URL string for any blocklisted-host token using a strict boundary class.

# Embedded full URL in query parameter
got=$(printf '%s' '{"url":"https://safe.com/?u=https://pastebin.com/leak","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "embedded https://pastebin.com in query is blocked"

# Embedded host (no scheme) in query parameter
got=$(printf '%s' '{"url":"https://safe.com/redirect?to=pastebin.com","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "embedded host (no scheme) in query is blocked"

# Percent-encoded embedded URL
got=$(printf '%s' '{"url":"https://safe.com/?u=https%3A%2F%2Fpastebin.com%2Fx","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "percent-encoded embedded URL is blocked"

# Comma-separated URL list with one blocklisted
got=$(printf '%s' '{"url":"https://safe.com,https://pastebin.com/x","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "comma-separated URL list with blocklisted is blocked"

# Different blocklisted host embedded
got=$(printf '%s' '{"url":"https://safe.com/path?domain=dehashed.com","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "embedded dehashed.com in query is blocked"

# --- Negative — strict token boundary excludes alnum/./_/- around match ---
# Xpastebin.comY has X before and Y after — both alnum (in set) → no match.
# Correctly NOT blocked (it's not actually a hostname reference).
got=$(printf '%s' '{"url":"https://safe.com/?u=Xpastebin.comY","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_contains "$got" "Xpastebin.comY" "alnum-bracketed substring is NOT blocked"

# Path segment that just happens to spell pastebin (no .com after)
got=$(printf '%s' '{"url":"https://safe.com/api/pastebin","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_contains "$got" "/api/pastebin" "path containing 'pastebin' (without .com) NOT blocked"

# --- Fix #13 — embedded SUBDOMAINS of blocklisted hosts are blocked ---
# The token boundary class needs to be asymmetric. Leading dot must be
# allowed (so .pastebin.com matches via subdomain prefix), trailing dot
# must NOT be allowed (so pastebin.com.au is still rejected as sibling
# domain). Symmetric classes either over-block (.au) or under-block
# (subdomain).

got=$(printf '%s' '{"url":"https://safe.com/?u=https://archive.pastebin.com/leak","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "embedded subdomain (archive.pastebin.com) blocked"

got=$(printf '%s' '{"url":"https://safe.com/?to=archive.dehashed.com","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "embedded subdomain of dehashed.com blocked"

got=$(printf '%s' '{"url":"https://safe.com,https://x.y.pastebin.com/path","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "deeply-nested subdomain (x.y.pastebin.com) blocked"

# Subdomain mention in content body
got=$(printf '%s' '{"url":"https://safe.com/x","content":"see archive.pastebin.com for more"}' | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "subdomain mention in content body blocked"

# Asymmetry confirmed — pastebin.com.au still NOT blocked even with new boundaries
got=$(printf '%s' '{"url":"https://safe.com/?ref=pastebin.com.au","content":"y"}' | bash "$FILTER" 2>/dev/null)
assert_contains "$got" "pastebin.com.au" "embedded sibling-TLD (pastebin.com.au) NOT blocked"

assert_summary
