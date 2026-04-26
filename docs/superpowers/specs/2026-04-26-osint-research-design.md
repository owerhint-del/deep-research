# Spec: `/osint-research` — OSINT recon skill

**Author:** hint-shu
**Date:** 2026-04-26
**Status:** Design approved by user, awaiting written spec review
**Target version:** v0.8.0
**Related skills:** parallel to research-ladder (L0–L5), reuses Tavily/Firecrawl/Exa channels

---

## 1. Problem and goal

The current `deep-research` plugin has six skills (L0–L5) for **topic-focused** research — narrative reports about ideas, technologies, and concepts. They synthesize prose from web sources.

Many real research tasks are **entity-focused** instead: "what is known about company X", "is domain Y legit", "is there a leak involving Z". These need different data classes (DNS, certificates, breaches, exposed services, employees, leaks) and a different output shape (dossier + relationship graph + findings list, not narrative prose).

**Goal:** add a single new skill `/osint-research` that:
- accepts an entity (domain / IP / email / person / company / github user) instead of a topic
- runs passive OSINT recon across ~12 free or pay-per-use channels
- outputs a hybrid report: findings-first → dossier → relationship graph → raw artifacts → audit trail
- lives parallel to (not inside) the L0–L5 ladder
- introduces no monthly subscription dependencies

**Out of goal:** active scanning, exploitation, darkweb crawling, multi-entity tree exploration, real-time monitoring, paid subscription tiers (HIBP, IntelX paid, etc.).

---

## 2. Decisions log (from brainstorming)

| # | Question | Decision | Rationale |
|---|----------|----------|-----------|
| 1 | Use case scope | Universal (security + investigative + competitive + tech recon) | User wants one tool that fits multiple OSINT scenarios |
| 2 | Architecture position | Separate skill `/osint-research`, parallel to L0–L5 | Entity-focused work has different pipeline shape than topic research; clean separation > forced merge |
| 3 | Tooling budget | Free + pay-per-use through existing Tavily/Firecrawl/Exa channels; no monthly subscriptions | User pays per use of existing channels; subscription model rejected explicitly |
| 4 | Output format | Hybrid: Findings → Dossier → Mermaid graph → Raw artifacts → Sources | All four user needs (red flags, structured facts, connections, evidence) covered in one report |
| 5 | Depth tiers | Single skill, no L0–L5-style ladder for OSINT | OSINT exhausts open-source data quickly; no genuine "deeper" tier without paid tools |
| 6 | Ethical scope | Permissive (any public data) with explicit disclaimer in every report and in README | User's call as project owner; documented disclaimers protect users and project reputation |

---

## 3. Architecture

### 3.1 Skill directory layout

```
skills/osint-research/
├── SKILL.md                    # main skill instructions (loaded by Claude Code)
├── channels/                   # per-channel bash helpers
│   ├── whois-dns.sh
│   ├── crtsh.sh
│   ├── wayback.sh
│   ├── shodan-idb.sh
│   ├── github-leaks.sh           # GitHub code search; output is redacted (see §13)
│   ├── theharvester-wrap.sh
│   ├── subfinder-wrap.sh
│   └── dorks.sh                  # general Tavily/Firecrawl dorks; pastebin/dump sites blocklisted
├── templates/
│   ├── osint-report.md.tpl     # hybrid report template
│   └── graph.mmd.tpl           # mermaid graph template
└── lib/
    ├── entity-classifier.sh    # detects domain/email/IP/person/company/github
    └── findings-extractor.sh   # parses channel outputs into findings with priorities
```

### 3.2 Artifacts directory layout

```
.firecrawl/osint/<slug>/
├── osint-report.md             # main hybrid report (the user-facing artifact)
├── graph.mmd                   # mermaid graph source
├── subdomains.csv
├── emails.csv
├── ips.csv
├── findings.md                 # CRITICAL/HIGH findings detail (metadata only, no plaintext secrets — see §13)
├── dorks-results.md
├── tech-stack.md
└── sources.md                  # full audit trail (channel + timestamp per claim)
```

`<slug>` is generated from the target (e.g. `example-corp-com-2026-04-26-1432`).

