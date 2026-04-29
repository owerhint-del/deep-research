#!/usr/bin/env bash
# skills/osint-research/lib/entity-classifier.sh
# Emits one of: domain, ip, email, person, company, github

set -uo pipefail

COMPANY_FLAG=0
RAW=""
while [ $# -gt 0 ]; do
    case "$1" in
        --company) COMPANY_FLAG=1; shift;;
        *) RAW="$1"; shift;;
    esac
done

if [ -z "$RAW" ]; then
    echo "entity-classifier: empty target" >&2
    exit 1
fi

# Strip surrounding quotes if present
unquoted="${RAW#\"}"
unquoted="${unquoted%\"}"

# github: prefix
if [[ "$RAW" =~ ^github: ]]; then
    echo "github"; exit 0
fi

# explicit --company flag
if [ "$COMPANY_FLAG" -eq 1 ]; then
    echo "company"; exit 0
fi

# email: <local>@<domain>
if [[ "$unquoted" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
    echo "email"; exit 0
fi

# IPv4
if [[ "$unquoted" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "ip"; exit 0
fi

# IPv6 (loose)
if [[ "$unquoted" == *:* ]] && [[ "$unquoted" =~ ^[0-9a-fA-F:]+$ ]]; then
    echo "ip"; exit 0
fi

# Quoted string (with or without space) → person (company would have used --company)
if [[ "$RAW" =~ ^\".*\"$ ]]; then
    echo "person"; exit 0
fi

# Domain: contains a dot, no spaces, no @, no /
if [[ "$unquoted" == *.* ]] && [[ "$unquoted" != *" "* ]] && [[ "$unquoted" != *"@"* ]] && [[ "$unquoted" != *"/"* ]]; then
    echo "domain"; exit 0
fi

echo "entity-classifier: cannot classify: $RAW" >&2
exit 1
