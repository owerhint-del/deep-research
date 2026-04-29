#!/usr/bin/env bash
# skills/osint-research/lib/inbound-filter.sh
# Reads NDJSON results from stdin, drops blocklisted ones, writes survivors to stdout.
# Reports `filtered=<N>` on stderr.

set -uo pipefail

# Hardcoded default blocklist. Cannot be shrunk by user — only extended via
# OSINT_EXTRA_BLOCKLIST (comma-separated additional hosts).
DEFAULT_BLOCKLIST="pastebin.com paste.ee ghostbin.com hastebin.com justpaste.it paste.org ix.io \
breached.cc breachforums.is breachforums.st raidforums.com cracked.io \
dehashed.com leakcheck.io intelx.io leak-lookup.com \
doxbin.com doxbin.org doxbin.net \
ddosecrets.com distributeddenialofsecrets.com \
nulled.to leakix.net snusbase.com weleakinfo.to"

EXTRA="${OSINT_EXTRA_BLOCKLIST:-}"
EXTRA="${EXTRA//,/ }"

BLOCKLIST="$DEFAULT_BLOCKLIST $EXTRA"

# Build a single anchored regex: (?:^|\.)(host1|host2|...)$ against URL host,
# and a content regex matching any blocklisted host as a substring.
# Tokens are validated to be hostname-shaped before inclusion so they cannot
# inject regex metachars or shell metachars.
host_alt=""
for h in $BLOCKLIST; do
    [ -z "$h" ] && continue
    [[ "$h" =~ ^[a-zA-Z0-9.-]+$ ]] || continue
    esc=$(printf '%s' "$h" | sed 's/\./\\./g')
    host_alt="${host_alt}|${esc}"
done
host_alt="${host_alt#|}"

# Per-line processing in python so JSON-escapes (\/, \", \\, \uXXXX) decode
# correctly before the blocklist regex runs. Earlier pure-perl regex extraction
# was bypassed by valid JSON encodings of the URL (escaped slashes) and content
# (escaped quotes / unicode escapes), letting blocklisted hosts through.
_py_tmp=$(mktemp)
trap 'rm -f "$_py_tmp"' EXIT
cat > "$_py_tmp" <<'PY'
import os, re, sys, json
from urllib.parse import urlparse, unquote

host_alt = os.environ.get("HOST_ALT", "")
if not host_alt:
    # No tokens — pass through unchanged but still report the count.
    for line in sys.stdin:
        sys.stdout.write(line)
    print("filtered=0", file=sys.stderr)
    sys.exit(0)

host_re = re.compile(r"(?:^|\.)(?:" + host_alt + r")$", re.IGNORECASE)

# Token boundary for matching blocklisted hosts inside content text and
# inside URL strings. Asymmetric: leading dot IS allowed (so subdomain
# matches like archive.pastebin.com fire on the .pastebin.com suffix),
# trailing dot is NOT allowed (so sibling domains like pastebin.com.au
# do not match the pastebin.com prefix).
#
#   LEFT  exclusion: [a-zA-Z0-9_-]   (no .)
#   RIGHT exclusion: [a-zA-Z0-9._-]
#
# Differs from \b (\w includes _ and excludes .) which has both
# false-positive (pastebin.com.au) and false-negative (_pastebin.com_)
# bugs. With the asymmetric class:
#   * archive.pastebin.com  — preceded by ., followed by EOS/non-host → match (subdomain)
#   * pastebin.com.au       — followed by . → no match (different domain)
#   * _pastebin.com_evil    — preceded by _ → no match (different host)
#   * Xpastebin.com         — preceded by X (alnum) → no match
#   * pastebin.commodity    — followed by m → no match
#   * https://x?u=pastebin.com — preceded by =, followed by EOS → match
HOSTNAME_TOKEN_RE = re.compile(
    r"(?<![a-zA-Z0-9_-])(?:" + host_alt + r")(?![a-zA-Z0-9._-])",
    re.IGNORECASE,
)
content_re = HOSTNAME_TOKEN_RE
url_embedded_re = HOSTNAME_TOKEN_RE


