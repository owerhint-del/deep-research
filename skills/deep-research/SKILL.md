---
name: deep-research
description: Advanced deep research (L2) — runs /research (L1) first, then adds reflection loop, contradiction detection, and tree depth 2 for follow-up questions. ~12 min, 20-30 sources, ~2000 word report. Use for serious questions, technology choices, non-trivial investigations.
user_invocable: true
---

# Deep Research — L2 Advanced

> ⚠️ **Read this first.** This skill has **four mandatory verification checkpoints** baked into the pipeline. They prevent the "hollow synthesis" failure mode where the model skips the scrape step and writes a report citing sources that don't exist on disk. **Run the Bash verification blocks at every checkpoint. Do not skip them.** See ["Why these checkpoints exist"](#why-these-checkpoints-exist) for the full story.

Advanced research tier. **Composes** on top of L1 (`/research`) by adding:

- **Reflection loop** — find gaps in L1 report, do second-pass search
- **Contradiction detection** — explicitly surface disagreements between sources
- **Tree depth 2** — follow-up questions per branch
- **Confidence grading** per claim (High / Medium / Low)

**Position in ladder:** L2. Calls L1 as its foundation. Called by L3 (`expert-research`), L4, L5.

## When to Use

- "что лучше X или Y" (comparisons)
- Technology choices: "стоит ли мигрировать с A на B"
- Non-trivial "как работает X" where L1 might miss nuance
- Investigations that need checking multiple angles
- Default when user says "подробно", "серьёзно", "глубоко"

**Escalate to:**

- `/expert-research` (L3) — when decision is strategic or you need critic agent
- `/academic-research` (L4) — when you need scientific/academic sources
- `/ultra-research` (L5) — when you want a full knowledge base

## Budget

- Time: ~12 min total (L1: ~5 min + L2 layer: ~7 min)
- Tavily credits: ~50 (L1: ~20 + L2: ~30)
- Sub-questions: 5 (L1: 3 + L2: +2 follow-ups)
- Sources: 20–30 (L1: 10–15 + L2: +10–15)
- Output: structured report ~2000 words

## Pipeline

```
┌─────────────────────────────────────────┐
│ STAGE 1: Execute /research (L1)         │
│ — plan → search → read → summarize      │
│ — produces L1/report.md + summaries     │
└──────────────────┬──────────────────────┘
                   │
         🛑 CHECKPOINT 1: Verify L1
                   │
                   ▼
┌─────────────────────────────────────────┐
│ STAGE 2: L2 Reflection Layer            │
│ 1. GAP ANALYSIS    — find holes in L1   │
│ 2. FOLLOW-UP PLAN  — 2 new sub-qs       │
│ 3. DEEPER SEARCH   — search the gaps    │
│    🛑 CHECKPOINT 2: Verify URLs         │
│ 4. READ + SUMMARIZE new sources         │
│    🛑 CHECKPOINT 3: Verify scrapes      │
│ 5. CONTRADICTION DETECTION              │
│ 6. CONFIDENCE GRADING                   │
│ 7. ENRICHED SYNTHESIS                   │
│ 8. BIBLIOGRAPHY                         │
│    🛑 CHECKPOINT 4: Final verify        │
└─────────────────────────────────────────┘
```

## Artifacts Directory

```
.firecrawl/research/<slug>/
├── L1/                       # produced by /research
│   ├── plan.md
│   ├── sources/
│   ├── report.md
│   └── bibliography.md
└── L2/                       # produced by this skill
    ├── gap-analysis.md       # what L1 missed
    ├── followup-plan.md      # 2 new sub-questions
    ├── search-4.json         # raw search results, subq 4
    ├── search-5.json         # raw search results, subq 5
    ├── sources/              # NEW sources only (don't duplicate L1)
    │   ├── 16-<slug>.md
    │   ├── 16-<slug>.sum.md
    │   └── ...
    ├── contradictions.md     # flagged disagreements
    ├── confidence.md         # per-claim confidence levels
    ├── report.md             # enriched report (supersedes L1/report.md)
    └── bibliography.md       # combined L1 + L2 sources
```

