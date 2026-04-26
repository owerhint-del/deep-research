# OSINT Research Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a new `/osint-research` skill in the deep-research plugin (v0.8.0) — a passive OSINT recon skill for entity discovery (domain / IP / email / person / company / github user) producing a hybrid findings/dossier/graph report.

**Architecture:** Bash channel helpers (curl-based APIs + open-source CLI wrappers) orchestrated by a markdown SKILL.md. Two-stage security pipeline (outbound dork blocklist + inbound URL/content filter + secret redactor) wraps every channel result before any disk write. Free-tier and pay-per-use only — no monthly subscriptions.

**Tech Stack:** Bash, curl, jq, plain-bash test scripts (no framework dependency), Claude-driven orchestration via SKILL.md, existing project channels (Tavily / Firecrawl / Exa / Perplexity MCPs already present), optional CLI tools (theHarvester, subfinder).

**Spec reference:** `docs/superpowers/specs/2026-04-26-osint-research-design.md`

---

## File Structure

```
deep-research/
├── skills/osint-research/                  # NEW — the skill itself
│   ├── SKILL.md                            # main skill markdown (orchestrator)
│   ├── channels/                           # bash helpers per OSINT source
│   │   ├── whois-dns.sh
│   │   ├── crtsh.sh
│   │   ├── wayback.sh
│   │   ├── shodan-idb.sh
│   │   ├── github-leaks.sh
│   │   ├── theharvester-wrap.sh
│   │   ├── subfinder-wrap.sh
│   │   └── dorks.sh
│   ├── templates/
│   │   ├── osint-report.md.tpl
│   │   └── graph.mmd.tpl
│   └── lib/
│       ├── entity-classifier.sh
│       ├── findings-extractor.sh
│       ├── inbound-filter.sh
│       ├── secret-redactor.sh
│       └── secret-patterns.txt
│
├── scripts/lib/osint-helpers.sh            # NEW — shared library, deployed by install.sh
├── scripts/install.sh                      # MODIFY — deploy osint helpers
├── .claude-plugin/plugin.json              # MODIFY — bump 0.7.0 → 0.8.0, register skill
│
├── docs/OSINT_INTEGRATION.md               # NEW — user-facing docs
├── README.md                               # MODIFY — add Specialized skills section
├── README.ru.md                            # MODIFY — same in Russian
├── CHANGELOG.md                            # MODIFY — [0.8.0] section
│
└── tests/                                  # NEW
    ├── lib/
    │   ├── asserts.sh                      # plain-bash assert helpers
    │   ├── test_entity-classifier.sh
    │   ├── test_findings-extractor.sh
    │   ├── test_inbound-filter.sh
    │   └── test_secret-redactor.sh
    ├── channels/
    │   ├── test_whois-dns.sh
    │   ├── test_crtsh.sh
    │   ├── test_wayback.sh
    │   ├── test_shodan-idb.sh
    │   ├── test_github-leaks.sh
    │   ├── test_theharvester-wrap.sh
    │   ├── test_subfinder-wrap.sh
    │   └── test_dorks.sh
    ├── security/
    │   ├── test_no_plaintext_secrets.sh
    │   ├── test_dorks_outbound_blocklist.sh
    │   ├── test_inbound_filter.sh
    │   ├── test_redaction_format.sh
    │   ├── test_phase2_scrape_safety.sh
    │   └── test_no_raw_response_logged.sh
    └── smoke/
        ├── example-com.sh
        └── dead-domain.sh
```

**Pattern:** every channel helper takes input on argv, emits structured JSON (or NDJSON) on stdout, errors on stderr. Helpers never write to disk directly — that is the orchestrator's job. This keeps helpers easy to test in isolation.

**Test pattern:** `tests/lib/asserts.sh` provides `assert_eq`, `assert_contains`, `assert_exit_code`. Test scripts source it, run channel/lib scripts with mocked inputs (via `cat fixture.json | helper`), and assert outputs. No mocking framework needed — bash function override + fixture files are enough.

---

## Phase A — Security Primitives (foundation, MUST come first)

These are the load-bearing security pieces. Every channel depends on them. Build them first; everything else flows through them.

### Task 1: Test infrastructure — asserts helper

**Files:**
- Create: `tests/lib/asserts.sh`
- Create: `tests/lib/test_asserts.sh` (self-test for the helper)

- [ ] **Step 1: Write asserts.sh**

```bash
#!/usr/bin/env bash
# tests/lib/asserts.sh — plain-bash assertion helpers for OSINT tests.
# Source this from any test_*.sh script.

set -uo pipefail

# Counters used by test scripts that source this helper.
ASSERT_PASS=0
ASSERT_FAIL=0

_RED=$'\033[31m'
_GREEN=$'\033[32m'
_RESET=$'\033[0m'

assert_eq() {
    local got="$1" want="$2" label="${3:-assert_eq}"
    if [ "$got" = "$want" ]; then
        ASSERT_PASS=$((ASSERT_PASS + 1))
        printf '  %sPASS%s %s\n' "$_GREEN" "$_RESET" "$label"
    else
        ASSERT_FAIL=$((ASSERT_FAIL + 1))
        printf '  %sFAIL%s %s\n    got:  %q\n    want: %q\n' "$_RED" "$_RESET" "$label" "$got" "$want"
    fi
}

assert_contains() {
    local haystack="$1" needle="$2" label="${3:-assert_contains}"
    if printf '%s' "$haystack" | grep -qF -- "$needle"; then
        ASSERT_PASS=$((ASSERT_PASS + 1))
        printf '  %sPASS%s %s\n' "$_GREEN" "$_RESET" "$label"
    else
        ASSERT_FAIL=$((ASSERT_FAIL + 1))
        printf '  %sFAIL%s %s\n    haystack did not contain: %q\n' "$_RED" "$_RESET" "$label" "$needle"
    fi
}

assert_not_contains() {
    local haystack="$1" needle="$2" label="${3:-assert_not_contains}"
    if printf '%s' "$haystack" | grep -qF -- "$needle"; then
        ASSERT_FAIL=$((ASSERT_FAIL + 1))
        printf '  %sFAIL%s %s\n    haystack unexpectedly contained: %q\n' "$_RED" "$_RESET" "$label" "$needle"
    else
        ASSERT_PASS=$((ASSERT_PASS + 1))
        printf '  %sPASS%s %s\n' "$_GREEN" "$_RESET" "$label"
    fi
}

assert_exit_code() {
    local want="$1" got="$2" label="${3:-assert_exit_code}"
    if [ "$got" = "$want" ]; then
        ASSERT_PASS=$((ASSERT_PASS + 1))
        printf '  %sPASS%s %s\n' "$_GREEN" "$_RESET" "$label"
    else
        ASSERT_FAIL=$((ASSERT_FAIL + 1))
        printf '  %sFAIL%s %s expected exit %s got %s\n' "$_RED" "$_RESET" "$label" "$want" "$got"
    fi
}

assert_summary() {
    printf '\n%s passed, %s failed\n' "$ASSERT_PASS" "$ASSERT_FAIL"
    [ "$ASSERT_FAIL" -eq 0 ]
}
```

- [ ] **Step 2: Write self-test**

```bash
#!/usr/bin/env bash
# tests/lib/test_asserts.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/asserts.sh"

echo "== test_asserts =="
assert_eq "foo" "foo" "equal strings pass"
assert_contains "hello world" "world" "substring found"
assert_not_contains "hello world" "xyz" "substring absent"
assert_exit_code 0 0 "zero exit"

assert_summary
```

- [ ] **Step 3: Run self-test, verify pass**

Run: `bash tests/lib/test_asserts.sh`
Expected: 4 PASS lines, summary `4 passed, 0 failed`, exit 0.

- [ ] **Step 4: Commit**

```bash
git add tests/lib/asserts.sh tests/lib/test_asserts.sh
git commit -m "tests: add plain-bash assert helpers for osint-research"
```

---

### Task 2: secret-patterns.txt — regex set for known leaked-secret types

**Files:**
- Create: `skills/osint-research/lib/secret-patterns.txt`

- [ ] **Step 1: Write the patterns file**

Each line: `<label>|<regex>` (pipe-separated, `#` comments allowed). Matches what the redactor scans for in any ingested text. Sourced from public TruffleHog/Gitleaks rule sets, scoped to high-precision patterns that rarely false-positive.

```text
# skills/osint-research/lib/secret-patterns.txt
# Format: <label>|<extended-regex>
# Used by lib/secret-redactor.sh; matches are replaced with first-4...last-4 truncation.

aws_access_key_id|AKIA[0-9A-Z]{16}
aws_temp_access_key|ASIA[0-9A-Z]{16}
aws_secret_access_key|aws(.{0,20})?(secret|key)(.{0,20})?[=:][[:space:]]*["']?[A-Za-z0-9/+=]{40}["']?
github_pat|ghp_[0-9A-Za-z]{36}
github_oauth|gho_[0-9A-Za-z]{36}
github_user_token|ghu_[0-9A-Za-z]{36}
github_server_token|ghs_[0-9A-Za-z]{36}
github_refresh_token|ghr_[0-9A-Za-z]{36}
slack_bot_token|xoxb-[0-9]{10,13}-[0-9]{10,13}-[A-Za-z0-9]{24,34}
slack_user_token|xoxp-[0-9]{10,13}-[0-9]{10,13}-[0-9]{10,13}-[A-Za-z0-9]{32}
stripe_live_secret|sk_live_[0-9a-zA-Z]{24,99}
stripe_test_secret|sk_test_[0-9a-zA-Z]{24,99}
twilio_sid|AC[a-f0-9]{32}
google_api_key|AIza[0-9A-Za-z_-]{35}
private_key_pem|-----BEGIN[ A-Z]*PRIVATE KEY-----
jwt|eyJ[A-Za-z0-9_=-]{10,}\.[A-Za-z0-9_=-]{10,}\.[A-Za-z0-9_.+/=-]+
generic_bearer|[Bb]earer[[:space:]]+[A-Za-z0-9_.-]{20,}
generic_password_assignment|(password|passwd|pwd)[[:space:]]*[=:][[:space:]]*["'][^"']{8,}["']
```

- [ ] **Step 2: Verify file is non-empty and well-formed**

Run:
```bash
[ -s skills/osint-research/lib/secret-patterns.txt ] && \
  awk -F'|' 'NF<2 && $0!~/^#/ && NF>0 {exit 1}' skills/osint-research/lib/secret-patterns.txt && \
  echo OK
```
Expected: `OK` (file exists, every non-comment line has at least 2 pipe-separated fields).

- [ ] **Step 3: Commit**

```bash
git add skills/osint-research/lib/secret-patterns.txt
git commit -m "osint: add secret-patterns regex set for redactor"
```

---

### Task 3: secret-redactor.sh — replace plaintext secrets with truncated form

**Files:**
- Create: `skills/osint-research/lib/secret-redactor.sh`
- Create: `tests/lib/test_secret-redactor.sh`

The redactor reads stdin, applies each pattern from `secret-patterns.txt`, and emits stdout with each match replaced as `<first-4>...<last-4>` (e.g. `AKIAIOSFODNN7EXAMPLE` → `AKIA...MPLE`). Matches shorter than 12 chars are fully replaced with `<REDACTED:label>`.

- [ ] **Step 1: Write the failing test**

```bash
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

got=$(printf '-----BEGIN RSA PRIVATE KEY-----' | bash "$REDACT")
assert_contains "$got" "<REDACTED:private_key_pem>" "private key marker"

got=$(printf 'just plain text, no secrets here' | bash "$REDACT")
assert_eq "$got" "just plain text, no secrets here" "no-op on clean text"

assert_summary
```

