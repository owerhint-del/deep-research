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
