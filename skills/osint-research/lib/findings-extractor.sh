#!/usr/bin/env bash
# skills/osint-research/lib/findings-extractor.sh
# Assigns CRITICAL/HIGH/MEDIUM/LOW priorities to channel findings.

set -uo pipefail

# Plan defect fix: bash heredoc shadows python's stdin. Write python script
# to a tmp file so python3 inherits parent stdin (the piped NDJSON).
_py_tmp=$(mktemp)
trap 'rm -f "$_py_tmp"' EXIT
cat > "$_py_tmp" <<'PY'
import json, sys, re

CRITICAL_PORTS = {6379, 27017, 9200, 11211, 5432, 3306}  # redis, mongo, es, memcached, pg, mysql
SUSPICIOUS_SUBDOMAIN_RE = re.compile(r'^(admin|dev|staging|test|jenkins|jira|grafana|kibana|metabase|backup|legacy|old)[\.\-]', re.I)
SEP = (',', ':')  # compact JSON to match test assertions

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    try:
        rec = json.loads(line)
    except Exception:
        continue

    channel = rec.get("channel", "")
    rtype = rec.get("record_type", "")
    content = rec.get("content", "")
    meta = rec.get("metadata", {}) or {}

    priority = "LOW"

    if channel == "github-leaks" and ("..." in content or "<REDACTED:" in content):
        priority = "CRITICAL"
    elif channel == "shodan-idb" and rtype == "open_port":
        port = meta.get("port")
        if port in CRITICAL_PORTS:
            priority = "CRITICAL"
        elif port in (22, 21, 23, 3389):
            priority = "MEDIUM"
    elif channel == "shodan-idb" and rtype == "cve":
        priority = "HIGH"
    elif rtype == "subdomain" and SUSPICIOUS_SUBDOMAIN_RE.match(content or ""):
        priority = "HIGH"

    rec["priority"] = priority
    print(json.dumps(rec, separators=SEP))
PY
python3 "$_py_tmp"