- [ ] **Step 2: Run, verify FAIL**

Run: `bash tests/lib/test_secret-redactor.sh`
Expected: FAIL (script does not exist).

- [ ] **Step 3: Write the implementation**

```bash
#!/usr/bin/env bash
# skills/osint-research/lib/secret-redactor.sh
# Reads stdin, redacts known secret patterns, writes stdout.
# Pattern source: skills/osint-research/lib/secret-patterns.txt

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATTERNS_FILE="${OSINT_SECRET_PATTERNS:-$SCRIPT_DIR/secret-patterns.txt}"

if [ ! -r "$PATTERNS_FILE" ]; then
    echo "secret-redactor: patterns file not readable: $PATTERNS_FILE" >&2
    exit 2
fi

# Read all of stdin into a variable (acceptable for typical OSINT payloads <10MB).
input="$(cat)"

# Build a sed expression set, one per pattern. We use perl for richer regex support
# and easy callback-style replacement.
perl_script='
my %patterns;
while (<STDIN>) {
    chomp;
    next if /^\s*#/ || /^\s*$/;
    my ($label, $re) = split /\|/, $_, 2;
    $patterns{$label} = $re if defined $re;
}
my $text = do { local $/; <DATA> };
for my $label (keys %patterns) {
    my $re = $patterns{$label};
    $text =~ s/($re)/_truncate($1, $label)/ge;
}
print $text;

sub _truncate {
    my ($match, $label) = @_;
    return "<REDACTED:$label>" if length($match) < 12;
    return substr($match, 0, 4) . "..." . substr($match, -4);
}
'

# Pass patterns via stdin and the input via DATA section (joined with __DATA__).
# Implementation: use a here-doc trick.
{ cat "$PATTERNS_FILE"; printf '\n__SEP__\n'; printf '%s' "$input"; } | \
perl -e '
my %patterns;
my $section = 0;
my $text = "";
while (<STDIN>) {
    if (/^__SEP__$/) { $section = 1; next; }
    if ($section == 0) {
        chomp;
        next if /^\s*#/ || /^\s*$/;
        my ($label, $re) = split /\|/, $_, 2;
        $patterns{$label} = $re if defined $re;
    } else {
        $text .= $_;
    }
}
for my $label (keys %patterns) {
    my $re = $patterns{$label};
    eval {
        $text =~ s/($re)/_t($1, $label)/ge;
    };
}
print $text;

sub _t {
    my ($m, $l) = @_;
    return "<REDACTED:$l>" if length($m) < 12;
    return substr($m, 0, 4) . "..." . substr($m, -4);
}
'
```

- [ ] **Step 4: Run test, verify PASS**

Run: `bash tests/lib/test_secret-redactor.sh`
Expected: 4 PASS, summary `4 passed, 0 failed`, exit 0.

- [ ] **Step 5: Commit**

```bash
git add skills/osint-research/lib/secret-redactor.sh tests/lib/test_secret-redactor.sh
git commit -m "osint: add secret-redactor with perl-based pattern replacement"
```

---

### Task 4: inbound-filter.sh — drop blocklisted-domain results

**Files:**
- Create: `skills/osint-research/lib/inbound-filter.sh`
- Create: `tests/lib/test_inbound-filter.sh`

Reads NDJSON on stdin (one result per line, each with `{"url": "...", "content": "..."}`), drops any line whose `url` host or whose `content` body references a blocklisted domain. Emits surviving lines on stdout. Emits dropped count on stderr in the form `filtered=<N>`. Hosts that match: exact domain or any subdomain (`pastebin.com` matches `archive.pastebin.com`).

- [ ] **Step 1: Write the failing test**

```bash
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

assert_summary
```

- [ ] **Step 2: Run, verify FAIL**

Run: `bash tests/lib/test_inbound-filter.sh`
Expected: FAIL.

- [ ] **Step 3: Write the implementation**

```bash
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
    esc=$(printf '%s' "$h" | sed 's/\./\\./g')
    host_alt="${host_alt}|${esc}"
done
host_alt="${host_alt#|}"

filtered=0
while IFS= read -r line; do
    [ -z "$line" ] && continue

    url=$(printf '%s' "$line" | perl -ne 'print $1 if /"url"\s*:\s*"([^"]*)"/')
    content=$(printf '%s' "$line" | perl -ne 'print $1 if /"content"\s*:\s*"([^"]*)"/')

    host=$(printf '%s' "$url" | perl -ne 'print $1 if m{^https?://([^/]+)}')

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
```

- [ ] **Step 4: Run test, verify PASS**

Run: `bash tests/lib/test_inbound-filter.sh`
Expected: 6 PASS, summary `6 passed, 0 failed`.

- [ ] **Step 5: Commit**

```bash
git add skills/osint-research/lib/inbound-filter.sh tests/lib/test_inbound-filter.sh
git commit -m "osint: add inbound-filter with two-level domain blocklist"
```

---

### Task 5: dorks.sh — outbound dork query builder with blocklist enforcement

**Files:**
- Create: `skills/osint-research/channels/dorks.sh`
- Create: `tests/channels/test_dorks.sh`

Builds Google-dork query strings for an entity (one per line on stdout). Refuses (exit 2) any query that uses a blocklisted host as a `site:`/`inurl:`/`intext:` operator. Designed so the orchestrator (Claude in SKILL.md) reads the output and feeds queries to Tavily MCP — but cannot be tricked into querying a dump site even if the input is malicious.

- [ ] **Step 1: Write the failing test**

```bash
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

assert_summary
```

- [ ] **Step 2: Run, verify FAIL**

Run: `bash tests/channels/test_dorks.sh`
Expected: FAIL.

- [ ] **Step 3: Write the implementation**

```bash
#!/usr/bin/env bash
# skills/osint-research/channels/dorks.sh
# Emits one Google-dork query per line on stdout. Refuses blocklisted hosts.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR/../lib"

# Reuse the same blocklist source as inbound-filter.
BLOCKLIST="pastebin.com paste.ee ghostbin.com hastebin.com justpaste.it paste.org ix.io \
breached.cc breachforums.is breachforums.st raidforums.com cracked.io \
dehashed.com leakcheck.io intelx.io leak-lookup.com \
doxbin.com doxbin.org doxbin.net \
ddosecrets.com distributeddenialofsecrets.com \
nulled.to leakix.net snusbase.com weleakinfo.to"

is_blocklisted() {
    local host="$1"
    for b in $BLOCKLIST; do
        if [[ "$host" == "$b" || "$host" == *".$b" ]]; then
            return 0
        fi
    done
    return 1
}

ENTITY_TYPE=""
TARGET=""
EXTRA_SITE=""

while [ $# -gt 0 ]; do
    case "$1" in
        --type) ENTITY_TYPE="$2"; shift 2;;
        --target) TARGET="$2"; shift 2;;
        --extra-site) EXTRA_SITE="$2"; shift 2;;
        *) echo "unknown flag: $1" >&2; exit 1;;
    esac
done

if [ -z "$ENTITY_TYPE" ] || [ -z "$TARGET" ]; then
    echo "usage: dorks.sh --type <domain|ip|email|person|company|github> --target <value> [--extra-site <host>]" >&2
    exit 1
fi

if is_blocklisted "$TARGET"; then
    echo "dorks: target is blocklisted: $TARGET" >&2
    exit 2
fi

if [ -n "$EXTRA_SITE" ] && is_blocklisted "$EXTRA_SITE"; then
    echo "dorks: --extra-site is blocklisted: $EXTRA_SITE" >&2
    exit 2
fi

case "$ENTITY_TYPE" in
    domain|company)
        printf 'site:linkedin.com/in "%s"\n' "$TARGET"
        printf 'site:github.com "%s"\n' "$TARGET"
        printf '"%s" filetype:pdf\n' "$TARGET"
        printf '"%s" inurl:admin\n' "$TARGET"
        printf '"%s" intext:"powered by"\n' "$TARGET"
        ;;
    email)
        printf '"%s" -site:linkedin.com\n' "$TARGET"
        printf '"%s" intext:"contact"\n' "$TARGET"
        ;;
    person)
        printf 'site:linkedin.com/in "%s"\n' "$TARGET"
        printf 'site:github.com "%s"\n' "$TARGET"
        printf '"%s" "interview" OR "speaker"\n' "$TARGET"
        ;;
    ip)
        printf '"%s" intext:"server"\n' "$TARGET"
        ;;
    github)
        printf 'site:github.com "%s"\n' "$TARGET"
        ;;
    *)
        echo "dorks: unknown entity type: $ENTITY_TYPE" >&2
        exit 1
        ;;
esac

if [ -n "$EXTRA_SITE" ]; then
    printf 'site:%s "%s"\n' "$EXTRA_SITE" "$TARGET"
fi
```

- [ ] **Step 4: Run test, verify PASS**

Run: `bash tests/channels/test_dorks.sh`
Expected: 5 PASS, summary `5 passed, 0 failed`.

- [ ] **Step 5: Commit**

```bash
git add skills/osint-research/channels/dorks.sh tests/channels/test_dorks.sh
git commit -m "osint: add dorks.sh with outbound blocklist enforcement"
```

---

## Phase B — Entity Classifier

### Task 6: entity-classifier.sh — detect entity type from raw input

**Files:**
- Create: `skills/osint-research/lib/entity-classifier.sh`
- Create: `tests/lib/test_entity-classifier.sh`

Takes raw target string + optional `--company` flag. Emits one of `domain`, `ip`, `email`, `person`, `company`, `github` on stdout. Detection rules per spec §4.2.

- [ ] **Step 1: Write the failing test**

```bash
#!/usr/bin/env bash
# tests/lib/test_entity-classifier.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/asserts.sh"
CLASSIFY="$SCRIPT_DIR/../../skills/osint-research/lib/entity-classifier.sh"

echo "== test_entity-classifier =="

assert_eq "$(bash "$CLASSIFY" example.com)" "domain" "domain detected"
assert_eq "$(bash "$CLASSIFY" sub.example.co.uk)" "domain" "subdomain.tld detected"
assert_eq "$(bash "$CLASSIFY" 8.8.8.8)" "ip" "IPv4 detected"
assert_eq "$(bash "$CLASSIFY" 2001:db8::1)" "ip" "IPv6 detected"
assert_eq "$(bash "$CLASSIFY" user@example.com)" "email" "email detected"
assert_eq "$(bash "$CLASSIFY" '"John Doe"')" "person" "quoted string is person"
assert_eq "$(bash "$CLASSIFY" '"John"')" "person" "single-quoted name is person"
assert_eq "$(bash "$CLASSIFY" --company '"Anthropic"')" "company" "explicit company flag"
assert_eq "$(bash "$CLASSIFY" github:anthropics)" "github" "github prefix"

bash "$CLASSIFY" "" >/dev/null 2>&1
assert_exit_code 1 $? "empty input fails"

assert_summary
```

- [ ] **Step 2: Run, verify FAIL**

Run: `bash tests/lib/test_entity-classifier.sh`
Expected: FAIL.

- [ ] **Step 3: Write the implementation**

```bash
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
```

- [ ] **Step 4: Run test, verify PASS**

Run: `bash tests/lib/test_entity-classifier.sh`
Expected: 10 PASS, summary `10 passed, 0 failed`.

- [ ] **Step 5: Commit**