### 3.3 Cross-cutting files

- `docs/OSINT_INTEGRATION.md` — user-facing documentation (mirrors `EXA_INTEGRATION.md`, `PERPLEXITY_INTEGRATION.md` style)
- `scripts/lib/osint-helpers.sh` — shared library, deployed to `~/.claude/scripts/lib/` by `install.sh`
- `README.md` / `README.ru.md` — new "Specialized skills" section, OSINT entry
- `CHANGELOG.md` — `[0.8.0]` section
- `.claude-plugin/plugin.json` — register new skill, bump to `0.8.0`

---

## 4. Pipeline

### 4.1 Mental flow

```
/osint-research <target>
    ↓
1. Classify entity type
    ↓
2. Phase 1 — parallel independent channel recon
    ↓
3. Phase 2 — channels that depend on Phase 1 outputs
    ↓
4. Findings extraction (assign priorities)
    ↓
5. Cross-reference and dedup
    ↓
6. Synthesize report and artifacts
```

### 4.2 Entity classification

| Input pattern | Type | Example |
|---|---|---|
| `<word>.<tld>` | domain | `vsenamid.ru` |
| IPv4 / IPv6 | IP | `8.8.8.8` |
| `<local>@<domain>` | email | `nmaximov@gmail.com` |
| Any quoted string (default for ambiguous strings) | person | `"Pavel Durov"`, `"John"` |
| `--company "<name>"` flag (explicit override) | company | `--company "Anthropic"` |
| `github:<handle>` | github | `github:anthropics` |

Classifier sits in `lib/entity-classifier.sh`. Type drives which channels run.

### 4.3 Channel-to-entity matrix

| Channel | domain | IP | email | person | company |
|---|:-:|:-:|:-:|:-:|:-:|
| Whois/DNS | ✅ | ✅ | — | — | — |
| crt.sh | ✅ | — | — | — | ✅ (corp domains) |
| Wayback | ✅ | — | — | — | ✅ |
| Shodan IDB | ✅ (resolve→IP) | ✅ | — | — | — |
| theHarvester | ✅ | — | — | — | ✅ |
| subfinder | ✅ | — | — | — | ✅ |
| GitHub code search (with redaction) | ✅ | — | ✅ | ✅ | ✅ |
| Tavily Dorks (general, no leak-site queries) | ✅ | ✅ | ✅ | ✅ | ✅ |
| Firecrawl scrape | ✅ | — | — | ✅ | ✅ |
| Exa neural | — | — | — | ✅ | ✅ |
| Perplexity | — | — | — | ✅ | ✅ |

### 4.4 Phase composition

**Phase 1 (parallel):** Whois, DNS, crt.sh, Wayback, GitHub code search (with secret redaction, see §13), theHarvester, subfinder, Tavily general dorks, Perplexity (when entity is person/company). All independent — no shared inputs.

**Phase 2 (depends on Phase 1):**
- Shodan IDB queries — needs IPs from DNS resolve
- Firecrawl scrape — needs URLs from top dork results
- Exa neural search for related entities — uses entity names found in Phase 1 (subsidiaries, partners)

**Phase 3 (synthesis):** Claude reads all channel outputs, builds findings list, fills templates, writes artifacts.

### 4.5 Findings classification rules

Each channel feeds raw data through `findings-extractor.sh`, which assigns priority by rules:

- 🔴 **CRITICAL:** secrets detected in public GitHub repos (only metadata recorded — see §13 redaction policy), exposed databases without auth (Shodan IDB shows open Redis/Mongo/Elasticsearch), exposed admin panels with default-credential signatures
- 🟠 **HIGH:** known CVEs on detected open ports, takeover-vulnerable subdomains, sensitive paths exposed (`/admin`, `/.git`, `/.env` accessible publicly)
- 🟡 **MEDIUM:** outdated tech stack (EOL versions), suspicious subdomain naming (`admin-`, `dev-`, `staging-` exposed publicly), unusual cert history
- 🟢 **LOW:** general infrastructure facts, public registrations, normal tech stack info

Priorities surface at the top of `osint-report.md`.

