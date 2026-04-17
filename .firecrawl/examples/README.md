# Research examples

Real research outputs preserved as live examples. Every file here was produced by running the skills on an actual query.

These are committed to the repo (whitelisted in `.gitignore`) so new users can see what the output looks like without running research themselves.

---

## Available examples

### `codex-cli-research-agent/`

- **Level:** L3 (expert-research)
- **Query:** "Best practices for using Codex CLI as a research agent"
- **Generated:** 2026-04-16
- **Sources:** 22+
- **Files to look at:**
  - `L1/report.md` — ~1,000-word base synthesis
  - `L1/sources/` — 15 full page scrapes
  - `L2/report.md` — ~2,000-word synthesis with contradictions
  - `L3/report.md` — ~3,000-word executive report with critic review

This is the research that informed the Codex integration design documented in [docs/CODEX_INTEGRATION.md](../../docs/CODEX_INTEGRATION.md).

---

## Adding a new example

When you run a research session that produced an exemplary output, you can contribute it here:

1. Move the folder from `.firecrawl/research/<slug>/` → `.firecrawl/examples/<slug>/`
2. Add an entry in this README with tier, query, date, source count
3. **Verify no secrets or sensitive info** — these examples go in the public repo
4. Open a PR

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for more.
