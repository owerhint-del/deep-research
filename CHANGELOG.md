# Changelog

All notable changes to this project are documented here.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versioning: [SemVer](https://semver.org).

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

### Known limitations deferred to v0.3

- Shared verification bash script (skills would link instead of inlining ~30 lines each)
- PDF export fallback chain (pandoc → weasyprint → wkhtmltopdf → HTML) — currently pandoc → HTML
- Full Russian translation of ARCHITECTURE.md and TROUBLESHOOTING.md

---

## [Unreleased] — v0.3 (planned)

### Planned

- Claude Code plugin marketplace packaging (one-command install via marketplace)
- Additional search backends (Kagi, Exa, Perplexity API)
- Full Russian translation of ARCHITECTURE and TROUBLESHOOTING
- Streaming Codex output (start synthesis before full `-o` file written)
- MCP-based Codex integration (replace Bash shell-out with structured tool calls)

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