---

## Stage 1: Execute L1

**Invoke the `research` skill directly.** Do NOT duplicate L1 logic inline.

Use the Skill tool:

```
Skill: research
Args: <user's query>
```

Wait for L1 to complete.

### 🛑 CHECKPOINT 1: Verify L1 Foundation

**v0.4.0:** uses shared verification library. See [verify-research.sh](../../scripts/lib/verify-research.sh) for the actual checks.

```bash
SLUG="<slug>"                  # replace with actual slug

VERIFY_LIB="$HOME/.claude/scripts/lib/verify-research.sh"
[ -f "$VERIFY_LIB" ] || VERIFY_LIB="scripts/lib/verify-research.sh"
[ -f "$VERIFY_LIB" ] || { echo "❌ verify-research.sh not found — run scripts/install.sh"; exit 1; }

source "$VERIFY_LIB"
verify_l2_checkpoint_1 "$SLUG" || exit 1
```

**Only proceed if this prints `✅ CHECKPOINT 1 PASSED`.** The function verifies L1 foundation (plan, report, bibliography, ≥10 summaries, ≥10 matching scrapes). If L1 didn't produce these artifacts, abort L2 and report the L1 problem to the user.

---

## Stage 2: L2 Layer

### Step 2.1: GAP ANALYSIS

Read `L1/report.md` and all `L1/sources/*.sum.md`. Identify:

1. **Unanswered questions** — parts of the original query L1 didn't cover
2. **Surface-level answers** — topics L1 treated shallowly that deserve more depth
3. **Missing perspectives** — angles not represented (critics, alternatives, real users)
4. **Outdated sources** — claims based on pre-2025 material that need verification
5. **Unverified claims** — strong assertions with only one source

Write `L2/gap-analysis.md`:

```markdown
# Gap Analysis

**Based on:** L1/report.md

## Unanswered
- Original query asks about X, but L1 doesn't address Y
- ...

## Shallow coverage
- L1 mentions Z but doesn't explain mechanism
- ...

## Missing perspectives
- No critical/skeptical sources
- No real-world user experiences
- ...

## Unverified claims
- "X is 3x faster" — only one source, no benchmark data
- ...
```

### Step 2.2: FOLLOW-UP PLAN