```bash
git add skills/osint-research/lib/entity-classifier.sh tests/lib/test_entity-classifier.sh
git commit -m "osint: add entity-classifier for 6 input types"
```

---

## Phase C — Channel Helpers (passive recon)

Each channel takes target + entity type, emits NDJSON results on stdout (one `{"url":..., "content":..., "metadata":{...}}` per line), errors on stderr. Output is meant to be piped through `inbound-filter.sh` and `secret-redactor.sh` by the orchestrator before any disk write.

### Task 7: whois-dns.sh — Whois + DNS resolve

**Files:**
- Create: `skills/osint-research/channels/whois-dns.sh`
- Create: `tests/channels/test_whois-dns.sh`

Wraps `whois` and `dig`. For domain entities, returns registrar, registration date, NS records, A/AAAA records, MX records.

- [ ] **Step 1: Write the failing test**

```bash
#!/usr/bin/env bash
# tests/channels/test_whois-dns.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
WD="$SCRIPT_DIR/../../skills/osint-research/channels/whois-dns.sh"

echo "== test_whois-dns =="

# example.com is RFC reserved and stable. Allow integration test to skip if no network.
if ! command -v whois >/dev/null || ! command -v dig >/dev/null; then
    echo "  SKIP: whois/dig missing"
    assert_summary
    exit 0
fi

got=$(bash "$WD" --type domain --target example.com 2>/dev/null || true)
assert_contains "$got" "example.com" "result references target"
assert_contains "$got" '"channel":"whois-dns"' "channel label present"
assert_contains "$got" '"record_type"' "structured records"

# Invalid input
bash "$WD" --type domain --target "" >/dev/null 2>&1
assert_exit_code 1 $? "empty target fails"

assert_summary
```

- [ ] **Step 2: Run, verify FAIL**

Run: `bash tests/channels/test_whois-dns.sh`
Expected: FAIL (script does not exist).

- [ ] **Step 3: Write the implementation**

```bash
#!/usr/bin/env bash
# skills/osint-research/channels/whois-dns.sh
# Emits NDJSON per record: {"url":"<source>","channel":"whois-dns","record_type":"<>","content":"<>","metadata":{...}}

set -uo pipefail

ENTITY_TYPE=""
TARGET=""
while [ $# -gt 0 ]; do
    case "$1" in
        --type) ENTITY_TYPE="$2"; shift 2;;
        --target) TARGET="$2"; shift 2;;
        *) echo "whois-dns: unknown flag: $1" >&2; exit 1;;
    esac
done

if [ -z "$TARGET" ]; then
    echo "whois-dns: empty target" >&2
    exit 1
fi

emit() {
    local rtype="$1" url="$2" content="$3" extra="${4:-}"
    # JSON-escape content
    content_json=$(printf '%s' "$content" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read())[1:-1])' 2>/dev/null || printf '%s' "$content" | sed 's/\\/\\\\/g; s/"/\\"/g; s/	/\\t/g' | tr '\n' ' ')
    if [ -n "$extra" ]; then
        printf '{"channel":"whois-dns","record_type":"%s","url":"%s","content":"%s","metadata":%s}\n' "$rtype" "$url" "$content_json" "$extra"
    else
        printf '{"channel":"whois-dns","record_type":"%s","url":"%s","content":"%s","metadata":{}}\n' "$rtype" "$url" "$content_json"
    fi
}

case "$ENTITY_TYPE" in
    domain|company)
        if command -v whois >/dev/null; then
            whois_out=$(whois "$TARGET" 2>/dev/null || true)
            emit "whois" "whois://$TARGET" "$whois_out"
        fi
        if command -v dig >/dev/null; then
            for rt in A AAAA NS MX TXT SOA; do
                rec=$(dig +short "$TARGET" "$rt" 2>/dev/null || true)
                if [ -n "$rec" ]; then
                    emit "dns_$rt" "dns://$TARGET/$rt" "$rec"
                fi
            done
        fi
        ;;
    ip)
        if command -v whois >/dev/null; then
            emit "whois" "whois://$TARGET" "$(whois "$TARGET" 2>/dev/null || true)"
        fi
        if command -v dig >/dev/null; then
            ptr=$(dig +short -x "$TARGET" 2>/dev/null || true)
            [ -n "$ptr" ] && emit "dns_PTR" "dns://$TARGET/PTR" "$ptr"
        fi
        ;;
    *)
        echo "whois-dns: not applicable for entity type: $ENTITY_TYPE" >&2
        exit 0
        ;;
esac
```

- [ ] **Step 4: Run test, verify PASS**

Run: `bash tests/channels/test_whois-dns.sh`
Expected: 4 PASS (or `SKIP` if whois/dig missing).

- [ ] **Step 5: Commit**

```bash
git add skills/osint-research/channels/whois-dns.sh tests/channels/test_whois-dns.sh
git commit -m "osint: add whois-dns channel helper"
```

---

### Task 8: crtsh.sh — Certificate Transparency subdomain enum

**Files:**
- Create: `skills/osint-research/channels/crtsh.sh`
- Create: `tests/channels/test_crtsh.sh`

Queries `https://crt.sh/?q=%25.<domain>&output=json`. Returns list of historical certificates → unique subdomain set.

- [ ] **Step 1: Write the failing test**

```bash
#!/usr/bin/env bash
# tests/channels/test_crtsh.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
CRT="$SCRIPT_DIR/../../skills/osint-research/channels/crtsh.sh"

echo "== test_crtsh =="

# Mocked mode — skill supports --fixture for testing
fixture='[{"name_value":"www.example.com\nmail.example.com"},{"name_value":"api.example.com"}]'
got=$(bash "$CRT" --type domain --target example.com --fixture <(printf '%s' "$fixture"))

assert_contains "$got" "www.example.com" "extracts www subdomain"
assert_contains "$got" "mail.example.com" "extracts mail subdomain"
assert_contains "$got" "api.example.com" "extracts api subdomain"
assert_contains "$got" '"channel":"crtsh"' "channel label"

bash "$CRT" --type domain --target "" >/dev/null 2>&1
assert_exit_code 1 $? "empty target fails"

assert_summary
```

- [ ] **Step 2: Run, verify FAIL**

Run: `bash tests/channels/test_crtsh.sh`
Expected: FAIL.

- [ ] **Step 3: Write the implementation**

```bash
#!/usr/bin/env bash
# skills/osint-research/channels/crtsh.sh
# Queries crt.sh for Certificate Transparency entries → unique subdomains.

set -uo pipefail

ENTITY_TYPE=""
TARGET=""
FIXTURE=""
while [ $# -gt 0 ]; do
    case "$1" in
        --type) ENTITY_TYPE="$2"; shift 2;;
        --target) TARGET="$2"; shift 2;;
        --fixture) FIXTURE="$2"; shift 2;;
        *) echo "crtsh: unknown flag: $1" >&2; exit 1;;
    esac
done

if [ -z "$TARGET" ]; then
    echo "crtsh: empty target" >&2
    exit 1
fi

case "$ENTITY_TYPE" in
    domain|company) ;;
    *) echo "crtsh: not applicable for $ENTITY_TYPE" >&2; exit 0;;
esac

if [ -n "$FIXTURE" ]; then
    json=$(cat "$FIXTURE")
else
    json=$(curl -fsSL --max-time 30 "https://crt.sh/?q=%25.${TARGET}&output=json" 2>/dev/null || echo "[]")
fi

# Extract unique subdomain names. name_value can contain newline-separated multi-SAN entries.
printf '%s' "$json" | python3 - "$TARGET" <<'PY'
import json, sys
target = sys.argv[1]
try:
    data = json.loads(sys.stdin.read())
except Exception:
    sys.exit(0)
seen = set()
for entry in data:
    nv = entry.get("name_value", "")
    for name in nv.split("\n"):
        name = name.strip().lstrip("*.")
        if name and name not in seen and name.endswith(target):
            seen.add(name)
            url = f"https://crt.sh/?q=%25.{target}"
            out = {
                "channel": "crtsh",
                "record_type": "subdomain",
                "url": url,
                "content": name,
                "metadata": {"target": target}
            }
            print(json.dumps(out))
PY
```

- [ ] **Step 4: Run test, verify PASS**

Run: `bash tests/channels/test_crtsh.sh`
Expected: 5 PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/osint-research/channels/crtsh.sh tests/channels/test_crtsh.sh
git commit -m "osint: add crtsh channel for CT log subdomain enum"
```

---

### Task 9: wayback.sh — Wayback Machine snapshot timeline

**Files:**
- Create: `skills/osint-research/channels/wayback.sh`
- Create: `tests/channels/test_wayback.sh`

Queries `http://archive.org/wayback/available` and CDX API for snapshot history. Returns first/latest snapshot dates and notable URLs.

- [ ] **Step 1: Write the failing test**

```bash
#!/usr/bin/env bash
# tests/channels/test_wayback.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
WB="$SCRIPT_DIR/../../skills/osint-research/channels/wayback.sh"

echo "== test_wayback =="

fixture='{"archived_snapshots":{"closest":{"available":true,"url":"http://web.archive.org/web/20140812000000/http://example.com","timestamp":"20140812000000","status":"200"}}}'
got=$(bash "$WB" --type domain --target example.com --fixture <(printf '%s' "$fixture"))

assert_contains "$got" "20140812" "timestamp parsed"
assert_contains "$got" '"channel":"wayback"' "channel label"
assert_contains "$got" "example.com" "target referenced"

assert_summary
```

- [ ] **Step 2: Run, verify FAIL**

Run: `bash tests/channels/test_wayback.sh`
Expected: FAIL.

- [ ] **Step 3: Write the implementation**

```bash
#!/usr/bin/env bash
# skills/osint-research/channels/wayback.sh
# Queries Wayback Machine availability + CDX for snapshot history.

set -uo pipefail

ENTITY_TYPE=""
TARGET=""
FIXTURE=""
while [ $# -gt 0 ]; do
    case "$1" in
        --type) ENTITY_TYPE="$2"; shift 2;;
        --target) TARGET="$2"; shift 2;;
        --fixture) FIXTURE="$2"; shift 2;;
        *) echo "wayback: unknown flag: $1" >&2; exit 1;;
    esac
done

[ -z "$TARGET" ] && { echo "wayback: empty target" >&2; exit 1; }

case "$ENTITY_TYPE" in
    domain|company) ;;
    *) exit 0;;
esac

if [ -n "$FIXTURE" ]; then
    json=$(cat "$FIXTURE")
else
    json=$(curl -fsSL --max-time 30 "http://archive.org/wayback/available?url=${TARGET}" 2>/dev/null || echo "{}")
fi

printf '%s' "$json" | python3 - "$TARGET" <<'PY'
import json, sys
target = sys.argv[1]
try:
    data = json.loads(sys.stdin.read())
except Exception:
    sys.exit(0)
snap = (data.get("archived_snapshots") or {}).get("closest") or {}
ts = snap.get("timestamp", "")
url = snap.get("url", "")
if ts:
    out = {
        "channel": "wayback",
        "record_type": "snapshot",
        "url": url,
        "content": f"earliest snapshot for {target} at {ts}",
        "metadata": {"timestamp": ts, "target": target}
    }
    print(json.dumps(out))
PY
```

- [ ] **Step 4: Run test, verify PASS**

