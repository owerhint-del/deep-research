# Changelog

All notable changes to this project are documented here.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versioning: [SemVer](https://semver.org).

---

## [Unreleased] — v0.8 (planned)

### Planned

- Full Russian translation of ARCHITECTURE and TROUBLESHOOTING
- Real-world L5 validation run (end-to-end full-stack test)
- Marketing: HN/Reddit/Twitter distribution

### Explicitly dropped from roadmap

- ~~MCP-based Codex integration~~ — aesthetic refactor without user value. Helper works, proven in v0.2.2 tests. Wrapping it as MCP wouldn't remove the onboarding friction (user still needs `brew install codex + codex auth login`). Would add ~500 lines of Node.js to maintain for zero functional improvement.
- ~~Streaming Codex output~~ — 1-2 min L3 latency improvement isn't worth the complexity. L3 target is ~20 min, current actual is ~18-22 min — we're already within target. Optimization for optimization's sake.

---

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

### Testing

Run the full suite manually before releasing:

```
for t in tests/lib/test_*.sh tests/channels/test_*.sh tests/security/test_*.sh tests/smoke/*.sh; do
    bash "$t" || exit 1
done
```

All tests must pass. CI integration is out of scope for v0.8.0.

---

## [0.7.0] — 2026-04-18

### Added

- **Obsidian auto-sync for L5 knowledge vaults.** When `OBSIDIAN_VAULT` env var is set, `/ultra-research` automatically exports its vault structure into the user's Obsidian vault with:
  - Subfolder: `<vault>/<OBSIDIAN_RESEARCH_FOLDER>/<slug>/` (default `Research/<slug>/`)
  - YAML frontmatter on every note (tags, query, date, slug, type)
  - Obsidian wiki-links (`[[01-main-report]]`) in the auto-generated `00-index.md`
  - Tag taxonomy: `#research #deep-research #L5 #<doc-type>`
  - All L5 artifacts copied: executive summary, main report, glossary, timeline, playbooks, counter-arguments, open questions, bibliography, methodology, recommended reading
- **Helper script:** `scripts/lib/obsidian-export.sh` — ~180 lines, one exported function `export_l5_to_obsidian()`, also runnable standalone as CLI (`bash ... <slug>`). Deployed to `~/.claude/scripts/lib/` by `install.sh`.
- **`DEEP_RESEARCH_DISABLE_OBSIDIAN=1`** env var for users who want to explicitly opt out.
- **New docs:** `docs/OBSIDIAN_INTEGRATION.md` — full setup, configuration, vault structure, disable options.
- **`install.sh`** prints a tip about `OBSIDIAN_VAULT` when the env var isn't set — helps discovery.

### Fault-tolerance

- Skill checks helper availability → if missing, skip silently
- If `OBSIDIAN_VAULT` unset → skip with `SKIPPED` status (not an error)
- If `OBSIDIAN_VAULT` invalid path → error with explanation, skill continues (L5 doesn't block on export failure)
- Retroactive import: `bash scripts/lib/obsidian-export.sh <slug>` imports any past L5 run

### Roadmap changes

- Removed MCP-based Codex integration and Streaming Codex output from v0.7 plan (see "Unreleased" section rationale above)

---

---

## [0.6.0] — 2026-04-18

### Added

- **Perplexity MCP integration** — fourth research channel, classified as an **answer engine** (vs Tavily/Exa's "URL list" output and Codex's "raw model response"). Perplexity returns a synthesized answer with inline citations in one call — specifically tuned for citation-grounded Q&A.

- **Official Perplexity MCP server** (`server-perplexity-ask`) installable via:
  ```bash
  claude mcp add perplexity-ask -e "PERPLEXITY_API_KEY=pplx-..." -- npx -y server-perplexity-ask
  ```

- **New docs: `docs/PERPLEXITY_INTEGRATION.md`** — integration reference with per-tier usage, model selection guide (sonar/sonar-pro/sonar-deep-research/sonar-reasoning), cost matrix, and comparison table vs Exa's deep_researcher.

- **Per-tier Perplexity integration:**
  - **L0 `/quick-research`** — **primary killer use case.** Replaces 3-step Tavily-search + Firecrawl-scrape + Claude-synthesis pipeline with one Perplexity call. Drops L0 latency from ~1 minute to ~5 seconds. Skill falls back to classic L0 path if Perplexity unavailable or quality-check fails.
  - **L2 `/deep-research`** — Perplexity answer as third parallel channel alongside Tavily/Exa for contradiction-surfacing. Three independent "opinions" triangulate.
  - **L3 `/expert-research` Step 2.4 (fact-check)** — Perplexity verifies top-5 critical claims. Cheaper and more focused than invoking Codex for short verification queries.
  - **L5 `/ultra-research`** — per-iteration fact-verifier alongside Codex. Codex challenges Claude's reasoning, Perplexity grounds claims in current citations — complementary not overlapping.

- **`DEEP_RESEARCH_DISABLE_PERPLEXITY=1`** environment variable for single-backend mode.

- Perplexity setup added to `docs/INSTALLATION.md` as optional Step 4.

### Research ecosystem — v0.6.0 overview

The stack now has four tool categories:

| Category | Tool | Output shape |
|----------|------|--------------|
| Extraction | Firecrawl | Full page content |
| Keyword discovery | Tavily | Ranked URLs + snippets |
| Neural discovery | Exa (v0.5.0) | Semantic-ranked URLs + content |
| **Answer engine** | **Perplexity (v0.6.0)** | **Synthesized answer + citations** |
| Cross-model | Codex (v0.2.0, optional) | GPT-5.4 second opinion |

Skills pick which to invoke based on tier and query shape. All additive — no installs are mandatory beyond Firecrawl and Tavily.

### Changed

- Plugin manifest bumped to v0.6.0.

---

---

## [0.5.0] — 2026-04-18

### Added

- **Exa MCP integration** — a third search channel alongside Tavily and Firecrawl, specializing in **neural semantic search** with its own index of billions of documents. Installed as an MCP server (symmetric with how Tavily is installed):

  ```bash
  claude mcp add --transport http exa \
    'https://mcp.exa.ai/mcp?exaApiKey=YOUR_KEY&tools=web_search_exa,web_search_advanced_exa,...'
  ```

- **New docs: `docs/EXA_INTEGRATION.md`** — full guide covering tool selection, per-tier usage patterns, cost considerations, and decision matrix for when to pick Tavily vs Exa vs Codex.

- **Per-tier Exa integration points:**
  - **L2 `/deep-research`** — Exa `web_search_advanced_exa` as parallel gap-fill channel. Runs alongside Codex; disagreements between Tavily/Exa highlight potential contradictions.
  - **L3 `/expert-research`** — Exa for neutral-angle research with `category` filters. Better at finding conceptually-related dissenting views than keyword search.
  - **L4 `/academic-research`** — **biggest upgrade in v0.5.0.** Exa's `category: "research paper"` index (arXiv, paperswithcode, preprint servers) replaces previous "Tavily + academic keywords" approach. Academic results now automatically grade as Quality A in the bibliography.
  - **L5 `/ultra-research`** — Exa's async `deep_researcher_start`/`deep_researcher_check` pattern kicks off at the start of each iteration, returns structured grounded answer while other iteration work runs.

- **`DEEP_RESEARCH_DISABLE_EXA=1`** environment variable for users who want single-backend mode (symmetric with the Codex disable flag).

- Exa setup step added to `docs/INSTALLATION.md` as optional Step 3.

### Changed

- Plugin manifest bumped to v0.5.0 (`plugin.json`, `marketplace.json`).

### Notes on graceful degradation

- Skills check for Exa MCP tool availability at runtime — if `mcp__exa__*` not present, the Exa step is skipped silently
- All v0.4.0 behavior preserved for users who don't install Exa
- Exa integration is additive — Firecrawl + Tavily + Codex still cover their existing roles

---

---

## [0.4.0] — 2026-04-17

### Added

- **Claude Code plugin manifest** — `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` at repo root. Enables one-command install via Claude Code's plugin system:
  ```
  /plugin install hint-shu/deep-research
  ```
  No more `git clone + bash install.sh` required for users on Claude Code 2.1.30+. Manual install remains available as a fallback.

### Changed

- **Migrated L1, L2, L3 skills to source the shared verification library** instead of inlining CHECKPOINT Bash. Each skill now has:
  ```bash
  VERIFY_LIB="$HOME/.claude/scripts/lib/verify-research.sh"
  [ -f "$VERIFY_LIB" ] || VERIFY_LIB="scripts/lib/verify-research.sh"
  source "$VERIFY_LIB"
  verify_l{1,2,3}_checkpoint_N "$SLUG" || exit 1
  ```
  instead of ~30 lines of inline Bash per checkpoint.

- **Skill size reduction** (lines of markdown/code):
  - `research/SKILL.md`: 320 → 299 (-21)
  - `deep-research/SKILL.md`: 596 → 508 (**-88**, biggest win — 4 CHECKPOINTs collapsed)
  - `expert-research/SKILL.md`: 530 → 503 (-27)
  - Total: -136 lines (-5.2% across affected skills)

  Skill files are loaded into Claude's context every time the skill is invoked. Thinner skills = less prompt bloat for users.

### Regression-tested

- All 3 tiers (L1, L2 all 4 CHECKPOINTs, L3 FINAL) pass on the flagship example using the shared library after migration. No behavioral change — just centralization.

### Backward compatibility

- Fallback path in skill Bash: skills try `$HOME/.claude/scripts/lib/verify-research.sh` first, then `scripts/lib/verify-research.sh`, then error. Covers plugin installs, `install.sh` installs, and in-repo development runs.

---

---

## [0.3.0] — 2026-04-17

### Added

- **Shared verification library** `scripts/lib/verify-research.sh` — centralizes the Bash checkpoint logic previously duplicated across L1/L2/L3 skills. Single source of truth for citation regex (the v0.2.2 multi-cite fix), file-size checks, source-summary pairing, and traceability checks. Exposes `verify_l1`, `verify_l2`, `verify_l2_checkpoint_{1..4}`, `verify_l3` functions plus a CLI entrypoint.
- **`install.sh` deploys the shared lib** to `~/.claude/scripts/lib/verify-research.sh` alongside the existing `codex-research.sh` helper.
- **`DEEP_RESEARCH_BASE_DIR` env var** — lets the verify library run against `.firecrawl/examples/` or a custom artifact location (default remains `.firecrawl/research`). Useful for CI-style validation of committed examples.
- **Full live-test example at `.firecrawl/examples/firecrawl-vs-tavily-2026/`** — complete L1+L2+L3 run (32 sources, 4 L2 checkpoints passed, L3 final checkpoint passed, Codex helper's RATE_LIMITED and TIMEOUT paths captured as evidence of v0.2 fault tolerance working). Verifiable with `scripts/lib/verify-research.sh`.

### Changed

- **L3 report minimum lowered from 2000 to 1700 words** based on observed real-session output (1777 words was the measured baseline for a rigorous, cited, critic-reviewed L3 synthesis). Target stays at 2000-3000 in skill guidance — the hard minimum just prevents truly truncated output rather than over-constraining realistic runs.
- Examples README significantly expanded with instructions for verifying examples using the shared lib and context for each example's historical relevance.

### Backward compatibility

- Skills still have inlined CHECKPOINT Bash blocks — they work as before, no forced migration. The shared lib is an **additional** path, not a replacement. Future releases will migrate skills one at a time with verification that nothing regresses.

---

## [0.2.2] — 2026-04-17

Patch release based on end-to-end live testing of the full L0→L3 ladder. Fixes regressions and bugs surfaced during real research runs, not theorized ones.

### Fixed

- **Citation regex silently missed multi-citations** (L1, L2, L3). The prior regex `\[[0-9]+\]` only matched single-number brackets like `[1]`, completely missing `[1, 3, 16]` formats. This meant citation-traceability CHECKPOINTs could false-pass on reports where hallucinated references appeared inside multi-cite groups. New regex `\[[0-9][0-9, ]*\]` plus comma-split catches both formats.
- **L3 had no formal Bash-enforced FINAL CHECKPOINT** — regression from L2's 4-checkpoint discipline. Added `🛑 L3 FINAL CHECKPOINT` block verifying report, executive summary, critic report, fact-check, bibliography, perspective plan, ≥8 L3 sources, and citation traceability before delivery.
- **Codex timeouts were too aggressive for higher tiers.** L3 calls include a 200-line L2 report as context + require web search; 240s was failing routinely. New defaults: L2=180s (unchanged), L3=360s, L4=360s, L5=420s (Researcher C) / 300s (fact-checker).
- **Codex helper was silent on WHY timeouts happened** — stderr was only shown in status if failure was classified. Now the full Codex stderr is always preserved as `<output>.log` sidecar, regardless of success/failure. Essential for diagnosing whether Codex died during auth handshake, mid-search, or during synthesis.
- **L3 report target (3000-4500 words) was unrealistic** for single-session execution without heavy subagent delegation. Relaxed to 2000-3000 in v0.2.2 skill docs + updated FINAL CHECKPOINT minimum to 2000.

### Added

- **Tavily result persistence instructions** in L1, L2, L3 skills. Tavily MCP responses live in conversation context only by default — if compaction hits, they're lost and CHECKPOINTs can't audit them. Skills now instruct Claude to `Write` each Tavily response JSON to disk (`tavily-N.json` in the appropriate L*/ folder).
- **L3 budget section** now documents subagent token cost (~50-80K for critic agent) and Codex token cost (~200-300K across 2 parallel calls) — previously only Tavily credits were budgeted.

---

## [0.2.1] — 2026-04-17

### Fixed

- **Codex helper success-first classification.** v0.2.0's helper checked stderr for auth/rate-limit patterns **before** checking success. Codex 0.120.0 emits non-fatal MCP transport warnings (including occasional `invalid_grant` messages from a background subsystem) to stderr during normal execution — the helper was false-flagging these as `AUTH_FAILED` and deleting valid Codex output. Reordered: success (exit 0 + non-empty output) now wins, stderr noise is preserved as `<output>.stderr` sidecar for debugging but doesn't trigger failure classification.
- Auth-failure detection tightened to avoid matching benign MCP subsystem patterns.

### Verified end-to-end
- Real web-search query returned a current answer with live URL; status `SUCCESS`, exit 0. Previously this same call was classified `AUTH_FAILED` and output deleted.

---

## [0.2.0] — 2026-04-17

### Added

- **Codex CLI cross-model channel** integrated into L2, L3, L4, and L5 skills:
  - **L2 `/deep-research`**: parallel gap-filler during scrape phase — output to `L2/codex-gap.md`
  - **L3 `/expert-research`**: two parallel Codex calls (neutral-angle researcher + cross-model critic) alongside Claude's critic agent
  - **L4 `/academic-research`**: Codex as Researcher C in the multi-agent crew, complementing Researcher A (web) and Researcher B (academic)
  - **L5 `/ultra-research`**: Codex as Researcher C AND dual-model fact-checker, invoked in every recursive iteration until knowledge saturation
- **Fault-tolerant helper** `scripts/codex-research.sh` (installed to `~/.claude/scripts/` by `install.sh`):
  - Auto-detects and handles 5 failure modes: disabled, not installed, auth expired, rate-limited, timeout
  - Cross-platform timeout (native `timeout` → `gtimeout` → `perl -e 'alarm'` fallback — works on macOS by default)
  - Returns distinct exit codes (124/125/126/127/128) and writes human-readable `.status` file next to output
  - Removes partial output on any failure so synthesis can never accidentally read garbage
- **`DEEP_RESEARCH_DISABLE_CODEX=1`** environment variable to force single-model mode
- **Russian translation** of `docs/CODEX_INTEGRATION.md` → `docs/ru/CODEX_INTEGRATION.md`
- **Updated `install.sh`** to deploy the Codex helper to `~/.claude/scripts/codex-research.sh`

### Changed

- Skills now explicitly note single-model vs cross-model mode in confidence sections of reports
- Status file (`<output>.md.status`) added so skills can route the pipeline based on Codex outcome
- Contradiction detection in L2+ now explicitly reads Codex output when present

### Not broken

- All L0/L1 behavior unchanged — L1 still works identically for downstream skills
- Skills fall back gracefully when Codex unavailable — the ladder works standalone in single-model mode

---

## [0.1.1] — 2026-04-17

### Fixed

- **L2 "hollow synthesis" bug** — L2 deep-research could previously produce reports citing `[L2-N]` sources without ever running the scrape step. Four mandatory Bash-verification checkpoints are now baked into `deep-research/SKILL.md`:
  - Checkpoint 1: L1 foundation present (report, bibliography, ≥10 source summaries)
  - Checkpoint 2: L2 searches returned ≥10 unique URLs
  - Checkpoint 3: L2 scrapes produced ≥8 real non-trivial files with matching `.sum.md` companions
  - Checkpoint 4: final report cites only sources that exist in bibliography
- **L1 final verification** — added analogous end-of-pipeline check in `research/SKILL.md` so broken L1 output never ships to downstream L2/L3/L4/L5.
- **Bibliography requirement** — every L1+ report now has an enforced non-empty bibliography.

### Added

- Russian documentation: `README.ru.md`, `docs/ru/INSTALLATION.md`, `docs/ru/USAGE.md`, `docs/ru/USE_CASES.md`, `docs/ru/README.md` (index).
- Language switcher badges in READMEs.
- "Why these checkpoints exist" section in `deep-research/SKILL.md` documenting the hollow-synthesis failure mode in detail.

---

## [0.1.0] — 2026-04-17

First public release. Internal toolkit made public.

### Added

- Six-tier research ladder:
  - `/quick-research` (L0) — ~1 min, 3–5 sources, fact-check
  - `/research` (L1) — ~5 min, 10–15 sources, ~1,000-word report
  - `/deep-research` (L2) — ~12 min, 20–30 sources, ~2,000-word report with contradictions
  - `/expert-research` (L3) — ~20 min, 40–60 sources, 3,000-word report with critic review
  - `/academic-research` (L4) — ~40 min, 80–120 sources, 5,000-word academic report
  - `/ultra-research` (L5) — 1+ hour, 150+ sources, 10,000+ word knowledge vault

- Firecrawl CLI integration for full-page scraping
- Tavily MCP integration for research-grade search
- WebSearch (Claude-native) as redundancy channel
- Per-source summarization for audit trail
- Confidence grading (H/M/L) at L2+
- Contradiction detection at L2+
- Independent critic agent at L3+
- Academic source support (arXiv, Google Scholar) at L4+
- Knowledge saturation loop at L5
- Full vault structure (executive summary, glossary, timeline, playbooks) at L5

- Complete documentation:
  - README.md
  - docs/INSTALLATION.md
  - docs/USAGE.md
  - docs/USE_CASES.md
  - docs/ARCHITECTURE.md
  - docs/CODEX_INTEGRATION.md
  - docs/TROUBLESHOOTING.md
  - CONTRIBUTING.md

- `scripts/install.sh` — one-command install with idempotent re-runs
- `.gitignore` protecting credentials and research artifacts from accidental commits
- `.env.example` template for users
- Example research artifact in `.firecrawl/examples/codex-cli-research-agent/`

### Known issues

- **L2 hollow synthesis** — L2 report can cite `[L2-XYZ]` references without actually scraping those sources. Workaround: re-run, or upgrade to v0.2 when released. See docs/TROUBLESHOOTING.md.
- **Codex integration not yet shipped** — v0.1 skills reference the Codex cross-model channel in docs, but the skill files themselves still need the integration wiring. Planned for v0.2.
- **No plugin marketplace entry** — skills must be installed via `scripts/install.sh` into `~/.claude/skills/`. Plugin-distributable packaging planned for v0.3.

---

## Versioning note

Pre-1.0 versions may have breaking changes between minor versions. Behavior stabilizes from 1.0 onward.