### 4.6 Cross-reference and deduplication

- One email found in `theHarvester` AND `tavily dorks` → single entry in `emails.csv` with both sources cited
- Subdomains from `crt.sh` are checked via DNS — if they don't resolve, marked `inactive` in CSV (still listed for completeness, but excluded from infrastructure section)
- Email pattern from leaked emails should match domain — mismatches flagged as "unverified"
- IPs from DNS resolve are de-duplicated against Shodan IDB results

### 4.7 Budget

- **Time:** ~10–15 min for a typical entity (parallelism is essential — sequentially this would be ~30–40 min)
- **Credits:** ~30–50 across Tavily/Firecrawl/Exa/Perplexity, comparable to `/deep-research` (L2)
- **Money:** $0/mo guaranteed (no subscriptions). Variable spend through existing pay-per-use channels.

---

## 5. Output format

### 5.1 Report skeleton

```markdown
# OSINT Report: <entity>

> ⚠️ Disclaimer: This report is generated from publicly available
> information. Use is at your own risk. Verify findings independently
> before action. Author and tool are not responsible for misuse.

**Generated:** <timestamp>
**Entity type:** <type>
**Channels run:** <N> / <total> (<skipped count> skipped: <reasons>)
**Duration:** <duration>

---

## 🚨 Findings Summary

**🔴 CRITICAL (<N>)** ...
**🟠 HIGH (<N>)** ...
**🟡 MEDIUM (<N>)** ...
**🟢 LOW (<N>)** ...

---

## 📋 Entity Dossier
### Identity
### Infrastructure
### People & Emails
### History
### Leaks & Breaches
### Tech Stack
### Related Entities

## 🕸 Relationship Graph
[mermaid diagram inline]

## 📁 Raw Artifacts
[links to CSV/MD files]

## 📚 Sources
[full audit trail — every claim cited to channel + timestamp]
```

### 5.2 Format invariants

1. **Disclaimer is non-removable** — injected by skill into every report, top of file. Includes the §13.6 line about secret handling.
2. **Findings come first** — the highest-value content is above the fold.
3. **Cross-references** — every Findings line links to its detail anchor in the Dossier; every Dossier item links back to its Findings entry if any.
4. **Audit trail completeness** — every factual claim in the report traces to at least one channel call with timestamp. No claim without a source.
5. **Mermaid graph degradation** — for entities with > 30 nodes, graph shows top-N most-connected nodes plus a link to full CSV. Beyond that, mermaid becomes unreadable.
6. **No plaintext secrets, ever** — see §13. Detected secrets are recorded as type + location + truncated match (first-4/last-4). Implementation must enforce this at helper level, not by Claude convention.

### 5.3 Why this format

- **Hybrid (D)** chosen by user during brainstorming because the universal use case (E) needs all of: red flags, structured facts, connections, evidence.
- Format mirrors `research-skill` artifact pattern (one main `*.md` plus typed support files in same directory) — ensures consistency in mental model and tooling.

---

## 6. Tool stack

### 6.1 Always available (no install, no key)

- `whois`, `dig`, `host` — bash builtins
- `curl` — for HTTP-based APIs
- crt.sh — public Certificate Transparency search, no auth
- Wayback Machine API — no auth
- Shodan InternetDB (`internetdb.shodan.io`) — public free endpoint, no auth, returns ports/CVEs/hostnames per IP
- GitHub code search via public web (or via gh CLI if available)
- Tavily — already used by other skills, pay-per-use
- Firecrawl — already used by other skills, pay-per-use
- Exa — already used by L2+, pay-per-use
- Perplexity — already used by L0+ (v0.6.0+), pay-per-use, used here for context enrichment on person/company entities

### 6.2 Optional CLI (recommended, install if missing)

- `theHarvester` — open source OSINT framework (`brew install theharvester` or `pipx`)
- `subfinder` — fast subdomain enumeration (`brew install subfinder`)
- `amass` — **alternative** to subfinder for subdomain enumeration (`brew install amass`); used as fallback if subfinder fails or for cross-validation
- `dnstwist` — **enrichment-only** channel for typosquatting/domain-spoofing detection (`pipx install dnstwist`); not in §4.3 matrix because it produces a separate `typosquats.md` artifact rather than feeding the main dossier
- `gh` (GitHub CLI) — improves GitHub code search rate limits
- `Hunter.io` API key — free 25/mo, optional, improves email pattern detection

