---
name: expert-research
description: Expert-level research (L3) — runs /deep-research (L2) then adds critic agent, fact-checking pass, multi-perspective search, and human-in-the-loop plan approval. ~20 min, 40-60 sources, 3000+ word report with executive summary. Use for strategic decisions, technology migrations, important investigations.
user_invocable: true
---

# Expert Research — L3

Expert research tier. **Composes** on top of L2 (`/deep-research`) by adding:
- **Human-in-the-loop plan approval** before expensive work
- **Multi-perspective search** (3 angles: proponents, critics, neutral)
- **Fact-check pass** — critical claims verified against 2+ independent sources
- **Critic agent** — adversarial review of the entire report
- **2 reflection loops** (vs L2's 1)
- **Structured decision matrix** when the query implies a choice

**Position in ladder:** L3. Calls L2 as its foundation (which itself calls L1). Called by L4, L5.

## When to Use

- Strategic decisions: migration, architecture choice, big-ticket tooling
- "стоит ли мигрировать X → Y"
- "какой стек выбрать для нового проекта"
- Investigations where being wrong costs real money/time
- When user says "критически", "стратегически", "серьёзно и надёжно"
- Default when the decision stakes are high

**Escalate to:**
- `/academic-research` (L4) — when you need scientific papers and academic rigor
- `/ultra-research` (L5) — when you want a full knowledge base and playbooks

## Budget

- Time: ~20-25 min total (L1: ~5 + L2: ~7 + L3: ~8-13)
- Tavily credits: ~150
- **Subagent tokens: ~50-80K** (critic agent via Agent tool) — added in v0.2.2 budget doc
- **Codex credits (if available): ~200-300K tokens** across 2 parallel calls (neutral + critic)
- Sub-questions: 8 (L1: 3 + L2: 2 + L3: 3)
- Sources: 40–60
- Output: **2000-3000 word report** + executive summary + PDF export (target relaxed in v0.2.2 based on real-session testing; prior 3000-4500 was unrealistic for single-session execution without heavy subagent delegation)

## Pipeline

```
┌────────────────────────────────────────┐
│ STAGE 0: Plan Approval (optional)      │
│ — show user the expected L3 plan       │
│ — wait for y/n or modifications        │
└──────────────────┬─────────────────────┘
                   │
                   ▼
┌────────────────────────────────────────┐
│ STAGE 1: Execute /deep-research (L2)   │
│ — produces L1/ + L2/ artifacts         │
└──────────────────┬─────────────────────┘
                   │
                   ▼
┌────────────────────────────────────────┐
│ STAGE 2: L3 Expert Layer               │
│ 1. MULTI-PERSPECTIVE PLAN              │
│ 2. 3-ANGLE SEARCH                      │
│ 3. READ + SUMMARIZE                    │
│ 4. FACT-CHECK CRITICAL CLAIMS          │
│ 5. CRITIC AGENT (adversarial review)   │
│ 6. SECOND REFLECTION LOOP              │
│ 7. DECISION MATRIX (if applicable)     │
│ 8. EXPERT SYNTHESIS                    │
│ 9. PDF EXPORT                          │
└────────────────────────────────────────┘
```

## Artifacts Directory

```
.firecrawl/research/<slug>/
├── L1/                  # from /research
├── L2/                  # from /deep-research
└── L3/                  # this skill
    ├── plan-approved.md           # user-approved plan
    ├── perspective-plan.md        # 3 angles
    ├── sources/
    │   ├── 31-<slug>.md           # continuing numbering
    │   └── ...
    ├── fact-check.md              # critical claims + verification
    ├── critic-report.md           # adversarial review findings
    ├── decision-matrix.md         # if query implies choice
    ├── report.md                  # final L3 report (supersedes L2/report.md)
    ├── executive-summary.md       # 500-word TL;DR for stakeholders
    ├── bibliography.md
    └── report.pdf                 # exported via pandoc
```

## Stage 0: Plan Approval

Before running L3 (which costs ~150 credits and 20 min), show the user a **plan preview**:

```markdown
# L3 Expert Research Plan

**Query:** <user's query>
**Estimated cost:** ~150 Tavily credits, ~20 min
**Will produce:** 3000+ word report, executive summary, fact-check report, PDF

## Approach
1. Run L2 baseline (planner + reflection + contradiction detection)
2. Add multi-perspective search: proponents, critics, neutral
3. Fact-check top 5 critical claims against 2+ independent sources
4. Run critic agent adversarial review
5. Build decision matrix (if query implies a choice)

## Initial sub-questions (will be refined after L1/L2)
- <preliminary subq1>
- <preliminary subq2>
- ...

**Proceed?** (y / n / modify)
```

If user says `y` — proceed. If `n` — abort gracefully. If `modify` — adjust and re-show.

**Skip approval** if:
- User explicitly invoked with `/expert-research --go` or said "сразу запускай"
- Called programmatically from L4 or L5

## Stage 1: Execute L2

Invoke the `deep-research` skill:
```
Skill: deep-research
Args: <query>
```

Wait for completion. Verify artifacts:
- `.firecrawl/research/<slug>/L2/report.md`
- `.firecrawl/research/<slug>/L2/contradictions.md`
- `.firecrawl/research/<slug>/L2/confidence.md`

## Stage 2: L3 Expert Layer

### Step 2.1: MULTI-PERSPECTIVE PLAN

Read L2 report. Generate 3 perspectives on the topic:

1. **Proponent angle** — what do advocates/vendors say?
2. **Critic angle** — what do detractors say? known problems?
3. **Neutral/academic angle** — what do benchmarks, studies, independent reviewers say?

Write `L3/perspective-plan.md`:
```markdown
# 3-Angle Research Plan

## Angle 1: Proponents
**Goal:** understand the strongest case for X
**Queries:**
- "why X is better than alternatives"
- "X official documentation advantages"
- "X success stories 2026"

## Angle 2: Critics
**Goal:** surface the strongest case against X
**Queries:**
- "problems with X in production"
- "why we moved away from X"
- "X limitations 2026"

## Angle 3: Neutral
**Goal:** independent data
**Queries:**
- "X vs Y benchmark 2026"
- "X real-world performance data"
- "X adoption metrics"
```

### Step 2.2: 3-ANGLE SEARCH

Run 9 searches in parallel (3 queries × 3 angles) using Firecrawl + Tavily.

**v0.9.0 — academic-angle augmentations.** For the **neutral angle** queries, also run:

- **Firecrawl with academic categories** to surface arXiv/Nature/IEEE/PubMed:
  ```bash
  firecrawl search "<neutral angle query>" \
    --limit 8 \
    --categories research,pdf \
    --scrape --scrape-formats markdown,summary \
    --json -o .firecrawl/research/$SLUG/L3/search-neutral-academic.json
  ```
- **Tavily map+extract pattern** for known authoritative domains (cheaper and more
  targeted than broad search):
  ```bash
  # Map first to find relevant pages
  tvly map "https://arxiv.org" \
    --instructions "Find recent papers on <topic>" \
    --json -o .firecrawl/research/$SLUG/L3/tavily-map-arxiv.json

  # Then extract with query focus on the matching URLs
  tvly extract "<picked-url-1>" "<picked-url-2>" \
    --query "<specific aspect of the claim>" \
    --chunks-per-source 3 --json \
    -o .firecrawl/research/$SLUG/L3/tavily-extract-arxiv.json
  ```

**v0.5.0:** If Exa MCP is installed (check for `mcp__exa__*` tools availability), run additional Exa searches in parallel. Exa's neural ranking **excels at the critic and neutral angles** — it finds conceptually-related dissenting views that keyword search misses.

```
# Neutral angle via Exa with category filter
mcp__exa__web_search_advanced_exa with:
  query: <original query, framed neutrally>
  category: "research paper"   # or omit for general news/web
  type: "auto"
  num_results: 10
  contents: { text: { max_characters: 20000 } }
```

Save to `.firecrawl/research/$SLUG/L3/exa-neutral.json`. For **research paper category**, this is the single best source of independent academic content we have. Fall back to Tavily if Exa unavailable.

> **v0.2.2: persist Tavily results.** After each `mcp__tavily__tavily_search` call, write the response JSON to `.firecrawl/research/$SLUG/L3/tavily-<angle>-<n>.json` (angle = proponent/critic/neutral, n = query index) using the Write tool. MCP responses live in conversation context only; disk persistence makes them auditable and survivable across compaction.

Critical: use different search tactics per angle:
- Proponent angle: official docs, vendor blogs
- Critic angle: HN discussions, "we moved from X" blog posts, issue trackers
- Neutral angle: benchmark sites, independent reviewers, academic indexes

### Step 2.3: READ + SUMMARIZE

Pick top 10–15 NEW sources across 3 angles. Scrape + summarize using same `.sum.md` format as L1/L2.

**Add metadata to summaries:**
```markdown
**Angle:** [proponent | critic | neutral]
**Bias estimate:** [low | medium | high]
```

Save to `L3/sources/` starting from the next available number.

### Step 2.4: FACT-CHECK CRITICAL CLAIMS (schema-based)

**v0.9.0+: schema-based fact-check via Tavily Research.** Each critical claim is verified
through Tavily Research's `--output-schema` flag — the result is a **structured JSON
verdict** (verdict + evidence_urls + confidence + rationale), not free-form text. This is
the Perplexity replacement and is **stronger** than the prior approach because the verdict
shape is enforced — no parsing free text or hoping the answer mentioned a verdict word.

Read L2/report.md + L3 new summaries. Identify the **top 5 most critical claims** — ones
that would change the recommendation if wrong.

For each claim, run Tavily Research with a fact-check schema. **Important:**
`tvly research --output-schema` expects a **PATH to a JSON file**, not inline JSON —
write the schema once to a temp file and reuse it across all 5 claims.

Set up shared CODEX_HELPER and SCHEMA_FILE up-front (used by both fact-check and
Codex tiebreaker below):

```bash
SLUG="<slug>"

# Codex helper path (used by tiebreaker logic at the end of this step)
CODEX_HELPER="$HOME/.claude/scripts/codex-research.sh"
[ -x "$CODEX_HELPER" ] || CODEX_HELPER="scripts/codex-research.sh"

# Tavily Research schema file (PATH-based, not inline)
SCHEMA_FILE=$(mktemp -t tvly-factcheck-schema.XXXXXX.json)
trap 'rm -f "$SCHEMA_FILE"' EXIT

cat > "$SCHEMA_FILE" <<'JSON'
{
  "properties": {
    "verdict": {
      "type": "string",
      "enum": ["confirmed", "disputed", "unclear"],
      "description": "confirmed if 2+ independent sources agree, disputed if sources disagree, unclear if not enough independent evidence"
    },
    "confidence": {
      "type": "number",
      "minimum": 0,
      "maximum": 1,
      "description": "0..1 score for how strongly the evidence supports the verdict"
    },
    "evidence_urls": {
      "type": "array",
      "items": {"type": "string"},
      "description": "2-5 URLs that informed the verdict (must be independent — not all same vendor/author)"
    },
    "supporting_quotes": {
      "type": "array",
      "items": {"type": "string"},
      "description": "Key quoted snippets from the evidence sources"
    },
    "rationale": {
      "type": "string",
      "description": "One-sentence explanation of why the verdict was chosen"
    }
  },
  "required": ["verdict", "confidence", "evidence_urls", "rationale"]
}
JSON
```

> **Schema format constraints (Tavily Research /research endpoint):**
> 1. Top level must contain ONLY `properties` and (optionally) `required`. Do NOT include a top-level `"type": "object"` — Tavily rejects "unexpected keys".
> 2. Each property MUST include a `description` field. Without it Tavily returns
>    `Error: Property 'X' missing required 'description' field`.

Now run the 5 fact-checks **in parallel** (they're independent — Tavily `mini` takes
~30-60 sec per claim, so 5 parallel = ~60 sec total wall time):

```bash
mkdir -p ".firecrawl/research/$SLUG/L3"

# Replace these with the actual top 5 claims extracted from L2/report.md:
CLAIMS=(
  "X is 3x faster than Y"
  "X has poor ecosystem"
  "Z released stable v2 in 2026"
  "claim 4..."
  "claim 5..."
)

for N in 1 2 3 4 5; do
    CLAIM="${CLAIMS[$((N-1))]}"
    tvly research \
      "Verify this claim and find independent sources that support or dispute it: $CLAIM" \
      --model mini \
      --output-schema "$SCHEMA_FILE" \
      --citation-format numbered \
      -o ".firecrawl/research/$SLUG/L3/tavily-factcheck-$N.json" &
done
wait
```

> **If Tavily CLI unavailable** (`DEEP_RESEARCH_DISABLE_TAVILY_RESEARCH=1` or auth missing):
> skill falls back to manual fact-check only (the prose process below). The schema-based
> verdict is preferred but not required for L3 to complete.

**Codex tiebreaker.** When a Tavily verdict is `disputed` or `confidence < 0.6`, run a
secondary Codex CLI verification on the same claim — second-model second opinion on
already-uncertain claims, not on every claim (cost-efficient). `CODEX_HELPER` was
defined at the top of this step:

```bash
for N in 1 2 3 4 5; do
    CLAIM="${CLAIMS[$((N-1))]}"
    JSON_FILE=".firecrawl/research/$SLUG/L3/tavily-factcheck-$N.json"
    if [ ! -f "$JSON_FILE" ]; then
        continue
    fi

    if jq -e '.confidence < 0.6 or .verdict == "disputed"' "$JSON_FILE" > /dev/null 2>&1; then
        if [ -x "$CODEX_HELPER" ]; then
            bash "$CODEX_HELPER" 180 \
                ".firecrawl/research/$SLUG/L3/codex-factcheck-$N.md" \
                "Verify or refute this claim independently: $CLAIM. Return verdict (CONFIRMED/DISPUTED/UNVERIFIED) with 2-3 source URLs." &
        fi
    fi
done
wait
```

After all schema verdicts and Codex tiebreakers complete, manually review evidence URLs
that aren't already in L1/L2/L3 sources — scrape them if they're load-bearing.

Write `L3/fact-check.md` synthesizing the structured verdicts:

```markdown
# Fact-check report

## Claim 1: "X is 3x faster than Y"
**Source in report:** [7]
**Tavily verdict:** confirmed (confidence: 0.92)
**Evidence URLs:**
- [23] independent benchmark shows 2.8x
- [25] community benchmark shows 3.1x

**Rationale (Tavily):** Two independent benchmarks within the past 12 months both confirm
the 3x range (2.8-3.1x), with consistent methodology.
**Codex tiebreaker:** N/A (high-confidence Tavily verdict)
**Final verdict:** CONFIRMED (High confidence)

## Claim 2: "X has poor ecosystem"
**Source in report:** [12] (critic blog)
**Tavily verdict:** disputed (confidence: 0.45)
**Evidence URLs:**
- [28] shows 500+ packages (contradicts)
- [30] mentions "some gaps" without specifics

**Rationale (Tavily):** Direct contradiction — package count refutes "poor ecosystem"
claim, "some gaps" comment is too vague to support it.
**Codex tiebreaker:** DISPUTED — agrees with Tavily, finds same package count.
**Final verdict:** DISPUTED — downgrade to "community opinion, not fact"

## Claim 3: ...
```

**Verdict categories (final, after merging Tavily + Codex):**
- **CONFIRMED** — Tavily `confirmed` with `confidence ≥ 0.7`, OR `confirmed` with Codex agreement
- **DISPUTED** — sources disagree (Tavily `disputed`, OR Tavily/Codex disagreement)
- **UNVERIFIED** — Tavily `unclear` AND no Codex tiebreaker rescue (downgrade in report)

### Step 2.4a: CODEX CROSS-MODEL CHANNEL (optional, added v0.2)

> Fault-tolerant — if Codex is unavailable, skill continues single-model.

Spawn **two parallel Codex calls** for independent second-model perspective: a neutral-angle research pass and a cross-model critic pass. These run in parallel with Step 2.5 (Claude critic agent).

```bash
CODEX_HELPER="$HOME/.claude/scripts/codex-research.sh"
[ -x "$CODEX_HELPER" ] || CODEX_HELPER="scripts/codex-research.sh"

# Call 1: Neutral-angle researcher (GPT-5.4 with its own index)
if [ -x "$CODEX_HELPER" ]; then
    bash "$CODEX_HELPER" 360 \
        ".firecrawl/research/$SLUG/L3/codex-neutral.md" \
        "You are an independent research assistant. Research the query '<ORIGINAL QUERY>' from a skeptical, neutral angle — ignore vendor marketing and hype. Look for benchmarks, independent reviewers, community experiences, and failures. Return 8-12 key findings with source URLs. Include dates. Be concise (≤1000 words)." &
    CODEX_NEUTRAL_PID=$!

    # Call 2: Cross-model critic (reads the L2 report and attacks conclusions)
    L2_REPORT=$(cat ".firecrawl/research/$SLUG/L2/report.md" 2>/dev/null | head -300)
    bash "$CODEX_HELPER" 360 \
        ".firecrawl/research/$SLUG/L3/codex-critic.md" \
        "You are a skeptical research critic. Review this research report adversarially. Challenge main conclusions. Find what's missing, wrong, or oversimplified. Use your own web search to verify or refute key claims. Return a critic report (≤1000 words).

REPORT TO REVIEW:
$L2_REPORT" &
    CODEX_CRITIC_PID=$!
else
    CODEX_NEUTRAL_PID=""
    CODEX_CRITIC_PID=""
fi
```

Proceed to Step 2.5 (Claude critic) while these run. After Step 2.5 finishes:

```bash
[ -n "$CODEX_NEUTRAL_PID" ] && wait "$CODEX_NEUTRAL_PID" 2>/dev/null
[ -n "$CODEX_CRITIC_PID" ]  && wait "$CODEX_CRITIC_PID" 2>/dev/null

# Log status outcomes
for f in codex-neutral codex-critic; do
    STATUS_FILE=".firecrawl/research/$SLUG/L3/${f}.md.status"
    [ -f "$STATUS_FILE" ] && echo "$f: $(cat "$STATUS_FILE")"
done
```

When writing the final L3 synthesis (Step 2.8), **merge Codex findings with Claude findings**:

- If `L3/codex-critic.md` exists — include its objections in the report's "Weaknesses / counterpoints" section
- If `L3/codex-neutral.md` exists — cross-check its facts against Claude's conclusions, flag any disagreements in `contradictions.md`
- If Codex outputs absent (check `.status` files) — note in Confidence section: `Cross-model verification: unavailable (<reason>). Report is single-model.`

### Step 2.5: CRITIC AGENT (adversarial review)

**Invoke a critic sub-agent** to attack the L2 report. Use the Agent tool with a dedicated prompt:

```
Agent(subagent_type="general-purpose",
      description="Critic review of L2 research",
      prompt="""
You are a skeptical research critic. Your job is to find problems with this research report.

Read: .firecrawl/research/<slug>/L2/report.md
Also read: .firecrawl/research/<slug>/L2/confidence.md

For each major claim, ask:
1. Is the evidence strong enough?
2. Are there alternative explanations?
3. What would change my mind?
4. What's missing?
5. What's the weakest part of the argument?

Also check:
- Is the recommendation justified by the evidence?
- Are there hidden assumptions?
- Is there selection bias in the sources?
- Are there more recent sources that contradict the conclusion?

Write findings to: .firecrawl/research/<slug>/L3/critic-report.md

Format:
# Critic Report
## Weakest claims
- Claim X [citation]: problem with it
- ...

## Hidden assumptions
- ...

## Missing considerations
- ...

## Recommendation validity
- Justified? partial? unjustified?

## Questions the report doesn't answer but should
- ...

Be harsh but fair. Cite specific parts of the report you're attacking.
""")
```

Wait for critic to complete. Read `critic-report.md`.

### Step 2.6: SECOND REFLECTION LOOP

Based on critic findings, identify new gaps:

1. Claims flagged as weak → need more sources
2. Missing considerations → need targeted searches
3. Hidden assumptions → need to verify or acknowledge

Run 3–5 more targeted searches + scrapes to address critic concerns. Add to `L3/sources/`.

### Step 2.7: DECISION MATRIX (if applicable)

**Skip this step** if query is pure information (no choice implied).

**Apply this step** if query implies choosing between alternatives ("X vs Y", "should we migrate", "best tool for Z").

Write `L3/decision-matrix.md`:
```markdown
# Decision Matrix

## Criteria (weighted)
| Criterion | Weight | Why it matters for user context |
|---|---|---|
| Performance | 20% | ... |
| DX | 15% | ... |
| Maturity | 15% | ... |
| Cost | 10% | ... |
| Community | 15% | ... |
| Migration effort | 25% | ... |

## Options scored
| Option | Perf | DX | Maturity | Cost | Community | Migration | **Total** |
|---|---|---|---|---|---|---|---|
| A | 8 | 7 | 9 | 6 | 8 | 5 | **7.15** |
| B | 9 | 6 | 6 | 8 | 6 | 9 | **7.25** |
| C | 6 | 9 | 8 | 7 | 9 | 4 | **7.05** |

## Winner
**B** — by a small margin (7.25 vs 7.15)

## Why B edges out A
[Detailed reasoning with citations]

## When to pick A instead
[Scenarios where the decision flips]

## When to pick C instead
[Scenarios]
```

### Step 2.8: EXPERT SYNTHESIS

Produce `L3/report.md` — supersedes `L2/report.md`.

Structure:
```markdown
# <Topic Title>

**Query:** <original>
**Level:** L3 (includes L1, L2)
**Sources:** <total count>
**Generated:** <date>

## Executive Summary
[400-500 words: the complete answer for someone who will read only this section]

## Context
[Why this question matters, what's at stake, user's context if known]

## Findings by Sub-question
[All L1/L2 subqs + L2 followups, enriched]

## Multi-perspective analysis
### Proponent view
[Strongest case for, with citations and confidence]

### Critic view
[Strongest case against, with citations]

### Neutral/independent data
[Benchmarks, studies, adoption data]

### Synthesis
[How to reconcile the three perspectives]

## Fact-check results
[From fact-check.md: confirmed / disputed / unverified claims]

## Addressing critic concerns
[From critic-report.md: weaknesses identified and how resolved or acknowledged]

## Decision Matrix
[If applicable — full matrix from decision-matrix.md]

## Recommendation
[Concrete, opinionated, with explicit reasoning chain]

## Risks and caveats
[What could go wrong with the recommendation]

## Next steps
[Actionable — what the user should do next]

## Bibliography
[See L3/bibliography.md for full list]
```

**Target length:** **2000–3000 words** (v0.2.2 relaxed from 3000-4500 based on real-session testing — old target was unachievable without aggressive subagent delegation and caused truncation artifacts).

### Step 2.9: Executive Summary

Write separate `L3/executive-summary.md` — 500 words max. For stakeholders who won't read the full report. Plain language, no jargon.

### 🛑 L3 FINAL CHECKPOINT (added v0.2.2, shared-lib'd v0.4.0)

Before delivering the report, run this verification. Mirrors the L2 CHECKPOINT discipline — L3 was previously only prose-level verified, which was a regression from L2.

```bash
SLUG="<slug>"

VERIFY_LIB="$HOME/.claude/scripts/lib/verify-research.sh"
[ -f "$VERIFY_LIB" ] || VERIFY_LIB="scripts/lib/verify-research.sh"
[ -f "$VERIFY_LIB" ] || { echo "❌ verify-research.sh not found — run scripts/install.sh"; exit 1; }

source "$VERIFY_LIB"
verify_l3 "$SLUG" || exit 1
```

The function checks: report ≥1700 words (target 2000-3000); executive summary, critic report (subagent output), fact-check, bibliography, perspective plan all present; ≥8 L3 source summaries; every `[N]` citation (including multi-cite formats) maps to a bibliography entry.

**Only proceed to PDF export (Step 2.10) after this prints `✅ L3 FINAL CHECKPOINT PASSED`.**

### Step 2.10: PDF Export

```bash
cd .firecrawl/research/<slug>/L3/
pandoc report.md -o report.pdf --pdf-engine=xelatex -V geometry:margin=1in 2>/dev/null || \
pandoc report.md -o report.html && \
echo "PDF export requires pandoc+xelatex. HTML fallback at report.html"
```

If pandoc isn't installed, fall back to HTML export.

## Final Output

1. Display `L3/executive-summary.md` in chat (short version)
2. Offer to show full `report.md` if user wants
3. Show stats:
   > 📊 L3 stats: <total> sources, <n> perspectives, <n> fact-checked claims, critic report: <n> concerns addressed
4. Artifact locations:
   > 📁 `.firecrawl/research/<slug>/L3/`
   > 📄 report.md, executive-summary.md, report.pdf, fact-check.md, critic-report.md, decision-matrix.md
5. Escalation:
   > Нужны научные источники? `/academic-research` (L4) добавит arXiv, Scholar и полный мультиагент.
   > Нужна полная база знаний? `/ultra-research` (L5) построит vault с playbook'ами.

## Rules

- **Plan approval is the norm** — skip only if user explicitly said "сразу запускай" or called from L4/L5
- **Always call L2 first** — never inline L2 logic
- **Multi-perspective is mandatory** — don't rely on one angle
- **Critic is a separate agent** — use Agent tool, not internal reasoning
- **Fact-check top 5 only** — don't try to verify every claim
- **Decision matrix only when applicable** — don't force it on info queries
- **Executive summary is separate** — ~500 words, standalone, no jargon
- **Preserve L1/L2 artifacts** — never modify or delete

## Called from higher levels

L4/L5 call this skill to get expert-grade foundation. When called:
- Run full L3 pipeline (including plan approval if user is present)
- Higher levels read `L3/report.md`, `L3/critic-report.md`, `L3/decision-matrix.md`
