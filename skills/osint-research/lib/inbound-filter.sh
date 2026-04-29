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
from urllib.parse import urlparse

host_alt = os.environ.get("HOST_ALT", "")
if not host_alt:
    # No tokens — pass through unchanged but still report the count.
    for line in sys.stdin:
        sys.stdout.write(line)
    print("filtered=0", file=sys.stderr)
    sys.exit(0)

host_re = re.compile(r"(?:^|\.)(?:" + host_alt + r")$", re.IGNORECASE)
content_re = re.compile(r"\b(?:" + host_alt + r")\b", re.IGNORECASE)


def extract_host(url):
    """Return canonical lowercased hostname or '' if none.

    urlparse handles port-stripping, userinfo, IPv6 brackets, capitalised
    scheme. We additionally strip the optional trailing dot (FQDN root)
    so blocklisted-host suffix matching works against pastebin.com. as
    well as pastebin.com.

    Note: urlparse preserves RFC 3986 sub-delims (;,=+!$*()) inside the
    regname per spec. The host_re anchored match relies on the hostname
    being clean LDH chars only; any sub-delim breaks the $ anchor. The
    full-URL substring fallback below catches those cases.
    """
    if not isinstance(url, str) or not url:
        return ""
    try:
        parsed = urlparse(url)
    except Exception:
        return ""
    if parsed.scheme.lower() not in ("http", "https"):
        return ""
    host = (parsed.hostname or "").lower()
    if host.endswith("."):
        host = host[:-1]
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

    # Primary check: clean hostname extracted by urlparse, matched against
    # the suffix-anchored host_re (catches example.com and *.example.com).
    host = extract_host(url)
    if host and host_re.search(host):
        blocked = True

    # Defense-in-depth: scan the full URL text for blocklisted host as a
    # word-bounded substring. Catches messy hostnames urlparse preserves
    # but where the $-anchor in host_re fails — e.g. pastebin.com;params,
    # pastebin.com,foo — and non-http schemes (ftp://, gopher://) that
    # extract_host filters out.
    if not blocked and isinstance(url, str) and content_re.search(url):
        blocked = True

    # Content body scan for any blocklisted host reference.
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