# RFC 3986 sub-delims — preserved by urlparse inside regname per spec, but
# never valid in an actual DNS label, so we treat them as host terminators.
# (Underscore is RFC-unreserved, not a sub-delim — it must NOT be trimmed.
# A hostname containing _ is a different DNS name, not pastebin.com.)
SUBDELIM_RE = re.compile(r"[!$&'()*+,;=]")
# Anything that should not appear inside a hostname — defensive trim after
# percent-decoding in case an attacker hid a separator behind %XX encoding.
HOST_TERM_RE = re.compile(r"[/?#\s\\]")


def extract_host(url):
    """Return canonical lowercased hostname suitable for blocklist match.

    urlparse handles port-stripping, userinfo, IPv6 brackets, scheme
    normalisation. Works for any scheme with an authority component
    (http, https, ftp, gopher, ws, wss, etc.). Schemes without authority
    (mailto, javascript, data, file) yield no hostname and we return ''
    — those URLs never trigger a network query.

    Additional canonicalisation:
    - percent-decode (resolvers do this before DNS lookup, so
      pastebin%2Ecom is the same target as pastebin.com)
    - trim at first /?#whitespace\\ (in case decoded value snuck a separator
      back in)
    - strip trailing dot (FQDN root form)
    - trim at first sub-delim (RFC-allowed in regname but not in DNS labels;
      typical resolvers stop here)
    """
    if not isinstance(url, str) or not url:
        return ""
    try:
        parsed = urlparse(url)
    except Exception:
        return ""
    host = parsed.hostname or ""
    try:
        host = unquote(host)
    except Exception:
        pass
    host = host.lower()
    host = HOST_TERM_RE.split(host, 1)[0]
    if host.endswith("."):
        host = host[:-1]
    host = SUBDELIM_RE.split(host, 1)[0]
    return host


filtered = 0
for raw in sys.stdin:
    line = raw.rstrip("\n")
    if not line:
        continue
    try:
        rec = json.loads(line)
    except Exception:
        # Malformed JSON: drop silently to be safe (don't pass through
        # something whose contents we can't inspect).
        filtered += 1
        continue

    url = rec.get("url", "") or ""
    content = rec.get("content", "") or ""

    blocked = False

    # URL host check: extract_host returns the canonical hostname so
    # that pastebin.com;junk, pastebin.com:443, pastebin.com#frag, etc all
    # collapse to pastebin.com before the suffix-anchored host_re fires.
    # Subdomain match (foo.pastebin.com) handled via (?:^|\.) anchor.
    host = extract_host(url)
    if host and host_re.search(host):
        blocked = True

    # Embedded-URL defense-in-depth: scan the URL string itself for any
    # blocklisted hostname token. Catches cases where the primary URL
    # navigates to a benign host but encodes a blocklisted destination
    # in its query/path (e.g. https://safe.com/?u=https://pastebin.com/x
    # or https://safe.com/?to=pastebin.com — orchestrators that follow
    # such redirect-style params would scrape the embedded host). Decode
    # percent-encoding first so https%3A%2F%2Fpastebin.com is also caught.
    if not blocked and isinstance(url, str) and url:
        try:
            decoded_url = unquote(url)
        except Exception:
            decoded_url = url
        if url_embedded_re.search(decoded_url):
            blocked = True

    # Content body scan for any blocklisted host reference in scraped text.
    if not blocked and isinstance(content, str) and content_re.search(content):
        blocked = True

    if blocked:
        filtered += 1
    else:
        # Re-emit the original line verbatim so downstream sees identical bytes.
        sys.stdout.write(line + "\n")

print(f"filtered={filtered}", file=sys.stderr)
PY

HOST_ALT="$host_alt" python3 "$_py_tmp"