Based on gaps, generate **2 new sub-questions** (tree depth 2 — branching from L1's 3 sub-questions).

Write `L2/followup-plan.md`:

```markdown
# Follow-up plan

## New sub-questions
4. <subq4 — targets gap A>
5. <subq5 — targets gap B>

## Search strategy
- subq4 → [specific queries, possibly contrarian]
- subq5 → [...]

## Target: 10-15 NEW sources (not already in L1)
```

### Step 2.3: DEEPER SEARCH

Run parallel searches for the 2 new sub-questions:

```bash
mkdir -p .firecrawl/research/$SLUG/L2
firecrawl search "<subq4>" --limit 8 --json -o .firecrawl/research/$SLUG/L2/search-4.json &
firecrawl search "<subq5>" --limit 8 --json -o .firecrawl/research/$SLUG/L2/search-5.json &
wait
```

Plus Tavily for each with `search_depth: "advanced"`.

> **v0.2.2: persist Tavily results.** Tavily goes through MCP — its output lives in conversation context by default, not on disk. After each `mcp__tavily__tavily_search` call, use the Write tool to save the returned JSON to `.firecrawl/research/$SLUG/L2/tavily-N.json`. This makes Tavily findings auditable and survivable across context compaction.

**Special L2 search tactics:**

- Add contrarian terms: "problems with X", "X issues", "X vs alternatives"
- Search for recent critiques: "X 2026 criticism"
- Look for real benchmarks: "X benchmark comparison"
- Russian-language search for additional angles

### Step 2.3a-tvr: TAVILY RESEARCH ANSWER CHANNEL (optional, parallel, v0.9.0+)

> Fault-tolerant — if Tavily CLI isn't authed or `DEEP_RESEARCH_DISABLE_TAVILY_RESEARCH=1` is set, this step is skipped silently.

> **Why this exists.** This step replaces the v0.6.0 Perplexity Answer Channel. Tavily Research provides an **already-synthesized answer with citations** — a different output shape from Tavily search/Exa (URL lists) and Codex (raw model response). For L2 contradictions, this gives a third independent "opinion" that can be directly cross-checked against Claude's synthesis of scraped sources.

Tavily Research runs multi-source agentic synthesis (Planning → WebSearch → Generating)
and returns a cited markdown report. For L2 it's the Perplexity-equivalent output shape:
synthesized answer + citations, in 30-120 sec.

```bash
# CLI variant (preferred — script-friendly):
tvly research "<gap description from L2/gap-analysis.md>" \
  --model auto \
  --citation-format numbered \
  -o .firecrawl/research/$SLUG/L2/tavily-research-gap.md
```

Or via Skill tool:
```
Skill: tavily-research
Args: <gap description from L2/gap-analysis.md>. Save to .firecrawl/research/$SLUG/L2/tavily-research-gap.md
```

Run in parallel with Step 2.4 scrape — typical Tavily Research wall time is 30-120 sec
which overlaps well with Firecrawl scrape parallelism.

In Step 2.5 (contradictions), compare Tavily Research's answer against Claude's L2 synthesis:

- **Same conclusion, same sources** → high confidence
- **Same conclusion, different sources** → triangulation (good)
- **Different conclusion** → flag in `contradictions.md` and investigate which is right

Tavily Research's cited URLs are candidates for additional Firecrawl scraping if they're not already in L1/L2 sources.

### Step 2.3a-exa: EXA NEURAL CHANNEL (optional, parallel, v0.5.0+)

> Fault-tolerant — if Exa MCP is not installed or `DEEP_RESEARCH_DISABLE_EXA=1` is set, this step is skipped. Independent from Codex — can run together or separately.

Exa provides **neural semantic search** with its own index. Complements Tavily (keyword-ish) and Firecrawl (extraction). For L2 gap-fill, Exa's `web_search_advanced_exa` with category filters often finds sources Tavily misses.

```
mcp__exa__web_search_advanced_exa with:
  query: <gap description from L2/gap-analysis.md>
  num_results: 8
  type: "auto"
  category: "news"    # or "research paper" for technical gaps, omit for general
  contents: { text: { max_characters: 20000 } }
```

Save the response JSON to `.firecrawl/research/$SLUG/L2/exa-gap.json` via the Write tool (same persistence pattern as Tavily — MCP responses don't survive context compaction).

In Step 2.5 (contradictions) and Step 2.7 (synthesis), merge Exa findings:

- URLs in Exa response but not in Tavily/Firecrawl → candidates for additional scrape
- Exa's `score` field (relevance) can flag high-confidence sources
- If Exa and Tavily point to conflicting sources → surface in `contradictions.md`

**If Exa unavailable:** skip silently. The skill's existing Tavily+Firecrawl+Codex channels still work.

See [docs/EXA_INTEGRATION.md](../../docs/EXA_INTEGRATION.md) for full integration reference.

### Step 2.3a: CODEX CROSS-MODEL CHANNEL (optional, parallel)

> Added in v0.2. This step is **optional and fault-tolerant** — if Codex isn't installed, auth is expired, or it times out, the skill continues without it. The report notes which mode was used.

Run a parallel research pass through OpenAI Codex CLI (GPT-5.4 with live web search). This gives a second, independent search index and model — disagreements between Claude's findings and Codex's findings are the strongest signal for `contradictions.md`.

```bash
# Prefer installed helper (from install.sh), fallback to repo-local copy.
CODEX_HELPER="$HOME/.claude/scripts/codex-research.sh"
[ -x "$CODEX_HELPER" ] || CODEX_HELPER="scripts/codex-research.sh"

CODEX_GAP_PROMPT="You are a research assistant working in parallel with another model on this query:

<ORIGINAL QUERY>

Focus specifically on filling these gaps identified in the first-pass research:
- <gap 1 from L2/gap-analysis.md>
- <gap 2 from L2/gap-analysis.md>

Return 5-10 key facts with source URLs. Include recent critiques and contrarian viewpoints if relevant. Be concise (≤800 words)."

# Runs in background in parallel with Step 2.4 scrape.
# Fail-open: if helper missing or codex fails, skill continues.
if [ -x "$CODEX_HELPER" ]; then
    bash "$CODEX_HELPER" 180 \
        ".firecrawl/research/$SLUG/L2/codex-gap.md" \
        "$CODEX_GAP_PROMPT" &
    CODEX_PID=$!
else
    echo "⏭️  Codex helper not found — skipping cross-model channel"
    CODEX_PID=""
fi
```

**After Step 2.4 (scrape) completes, wait for Codex and record the outcome:**

```bash
if [ -n "$CODEX_PID" ]; then
    wait "$CODEX_PID" 2>/dev/null
    if [ -s ".firecrawl/research/$SLUG/L2/codex-gap.md" ]; then
        echo "✅ Codex cross-model channel: output available"
    else
        cat ".firecrawl/research/$SLUG/L2/codex-gap.md.status" 2>/dev/null
    fi
fi
```

The status file will say one of: `SUCCESS`, `SKIPPED`, `AUTH_FAILED`, `RATE_LIMITED`, `TIMEOUT`, `FAILED`. Use this in Step 2.5 (contradictions) and Step 2.7 (synthesis) to decide whether to incorporate Codex findings.

### 🛑 CHECKPOINT 2: Verify Searches Produced URLs

```bash
source "$VERIFY_LIB"
verify_l2_checkpoint_2 "$SLUG" || exit 1
```

Checks: ≥2 search JSON files, each non-trivially sized (≥500 bytes), ≥10 unique URLs total. **Only proceed if this prints `✅ CHECKPOINT 2 PASSED`.**

### Step 2.4: READ + SUMMARIZE (MANDATORY — DO NOT SKIP)

> ⚠️ **This step is the primary hollow-synthesis pitfall.** Do NOT rely on search snippets. You MUST run `firecrawl scrape` for each chosen URL. Each scrape must produce a real file on disk. The checkpoint after this step will verify.

Deduplicate against L1 sources. Pick 10–15 NEW URLs.

Scrape in parallel — one `firecrawl scrape` per URL — and write summaries with same structure as L1 (`.sum.md` with Key facts, Key quotes, Notes).

```bash
mkdir -p .firecrawl/research/$SLUG/L2/sources

# Scrape in parallel. Number starting from where L1 left off (16, 17, 18, ...).
firecrawl scrape "<URL1>" --only-main-content -o .firecrawl/research/$SLUG/L2/sources/16-<slug>.md &
firecrawl scrape "<URL2>" --only-main-content -o .firecrawl/research/$SLUG/L2/sources/17-<slug>.md &
firecrawl scrape "<URL3>" --only-main-content -o .firecrawl/research/$SLUG/L2/sources/18-<slug>.md &
# ... up to ~25, pick 10-15 good ones
wait
```

After scraping, write a `.sum.md` summary companion for EACH scraped file (same structure as L1):

```markdown
# Source 16: <title>

**URL:** <url>
**Type:** [official-docs | tech-blog | community | news | academic]
**Date:** <publication date if available>
**Quality:** [A | B | C]
**Relevant to:** [subq4 | subq5]

## Key facts
- Fact 1 (specific, citable)
- ...

## Key quotes
> "exact quote 1"

## Notes
- Contradicts source X on Y (if applicable)
- Gap: doesn't address W
```

### 🛑 CHECKPOINT 3: Verify Scrapes Completed (CRITICAL — prevents hollow synthesis)

> **This is the most important checkpoint in the pipeline.** Skipping it is how "hollow synthesis" happens.

```bash
source "$VERIFY_LIB"
verify_l2_checkpoint_3 "$SLUG" || exit 1
```

Checks: ≥8 L2 scrapes, each ≥500 bytes (not error page), each has matching `.sum.md` companion ≥1000 bytes. **If this fails, DO NOT write the L2 report. Re-run the scrape step.**

### Step 2.5: CONTRADICTION DETECTION

Read all summaries (L1 + L2). **Also read these channel artifacts if they exist** —
their independent findings often surface contradictions Claude's scrapes miss:

- `L2/codex-gap.md` — Codex CLI cross-model channel (different model)
- `L2/tavily-research-gap.md` — Tavily Research cited synthesis (independent search index)
- `L2/exa-gap.json` — Exa neural-search channel (different ranking)

Look for **direct disagreements**:

- Two sources claim different numbers
- Two sources recommend opposite approaches
- Source claims X is best, another says X is deprecated
- Old source vs new source

Write `L2/contradictions.md`:

```markdown
# Contradictions found

## C1: [Topic]
**Source A** ([1]): "claim A"
**Source B** ([7]): "opposite claim B"

**Analysis:** which is more recent? more authoritative? specific context?
**Resolution:** [which to trust and why, OR "unresolved, flag in report"]
```

If truly no contradictions exist, write the file with `# Contradictions found\n\nNone — all sources in agreement on major points.` — do not omit the file.

### Step 2.6: CONFIDENCE GRADING

For each major claim in the enriched report, assign:

- **High** — confirmed by 3+ independent authoritative sources, recent, no contradictions
- **Medium** — confirmed by 2 sources, or 1 authoritative source, minor gaps
- **Low** — single source, old, or contradicted by other sources

Write `L2/confidence.md` listing major claims with their grade.

### Step 2.7: ENRICHED SYNTHESIS

Produce `L2/report.md` — this **supersedes** `L1/report.md`.

**Before writing, re-read ALL `.sum.md` files (both L1 and L2).** The report must synthesize from summaries, not from memory of what you searched.

**Channel attribution.** Mark facts in the report by which independent channel(s) confirmed them:

- `(cross-model)` — confirmed by Codex (`L2/codex-gap.md`)
- `(answer-channel)` — confirmed by Tavily Research (`L2/tavily-research-gap.md`)
- `(neural)` — confirmed by Exa (`L2/exa-gap.json`)

A claim with two or more such tags is high-confidence triangulated. A claim only from
Claude-scraped sources is single-channel — flag it as Medium confidence unless the source
is itself authoritative (official docs, peer-reviewed paper, etc.).

**Channel availability notes.** If a channel was unavailable, document it in the Confidence
Summary section. Check the corresponding `.status` files (`L2/codex-gap.md.status`) and the
existence of `tavily-research-gap.md` / `exa-gap.json`. Example note:
`Note: Codex channel was TIMEOUT, Tavily Research available, Exa skipped (DEEP_RESEARCH_DISABLE_EXA=1). Claims rely on 2 of 3 cross-channel verifiers.`

```markdown
# <Topic Title>

**Query:** <original>
**Level:** L2 (includes L1)
**Sources:** <L1 count> + <L2 count> = <total>
**Generated:** <date>

## TL;DR
[Core answer, 3-4 sentences. Include confidence marker: "✓ high confidence"]

## Executive Summary
[1 paragraph, ~200 words. Main findings with citations.]

## <Section 1: from L1 subq1, enriched with L2 findings>
[Full answer with [N] citations. Mark confidence where relevant: "(High)", "(Medium)".]

## <Section 2: from L1 subq2, enriched>
[...]

## <Section 3: from L1 subq3, enriched>
[...]

## <Section 4: from L2 subq4 — deeper dive>
[New angle not covered in L1]

## <Section 5: from L2 subq5 — deeper dive>
[Another new angle]

## Contradictions & Debates
[Explicit section listing disagreements from contradictions.md]

- **On X:** Source [1] says A, source [7] says B. Resolution: [explanation]
- **On Y:** ...

## Confidence Summary
- High confidence: [list of claims]
- Medium confidence: [list]
- Low confidence: [list, flagged as "needs verification"]

## Key takeaways
- Point 1 [1, 3, 16] (High)
- Point 2 [2, 5, 19] (Medium)
- ...

## Open questions
- What even L2 research couldn't resolve
- Where user might want to escalate to L3/L4

## Recommendation
[Concrete recommendation with explicit reasoning, accounting for confidence levels]
```

**Target length:** 1800–2500 words.

**Citation rule:** every `[N]` citation must correspond to a real bibliography entry. Do not invent citation numbers.

### Step 2.8: Bibliography

Write `L2/bibliography.md` merging L1 and L2 sources. Keep L1 numbering intact (1–15), L2 sources continue (16+).

```markdown
# Bibliography

## L1 sources (from research)
1. **[Title]**(URL) — Quality: A | Type: official-docs
   Contribution: primary source for X
2. ...
15. ...

## L2 sources (new in deep-research)
16. **[Title]**(URL) — Quality: A | Type: tech-blog
    Contribution: benchmark data, contradicts [3] on Y
17. ...
```

### 🛑 CHECKPOINT 4: Final Verification Before Delivering Report

```bash
source "$VERIFY_LIB"
verify_l2_checkpoint_4 "$SLUG" || exit 1
```

Checks: L2 report ≥1500 words; bibliography, contradictions, confidence, gap-analysis, followup-plan all present; every `[N]` citation (including multi-cite `[1, 3, 16]`) maps to a bibliography entry.

**Only deliver the report to the user if this prints `✅ CHECKPOINT 4 PASSED`.**

---

## Final Output

1. Display `L2/report.md` in chat
2. Mention artifacts: `Полные материалы в .firecrawl/research/<slug>/`
3. Show summary stats:
   > 📊 L2 stats: `<L1>` L1 sources + `<L2>` L2 sources, `<N>` contradictions, confidence: H:`<n>` M:`<n>` L:`<n>`
4. Offer escalation:
   > Нужна критическая проверка? `/expert-research` (L3) добавит critic-агента и fact-check.
   > Нужны научные источники? `/academic-research` (L4) подключит arXiv и Scholar.

---

## Why these checkpoints exist

Earlier versions of this skill had a recurring failure mode called **"hollow synthesis"**: the model would run the search step, look at Tavily and Firecrawl search-result snippets, and jump directly to writing the report — silently skipping the actual `firecrawl scrape` step.

The resulting report looked plausible but was structurally broken:

- Cited `[L2-N]` references with no corresponding file in `L2/sources/`
- Had no `bibliography.md`
- Synthesized from snippets, not full content
- Read confidently but had zero audit trail

Root cause: under context pressure (long conversation, many tools already called), the model economizes by treating rich search-result snippets as if they were full sources. The skill said "scrape 10–15 URLs" but had no enforcement.

The checkpoints above make this failure impossible:

- **Checkpoint 1** guarantees L1 actually ran before L2 starts
- **Checkpoint 2** guarantees searches returned URLs
- **Checkpoint 3** guarantees scrapes produced real files of non-trivial size with matching summaries
- **Checkpoint 4** guarantees the final report only cites sources that exist in the bibliography

**Rule of thumb:** if `.firecrawl/research/<slug>/L2/sources/` is empty or missing `.sum.md` companions, something went wrong. Stop, diagnose, fix. No synthesis allowed on a broken foundation.

---

## Rules

- **Always call L1 first** — never inline the L1 logic
- **Never duplicate L1 sources** — L2 adds NEW sources only
- **Contradictions are a feature** — surface them, don't hide them
- **Confidence is honest** — if it's one source, grade it Low
- **Gap analysis is grounded** — base on actual L1 content, not assumptions
- **Parallel operations** — searches and scrapes run concurrently
- **Preserve L1 artifacts** — never modify or delete `L1/*` files
- **Run EVERY checkpoint** — all four Bash verification blocks must print `✅ PASSED` before proceeding
- **Scrape is mandatory** — snippets are not sources; no scrape means no citation
- **No hollow synthesis** — if `L2/sources/` has fewer than 8 real `.md` files, stop and re-scrape

## Called from higher levels

L3/L4/L5 call this skill to get an L2-grade foundation before adding their own layers. When called from higher levels:

- Produce all L2 artifacts as usual
- All four checkpoints still apply
- Higher level reads `L2/report.md`, `L2/contradictions.md`, `L2/confidence.md` as its input