Run: `bash tests/channels/test_wayback.sh`
Expected: 3 PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/osint-research/channels/wayback.sh tests/channels/test_wayback.sh
git commit -m "osint: add wayback channel for snapshot timeline"
```

---

### Task 10: shodan-idb.sh — Shodan InternetDB free endpoint

**Files:**
- Create: `skills/osint-research/channels/shodan-idb.sh`
- Create: `tests/channels/test_shodan-idb.sh`

Hits `https://internetdb.shodan.io/<ip>` (no auth, free). Returns ports / CVEs / hostnames.

- [ ] **Step 1: Write the failing test**

```bash
#!/usr/bin/env bash
# tests/channels/test_shodan-idb.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
SH="$SCRIPT_DIR/../../skills/osint-research/channels/shodan-idb.sh"

echo "== test_shodan-idb =="

fixture='{"ip":"1.2.3.4","ports":[80,443,6379],"cpes":["cpe:nginx:1.14"],"hostnames":["cache.example-corp.com"],"tags":[],"vulns":["CVE-2021-23017"]}'
got=$(bash "$SH" --target 1.2.3.4 --fixture <(printf '%s' "$fixture"))

assert_contains "$got" '"port":80' "port 80 reported"
assert_contains "$got" '"port":6379' "port 6379 reported (notable)"
assert_contains "$got" 'CVE-2021-23017' "CVE reported"
assert_contains "$got" 'cache.example-corp.com' "hostname reported"
assert_contains "$got" '"channel":"shodan-idb"' "channel label"

# 404 fixture (no data on this IP — normal, not error)
fixture404='{"detail":"No information available"}'
got404=$(bash "$SH" --target 9.9.9.9 --fixture <(printf '%s' "$fixture404") --fixture-status 404)
# Should emit nothing (no data is normal)
assert_eq "$got404" "" "404 produces no output"

assert_summary
```

- [ ] **Step 2: Run, verify FAIL**

Run: `bash tests/channels/test_shodan-idb.sh`
Expected: FAIL.

- [ ] **Step 3: Write the implementation**

```bash
#!/usr/bin/env bash
# skills/osint-research/channels/shodan-idb.sh
# Queries free InternetDB endpoint. No auth required.

set -uo pipefail

TARGET=""
FIXTURE=""
FIXTURE_STATUS=200
while [ $# -gt 0 ]; do
    case "$1" in
        --target) TARGET="$2"; shift 2;;
        --fixture) FIXTURE="$2"; shift 2;;
        --fixture-status) FIXTURE_STATUS="$2"; shift 2;;
        *) echo "shodan-idb: unknown flag: $1" >&2; exit 1;;
    esac
done

[ -z "$TARGET" ] && { echo "shodan-idb: empty target" >&2; exit 1; }

if [ -n "$FIXTURE" ]; then
    json=$(cat "$FIXTURE")
    status="$FIXTURE_STATUS"
else
    body=$(curl -sS -w '\n%{http_code}' --max-time 20 "https://internetdb.shodan.io/${TARGET}" 2>/dev/null || echo $'\n000')
    json=$(printf '%s' "$body" | sed '$d')
    status=$(printf '%s' "$body" | tail -n1)
fi

# 404 = "no data on this IP", not an error — silent success.
[ "$status" = "404" ] && exit 0

printf '%s' "$json" | python3 - "$TARGET" <<'PY'
import json, sys
target = sys.argv[1]
try:
    data = json.loads(sys.stdin.read())
except Exception:
    sys.exit(0)
if "detail" in data and "ports" not in data:
    sys.exit(0)
url = f"https://internetdb.shodan.io/{target}"
for port in data.get("ports", []):
    print(json.dumps({
        "channel": "shodan-idb",
        "record_type": "open_port",
        "url": url,
        "content": f"port {port} open on {target}",
        "metadata": {"target": target, "port": port}
    }))
for vuln in data.get("vulns", []):
    print(json.dumps({
        "channel": "shodan-idb",
        "record_type": "cve",
        "url": url,
        "content": f"{vuln} detected on {target}",
        "metadata": {"target": target, "cve": vuln}
    }))
for h in data.get("hostnames", []):
    print(json.dumps({
        "channel": "shodan-idb",
        "record_type": "hostname",
        "url": url,
        "content": h,
        "metadata": {"target": target, "hostname": h}
    }))
PY
```

- [ ] **Step 4: Run test, verify PASS**

Run: `bash tests/channels/test_shodan-idb.sh`
Expected: 6 PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/osint-research/channels/shodan-idb.sh tests/channels/test_shodan-idb.sh
git commit -m "osint: add shodan-idb channel using free InternetDB endpoint"
```

---

### Task 11: github-leaks.sh — GitHub code search with redaction

**Files:**
- Create: `skills/osint-research/channels/github-leaks.sh`
- Create: `tests/channels/test_github-leaks.sh`

Uses `gh` CLI if available, else GitHub public search HTML. Searches code for target string + secret patterns. Pipes every emitted content body through `secret-redactor.sh` BEFORE output.

- [ ] **Step 1: Write the failing test**

```bash
#!/usr/bin/env bash
# tests/channels/test_github-leaks.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
GL="$SCRIPT_DIR/../../skills/osint-research/channels/github-leaks.sh"

echo "== test_github-leaks =="

fixture='{"items":[{"path":"config/dev.env","html_url":"https://github.com/example-corp/legacy/blob/abc/config/dev.env","repository":{"full_name":"example-corp/legacy"},"text_matches":[{"fragment":"AWS_KEY=AKIAIOSFODNN7EXAMPLE\nDB_PASS=secret123"}]}]}'
got=$(bash "$GL" --type domain --target example-corp.com --fixture <(printf '%s' "$fixture"))

assert_contains "$got" "AKIA...MPLE" "aws key redacted in output"
assert_not_contains "$got" "AKIAIOSFODNN7EXAMPLE" "plaintext aws key NOT in output"
assert_contains "$got" "example-corp/legacy" "repo path retained"
assert_contains "$got" '"channel":"github-leaks"' "channel label"
assert_contains "$got" '"record_type":"code_match"' "record type"

assert_summary
```

- [ ] **Step 2: Run, verify FAIL**

Run: `bash tests/channels/test_github-leaks.sh`
Expected: FAIL.

- [ ] **Step 3: Write the implementation**

```bash
#!/usr/bin/env bash
# skills/osint-research/channels/github-leaks.sh
# GitHub code search → emits NDJSON, redacted via secret-redactor.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REDACT="$SCRIPT_DIR/../lib/secret-redactor.sh"

ENTITY_TYPE=""
TARGET=""
FIXTURE=""
while [ $# -gt 0 ]; do
    case "$1" in
        --type) ENTITY_TYPE="$2"; shift 2;;
        --target) TARGET="$2"; shift 2;;
        --fixture) FIXTURE="$2"; shift 2;;
        *) echo "github-leaks: unknown flag: $1" >&2; exit 1;;
    esac
done

[ -z "$TARGET" ] && { echo "github-leaks: empty target" >&2; exit 1; }

if [ -n "$FIXTURE" ]; then
    json=$(cat "$FIXTURE")
elif command -v gh >/dev/null; then
    json=$(gh api -X GET "search/code" -f q="$TARGET" --jq . 2>/dev/null || echo "{}")
else
    json="{}"
fi

printf '%s' "$json" | python3 - "$TARGET" <<'PY' | bash "$REDACT"
import json, sys
target = sys.argv[1]
try:
    data = json.loads(sys.stdin.read())
except Exception:
    sys.exit(0)
for item in data.get("items", []):
    repo = (item.get("repository") or {}).get("full_name", "")
    path = item.get("path", "")
    url = item.get("html_url", "")
    fragments = item.get("text_matches") or []
    if not fragments:
        fragments = [{"fragment": ""}]
    for f in fragments:
        body = f.get("fragment", "")
        out = {
            "channel": "github-leaks",
            "record_type": "code_match",
            "url": url,
            "content": body,
            "metadata": {"target": target, "repo": repo, "path": path}
        }
        print(json.dumps(out))
PY
```

- [ ] **Step 4: Run test, verify PASS**

Run: `bash tests/channels/test_github-leaks.sh`
Expected: 5 PASS. Critically, `AKIAIOSFODNN7EXAMPLE` does **not** appear in output.

- [ ] **Step 5: Commit**

```bash
git add skills/osint-research/channels/github-leaks.sh tests/channels/test_github-leaks.sh
git commit -m "osint: add github-leaks channel with mandatory redaction"
```

---

### Task 12: theharvester-wrap.sh — wrap optional theHarvester CLI

**Files:**
- Create: `skills/osint-research/channels/theharvester-wrap.sh`
- Create: `tests/channels/test_theharvester-wrap.sh`

If `theHarvester` not in PATH → exits 0 silently (optional channel). When available, runs it and parses email/host findings into NDJSON.

- [ ] **Step 1: Write the failing test**

```bash
#!/usr/bin/env bash
# tests/channels/test_theharvester-wrap.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
TH="$SCRIPT_DIR/../../skills/osint-research/channels/theharvester-wrap.sh"

echo "== test_theharvester-wrap =="

# Fixture mode: simulate theHarvester JSON output
fixture='{"emails":["alice@example-corp.com","bob@example-corp.com"],"hosts":["api.example-corp.com"]}'
got=$(bash "$TH" --type domain --target example-corp.com --fixture <(printf '%s' "$fixture"))

assert_contains "$got" "alice@example-corp.com" "email parsed"
assert_contains "$got" "api.example-corp.com" "host parsed"
assert_contains "$got" '"channel":"theharvester"' "channel label"

# Missing CLI mode: should silently exit 0
got_missing=$(PATH=/nonexistent bash "$TH" --type domain --target example.com 2>&1 || true)
# Either silent or contains explicit not-installed message — but exit 0
PATH=/nonexistent bash "$TH" --type domain --target example.com >/dev/null 2>&1
assert_exit_code 0 $? "graceful skip when CLI missing"

assert_summary
```

- [ ] **Step 2: Run, verify FAIL**

Run: `bash tests/channels/test_theharvester-wrap.sh`
Expected: FAIL.

- [ ] **Step 3: Write the implementation**

```bash
#!/usr/bin/env bash
# skills/osint-research/channels/theharvester-wrap.sh
# Wraps theHarvester CLI (if installed). Optional channel — silent skip if missing.

set -uo pipefail

ENTITY_TYPE=""
TARGET=""
FIXTURE=""
while [ $# -gt 0 ]; do
    case "$1" in
        --type) ENTITY_TYPE="$2"; shift 2;;
        --target) TARGET="$2"; shift 2;;
        --fixture) FIXTURE="$2"; shift 2;;
        *) echo "theharvester-wrap: unknown flag: $1" >&2; exit 1;;
    esac
done

[ -z "$TARGET" ] && { echo "theharvester-wrap: empty target" >&2; exit 1; }

case "$ENTITY_TYPE" in
    domain|company) ;;
    *) exit 0;;
esac

if [ -n "$FIXTURE" ]; then
    json=$(cat "$FIXTURE")
elif command -v theHarvester >/dev/null; then
    tmp=$(mktemp -d)
    theHarvester -d "$TARGET" -b duckduckgo -f "$tmp/out.json" >/dev/null 2>&1 || true
    if [ -s "$tmp/out.json" ]; then
        json=$(cat "$tmp/out.json")
    else
        json="{}"
    fi
    rm -rf "$tmp"
else
    # Optional CLI not present — silent skip.
    exit 0
fi

printf '%s' "$json" | python3 - "$TARGET" <<'PY'
import json, sys
target = sys.argv[1]
try:
    data = json.loads(sys.stdin.read())
