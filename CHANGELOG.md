# Changelog

All notable changes to this project are documented here.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versioning: [SemVer](https://semver.org).

---

## [Unreleased] — v0.2 (planned)

### Planned

- Codex CLI cross-model channel integrated into L2+ skills
- Environment variable `DEEP_RESEARCH_DISABLE_CODEX=1` for users who want single-model mode
- Full Russian translation of ARCHITECTURE, CODEX_INTEGRATION, TROUBLESHOOTING

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