### 6.3 Excluded from scope

- Shodan paid Membership / API key — replaced by free InternetDB endpoint
- HIBP entirely (both Pwned Passwords k-anon and paid Breached Account API) — out of scope. The free endpoint only checks password hashes, which is not a meaningful signal in entity-recon (we don't know the password). The paid endpoint is excluded by the no-subscription constraint. For email-in-breach coverage, this skill is shallower than commercial OSINT — see §10.2.1.
- All breach-leak dump sites (pastebin.com, breached.cc, dehashed.com, raidforums archives, doxbin, etc.) — explicitly **blocklisted** in dorks. Reason: copying stolen data from these sources into local artifacts is both ethically problematic (re-distributing leaked PII) and legally risky in many jurisdictions, regardless of the report being for personal use. See §13 Security & Privacy.
- Hunter.io paid — free tier sufficient
- IntelX, OSINT Industries, Maltego Hub — paid subscriptions, dropped
- nmap, masscan, sqlmap — active scanning, out of ethical scope
- Anything requiring darkweb access

---

## 7. Error handling

OSINT pipeline runs ~12 channels in parallel — fault tolerance is not optional.

### 7.1 Channel classification

| Tier | Channels | Behavior on failure |
|---|---|---|
| **Required** | Whois, DNS | Abort with clear error message. Without these, no useful report. |
| **Recommended** | crt.sh, Wayback, Shodan IDB, GitHub code search, Tavily dorks, Perplexity | Continue. Mark `SKIPPED: <reason>` in report. |
| **Optional** | theHarvester, subfinder, amass, dnstwist, Hunter.io, gh CLI | Silent skip if missing. Add tip in report: "install `<tool>` for richer results". |

### 7.2 Specific failure modes

- **Tavily/Firecrawl/Exa rate limit:** exponential backoff (3 retries) → if still fails, mark channel PARTIAL, continue with other channels.
- **Shodan IDB returns 404 for IP:** treated as "no data on this IP" (normal), not as error.
- **theHarvester / subfinder not in PATH:** warning at start of report + install tip; do not fail.
- **crt.sh timeout (common):** fallback to subfinder if available; otherwise skip subdomain enum and mark in report.
- **DNS does not resolve:** entity is likely dead/parked; report still generated from channels that don't need DNS (Wayback, GitHub history, dorks).
- **Channel returns malformed JSON:** log raw response in `sources.md`, mark channel ERRORED in status block, continue.

### 7.3 Channel status block

Every report includes a `Channels run` block at the top so the user knows which signals were and weren't available:

```
**Channels run:** 9 / 12
- ✅ Whois, DNS, crt.sh, Wayback, Shodan IDB, GitHub, theHarvester, Tavily dorks, Firecrawl
- ⚠️ subfinder: not installed (install: brew install subfinder)
- ⚠️ Hunter.io: free tier exhausted (resets 2026-05-01)
- ❌ Exa: API key not configured
```

This is critical UX — the user should never wonder "did I get full coverage or partial".

---

## 8. Testing

The skill is markdown instructions plus bash channels. Testing follows existing `deep-research` conventions: no formal CI, but bash test harness for channels and snapshot test for report shape.

### 8.1 Unit tests (`tests/channels/`)

Each channel has a test file with mocked API responses:

- `test_crtsh.sh` — mocked crt.sh JSON, parse correctness
- `test_whois-dns.sh` — mocked whois output, multi-format parser
- `test_shodan-idb.sh` — mocked InternetDB JSON, including 404 (no data) case
- `test_dorks.sh` — Tavily dork query construction (advanced operators correctly built)
- ... one per channel

Edge cases per channel: empty response, malformed JSON, rate-limit response, unicode/punycode domains.

### 8.2 Entity classifier tests

`tests/lib/test_entity-classifier.sh`:

- `target.com` → `domain` ✅
- `1.2.3.4` → `IP` ✅
- `2001:db8::1` → `IP` ✅
- `a@b.com` → `email` ✅
- `"John Doe"` (quoted) → `person` ✅
- `"Acme Corp"` with `--company` flag → `company` ✅
- `github:anthropics` → `github` ✅
- Edge: emoji in name, internationalized domain (xn--), invalid input

### 8.3 Findings extractor tests

`tests/lib/test_findings-extractor.sh`:

- Mock channel outputs containing known CRITICAL signals (open Redis on port 6379, SSH key in repo) → verify CRITICAL classification
- Mock channel outputs containing only neutral facts → verify all LOW/no findings
- Deduplication: same email in 3 channels → 1 entry in `emails.csv` with all 3 sources cited

### 8.4 End-to-end smoke tests

- `tests/smoke/example-com.sh` — runs `/osint-research example.com` (RFC reserved, stable forever) → snapshot test of report **structure** (sections present), not content
- `tests/smoke/dead-domain.sh` — runs against a known-dead domain → verify graceful degradation, no crash
- `tests/smoke/anthropic-com.sh` — runs against a real public company → verify completeness of report sections (manual review, not assertion-based)

### 8.5 CI scope

Out of scope for v0.8.0. Existing research skills don't have CI either; testing is manual + smoke. If/when CI is added project-wide, OSINT channels integrate naturally.

---

## 9. Install integration

### 9.1 `scripts/install.sh` updates

- Copy `osint-helpers.sh` → `~/.claude/scripts/lib/`
- Copy `skills/osint-research/` → `~/.claude/skills/osint-research/`
- Detect optional CLI presence (theHarvester, subfinder, amass, dnstwist, gh) — print install tips for missing ones, never fail
- Print tip about Hunter.io free signup if `HUNTER_API_KEY` env var not set
- Print pointer to `docs/OSINT_INTEGRATION.md` for first-run guidance

### 9.2 Plugin manifest (`.claude-plugin/plugin.json`)

- Add `osint-research` to the skills list
- Description: `"OSINT recon skill — entity discovery via passive public sources"`
- Bump version: `0.7.0` → `0.8.0` (major feature, not patch)

### 9.3 Documentation

- `docs/OSINT_INTEGRATION.md` — new file. Sections: what it does, channel inventory, optional CLI install, ethics disclaimer (full text), examples.
- `README.md` — add "Specialized skills" section below the L0–L5 ladder table; add `/osint-research` entry there. Do **not** mix into ladder table.
- `README.ru.md` — same change in Russian.
- `CHANGELOG.md` — `[0.8.0]` section: "Added OSINT recon skill" with full feature list.

### 9.4 Optional dependencies declaration

`OSINT_INTEGRATION.md` will state up front: "Base functionality works with what's already in the project (Tavily, Firecrawl, Exa). For richer coverage, install:" followed by the optional CLI list with one-line install commands.

---

## 10. Scope summary

### 10.1 In scope (v0.8.0)

- Single skill `/osint-research`
- Entity types: domain, IP, email, person, company, github
- 12 channels (free + pay-per-use through existing project channels)
- Hybrid output format with disclaimer, findings, dossier, mermaid graph, raw artifacts, audit trail
- Permissive ethical scope, with non-removable disclaimer in every report
- Single pass per invocation, ~10–15 min, ~30–50 credits

### 10.2 Out of scope

- Multi-entity tree exploration (one entity per invocation)
- Active scanning, vulnerability exploitation, nmap-style probing
- Darkweb crawling
- Paid subscriptions (HIBP Breached Account API, IntelX paid, Shodan Membership, DeHashed, etc.)
- Real-time monitoring or alerts
- L0–L5 ladder for OSINT (one skill, no depth tiers)
- Auto-detection that triggers OSINT inside existing research skills (separate path; user explicitly chooses `/osint-research`)

### 10.2.1 Known coverage caveats

Because we exclude paid subscriptions **and** explicitly avoid breach-leak dump sites for security/legal reasons (§13), several OSINT sub-domains have **shallower** coverage than commercial OSINT tools:

- **Email-in-breach lookup:** Out of scope. We do not query HIBP Breached Account API (paid), and we do not scrape pastebin/dump sites (excluded for ethical/legal reasons — see §13). The only signal we surface is when secrets are committed to **public GitHub repos** (with redaction). For comprehensive email-in-breach checks, users should pair this skill with HIBP's official UI on `haveibeenpwned.com` externally.
- **Plaintext credential discovery:** Out of scope by policy. The skill detects that a secret was leaked (commit hash, file path, secret type) but **never** records the secret itself in artifacts.
- **Person enrichment:** No paid people-search APIs (Pipl, Spokeo, OSINT Industries). Coverage limited to LinkedIn dorks, GitHub commits, Wayback, and Perplexity context.
- **Darkweb mentions:** Out of scope. Use IntelX or commercial darkweb monitoring externally if needed.

These caveats are documented in `OSINT_INTEGRATION.md` so users have correct expectations.

### 10.3 Future (not committed)

- v0.8.x — fixes from real-world runs, dorks template expansion
- v0.9 (only if real demand surfaces) — paid Apify integration, or 2-tier mini-ladder (`/quick-osint` + `/osint-research`)

---

## 11. Risks and mitigations

| Risk | Mitigation |
|---|---|
| OSINT skill gets used for doxxing / harassment | Non-removable disclaimer in every report; README explicitly states "use at your own risk"; permissive scope is documented as a deliberate choice with user assuming responsibility; PII aggregation rules in §13.4 prevent the worst patterns (no joining of name+email+address into profiles) |
| Skill artifacts contain plaintext secrets and become a leak vector | Hard redaction policy (§13) enforced at helper level, not by convention. Tests in `tests/security/` verify no plaintext secret ever lands in any artifact. |
| Dorks abuse breach-leak dump sites and pull stolen data into local files | Hardcoded blocklist (§13.3) at helper level, cannot be disabled by user. Verified by `tests/security/test_dorks_blocklist.sh`. |
| Channel APIs change format and break parsers | Each channel has its own bash helper isolated; failure of one channel does not break others (graceful degradation by design) |
| Paid CLI tools not installed → poor results | Channel status block shows what ran and what didn't; install tips included in report; base functionality works without optional CLI |
| Mermaid graph unreadable for large entities | Graph capped at top-N nodes by connectivity; full data always available in CSV artifacts |
| Tavily/Firecrawl/Exa rate limits exhausted mid-run | Exponential backoff + PARTIAL marker; report still generated from completed channels |
| Findings extractor misclassifies severity | Rules are simple and conservative (over-classify rather than under); user reviews, not auto-actions |
| Open source ecosystem blowback against OSINT in plugin | Disclaimers, README ethics section, no active recon, no paid leak resources — minimizes attack surface |

---

## 12. Acceptance criteria

This spec is complete when implementation can begin without further design questions. The following criteria define success for the v0.8.0 implementation:

1. `/osint-research example.com` produces a complete `osint-report.md` in `.firecrawl/osint/<slug>/` with all required sections (Disclaimer, Findings Summary, Dossier, Graph, Raw Artifacts, Sources).
2. All channels listed in §4.3 have a working bash helper in `skills/osint-research/channels/`.
3. Entity classifier correctly identifies all 6 types from §4.2.
4. Findings extractor assigns priorities according to §4.5 rules.
5. Report includes channel status block per §7.3.
6. **No artifact in `.firecrawl/osint/<slug>/` contains plaintext secrets** — verified by §13 redaction tests (`tests/security/test_no_plaintext_secrets.sh`).
7. **Dorks blocklist is enforced** — Tavily/Firecrawl queries against blocklisted domains (§13.3) are rejected at helper level, verified by `tests/security/test_dorks_blocklist.sh`.
8. `install.sh` deploys OSINT helpers and prints CLI install tips for missing optional tools.
9. `docs/OSINT_INTEGRATION.md` exists and covers what's described in §9.3, including §13 Security & Privacy section.
10. `README.md` lists `/osint-research` in a "Specialized skills" section, distinct from L0–L5 ladder.
11. Plugin manifest bumped to `0.8.0`.
12. CHANGELOG entry for `[0.8.0]` covers all the above.

---

## 13. Security & Privacy (secret-handling policy)

This section is **load-bearing** — it defines the hard boundary on what the skill may and may not write to local artifacts. Implementation must match this exactly.

### 13.1 Core principle

The skill **discovers** the existence of leaked secrets but **never re-distributes them**. Existence + location = useful signal. Plaintext copy in a local file = liability and additional exposure.

### 13.2 Redaction rules (mandatory)

When a channel surfaces what looks like a secret (regex-detected patterns: API keys, private keys, tokens, passwords, AWS access keys, JWT, etc.):

| Field | Recorded in artifact | Example |
|---|---|---|
| Type of secret | ✅ Yes | `aws_access_key_id`, `private_ssh_key`, `github_pat` |
| Location | ✅ Yes | `github.com/example-corp/legacy@a1b2c3d, file: config/dev.env, line 14` |
| Detection timestamp | ✅ Yes | `2026-04-26T14:32:11Z` |
| Pattern match (truncated) | ⚠️ First 4 + last 4 chars only | `AKIA...XYZW` (never the full key) |
| **Plaintext value** | ❌ **NEVER** | — |
| **Surrounding code** | ❌ Never (could include other secrets / PII) | — |

The first-4 / last-4 pattern is the **same** convention used by GitHub Secret Scanning UI and is sufficient for the user to verify which secret was found without the artifact itself becoming a leak.

### 13.3 Dorks blocklist

The general dorks helper (`channels/dorks.sh`) **must** reject queries containing any of the following domains as `site:` operators (case-insensitive). The list is enforced at helper level — not just by Claude convention — so misuse is impossible:

```
pastebin.com, paste.ee, ghostbin.com, hastebin.com,
breached.cc, breachforums.is, raidforums.com, cracked.io,
dehashed.com, leakcheck.io, intelx.io,
doxbin.com, doxbin.org, doxbin.net,
ddosecrets.com, distributeddenialofsecrets.com
```

Reason: copying content from these domains into local artifacts (or even fetching it through paid Tavily credits) constitutes redistribution of stolen / leaked PII. Even for personal use this is risky in most jurisdictions and ethically incompatible with the stated "Permissive" scope (which means "any legitimate public data", not "any data that ended up online").

The user can extend the blocklist via env var `OSINT_EXTRA_BLOCKLIST` (comma-separated). The user **cannot** disable the default blocklist — it is hardcoded.

### 13.4 PII handling

Public personal data (names, public email addresses, public LinkedIn profiles) is **in scope** under the Permissive ethical decision (§2 row 6).

But the skill must NOT:
- Combine PII fields into "profiles" of private individuals (e.g. join a name + email + home address from leaked data into one record). Aggregation is what makes raw OSINT data dangerous.
- Record home addresses, phone numbers, government IDs, financial data, or family relationships of named individuals — even if they appear in dork results.
- Cache PII in the audit trail beyond what is in the report itself. `sources.md` cites channels and timestamps, not raw PII.

These constraints apply even though the ethical scope is Permissive. "Permissive" means the user takes responsibility for use, not that the skill produces maximum-exposure artifacts.

### 13.5 Verification (tests)

- `tests/security/test_no_plaintext_secrets.sh` — runs the skill against fixtures known to contain regex-matchable secrets, then greps every artifact for plaintext patterns. Test fails if any plaintext secret appears in any output file.
- `tests/security/test_dorks_blocklist.sh` — calls `dorks.sh` with each blocklisted domain as `site:` operator, asserts non-zero exit and no API call made.
- `tests/security/test_redaction_format.sh` — verifies redacted secrets follow the first-4 / last-4 convention exactly.

### 13.6 Disclaimer expansion

The non-removable disclaimer (§5.2 invariant 1) must include a line about secret handling:

> "When this report references leaked secrets, only their existence and location are recorded — never the secret value itself. To verify a finding, fetch the source location yourself with appropriate authorization."

This sets correct expectations: the skill is a **detection tool**, not a credential exfiltration tool.