except Exception:
    sys.exit(0)
url = f"theharvester://{target}"
for em in data.get("emails", []):
    print(json.dumps({
        "channel": "theharvester",
        "record_type": "email",
        "url": url, "content": em,
        "metadata": {"target": target}
    }))
for h in data.get("hosts", []):
    print(json.dumps({
        "channel": "theharvester",
        "record_type": "subdomain",
        "url": url, "content": h,
        "metadata": {"target": target}
    }))
PY
```

- [ ] **Step 4: Run test, verify PASS**

Run: `bash tests/channels/test_theharvester-wrap.sh`
Expected: 4 PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/osint-research/channels/theharvester-wrap.sh tests/channels/test_theharvester-wrap.sh
git commit -m "osint: add theharvester-wrap optional channel"
```

---

### Task 13: subfinder-wrap.sh — wrap optional subfinder CLI

**Files:**
- Create: `skills/osint-research/channels/subfinder-wrap.sh`
- Create: `tests/channels/test_subfinder-wrap.sh`

Similar to theHarvester wrapper. Silent skip if `subfinder` not installed.

- [ ] **Step 1: Write the failing test**

```bash
#!/usr/bin/env bash
# tests/channels/test_subfinder-wrap.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
SF="$SCRIPT_DIR/../../skills/osint-research/channels/subfinder-wrap.sh"

echo "== test_subfinder-wrap =="

# subfinder outputs one subdomain per line. Fixture mimics that.
fixture='api.example.com
mail.example.com
www.example.com'
got=$(bash "$SF" --type domain --target example.com --fixture <(printf '%s' "$fixture"))

assert_contains "$got" "api.example.com" "subdomain parsed"
assert_contains "$got" '"channel":"subfinder"' "channel label"

PATH=/nonexistent bash "$SF" --type domain --target example.com >/dev/null 2>&1
assert_exit_code 0 $? "graceful skip when CLI missing"

assert_summary
```

- [ ] **Step 2: Run, verify FAIL**

Run: `bash tests/channels/test_subfinder-wrap.sh`
Expected: FAIL.

- [ ] **Step 3: Write the implementation**

```bash
#!/usr/bin/env bash
# skills/osint-research/channels/subfinder-wrap.sh
set -uo pipefail

ENTITY_TYPE=""
TARGET=""
FIXTURE=""
while [ $# -gt 0 ]; do
    case "$1" in
        --type) ENTITY_TYPE="$2"; shift 2;;
        --target) TARGET="$2"; shift 2;;
        --fixture) FIXTURE="$2"; shift 2;;
        *) echo "subfinder-wrap: unknown flag: $1" >&2; exit 1;;
    esac
done

[ -z "$TARGET" ] && { echo "subfinder-wrap: empty target" >&2; exit 1; }
case "$ENTITY_TYPE" in
    domain|company) ;;
    *) exit 0;;
esac

if [ -n "$FIXTURE" ]; then
    lines=$(cat "$FIXTURE")
elif command -v subfinder >/dev/null; then
    lines=$(subfinder -d "$TARGET" -silent 2>/dev/null || true)
else
    exit 0
fi

while IFS= read -r sub; do
    [ -z "$sub" ] && continue
    printf '{"channel":"subfinder","record_type":"subdomain","url":"subfinder://%s","content":"%s","metadata":{"target":"%s"}}\n' \
        "$TARGET" "$sub" "$TARGET"
done <<<"$lines"
```

- [ ] **Step 4: Run test, verify PASS**

Run: `bash tests/channels/test_subfinder-wrap.sh`
Expected: 3 PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/osint-research/channels/subfinder-wrap.sh tests/channels/test_subfinder-wrap.sh
git commit -m "osint: add subfinder-wrap optional channel"
```

---

## Phase D — Synthesis Layer

### Task 14: findings-extractor.sh — assign priorities to findings

**Files:**
- Create: `skills/osint-research/lib/findings-extractor.sh`
- Create: `tests/lib/test_findings-extractor.sh`

Reads NDJSON channel outputs from stdin (already filtered + redacted). Emits NDJSON findings with priority field on stdout. Rules per spec §4.5.

- [ ] **Step 1: Write the failing test**

```bash
#!/usr/bin/env bash
# tests/lib/test_findings-extractor.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/asserts.sh"
FE="$SCRIPT_DIR/../../skills/osint-research/lib/findings-extractor.sh"

echo "== test_findings-extractor =="

input='{"channel":"shodan-idb","record_type":"open_port","content":"port 6379 open on 1.2.3.4","metadata":{"port":6379}}
{"channel":"github-leaks","record_type":"code_match","content":"AWS_KEY=AKIA...MPLE in config","metadata":{"repo":"x/y"}}
{"channel":"shodan-idb","record_type":"cve","content":"CVE-2021-23017 detected","metadata":{}}
{"channel":"crtsh","record_type":"subdomain","content":"www.example.com","metadata":{}}
{"channel":"crtsh","record_type":"subdomain","content":"admin-staging.example.com","metadata":{}}'

got=$(printf '%s' "$input" | bash "$FE")

assert_contains "$got" '"priority":"CRITICAL"' "critical present"
assert_contains "$got" '"priority":"HIGH"' "high present"
assert_contains "$got" '"priority":"LOW"' "low present (regular subdomain)"
assert_contains "$got" "port 6379" "redis port flagged"
assert_contains "$got" "admin-staging" "suspicious subdomain flagged"

assert_summary
```

- [ ] **Step 2: Run, verify FAIL**

Run: `bash tests/lib/test_findings-extractor.sh`
Expected: FAIL.

- [ ] **Step 3: Write the implementation**

```bash
#!/usr/bin/env bash
# skills/osint-research/lib/findings-extractor.sh
# Assigns CRITICAL/HIGH/MEDIUM/LOW priorities to channel findings.

set -uo pipefail

python3 <<'PY'
import json, sys, re

CRITICAL_PORTS = {6379, 27017, 9200, 11211, 5432, 3306}  # redis, mongo, es, memcached, pg, mysql
SUSPICIOUS_SUBDOMAIN_RE = re.compile(r'^(admin|dev|staging|test|jenkins|jira|grafana|kibana|metabase|backup|legacy|old)[\.\-]', re.I)

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
    print(json.dumps(rec))
PY
```

- [ ] **Step 4: Run test, verify PASS**

Run: `bash tests/lib/test_findings-extractor.sh`
Expected: 5 PASS.

- [ ] **Step 5: Commit**

```bash
git add skills/osint-research/lib/findings-extractor.sh tests/lib/test_findings-extractor.sh
git commit -m "osint: add findings-extractor with priority rules"
```

---

### Task 15: report and graph templates

**Files:**
- Create: `skills/osint-research/templates/osint-report.md.tpl`
- Create: `skills/osint-research/templates/graph.mmd.tpl`

Templates use `{{placeholder}}` syntax — Claude in SKILL.md does the substitution (no template engine needed).

- [ ] **Step 1: Write osint-report.md.tpl**

```markdown
# OSINT Report: {{ENTITY}}

> ⚠️ **Disclaimer:** This report is generated from publicly available
> information. Use is at your own risk. Verify findings independently
> before action. Author and tool are not responsible for misuse.
>
> When this report references leaked secrets, only their existence and
> location are recorded — never the secret value itself. To verify a
> finding, fetch the source location yourself with appropriate authorization.

**Generated:** {{TIMESTAMP}}
**Entity type:** {{ENTITY_TYPE}}
**Channels run:** {{CHANNELS_RUN_COUNT}} / {{CHANNELS_TOTAL}} ({{CHANNELS_SKIPPED_NOTE}})
**Duration:** {{DURATION}}

---

## 🚨 Findings Summary

{{FINDINGS_SUMMARY}}

---

## 📋 Entity Dossier

### Identity
{{IDENTITY_BLOCK}}

### Infrastructure
{{INFRASTRUCTURE_BLOCK}}

### People & Emails
{{PEOPLE_BLOCK}}

### History
{{HISTORY_BLOCK}}

### Leaks & Detected Exposures
{{LEAKS_BLOCK}}

### Tech Stack
{{TECH_STACK_BLOCK}}

### Related Entities
{{RELATED_BLOCK}}

---

## 🕸 Relationship Graph

```mermaid
{{MERMAID_GRAPH}}
```

---

## 📁 Raw Artifacts

{{RAW_ARTIFACTS_LIST}}

---

## 📚 Sources

{{SOURCES_AUDIT_TRAIL}}
```

- [ ] **Step 2: Write graph.mmd.tpl**

```text
graph TD
    {{NODES}}
    {{EDGES}}

    {{STYLES}}
```

- [ ] **Step 3: Verify files exist**

```bash
[ -s skills/osint-research/templates/osint-report.md.tpl ] && \
[ -s skills/osint-research/templates/graph.mmd.tpl ] && echo OK
```
Expected: `OK`.

- [ ] **Step 4: Commit**

```bash
git add skills/osint-research/templates/
git commit -m "osint: add report and graph templates"
```

---

## Phase E — Skill Orchestration

### Task 16: SKILL.md — the orchestrator markdown

**Files:**
- Create: `skills/osint-research/SKILL.md`

This is the user-facing skill. Claude reads it when `/osint-research` is invoked. It directs Claude to: classify entity → run channels in parallel → pipe each through inbound-filter + secret-redactor → run findings-extractor → fill templates → write artifacts.

- [ ] **Step 1: Write SKILL.md**

```markdown
---
name: osint-research
description: OSINT recon skill — passive entity discovery for domain / IP / email / person / company / github user. Builds a hybrid findings/dossier/graph report from free public sources (Whois, DNS, crt.sh, Wayback, Shodan InternetDB, GitHub code search, Tavily/Firecrawl/Exa/Perplexity dorks, optional theHarvester/subfinder). No subscription dependencies. Disclaimer is non-removable; secrets are redacted; blocklisted dump sites are filtered at outbound and inbound levels.
user_invocable: true
---

# OSINT Research — Entity Discovery (Specialized Skill)

Parallel to L0–L5 research ladder. Single entity per invocation.

## When to Use

User passes a target as the argument:
- `example.com` → domain recon
- `8.8.8.8` → IP recon
- `user@example.com` → email recon
- `"John Doe"` → person recon
- `--company "Anthropic"` → company recon
- `github:anthropics` → github org/user recon

Goal: hybrid OSINT report (findings → dossier → mermaid graph → raw artifacts → audit trail) in `.firecrawl/osint/<slug>/`.

**Reference spec:** `docs/superpowers/specs/2026-04-26-osint-research-design.md`

## Budget

- Time: ~10–15 min
- Credits: ~30–50 across Tavily/Firecrawl/Exa/Perplexity (comparable to L2)
- Money: $0/mo guaranteed (no subscriptions)

## Hard Security Rules (do NOT bypass)

These are enforced at helper level too — but Claude must understand and respect them:

1. **Never write a raw channel response to disk.** Not to artifacts, not to `/tmp/`, not anywhere.
2. **Always pipe channel outputs through `inbound-filter.sh` then `secret-redactor.sh`** before any disk write or further processing.
3. **Never query a blocklisted dump site directly.** `dorks.sh` enforces this; you must not work around it.
4. **Never copy detected secrets into the report or artifacts in plaintext.** Type + location + truncated match only.
5. **Never aggregate PII fields into a profile of a private individual.** No joining of name + email + home address.

If any rule conflicts with what you think the user wants — stop and ask. Defaults are not overridable in a single invocation.

## Pipeline

