# Architecture

Design philosophy behind the ladder. Why six tiers, why composable, why these specific boundaries.

---

## The core insight

Most LLM research tooling falls into one of two traps:

1. **One-size-fits-all** — a single `/research` command that tries to be fast *and* thorough. It's always wrong for at least half the use cases.
2. **Manual plumbing** — you wire together search, scrape, summarize, synthesize yourself for every investigation. Works, but nobody actually does it consistently.

The ladder solves both by offering **six explicit tiers** with clear boundaries, each composable on top of the previous one.

---

## Why a ladder

| Alternative | Problem |
|-------------|---------|
| One skill with a "depth" parameter | User has no intuition for what `depth=4` means; failure modes are hidden |
| Separate unrelated skills per use case | Code duplication, inconsistent output format |
| Composable ladder | One mental model, one output format, one set of primitives — just more layers for more depth |

The ladder is **explicit about cost/depth tradeoff**. When you type `/deep-research`, you know you're spending ~12 minutes and ~50 Tavily credits. When you type `/ultra-research`, you know it's 1+ hour and you'll get a full vault. That predictability is worth more than marginal flexibility.

---

## Composition rules

The invariant: **every higher tier calls the next-lower tier as its first stage**.

```
L5 calls L4 → calls L3 → calls L2 → calls L1 → produces artifacts
```

Why:

1. **Code reuse** — L2's "reflection loop" logic lives in one place. L3 doesn't re-implement it.
2. **Consistent artifacts** — the `.firecrawl/research/<slug>/L1/` folder always looks the same, whether you invoked L1 directly or via L5.
3. **Partial-failure tolerance** — if L3's critic times out, you still have a working L2 report to fall back on.
4. **Upgrade in place** — running `/expert-research <same query>` after `/deep-research` reuses the L1/L2 artifacts and only runs the L3 layer on top.

---

## What each tier adds

| Tier | Foundation | Unique additions |
|------|-----------|-----------------|
| L0 | — | Search-with-citations (no full scrape) |
| L1 | — | Query decomposition, per-source scrape, per-source summary, structured report |
| L2 | L1 | Gap reflection, follow-up searches, contradiction surfacing, confidence grading |
| L3 | L2 | Independent critic agent, neutral-angle researcher, human-in-loop plan approval |
| L4 | L3 | Academic sources (arXiv, Scholar), multi-agent crew, timeline, annotated bibliography |
| L5 | L4 | Recursive exploration to knowledge saturation, peer-review simulation, full vault structure |

**No tier redefines what a lower tier already does.** L3 doesn't change how L1 scrapes. It only adds the critic pass.

---

## Why these boundaries

### L0 vs L1

L0 has no scrape step. L1 has scrape + summarize. This is the **biggest jump** in the ladder — once you scrape full content, you unlock multi-faceted synthesis.

L0 is ~1 minute because the Tavily search result *is* the answer. L1 is ~5 minutes because it fetches ~10–15 URLs, reads them, and synthesizes across them.

### L1 vs L2

L1 gives you a report. L2 asks "what did L1 miss?" and runs another pass on the gaps.

The key insight: **first-pass research has systematic blind spots**. The planner decomposes into sub-questions, but some important angles only become visible after you've read the first batch of sources. L2's reflection surfaces those.

### L2 vs L3

L2 reports can be internally consistent but wrong. L3 adds an **independent second opinion** — the critic agent never sees L1 or L2 intermediate artifacts, only the final L2 report. It challenges conclusions fresh.

This matters most for strategic decisions where the cost of a confident-but-wrong answer is high.

### L3 vs L4

L3 can miss domains where authoritative sources live behind paywalls or in academic databases. L4 adds explicit arXiv, Google Scholar, and DOI-backed paper fetching. It also introduces **source quality grading** in the bibliography — not every webpage is equally trustworthy.

### L4 vs L5

L4 still terminates after a fixed number of passes. L5 runs a **recursive loop** — it keeps exploring until follow-up searches stop returning new facts (knowledge saturation). This is expensive but necessary for "become an expert" workflows where you want real coverage.

L5 also builds the **knowledge vault** — executive summary, glossary, timeline, playbooks, counter-arguments, open questions. This is a different *shape* of output, not just a longer report.

