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
host_alt=""
for h in $BLOCKLIST; do
    [ -z "$h" ] && continue
    # Reject tokens with regex metacharacters or shell weirdness — only allow
    # hostname-shaped strings (alnum, dot, hyphen).
    [[ "$h" =~ ^[a-zA-Z0-9.-]+$ ]] || continue
    esc=$(printf '%s' "$h" | sed 's/\./\\./g')
    host_alt="${host_alt}|${esc}"
done
host_alt="${host_alt#|}"

filtered=0
while IFS= read -r line || [ -n "$line" ]; do
    [ -z "$line" ] && continue

    url=$(printf '%s' "$line" | perl -ne 'print $1 if /"url"\s*:\s*"([^"]*)"/')
    content=$(printf '%s' "$line" | perl -ne 'print $1 if /"content"\s*:\s*"([^"]*)"/')

    host=$(printf '%s' "$url" | perl -ne 'if (m{^https?://([^/]+)}) { my $h = $1; $h =~ s/^[^@]*@//; print $h }')

    block=0
    if [ -n "$host" ] && printf '%s' "$host" | perl -ne "exit 0 if /(?:^|\\.)($host_alt)$/i; exit 1"; then
        block=1
    fi
    if [ "$block" -eq 0 ] && [ -n "$content" ] && printf '%s' "$content" | perl -ne "exit 0 if /\\b($host_alt)\\b/i; exit 1"; then
        block=1
    fi

    if [ "$block" -eq 1 ]; then
        filtered=$((filtered + 1))
    else
        printf '%s\n' "$line"
    fi
done

printf 'filtered=%d\n' "$filtered" >&2