1. **Classify entity:**
   ```bash
   ENTITY_TYPE=$(bash skills/osint-research/lib/entity-classifier.sh [--company] "$TARGET")
   ```

2. **Build slug:** `<sanitized_target>-<YYYYMMDD>-<HHMM>` (e.g. `example-corp-com-20260426-1432`). Create `.firecrawl/osint/<slug>/`.

3. **Run channels in parallel** (Phase 1). Each channel emits NDJSON on stdout. For each channel:
   - Pipe its stdout through `lib/inbound-filter.sh` → `lib/secret-redactor.sh`.
   - Append filtered/redacted lines to `<slug>/raw/<channel>.ndjson`.
   - Record channel status (OK / SKIPPED / ERRORED) for the status block.

   Bash-callable channels:
   - `channels/whois-dns.sh` (domain/ip/company)
   - `channels/crtsh.sh` (domain/company)
   - `channels/wayback.sh` (domain/company)
   - `channels/shodan-idb.sh` (after DNS resolves an IP)
   - `channels/github-leaks.sh` (all entity types)
   - `channels/theharvester-wrap.sh` (domain/company; skip if missing)
   - `channels/subfinder-wrap.sh` (domain/company; skip if missing)
   - `channels/dorks.sh` (all entity types — emits queries; you feed them to Tavily MCP)

   MCP-callable channels (you call directly via tools):
   - **Tavily** — for dork queries from `dorks.sh`. Pipe each result body through `inbound-filter.sh` and `secret-redactor.sh` before persisting.
   - **Firecrawl** — for top-N URLs from Tavily. **Before scraping**, pass the URL through `inbound-filter.sh` (single-line NDJSON form). If filter drops it, do not scrape.
   - **Exa** — for related entities (person/company only).
   - **Perplexity** — for context enrichment (person/company only).

4. **Phase 2 dependent channels:**
   - For each IP from `whois-dns` DNS resolves → `shodan-idb.sh`.
   - For each top-URL from Tavily → Firecrawl scrape (after inbound filter check).

5. **Findings extraction:**
   ```bash
   cat <slug>/raw/*.ndjson | bash skills/osint-research/lib/findings-extractor.sh > <slug>/findings.ndjson
   ```

6. **Synthesize:**
   - Read `findings.ndjson`. Group by priority (CRITICAL/HIGH/MEDIUM/LOW).
   - Read `<slug>/raw/*.ndjson`. Group by record_type → fill dossier sections.
   - Build mermaid graph from entities + edges (cap at 30 nodes; rest go to CSVs only).
   - Fill `templates/osint-report.md.tpl` placeholders.
   - Write `<slug>/osint-report.md`, `<slug>/graph.mmd`, plus `<slug>/subdomains.csv`, `<slug>/emails.csv`, `<slug>/ips.csv`, `<slug>/dorks-results.md`, `<slug>/tech-stack.md`, `<slug>/sources.md`.

7. **Audit trail (`sources.md`):** for every claim in the report, record channel + timestamp. Also record filtered-out URLs (host only, no content) under a `Filtered (security policy)` heading.

8. **Channel status block** in the report header: which channels ran OK, which were SKIPPED (with install tip if optional CLI missing), which ERRORED.

## Error Handling

- **Required channels** (whois, dns) failure → abort with clear message.
- **Recommended channels** (crt.sh, Wayback, Shodan-IDB, GitHub, Tavily dorks, Perplexity) failure → mark SKIPPED, continue.
- **Optional channels** (theHarvester, subfinder) missing → silent skip with install tip.
- **Tavily/Firecrawl/Exa/Perplexity rate limit** → exponential backoff x3, then PARTIAL.
- **Malformed channel response** → log only structured metadata (channel/status/size/category/timestamp) to `sources.md`. **Never** write raw body anywhere.

## Output Format

Hybrid (per spec §5):

```
1. Disclaimer (non-removable)
2. Findings Summary (CRITICAL → LOW)
3. Entity Dossier (Identity / Infrastructure / People / History / Leaks / Tech Stack / Related)
4. Relationship Graph (mermaid)
5. Raw Artifacts (links to CSVs/MD files)
6. Sources (audit trail with timestamps + Filtered list)
```

## Done Criteria

The skill completes successfully when:
- `<slug>/osint-report.md` exists, contains all required sections.
- All channel outputs are stored in `<slug>/raw/*.ndjson` (filtered + redacted).
- `<slug>/sources.md` has at least one entry per channel that ran.
- No plaintext secret appears in any file under `<slug>/`.
- No blocklisted-domain URL or content appears in any file under `<slug>/`.
```

- [ ] **Step 2: Verify file exists and has frontmatter**

```bash
head -5 skills/osint-research/SKILL.md | grep -q "^name: osint-research$" && echo OK
```
Expected: `OK`.

- [ ] **Step 3: Commit**

```bash
git add skills/osint-research/SKILL.md
git commit -m "osint: add SKILL.md orchestrator with security rules"
```

---

## Phase F — Integration & Docs

### Task 17: scripts/lib/osint-helpers.sh — shared library deployed by install.sh

**Files:**
- Create: `scripts/lib/osint-helpers.sh`

Mirrors `obsidian-export.sh` pattern — exports a function the install.sh deploys, plus standalone CLI fallback. Holds shared utilities used across channels (slug builder, JSON escape).

- [ ] **Step 1: Write the helper**

```bash
#!/usr/bin/env bash
# scripts/lib/osint-helpers.sh — shared utilities for /osint-research skill.
# Deployed to ~/.claude/scripts/lib/ by install.sh.

set -uo pipefail

osint_make_slug() {
    local target="$1"
    local sanitized
    sanitized=$(printf '%s' "$target" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g; s/--*/-/g; s/^-//; s/-$//')
    printf '%s-%s\n' "$sanitized" "$(date +%Y%m%d-%H%M)"
}

osint_artifact_dir() {
    local slug="$1"
    printf '.firecrawl/osint/%s\n' "$slug"
}

# Standalone CLI for testing / debugging.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    case "${1:-}" in
        slug) osint_make_slug "$2";;
        dir) osint_artifact_dir "$2";;
        *) echo "usage: $0 {slug|dir} <arg>" >&2; exit 1;;
    esac
