# Research examples

Real research outputs preserved as live examples. Every folder here was produced by running the skills on an actual query. These are committed to the repo (whitelisted in `.gitignore`) so new users can see what the pipeline output looks like without running research themselves.

---

## Available examples

### `claude-code-skills-patterns-2026/` ⭐ newest flagship (v0.7.0 live test)

- **Levels executed:** L1 → L2 → L3 (full end-to-end)
- **Query:** "Claude Code skills — patterns, what's shipping, limitations in 2026"
- **Generated:** 2026-04-18
- **Total sources:** **30** (12 L1 + 10 L2 + 8 L3)
- **Stack exercised:** Firecrawl (scrape) + Tavily (keyword) + **Exa `web_search_advanced_exa`** (v0.5.0 neural) + **Perplexity `perplexity_ask`** (v0.6.0 answer engine — for L3 neutral-angle analysis) + **Agent-tool subagent critic** (L3)
- **Key L3 insight:** the **84%/29% trust-adoption paradox** — 84% of devs use AI coding tools but only 29% trust the code they ship (Stackademic, Apr 2026). L1/L2 entirely missed this neutral signal because the corpus was vendor-biased; Perplexity + L3 critic surfaced it
- **All verification checkpoints passed:** L1 VERIFIED, all 4 L2 CHECKPOINTs, L3 FINAL CHECKPOINT — verified against `.firecrawl/examples/` via shared lib

**Files worth reading:**

- `L1/report.md` — 1,189-word foundation
- `L2/report.md` — 1,998-word synthesis with contradictions + confidence grading
- `L2/contradictions.md` — 3 contradictions surfaced and resolved
- `L2/perplexity-answer.json` — persisted Perplexity MCP response (v0.2.2 persistence pattern in action)
- `L3/perplexity-neutral.md` — independent-angle findings via Perplexity answer engine
- `L3/critic-report.md` — 1,304-word adversarial review from Agent-tool subagent (flagged source bias + CVE scope conflation)
- `L3/fact-check.md` — top-5 claim verification (2 DISPUTED, 2 UNVERIFIED after critic pass)
- `L3/report.md` — 1,757-word expert synthesis with critic corrections integrated
- `L3/executive-summary.md` — 583-word stakeholder version

**Verify yourself:**

```bash
DEEP_RESEARCH_BASE_DIR=.firecrawl/examples \
  bash scripts/lib/verify-research.sh l3 claude-code-skills-patterns-2026
# → ✅ L3 FINAL CHECKPOINT PASSED: 1757-word report, 8 L3 sources, ...
```

Shows the **v0.7.0 full stack end-to-end** — particularly how Perplexity's answer engine surfaces neutral findings that a vendor-tilted L1/L2 corpus misses, and how the L3 critic subagent sharpens findings with scope distinctions (e.g., CVE-2025-59536 is MCP config supply chain, not SKILL.md).

---

### `firecrawl-vs-tavily-2026/` (v0.2.2 live test, added v0.3.0)

- **Levels executed:** L1 → L2 → L3 (full end-to-end)
- **Query:** "Firecrawl vs Tavily для research-пайплайнов в 2026 — когда что использовать, сильные и слабые стороны"
- **Generated:** 2026-04-17
- **Total sources:** 32 (12 L1 + 10 L2 + 10 L3)
- **Codex cross-model channel:** tested under real failure conditions — RATE_LIMITED (L2) and TIMEOUT (L3 x2); v0.2 helper correctly degraded to single-model mode
- **Subagent critic review:** executed successfully (~1200 words, integrated into L3 synthesis)
- **All verification checkpoints passed:** 4× L2 + L3 final (multi-citation safe regex from v0.2.2)

**Files worth reading:**

- `L1/report.md` — 944-word base synthesis with 12 sources
- `L1/sources/` — 12 full page scrapes + per-source summaries
- `L2/report.md` — 1511-word deep-research synthesis with contradictions
- `L2/contradictions.md` — 3 identified contradictions, all resolved with cross-source analysis
- `L2/confidence.md` — H/M/L grading per major claim
- `L2/codex-gap.md.status` — evidence of v0.2 Codex helper RATE_LIMITED path
- `L3/report.md` — 1777-word expert-level synthesis with critic integration
- `L3/critic-report.md` — adversarial subagent review findings
- `L3/fact-check.md` — 5 critical claims verified/disputed/refined
- `L3/decision-matrix.md` — weighted option scoring
- `L3/executive-summary.md` — 561-word stakeholder summary

**Verify this example with the shared library** (v0.3.0+):

```bash
# From the repo root
DEEP_RESEARCH_BASE_DIR=.firecrawl/examples \
    bash scripts/lib/verify-research.sh l1 firecrawl-vs-tavily-2026
# Output: ✅ L1 VERIFIED: 12 scrapes, 12 summaries, 944-word report, citations traceable

DEEP_RESEARCH_BASE_DIR=.firecrawl/examples \
    bash scripts/lib/verify-research.sh l2 firecrawl-vs-tavily-2026
# Output: ✅ All 4 L2 CHECKPOINTs PASSED

DEEP_RESEARCH_BASE_DIR=.firecrawl/examples \
    bash scripts/lib/verify-research.sh l3 firecrawl-vs-tavily-2026
# Output: ✅ L3 FINAL CHECKPOINT PASSED: 1777-word report, 10 L3 sources, critic + fact-check verified
```

This is a great way to see what the verification library actually checks.

---

### `codex-cli-research-agent/` (L3 — v0.1 release test)

- **Level:** L3 (expert-research)
- **Query:** "Best practices for using Codex CLI as a research agent"
- **Generated:** 2026-04-16
- **Sources:** 22+
- **Context:** The research that informed the Codex integration design documented in [docs/CODEX_INTEGRATION.md](../../docs/CODEX_INTEGRATION.md).

Note: this example predates the v0.1.1 verification checkpoints and v0.2.2 citation-regex fix — it has some artifact-structure inconsistencies (e.g., not all `L*/sources/*.sum.md` files exist). It is preserved as the history of how the Codex integration came about, not as a reference-quality artifact. For reference-quality output, see `firecrawl-vs-tavily-2026/`.

---

## Adding a new example

When you run a research session that produced an exemplary output, contribute it here:

1. Move the folder from `.firecrawl/research/<slug>/` → `.firecrawl/examples/<slug>/`
2. Add an entry in this README with tier, query, date, source count
3. Run the verification library to confirm all checkpoints pass:
   ```bash
   DEEP_RESEARCH_BASE_DIR=.firecrawl/examples \
       bash scripts/lib/verify-research.sh lN <slug>
   ```
4. **Verify no secrets or sensitive info** — these examples go in the public repo
5. Open a PR

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for more.
