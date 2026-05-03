# Perplexity MCP Integration (v0.6.0–v0.8.0) — DEPRECATED

> ⚠️ **DEPRECATED in v0.9.0.** Perplexity has been removed from the deep-research stack. The "answer engine" role is now served by **Tavily Research** (`tvly research --model auto/mini/pro` with optional `--output-schema` for structured verdicts). See [CHANGELOG.md](../CHANGELOG.md) for the v0.9.0 migration guide. This document is retained for historical reference and for users on v0.6.0–v0.8.0 of the skill set.

---

How to use [Perplexity](https://perplexity.ai) as a fourth channel — an **answer engine** that returns synthesized responses with citations, complementing the raw-materials APIs (Firecrawl, Tavily, Exa) and the cross-model channel (Codex).

---

## What Perplexity adds to the stack

We now have four categories of research tools:

| Category | Tools | What they return |
|----------|-------|------------------|
| **Extraction** | Firecrawl | Full page content from URLs |
| **Discovery (keyword)** | Tavily | Ranked URLs with snippets |
| **Discovery (neural)** | Exa | Semantic-ranked URLs with content |
| **Answer engine** (v0.6.0+) | **Perplexity** | **Synthesized answer + citations** |
| **Cross-model** (optional) | Codex GPT-5.4 | Second opinion from different model |

**Key differentiator:** Perplexity doesn't return URLs for you to read — it reads them and writes an answer with inline citations. Like asking an assistant who already did the research. For L0 fact-checks, this replaces 3 separate steps (search → scrape → synthesize) with one call.

---

## Installation

### 1. Get an API key

Sign up at [perplexity.ai](https://perplexity.ai/settings/api) → API tab. Free tier varies by time; paid from ~$5/month.

### 2. Install the MCP server

Official Perplexity MCP is published as npm package `server-perplexity-ask`:

```bash
claude mcp add perplexity-ask -e "PERPLEXITY_API_KEY=pplx-YOUR_KEY" -- npx -y server-perplexity-ask
```

Verify:

```bash
claude mcp list | grep perplexity
# perplexity-ask: npx -y server-perplexity-ask - ✓ Connected
```

Restart Claude Code if tools don't appear immediately.

---

## Available tool

The server exposes one tool:

| Tool | What it does |
|------|--------------|
| `mcp__perplexity-ask__perplexity_ask` | Send a question, get an answer with citations |

The Perplexity API call supports different models via the `model` parameter:

| Model | Speed | Use for |
|-------|-------|---------|
| `sonar` | Fast (~3s) | Quick fact-checks, L0 |
| `sonar-pro` | Medium (~8s) | Better for complex queries, L1-L3 |
| `sonar-deep-research` | Slow (~2-5 min) | Autonomous multi-step, L4-L5 |
| `sonar-reasoning` | Medium | Multi-step reasoning with explanation |
| `sonar-reasoning-pro` | Medium | Like reasoning + better quality |

If the MCP defaults to `sonar-pro`, that covers most tiers well.

---

## Per-tier integration

### L0 `/quick-research` — THE killer use case

Previously L0 did: Tavily search → Firecrawl scrape 3 URLs → Claude synthesis. ~1 minute total.

**With Perplexity:** one call, ~5 seconds, returns synthesized answer with inline citations already:

```
mcp__perplexity-ask__perplexity_ask with:
  messages: [
    {role: "user", content: "<original query>"}
  ]
```

Output is already in the exact format L0 delivers: short answer + sources. Skill just passes through.

**When to still use Tavily+Firecrawl path for L0:**
- Query needs full content (rare for L0)
- User explicitly requires independent verification
- Perplexity unavailable or rate-limited

Default: Perplexity first, Tavily fallback.

### L1 `/research`

Perplexity runs **alongside** Tavily+Firecrawl, not replacing them. Why: L1 builds an auditable knowledge base with per-source summaries — Perplexity's single-answer output doesn't give you that audit trail.

Use Perplexity as the **3rd sub-question answerer** when the sub-question is answerable by Q&A:

```
# For a sub-question like "how does feature X work"
mcp__perplexity-ask__perplexity_ask with:
  messages: [{role: "user", content: "<sub-question>"}]
```

Save response JSON to `.firecrawl/research/$SLUG/L1/perplexity-<n>.json`. Use its citation URLs as candidates for Firecrawl scrape (ground them further in L1's full-content discipline).

### L2 `/deep-research`

Perplexity as **another contradiction-surfacing channel**. Same query through Tavily, Exa, and Perplexity — if they return different top sources or disagree on facts, that's a red flag worth adding to `contradictions.md`.

Added in Step 2.3a alongside Codex and Exa.

### L3 `/expert-research`

Perplexity plays the **fact-check role** beautifully for L3 Step 2.4 (Fact-check critical claims):

```
# For each of the top 5 critical claims:
mcp__perplexity-ask__perplexity_ask with:
  messages: [{role: "user", content: "Verify this claim: <claim>. Find sources that support or dispute it."}]
```

Perplexity is specifically tuned for citation-grounded Q&A — exactly what fact-checking needs. Cheaper than invoking Codex for short fact-check queries.

### L4 `/academic-research`

Use `sonar-deep-research` model for the hardest academic sub-questions — returns a curated synthesis with academic sources (and often includes arXiv preprints Perplexity has indexed).

Complements but doesn't replace Exa's `category: "research paper"` — Perplexity synthesizes, Exa returns raw papers.

### L5 `/ultra-research`

Per-iteration **fact-verifier**. At the end of each iteration, take the top 3-5 claims and ask Perplexity to verify. Responses feed into `peer-review-N.md`.

Codex still does cross-model critique (different model, different prompt patterns). Perplexity provides cited evidence.

---

## Cost considerations

Perplexity API pricing (as of April 2026, check current rates):

| Model | ~Cost per 1M tokens |
|-------|---------------------|
| `sonar` | $1 input / $1 output |
| `sonar-pro` | $3 input / $15 output |
| `sonar-deep-research` | $2 input / $8 output + $5 per search |
| `sonar-reasoning-pro` | $2 input / $8 output |

Typical calls are 500-2000 tokens input + 500-3000 tokens output:
- Sonar: ~$0.003 per call
- Sonar-pro: ~$0.05 per call
- Sonar-deep-research: $0.25-1.00 per call (includes autonomous search fees)

For our ladder:
- L0-L1: mostly `sonar` — cheap
- L2-L3: `sonar-pro` — ~$0.05-0.20 per session
- L4-L5: 1-3 `sonar-deep-research` calls per session — $0.75-3.00

Monthly budget for heavy use (30 L3 sessions + 5 L5 sessions): ~$15-30.

---

## Decision matrix: when to pick what

| Scenario | Best choice |
|----------|-------------|
| L0 fact-check | **Perplexity** — one call, synthesized + cited |
| L1 topical overview | **Tavily + Firecrawl** — need audit trail per source |
| L2 contradiction surfacing | **Perplexity + Exa + Tavily in parallel** — 3 independent views |
| L3 fact-check top claims | **Perplexity** — tuned exactly for this, cheaper than Codex |
| L4 academic papers | **Exa `category: "research paper"`** primary; Perplexity `sonar-deep-research` for synthesis |
| L5 iteration fact-verify | **Perplexity** — fast, grounded |
| Cross-model (2nd model) | **Codex** — GPT-5.4 is a genuinely different model |
| Need URLs not answers | **Tavily or Exa** — not Perplexity |

**Not mutually exclusive.** L3 can use Perplexity for fact-check AND Exa for neutral-angle AND Codex for cross-model. They measure different things.

---

## Disabling Perplexity

If not installed: skills skip silently. To explicitly disable:

```bash
export DEEP_RESEARCH_DISABLE_PERPLEXITY=1
```

Skills fall back to their pre-v0.6 behavior (Tavily+Firecrawl+Exa+Codex as configured).

---

## Known limitations

- **Perplexity doesn't return raw URLs you can scrape** — responses include citation URLs but the content is already synthesized. For deep extraction you still need Firecrawl.
- **`sonar-deep-research` timeouts** can hit 5+ minutes — treat async like Exa `deep_researcher`
- **Rate limits on free tier** — check your Perplexity dashboard
- **Not a replacement for independent verification** — Perplexity is a single model with a single point of view; Codex gives you a genuinely different model

---

## Comparison: Perplexity vs Exa deep_researcher

Both return "synthesized answer with citations." Which to pick?

| Dimension | Perplexity sonar-deep-research | Exa deep_researcher |
|-----------|-------------------------------|---------------------|
| Index coverage | Broad web + some academic | Exa's own curated index |
| Synthesis quality | Strong Q&A model tuning | Grounded structured output |
| Speed | 2-5 min | 2-5 min |
| Cost | ~$0.50-1/call | Included in Exa credits |
| Use for | Open-ended questions | Specific research tasks |

**L5 pattern:** use both in parallel. Disagreements signal gaps worth more research.