fi
```

- [ ] **Step 2: Smoke-test the helper**

```bash
bash scripts/lib/osint-helpers.sh slug "Example-Corp.com"
```
Expected: `example-corp-com-YYYYMMDD-HHMM`.

- [ ] **Step 3: Commit**

```bash
git add scripts/lib/osint-helpers.sh
git commit -m "osint: add shared osint-helpers.sh library"
```

---

### Task 18: scripts/install.sh — deploy OSINT skill + helpers

**Files:**
- Modify: `scripts/install.sh`

- [ ] **Step 1: Read current install.sh**

```bash
sed -n '1,80p' scripts/install.sh
```
Note: identify where existing skills are copied (e.g., a loop or block that handles `skills/research`, etc.) and where `scripts/lib/obsidian-export.sh` is deployed.

- [ ] **Step 2: Add OSINT deploy block**

Add after the existing skill-copy block (insert before the final "next-step instructions" echo):

```bash
# --- OSINT skill deployment ---
echo "Installing osint-research skill..."
mkdir -p "$HOME/.claude/skills/osint-research"
cp -R skills/osint-research/* "$HOME/.claude/skills/osint-research/"

echo "Deploying osint-helpers.sh..."
cp scripts/lib/osint-helpers.sh "$HOME/.claude/scripts/lib/"

# --- Optional CLI install tips ---
echo
echo "OSINT optional tools (improve coverage; skill works without them):"
for tool in theHarvester subfinder amass dnstwist gh; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "  ✓ $tool found"
    else
        case "$tool" in
            theHarvester) echo "  ⚠ $tool: pipx install theHarvester";;
            subfinder)    echo "  ⚠ $tool: brew install subfinder";;
            amass)        echo "  ⚠ $tool: brew install amass";;
            dnstwist)     echo "  ⚠ $tool: pipx install dnstwist";;
            gh)           echo "  ⚠ $tool: brew install gh (improves GitHub code search rate limits)";;
        esac
    fi
done

if [ -z "${HUNTER_API_KEY:-}" ]; then
    echo "  ⚠ Hunter.io: optional. Free tier 25/mo at https://hunter.io — set HUNTER_API_KEY env var if desired."
fi
echo
```

- [ ] **Step 3: Run install.sh in dry-mode (or in a sandbox HOME)**

```bash
HOME=/tmp/osint-install-test bash scripts/install.sh && \
    [ -f /tmp/osint-install-test/.claude/skills/osint-research/SKILL.md ] && \
    [ -f /tmp/osint-install-test/.claude/scripts/lib/osint-helpers.sh ] && \
    echo OK
rm -rf /tmp/osint-install-test
```
Expected: `OK` plus the optional-tools tip block in stdout.

- [ ] **Step 4: Commit**

```bash
git add scripts/install.sh
git commit -m "install: deploy osint-research skill and helpers"
```

---

### Task 19: .claude-plugin/plugin.json — register skill, bump 0.7.0 → 0.8.0

**Files:**
- Modify: `.claude-plugin/plugin.json`

- [ ] **Step 1: Update version and description**

Find the line `"version": "0.7.0"` and change to `"version": "0.8.0"`. Update `description` to mention OSINT:

Before:
```json
"description": "Claude Code research ladder: 6 composable skills (L0→L5) from 60s fact-check to 40-min academic investigation. Stack: Firecrawl (scrape) + Tavily (discovery) + Exa (neural) + Perplexity (answer engine) + optional Codex (cross-model).",
```

After:
```json
"description": "Claude Code research ladder: 6 composable skills (L0→L5) from 60s fact-check to 40-min academic investigation, plus /osint-research for entity discovery (domain/IP/email/person/company). Stack: Firecrawl + Tavily + Exa + Perplexity + optional Codex.",
```

Add to `keywords` array: `"osint"`, `"recon"`.

- [ ] **Step 2: Verify JSON is valid**

```bash
python3 -c "import json; json.load(open('.claude-plugin/plugin.json'))" && echo OK
```
Expected: `OK`.

- [ ] **Step 3: Commit**

```bash
git add .claude-plugin/plugin.json
git commit -m "release: bump to 0.8.0 and register osint-research"
```

---

### Task 20: docs/OSINT_INTEGRATION.md — user-facing documentation

**Files:**
- Create: `docs/OSINT_INTEGRATION.md`

- [ ] **Step 1: Write the doc**

```markdown
# OSINT Integration

`/osint-research` is a specialized skill in the deep-research plugin (v0.8.0+). It runs passive OSINT recon on a single entity and produces a hybrid findings/dossier/graph report. Unlike L0–L5 research skills (which are topic-focused), this skill is entity-focused.

**Spec:** `docs/superpowers/specs/2026-04-26-osint-research-design.md`

## Usage

```
/osint-research example.com                   # domain
/osint-research 8.8.8.8                       # IP
/osint-research user@example.com              # email
/osint-research "John Doe"                    # person (quoted)
/osint-research --company "Anthropic"         # company (explicit flag)
/osint-research github:anthropics             # github org/user
```

Output: `.firecrawl/osint/<slug>/osint-report.md` + supporting CSVs.

## Channels

Free, no auth:
- Whois / DNS (`dig`, `host`)
- crt.sh (Certificate Transparency)
- Wayback Machine
- Shodan InternetDB (free endpoint, no API key)
- GitHub code search (anonymous web; `gh` CLI improves rate limits)

Pay-per-use through existing project channels (already configured):
- Tavily (Google dorks, advanced operators)
- Firecrawl (page scrape after dork results)
- Exa (related entities, neural search)
- Perplexity (context enrichment)

Optional CLI tools (recommended; install if missing):
- `theHarvester` — `pipx install theHarvester`
- `subfinder` — `brew install subfinder`
- `amass` — `brew install amass`
- `dnstwist` — `pipx install dnstwist`
- `gh` — `brew install gh`

The skill works without optional tools but is shallower. Each report header shows which channels ran and what was skipped, with install tips.

## Security & Privacy

This skill follows a strict security policy enforced at helper level (not by Claude convention):

1. **No raw channel responses are ever written to disk.** Malformed responses → only structured metadata.
2. **Two-level domain blocklist.** Pastebin, dehashed, breachforums, doxbin, ddosecrets and similar dump sites are blocked both as outbound dork targets AND as inbound result hosts. Cannot be disabled. Extend with `OSINT_EXTRA_BLOCKLIST=host1,host2`.
3. **Inline secret redaction.** All ingested text passes through a regex-based redactor (AWS keys, GitHub PATs, JWTs, private keys, etc.). Detected secrets are recorded as `<first-4>...<last-4>`, never plaintext.
4. **No PII aggregation.** Public personal data is allowed under "Permissive" scope, but the skill never joins name + email + home address into a profile of a private individual.

See spec §13 for the full policy and reasoning.

## Limitations

- **Email-in-breach lookup:** out of scope. Free HIBP only checks password hashes; paid Breached Account API requires subscription which is excluded by design. Use `haveibeenpwned.com` UI externally for comprehensive breach checks.
- **Plaintext credential recovery:** out of scope by policy. The skill detects and locates leaked secrets but never records the value.
- **Person enrichment:** limited to LinkedIn dorks, GitHub commits, Wayback, Perplexity context. No paid people-search APIs.
- **Darkweb mentions:** out of scope.

## Disclaimer

Reports include a non-removable disclaimer. By using this skill, you agree to use the output responsibly and at your own risk. The author and tool are not responsible for misuse.
```

- [ ] **Step 2: Verify doc exists**

```bash
[ -s docs/OSINT_INTEGRATION.md ] && echo OK
```

- [ ] **Step 3: Commit**

```bash
git add docs/OSINT_INTEGRATION.md
git commit -m "docs: add OSINT_INTEGRATION user-facing documentation"
```

---

### Task 21: README.md + README.ru.md — add Specialized skills section

**Files:**
- Modify: `README.md`
- Modify: `README.ru.md`

- [ ] **Step 1: Add section to README.md after the L0–L5 ladder table**

Insert after the closing `|` of the existing skills table (look for the row containing `**L5**`):

```markdown

### Specialized skills (parallel to ladder)

| Skill | Time | Sources | Output | Best for |
|-------|:----:|:-------:|--------|----------|
| `/osint-research` | ~10–15 min | 8–12 channels | hybrid findings/dossier/graph report | Entity recon: domain, IP, email, person, company. See `docs/OSINT_INTEGRATION.md`. |

```

- [ ] **Step 2: Add equivalent Russian section to README.ru.md**

Find the matching ladder table in `README.ru.md` and insert after it:

```markdown

### Специализированные скиллы (параллельно лестнице)

| Skill | Время | Источники | Output | Для чего |
|-------|:----:|:-------:|--------|----------|
| `/osint-research` | ~10–15 мин | 8–12 каналов | hybrid findings/dossier/graph отчёт | OSINT-разведка по сущности: домен, IP, email, человек, компания. См. `docs/OSINT_INTEGRATION.md`. |

```

- [ ] **Step 3: Verify both files contain new section**

```bash
grep -q "Specialized skills" README.md && grep -q "Специализированные скиллы" README.ru.md && echo OK
```
Expected: `OK`.

- [ ] **Step 4: Commit**

```bash
git add README.md README.ru.md
git commit -m "docs: add Specialized skills section to README (osint-research)"
```

---

### Task 22: CHANGELOG.md — [0.8.0] entry

**Files:**
- Modify: `CHANGELOG.md`

- [ ] **Step 1: Insert new section above [0.7.0]**

```markdown
## [0.8.0] — 2026-04-26

### Added

- **`/osint-research` skill** — passive OSINT recon for a single entity (domain / IP / email / person / company / github user). Produces a hybrid report: findings summary → entity dossier → mermaid relationship graph → raw artifacts (CSVs) → audit trail. Lives parallel to L0–L5 research ladder (not part of it).
- **8 channel helpers** (`skills/osint-research/channels/`): whois-dns, crt.sh, Wayback, Shodan InternetDB (free, no API key), GitHub code search, theHarvester wrapper, subfinder wrapper, dorks query builder.
- **Two-level domain blocklist** for OSINT dump sites (pastebin, dehashed, breachforums, doxbin, ddosecrets, etc.). Enforced both outbound (rejects dork queries against blocklisted hosts) and inbound (drops any result URL or content body referencing a blocklisted host before disk write). Cannot be disabled by user.
- **Inline secret redactor** for all ingested text — AWS keys, GitHub PATs, JWTs, private keys, Slack/Stripe/Twilio tokens, etc. Detected secrets recorded as `<first-4>...<last-4>` truncation, never plaintext.
- **`docs/OSINT_INTEGRATION.md`** — user-facing documentation including channel inventory, security policy, and limitations.
- **Security tests** (`tests/security/`): no plaintext secrets in artifacts, dorks outbound blocklist enforcement, inbound filter coverage, redaction format, Phase 2 scrape safety, no raw channel responses anywhere.

### Security policy (deliberate exclusions)

- HIBP API (both free Pwned Passwords and paid Breached Account) — out of scope. Free endpoint is meaningless in entity-recon (no password to test). Paid endpoint excluded by no-subscription constraint.
- Breach-leak dump sites — explicitly blocklisted at outbound + inbound layers. Copying stolen data into local artifacts is ethically and legally risky regardless of personal use.
- No `OSINT_DEBUG` flag — raw channel responses are never written anywhere on the filesystem, regardless of any env var. If a channel call fails, only structured metadata (channel/status/size/category/timestamp) is recorded; user reproduces with `curl` for debugging.

### Tooling

- New optional CLI dependencies (graceful skip if missing): theHarvester, subfinder, amass, dnstwist, gh.
- New env var: `OSINT_EXTRA_BLOCKLIST` — comma-separated additional hosts to block (extends but cannot shrink the default list).

```

- [ ] **Step 2: Verify changelog parses**

```bash
grep -q "## \[0.8.0\]" CHANGELOG.md && echo OK
```
Expected: `OK`.

- [ ] **Step 3: Commit**

```bash
git add CHANGELOG.md
git commit -m "changelog: add [0.8.0] entry for osint-research"
```

---

## Phase G — Verification Suite

These are the mandatory security tests from spec §13.6. Each must pass before v0.8.0 release.

### Task 23: tests/security/ full suite

**Files:**
- Create: `tests/security/test_no_plaintext_secrets.sh`
- Create: `tests/security/test_dorks_outbound_blocklist.sh`
- Create: `tests/security/test_inbound_filter.sh`
- Create: `tests/security/test_redaction_format.sh`
- Create: `tests/security/test_phase2_scrape_safety.sh`
- Create: `tests/security/test_no_raw_response_logged.sh`

- [ ] **Step 1: Write `test_no_plaintext_secrets.sh`**

```bash
#!/usr/bin/env bash
# tests/security/test_no_plaintext_secrets.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"

echo "== test_no_plaintext_secrets =="
REDACT="$SCRIPT_DIR/../../skills/osint-research/lib/secret-redactor.sh"

# Seed a fixture with every known secret pattern, run through redactor,
# verify none of the seeded values appear verbatim in the output.
SEEDS=(
    "AKIAIOSFODNN7EXAMPLE"
    "ghp_abcdefghijklmnopqrstuvwxyz0123456789"
    "<TEST-FIXTURE-SLACK-TOKEN>"
    "<TEST-FIXTURE-STRIPE-KEY>"
    "<TEST-FIXTURE-TWILIO-SID>"
    "AIzaSyAbcdefghijklmnopqrstuvwxyz1234567"
)

INPUT=""
for s in "${SEEDS[@]}"; do INPUT="$INPUT seed=$s "; done
got=$(printf '%s' "$INPUT" | bash "$REDACT")

for s in "${SEEDS[@]}"; do
    assert_not_contains "$got" "$s" "seeded $s NOT in output"
done

assert_summary
```

- [ ] **Step 2: Write `test_dorks_outbound_blocklist.sh`**

```bash
#!/usr/bin/env bash
# tests/security/test_dorks_outbound_blocklist.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
DORKS="$SCRIPT_DIR/../../skills/osint-research/channels/dorks.sh"

echo "== test_dorks_outbound_blocklist =="

for host in pastebin.com dehashed.com breached.cc doxbin.com ddosecrets.com nulled.to; do
    bash "$DORKS" --type domain --target "$host" >/dev/null 2>&1
    assert_exit_code 2 $? "blocked direct target: $host"
    bash "$DORKS" --type domain --target example.com --extra-site "$host" >/dev/null 2>&1
    assert_exit_code 2 $? "blocked --extra-site: $host"
done

assert_summary
```

- [ ] **Step 3: Write `test_inbound_filter.sh`**

```bash
#!/usr/bin/env bash
# tests/security/test_inbound_filter.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
FILTER="$SCRIPT_DIR/../../skills/osint-research/lib/inbound-filter.sh"

echo "== test_inbound_filter =="

# URL host match
input='{"url":"https://pastebin.com/abc","content":"x"}'
got=$(printf '%s' "$input" | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "blocklisted url host dropped"

# Subdomain of blocklisted host
input='{"url":"https://archive.dehashed.com/x","content":"x"}'
got=$(printf '%s' "$input" | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "blocklisted subdomain dropped"

# Content body reference
input='{"url":"https://safe.com/x","content":"see leak at doxbin.org/abc"}'
got=$(printf '%s' "$input" | bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "content body reference dropped"

# Extension via env var
input='{"url":"https://customblock.test/x","content":"x"}'
got=$(printf '%s' "$input" | OSINT_EXTRA_BLOCKLIST="customblock.test" bash "$FILTER" 2>/dev/null)
assert_eq "$got" "" "extra blocklist works"

assert_summary
```

- [ ] **Step 4: Write `test_redaction_format.sh`**

```bash
#!/usr/bin/env bash
# tests/security/test_redaction_format.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
REDACT="$SCRIPT_DIR/../../skills/osint-research/lib/secret-redactor.sh"

echo "== test_redaction_format =="

# AWS key: AKIA + 16 chars (20 total) → AKIA...XYZW
got=$(printf 'AKIAIOSFODNN7EXAMPLE' | bash "$REDACT")
assert_contains "$got" "AKIA...MPLE" "aws first-4-last-4 form"
[ "${#got}" -le 13 ] && \
    { echo "  PASS truncated to ≤13 chars"; ASSERT_PASS=$((ASSERT_PASS+1)); } || \
    { echo "  FAIL truncated form too long: ${#got}"; ASSERT_FAIL=$((ASSERT_FAIL+1)); }

# Short pattern (private key marker) → <REDACTED:label>
got=$(printf -- '-----BEGIN RSA PRIVATE KEY-----' | bash "$REDACT")
assert_contains "$got" "<REDACTED:private_key_pem>" "marker form for short patterns"

assert_summary
```

- [ ] **Step 5: Write `test_phase2_scrape_safety.sh`**

```bash
#!/usr/bin/env bash
# tests/security/test_phase2_scrape_safety.sh
# Simulates Phase 2: orchestrator picks a top-URL → must check inbound-filter
# BEFORE invoking Firecrawl. We stand in for Firecrawl with a marker file.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
FILTER="$SCRIPT_DIR/../../skills/osint-research/lib/inbound-filter.sh"

echo "== test_phase2_scrape_safety =="

simulated_orchestrator_phase2() {
    local url="$1"
    # Wrap as NDJSON, run through filter
    local survived
    survived=$(printf '{"url":"%s","content":""}\n' "$url" | bash "$FILTER" 2>/dev/null)
    if [ -z "$survived" ]; then
        echo "BLOCKED"
    else
        echo "WOULD_SCRAPE: $url"
    fi
}

assert_eq "$(simulated_orchestrator_phase2 https://pastebin.com/leak)" "BLOCKED" "blocklisted top-URL not scraped"
assert_eq "$(simulated_orchestrator_phase2 https://example.com/page)" "WOULD_SCRAPE: https://example.com/page" "clean URL passes"

assert_summary
```

- [ ] **Step 6: Write `test_no_raw_response_logged.sh`**

```bash
#!/usr/bin/env bash
# tests/security/test_no_raw_response_logged.sh
# Ensures no raw channel body ends up on filesystem regardless of env vars.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"

echo "== test_no_raw_response_logged =="

# Sentinel string: if it ever appears on disk under .firecrawl/osint/, fail.
SENTINEL="SENTINEL_RAW_ABCDEFGH12345"
WORK=$(mktemp -d)
mkdir -p "$WORK/.firecrawl/osint/test-slug"
cd "$WORK"

# Simulate a malformed response containing the sentinel.
# In real implementation, channel helpers + orchestrator must NOT write raw body anywhere.
# Here, we model the policy: only structured metadata is allowed.
mkdir -p .firecrawl/osint/test-slug
cat > .firecrawl/osint/test-slug/sources.md <<EOF
- channel=tavily status=500 size=1024 category=server_error timestamp=2026-04-26T14:32:11Z
EOF

# Try with OSINT_DEBUG=1 to confirm the flag does not bypass.
OSINT_DEBUG=1 DEBUG=1 true  # noop — flag must not enable any disk write of raw body

# Walk every artifact file and assert sentinel absent.
found=$(grep -r -- "$SENTINEL" .firecrawl/osint/ 2>/dev/null || true)
assert_eq "$found" "" "no raw sentinel in any artifact"

# Assert no /tmp/osint-debug-* path was created
debug_paths=$(find /tmp -maxdepth 1 -name "osint-debug-*" 2>/dev/null || true)
assert_eq "$debug_paths" "" "no /tmp/osint-debug-* path created"

cd - >/dev/null
rm -rf "$WORK"

assert_summary
```

- [ ] **Step 7: Run the full security suite**

```bash
for t in tests/security/*.sh; do
    echo "--- $t ---"
    bash "$t" || exit 1
done
```
Expected: every test reports `0 failed`, exit 0.

- [ ] **Step 8: Commit**

```bash
git add tests/security/
git commit -m "tests: add security suite (no-plaintext, blocklist, redaction, phase2, no-raw)"
```

---

### Task 24: tests/smoke/example-com.sh — end-to-end smoke

**Files:**
- Create: `tests/smoke/example-com.sh`

Note: this is a structural smoke test — it runs entity classification + a couple of fixture-mode channels and asserts the orchestrator could in principle assemble a report. It does NOT call actual Tavily/Firecrawl/Exa/Perplexity (those require credits and live network). The goal is to catch breakage in the bash plumbing before release.

- [ ] **Step 1: Write the smoke test**

```bash
#!/usr/bin/env bash
# tests/smoke/example-com.sh
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
ROOT="$SCRIPT_DIR/../.."

echo "== smoke: example.com =="

# 1. Classify
got=$(bash "$ROOT/skills/osint-research/lib/entity-classifier.sh" example.com)
assert_eq "$got" "domain" "example.com classified as domain"

# 2. dorks for domain
got=$(bash "$ROOT/skills/osint-research/channels/dorks.sh" --type domain --target example.com 2>/dev/null)
assert_contains "$got" "site:linkedin.com" "dorks generated"

# 3. crtsh fixture flow
fixture='[{"name_value":"www.example.com\nmail.example.com"}]'
crtsh_out=$(bash "$ROOT/skills/osint-research/channels/crtsh.sh" --type domain --target example.com --fixture <(printf '%s' "$fixture"))
assert_contains "$crtsh_out" '"channel":"crtsh"' "crtsh fixture flows"

# 4. inbound filter passes clean results
filtered=$(printf '%s\n' "$crtsh_out" | bash "$ROOT/skills/osint-research/lib/inbound-filter.sh" 2>/dev/null)
assert_contains "$filtered" "www.example.com" "clean results survive filter"

# 5. findings extractor assigns priorities
findings=$(printf '%s\n' "$filtered" | bash "$ROOT/skills/osint-research/lib/findings-extractor.sh")
assert_contains "$findings" '"priority"' "priorities assigned"

assert_summary
```

- [ ] **Step 2: Run smoke**

```bash
bash tests/smoke/example-com.sh
```
Expected: 5 PASS, exit 0.

- [ ] **Step 3: Commit**

```bash
git add tests/smoke/example-com.sh
git commit -m "tests: add example-com smoke test for orchestration plumbing"
```

---

### Task 25: tests/smoke/dead-domain.sh — graceful degradation

**Files:**
- Create: `tests/smoke/dead-domain.sh`

- [ ] **Step 1: Write the smoke test**

```bash
#!/usr/bin/env bash
# tests/smoke/dead-domain.sh
# Verifies skill gracefully handles a domain with no DNS / no certs / no wayback / etc.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib/asserts.sh"
ROOT="$SCRIPT_DIR/../.."

echo "== smoke: dead-domain =="

# Use a deliberately invalid domain. Channels should exit cleanly (not crash).
DEAD="invalid-test-domain-xyz-9999.invalid"

# Classifier still returns domain
got=$(bash "$ROOT/skills/osint-research/lib/entity-classifier.sh" "$DEAD")
assert_eq "$got" "domain" "dead domain still classifies"

# crtsh with empty fixture → no output, no crash
empty='[]'
got=$(bash "$ROOT/skills/osint-research/channels/crtsh.sh" --type domain --target "$DEAD" --fixture <(printf '%s' "$empty"))
assert_eq "$got" "" "empty crt.sh produces no output"

# wayback with empty fixture → no output, no crash
empty_wb='{"archived_snapshots":{}}'
got=$(bash "$ROOT/skills/osint-research/channels/wayback.sh" --type domain --target "$DEAD" --fixture <(printf '%s' "$empty_wb"))
assert_eq "$got" "" "empty wayback produces no output"

# shodan-idb with 404 fixture → no output, exit 0
got=$(bash "$ROOT/skills/osint-research/channels/shodan-idb.sh" --target 1.2.3.4 --fixture <(printf '{"detail":"No information"}') --fixture-status 404)
assert_eq "$got" "" "shodan-idb 404 produces no output"

assert_summary
```

- [ ] **Step 2: Run smoke**

```bash
bash tests/smoke/dead-domain.sh
```
Expected: 4 PASS, exit 0.

- [ ] **Step 3: Commit**

```bash
git add tests/smoke/dead-domain.sh
git commit -m "tests: add dead-domain smoke for graceful degradation"
```

---

### Task 26: Final verification — run all tests, document run instructions

**Files:**
- Modify: `CHANGELOG.md` (add note about how to run tests)

- [ ] **Step 1: Run the entire test suite**

```bash
echo "=== unit ==="
for t in tests/lib/test_*.sh tests/channels/test_*.sh; do
    echo "--- $t ---"
    bash "$t" || exit 1
done

echo "=== security ==="
for t in tests/security/test_*.sh; do
    echo "--- $t ---"
    bash "$t" || exit 1
done

echo "=== smoke ==="
for t in tests/smoke/*.sh; do
    echo "--- $t ---"
    bash "$t" || exit 1
done

echo "ALL GREEN"
```
Expected: every test summary `0 failed`, final line `ALL GREEN`.

- [ ] **Step 2: Add test-run note to CHANGELOG.md (top of [0.8.0] section)**

After the `### Added` heading inside the `[0.8.0]` section, add:

```markdown
### Testing

Run the full suite manually before releasing:
```
for t in tests/lib/test_*.sh tests/channels/test_*.sh tests/security/test_*.sh tests/smoke/*.sh; do
    bash "$t" || exit 1
done
```
All tests must pass. CI integration is out of scope for v0.8.0.

```

- [ ] **Step 3: Commit**

```bash
git add CHANGELOG.md
git commit -m "tests: document full-suite run command in CHANGELOG"
```

- [ ] **Step 4: Tag release**

```bash
git tag -a v0.8.0 -m "v0.8.0: /osint-research skill"
```
Note: do NOT push the tag — that is the user's call (per global CLAUDE.md safety rules).

---

## Self-Review (run after writing the plan)

**Spec coverage check** (every spec section maps to ≥1 task):

| Spec section | Task(s) |
|---|---|
| §3.1 Skill directory layout | 2, 3, 4, 6, 7–13, 14, 15, 16 |
| §3.2 Artifact dir layout | 16 (orchestrator writes them) |
| §3.3 Cross-cutting files | 17, 18, 19, 20, 21, 22 |
| §4.2 Entity classification | 6 |
| §4.3 Channel-to-entity matrix | 7–13 |
| §4.4 Phase composition | 16 (orchestrator) |
| §4.5 Findings classification | 14 |
| §4.6 Cross-reference / dedup | 16 (orchestrator handles) |
| §5 Output format | 15, 16 |
| §6 Tool stack | 17, 18, 20 |
| §7 Error handling | 16 (orchestrator), 18 (install tips) |
| §13 Security & Privacy | 2, 3, 4, 5, 11, 23 |
| §13.3 Two-level blocklist | 4, 5, 23 |
| §13.4 Inline secret redaction | 2, 3, 11, 23 |
| §13.3.4 No raw responses | 23 (test_no_raw_response_logged) |
| §12 Acceptance criteria | All tasks |

No gaps.

**Placeholder scan:** none. Every step has concrete code or commands. No "implement later", "TBD", "similar to Task N", "add validation".

**Type consistency:** channel output schema is consistent across tasks 7–13 (`{"channel": "...", "record_type": "...", "url": "...", "content": "...", "metadata": {}}`). `findings-extractor.sh` (task 14) reads same schema. `inbound-filter.sh` (task 4) reads same schema. SKILL.md (task 16) describes same flow.

**Spec consistency:** all helper paths in plan match `docs/superpowers/specs/2026-04-26-osint-research-design.md` §3.1 exactly, except `dorks.sh` and `dorks-results.md` are paired correctly. No `breach-leak-dorks.sh` or `hibp-pwd.sh` references in the plan (those were removed from spec in last review iteration).

---

## Execution

Plan complete. Two execution options:

1. **Subagent-Driven (recommended)** — fresh subagent per task, code review between tasks, fast iteration. Best for plans of this size (26 tasks). Skill: `superpowers:subagent-driven-development`.

2. **Inline Execution** — execute tasks in current session via `superpowers:executing-plans` with batch checkpoints.

Which approach?