---

## Why these tools (Firecrawl + Tavily + optional Codex)

### Firecrawl — scraping engine

**Why not just Tavily's `include_raw_content`?** Tavily's raw content is useful for search snippets but often truncated or degraded. Firecrawl is purpose-built for full-page scraping with `--only-main-content` that strips ads and navigation. For the audit trail ("what did the source actually say?"), Firecrawl wins.

### Tavily — search + research API

**Why not the built-in `WebSearch`?** WebSearch is fine as a backup, but:

- Tavily has tiered results (topic-tuned, date-filtered, domain-filtered)
- Tavily's `search_depth=advanced` returns ranked results that are noticeably better for research
- Tavily has an MCP server — clean integration with Claude Code
- Tavily has a Research API on L4/L5 that does multi-hop exploration natively

`WebSearch` is used as a redundancy channel.

### Optional Codex CLI — cross-model channel

**Why add a second model?** Claude and GPT-5.4 have different training cutoffs, different web search indexes, and different biases. When L2+ runs a parallel Codex query, disagreements between the two channels surface quickly — they're a strong signal for the `contradictions.md` file.

Added benefit: Codex runs on the user's existing ChatGPT Pro subscription — no extra API cost on top of what they already pay.

---

## Why artifacts on disk, not in conversation

Every tier dumps its intermediate results into `.firecrawl/research/<slug>/` as markdown and JSON files.

This has three big benefits:

1. **Context hygiene** — the main conversation doesn't bloat with 50 scraped pages. Claude only pulls specific artifacts back into context when synthesizing.
2. **Audit trail** — every claim in the final report points to a file on disk that you can read.
3. **Portability** — commit the folder to your project wiki, share with teammates, feed it back as context for a follow-up task (e.g. "write an RFC based on research/L2/report.md").

---

## Failure modes we explicitly design for

### Hollow synthesis

**Symptom:** report cites `[SOURCE-X]` but no actual file exists at `.firecrawl/research/.../sources/X.md`.

**Cause:** the model skipped the scrape step and synthesized from search snippets alone.

**Design response:** future versions add explicit verification checkpoints — after the search step, check that scrape files exist before moving to synthesis. (Planned in v0.2.)

### Context pressure

**Symptom:** L2/L3 produces degraded output when invoked in a conversation that's already long.

**Cause:** the model has limited attention budget; long conversations leave less for careful synthesis.

**Design response:** the optional Codex channel runs *independently* in a subprocess — it doesn't consume main-conversation context at all. For L4/L5, Claude delegates to subagents for the same reason.

### Over-reliance on one source

**Symptom:** 80% of claims in the report trace to one article.

**Cause:** the planner's sub-questions accidentally all pointed to the same domain.

**Design response:** L2's contradiction-detection and L3's neutral-angle researcher explicitly chase non-conforming sources.

### Rate limits

**Symptom:** Tavily or Codex refuses partway through L4/L5.

**Cause:** free-tier or subscription limits hit.

**Design response:** every tier is designed to **degrade gracefully** — if Tavily rate-limits, fall back to WebSearch; if Codex fails, skip the cross-model channel and flag that the report is single-model.

---

## Non-goals

- **Being faster than one-shot search.** We're explicitly slower for a reason — depth costs time.
- **Being cheaper than raw API calls.** We're optimized for audit trail and quality, not cost minimization.
- **Replacing human judgment.** The output is input to decisions, not the decision itself.
- **Being a general-purpose agent framework.** These are research skills, not coding agents.

---

## Future architecture work

- **Shared primitives library** — extract `search → scrape → summarize` as a reusable helper that any tier can call, so adding a new tier is low-overhead.
- **Better artifact indexing** — a `manifest.json` per slug that tracks every file with metadata, so tools can query the research corpus.
- **Obsidian integration** — auto-sync L5 vaults to a configured Obsidian path (partially exists, formalizing in v1.0).
- **Pluggable backends** — Firecrawl and Tavily are good defaults, but future versions should allow swapping in Kagi, Exa, Perplexity API, or internal enterprise search.

See [CONTRIBUTING.md](../CONTRIBUTING.md) if you want to help with any of these.
