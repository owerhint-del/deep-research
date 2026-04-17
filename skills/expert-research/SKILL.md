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

- Time: ~20 min total (L1: ~5 + L2: ~7 + L3: ~8)
- Tavily credits: ~150
- Sub-questions: 8 (L1: 3 + L2: 2 + L3: 3)
- Sources: 40–60
- Output: 3000+ word report + executive summary + PDF export

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

### Step 2.4: FACT-CHECK CRITICAL CLAIMS

Read L2/report.md + L3 new summaries. Identify the **top 5 most critical claims** — ones that would change the recommendation if wrong.

For each, verify against 2+ **independent** sources (not from the same vendor/author):

Write `L3/fact-check.md`:
```markdown
# Fact-check report

## Claim 1: "X is 3x faster than Y"
**Source in report:** [7]
**Verification attempts:**
- ✓ Confirmed: [23] independent benchmark shows 2.8x
- ✓ Confirmed: [25] community benchmark shows 3.1x
- **Verdict:** CONFIRMED (High confidence)

## Claim 2: "X has poor ecosystem"
**Source in report:** [12] (critic blog)
**Verification attempts:**
- ✗ Contradicted: [28] shows 500+ packages
- ? Inconclusive: [30] mentions "some gaps" without specifics
- **Verdict:** DISPUTED — downgrade to "community opinion, not fact"

## Claim 3: ...
```

**Verdict categories:**
- **CONFIRMED** — 2+ independent sources agree
- **DISPUTED** — sources disagree, needs careful framing
- **UNVERIFIED** — couldn't find independent confirmation (downgrade in report)

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

**Target length:** 3000–4500 words.

### Step 2.9: Executive Summary

Write separate `L3/executive-summary.md` — 500 words max. For stakeholders who won't read the full report. Plain language, no jargon.

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
