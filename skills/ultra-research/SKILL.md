---
name: ultra-research
description: Ultra research (L5) — maximum depth. Runs /academic-research (L4) then adds peer-review simulation, recursive exploration until knowledge saturation, full agent crew (7+), and builds a complete knowledge base with executive summary, glossary, timeline, playbooks, counter-arguments, and open questions. 1+ hour, 150+ sources, 10000+ word main report + full vault structure. Auto-syncs to auto-memory. Use when you want to become an expert on a topic.
user_invocable: true
---

# Ultra Research — L5 Knowledge Base

Maximum research tier. **Composes** on top of L4 (`/academic-research`) by adding:
- **Recursive exploration until saturation** — keep expanding until no new facts appear
- **Peer-review simulation** — 3 independent critic passes
- **Full 7-agent crew** — Coordinator, Planner, 3× Researchers, Fact-checker, Critic, Editor, Synthesizer
- **Knowledge base output** — not a single report, but a full vault structure
- **Playbooks** — actionable how-tos derived from research
- **Auto-memory sync** — long-term knowledge saved to memory system

**Position in ladder:** L5. Calls L4 (which chains through L3, L2, L1). Top of ladder.

## When to Use

- "хочу знать всё про X"
- "построй мне базу знаний по Y"
- "мне нужны playbook'и по Z"
- Topics you want to become a genuine expert on
- Strategic domains for your business
- One-time investment in a knowledge area you'll return to
- When user says "максимально", "полный ресёрч", "база знаний", "всё что можно найти"

**No escalation** — this is the top tier.

## Budget

- **Time:** 1+ hour (L1: 5 + L2: 7 + L3: 8 + L4: 20 + L5: 30+)
- **Tavily credits:** 1000+
- **LLM tokens:** ~500k–1M (significant cost)
- **Estimated $ cost:** $5–20 per session
- **Sub-questions:** 20+ recursive
- **Sources:** 150+
- **Output:** 10000+ word main report + full knowledge base structure

**Warn the user before starting:**
```
⚠️ L5 Ultra Research costs ~1000 Tavily credits and ~$10 in LLM tokens per run.
Estimated time: 1-2 hours (runs mostly autonomously with occasional checkpoints).

Continue? (y / n)
```

## Pipeline

```
STAGE 1: Execute /academic-research (L4)
    → Full L1-L4 artifacts

STAGE 2: L5 Ultra Layer
  1. SATURATION PLANNING       — define stop condition
  2. COORDINATOR SETUP         — spawn the full crew
  3. RECURSIVE EXPLORATION     — loop until saturation
     ├─ Planner: next questions
     ├─ Researcher A/B/C: parallel gathering
     ├─ Fact-checker: verify claims
     ├─ Critic: attack findings
     └─ Loop check: new facts? continue : stop
  4. PEER-REVIEW SIMULATION    — 3 independent critic passes
  5. KNOWLEDGE BASE ASSEMBLY   — vault structure
  6. PLAYBOOK GENERATION       — actionable artifacts
  7. COUNTER-ARGUMENTS         — steel-man opposing views
  8. MEMORY SYNC               — persist to auto-memory
```

## Artifacts Directory — Full Knowledge Base

```
.firecrawl/research/<slug>/
├── L1/ L2/ L3/ L4/                     # from lower levels
└── L5/                                  # KNOWLEDGE BASE VAULT
    ├── 00-executive-summary.md          # 500-word TL;DR
    ├── 01-main-report.md                # 10000+ word comprehensive report
    ├── 02-glossary.md                   # all terms and definitions
    ├── 03-timeline.md                   # extended from L4
    ├── 04-key-players.md                # people, companies, projects, projects
    ├── 05-playbooks/                    # actionable how-tos
    │   ├── how-to-<task-1>.md
    │   ├── how-to-<task-2>.md
    │   └── decision-tree.md
    ├── 06-counter-arguments.md          # steel-manned opposition
    ├── 07-open-questions.md             # from L4 + L5 additions
    ├── 08-bibliography.md               # full annotated, 150+ entries
    ├── 09-methodology.md                # full transparency
    ├── 10-recommended-next-reading.md   # curated further learning
    ├── crew/
    │   ├── coordinator-log.md
    │   ├── planner-iterations.md
    │   ├── researcher-a/
    │   ├── researcher-b/
    │   ├── researcher-c/
    │   ├── fact-checker-report.md
    │   ├── peer-review-1.md
    │   ├── peer-review-2.md
    │   ├── peer-review-3.md
    │   └── editor-notes.md
    ├── sources/                          # ALL scraped materials archived
    │   └── <all source files>
    ├── saturation-log.md                 # record of saturation checks
    ├── knowledge-base.pdf                # full report as PDF
    └── knowledge-base.epub               # EPUB for reading offline
```

## Stage 0: Warning and Confirmation

Before spending ~$10 and 1 hour, confirm with user:

```markdown
# ⚠️ L5 Ultra Research — Confirmation

**Query:** <user's query>

## Estimated cost
- Tavily: ~1000 credits
- LLM tokens: ~500k-1M (~$5-20)
- Time: 1-2 hours

## Will produce
- Full knowledge base vault (~15 files)
- Main report: 10000+ words
- Playbooks: 3-5 actionable how-tos
- 150+ sources with quality ratings
- Auto-sync to memory system
- PDF + EPUB exports

## Process
1. Executes L4 (~40 min, ~400 credits) as foundation
2. Recursive exploration until saturation (~30-60 min)
3. Peer-review simulation (3 critic passes)
4. Knowledge base assembly
5. Memory sync

**Continue?** (y / n)
```

If `n` — abort. If `y` — proceed. If called from test/dev — skip with `--go` flag semantic.

## Stage 1: Execute L4

Invoke `academic-research` skill:
```
Skill: academic-research
Args: <query>
```

Wait for L4 completion. This alone takes ~40 min. Verify all L4 artifacts exist.

## Stage 2: L5 Ultra Layer

### Step 2.1: SATURATION PLANNING

Define the **stop condition** for recursive exploration:

```markdown
# L5 Saturation Criteria

## Exploration stops when:
1. **Fact saturation:** Last 2 iterations produced <3 new verified facts each
2. **Source saturation:** Last 2 iterations found mostly duplicates of existing sources
3. **Sub-question exhaustion:** Planner can't generate meaningfully new questions
4. **Budget cap:** Tavily credits used > 700 for L5 alone
5. **Time cap:** L5 loop has run for > 45 min

## Iteration budget
- Minimum: 3 iterations
- Maximum: 8 iterations
- Each iteration: Planner → 3 Researchers (parallel) → Fact-checker → Critic → Saturation check
```

Save to `L5/saturation-log.md` (will be appended with actual iteration results).

### Step 2.2: COORDINATOR SETUP

Unlike lower levels, L5 uses a **Coordinator pattern**. The Coordinator is a long-running conceptual role (implemented via repeated Agent calls with shared state).

The Coordinator:
1. Reads current state (all L1-L5 artifacts so far)
2. Decides what iteration is needed next
3. Spawns the appropriate sub-agents
4. Evaluates if saturation is reached
5. Either continues or proceeds to assembly

### Step 2.3: RECURSIVE EXPLORATION LOOP

**This is the heart of L5.** Loop until saturation:

```
iteration = 0
while not saturated and iteration < 8:
    iteration += 1

    # Phase A: Planner generates next questions
    planner_output = Agent(
        description=f"L5 Iteration {iteration} Planner",
        prompt="Read all L1-L5 artifacts so far. Generate 3 new sub-questions that
                would add significant new knowledge not yet covered. Focus on:
                - Depth: go deeper into one specific aspect
                - Breadth: explore an angle not yet covered
                - Verification: re-examine a Low-confidence claim

                Write questions to L5/crew/planner-iterations.md, append with iteration number.
                If you can't find 3 meaningfully new questions, say so explicitly."
    )

    if "cannot find meaningfully new questions" in planner_output:
        mark_saturated("no new questions")
        break

    # Phase B: Parallel Researchers (3 agents in background)
    researcher_a = Agent(
        description=f"L5 Iter {iteration} Researcher A — depth",
        run_in_background=True,
        prompt="Go DEEP on sub-question 1 from planner-iterations.md iteration {iteration}.
                Target: 5-10 highly specific sources.
                Scrape, summarize, save to L5/sources/ numbered from next available.
                Write findings to L5/crew/researcher-a/iter-{iteration}.md"
    )

    researcher_b = Agent(
        description=f"L5 Iter {iteration} Researcher B — breadth",
        run_in_background=True,
        prompt="Go WIDE on sub-question 2. Target different angles, cross-domain, adjacent fields.
                5-10 sources. Save summaries + write to L5/crew/researcher-b/iter-{iteration}.md"
    )

    researcher_c = Agent(
        description=f"L5 Iter {iteration} Researcher C — verification",
        run_in_background=True,
        prompt="Focus on sub-question 3 (verification angle). Re-examine Low-confidence claims
                from previous iterations and L4 report. Find 5-10 sources specifically to
                verify or refute. Save summaries + write to L5/crew/researcher-c/iter-{iteration}.md"
    )

    wait_for(researcher_a, researcher_b, researcher_c)

    # Phase C: Fact-checker reviews new findings
    fact_checker = Agent(
        description=f"L5 Iter {iteration} Fact-checker",
        prompt="Read new findings from L5/crew/researcher-*/iter-{iteration}.md.
                For each new factual claim, verify against existing L1-L5 sources.
                Flag contradictions, confirm confirmations.
                Write to L5/crew/fact-checker-report.md (append)."
    )

    # Phase D: Critic attacks new findings
    critic = Agent(
        description=f"L5 Iter {iteration} Critic",
        prompt="Challenge the new findings from iteration {iteration}.
                Are they rigorous? Do they actually add knowledge or are they redundant?
                Is there a weaker source being over-weighted?
                Append to L5/crew/editor-notes.md under iteration {iteration}."
    )

    # Phase E: Saturation check
    new_verified_facts = count_new_facts(iteration)
    new_unique_sources = count_new_sources(iteration)

    append_to_saturation_log({
        iteration: iteration,
        new_facts: new_verified_facts,
        new_sources: new_unique_sources,
        tavily_credits_used: current_credits,
        time_elapsed: current_time,
    })

    if iteration >= 3 and all_saturation_criteria_met():
        mark_saturated("all criteria met")
        break

    if tavily_credits_used > 700:
        mark_saturated("budget cap")
        break

    if time_elapsed > 45_minutes:
        mark_saturated("time cap")
        break
```

**Implementation note:** Claude Code implements this loop as sequential tool calls with the Coordinator reading state from disk between iterations. Use TaskCreate/TaskUpdate to track iteration progress.

### Step 2.4: PEER-REVIEW SIMULATION

After recursive exploration stops, run **3 independent peer-review passes**. Each reviewer gets a different angle:

#### Peer Review 1: Academic rigor
```
Agent(
    description="L5 Peer Review 1 — academic rigor",
    prompt="""
You are peer reviewer 1. Role: academic rigor reviewer.

Read all L5 findings + main report draft.

Check:
- Are citations used correctly?
- Are academic sources weighted appropriately vs blog posts?
- Is methodology sound?
- Are conclusions supported by evidence strength?
- Any cherry-picking?

Write review to: L5/crew/peer-review-1.md

Format:
- Overall verdict: accept / accept with revisions / major revision / reject
- Strengths
- Weaknesses
- Required revisions before publication
- Optional suggestions
"""
)
```

#### Peer Review 2: Practical validity
```
Agent(
    description="L5 Peer Review 2 — practical validity",
    prompt="""
You are peer reviewer 2. Role: practitioner reviewer.

Check:
- Do the findings actually help someone working on this in practice?
- Are the playbooks executable or vague?
- Is the recommendation section actionable?
- Any dangerous advice?
- What would a senior engineer dismiss as theoretical?

Write to: L5/crew/peer-review-2.md
"""
)
```

#### Peer Review 3: Completeness
```
Agent(
    description="L5 Peer Review 3 — completeness",
    prompt="""
You are peer reviewer 3. Role: completeness reviewer.

Check:
- Major topics missed?
- Key authors not cited?
- Recent developments (past 3 months) covered?
- Cross-references to related fields?
- Is the knowledge base actually complete or does it have obvious holes?

Write to: L5/crew/peer-review-3.md
"""
)
```

After all 3 reviews, integrate findings: address required revisions, add missing content, fix flagged issues.

### Step 2.5: KNOWLEDGE BASE ASSEMBLY

Now build the full vault. This is the "editor" role, synthesizing everything.

#### 00-executive-summary.md
500 words. For someone who'll read ONLY this. Covers: what the topic is, why it matters, the key takeaways, the main recommendation.

#### 01-main-report.md
10000+ word comprehensive report. Extended version of L4 report, enriched with L5 iterations. Full academic structure.

#### 02-glossary.md
Every technical term used in the report, with definition and citation. Sorted alphabetically.

#### 03-timeline.md
Extended timeline from L4 with L5 additions.

#### 04-key-players.md
- People: researchers, authors, founders (with brief bios and contributions)
- Companies: vendors, startups, established players
- Projects: open-source, commercial, academic
- Each entry: 100-200 words + citations

#### 05-playbooks/
Generate 3-5 actionable playbooks. Each is a how-to derived from the research:

Examples:
- `how-to-choose-<X>.md` — decision tree with criteria
- `how-to-implement-<Y>.md` — step-by-step with gotchas
- `how-to-evaluate-<Z>.md` — evaluation rubric with examples
- `decision-tree.md` — when to use approach A vs B vs C

Each playbook:
- Clear objective
- Prerequisites
- Step-by-step with citations
- Gotchas from research
- Success criteria

#### 06-counter-arguments.md
**Steel-manned opposition.** For every major recommendation, write the strongest counter-argument as if you genuinely believed it. Format:

```markdown
## Recommendation X: [from main report]

### Steel-manned counter-argument
[Most convincing case AGAINST X, as if written by an advocate for the opposite view]

### Which parts of the counter-argument are strong
[Honest acknowledgment]

### Why the main recommendation still holds (or doesn't)
[Response with reasoning]
```

#### 07-open-questions.md
Extended from L4. Include:
- Questions the literature doesn't answer
- Questions L5 tried to answer but couldn't
- Questions that emerged from L5 findings
- Speculative questions for future exploration

#### 08-bibliography.md
Full annotated bibliography. All 150+ sources with:
- Quality rating (A/B/C/D)
- Type (academic / official / tech-blog / community)
- Date
- 1-2 sentence contribution summary

#### 09-methodology.md
Full transparency. Extend L4 methodology with L5 details:
- Iterations run, facts added per iteration
- Saturation criteria and when they triggered
- Peer-review verdicts
- Biases acknowledged
- What we deliberately excluded

#### 10-recommended-next-reading.md
Curated further learning:
- 5 essential papers (with abstracts)
- 5 essential books / long-form
- 5 practitioner resources (courses, tutorials)
- Communities to join
- People to follow

### Step 2.6: EXPORT

```bash
cd .firecrawl/research/<slug>/L5/

# PDF — main report only
pandoc 01-main-report.md -o knowledge-base.pdf \
  --pdf-engine=xelatex --toc --number-sections \
  -V geometry:margin=1in

# EPUB — full knowledge base combined
pandoc 00-executive-summary.md 01-main-report.md 02-glossary.md \
       03-timeline.md 04-key-players.md 06-counter-arguments.md \
       07-open-questions.md 08-bibliography.md \
       -o knowledge-base.epub \
       --metadata title="<Topic>: Knowledge Base" \
       --toc
```

### Step 2.7: MEMORY SYNC

Save the knowledge base to auto-memory as long-term reference.

1. Create new memory file: `~/.claude/projects/-Users-nmaximov/memory/reference_<topic-slug>.md`:

```markdown
---
name: <Topic> Knowledge Base
description: L5 ultra-research knowledge base — main facts, playbooks pointer, saturation reached after N iterations
type: reference
---

# <Topic>

## TL;DR
[copied from executive summary]

## Key facts (high confidence)
- Fact 1 [source]
- Fact 2 [source]
- ...

## Playbooks available
- how-to-X (decision tree)
- how-to-Y (implementation)
- ...

## Full knowledge base
📁 `.firecrawl/research/<slug>/L5/`
- 01-main-report.md (10k+ words)
- 05-playbooks/ (N playbooks)
- knowledge-base.pdf
- knowledge-base.epub

## Saturation
- Iterations: N
- Sources: 150+
- Quality: A:<n> B:<n> C:<n>
- Peer reviews: 3 passes, verdicts: <list>

## When to revisit
- When user asks about <topic> again
- When making decisions involving <topic>
- Update if topic significantly evolves (re-run L2 or L3 on specific aspects)
```

2. Append to `~/.claude/projects/-Users-nmaximov/memory/MEMORY.md`:
```
- [<Topic> Knowledge Base](reference_<topic-slug>.md) — L5 ultra-research, 150+ sources, N playbooks
```

3. Ask user if they want Obsidian sync (optional):
> База знаний создана. Синхронизировать в Obsidian vault (`2-Areas/Research/<topic>.md`)? (y/n)

If yes, copy main report + playbooks to Obsidian vault location from user's global CLAUDE.md.

## Final Output

1. Show user the `00-executive-summary.md` in chat
2. List vault structure:
   ```
   📚 Knowledge Base created at .firecrawl/research/<slug>/L5/
   
   📄 Main artifacts:
   - 00-executive-summary.md      (500 words)
   - 01-main-report.md            (<word_count> words)
   - 05-playbooks/                (<n> playbooks)
   - 08-bibliography.md           (<source_count> sources)
   
   📦 Exports:
   - knowledge-base.pdf
   - knowledge-base.epub
   
   🧠 Memory synced: reference_<topic-slug>.md
   ```
3. Stats:
   ```
   📊 L5 Ultra Research Stats
   - Iterations: <n>
   - Total sources: <n> (A:<n> B:<n> C:<n>)
   - Peer reviews: 3 passes
   - Tavily credits used: <n>
   - LLM tokens: ~<n>
   - Time: <n> min
   - Saturation reason: <reason>
   ```
4. Next steps:
   > База знаний сохранена и синхронизирована в память. В будущем вопросы по теме автоматически подтянут эти материалы.
   > Хочешь посмотреть какой-то конкретный раздел? (main-report / playbooks / counter-arguments / open-questions / timeline)

## Rules

- **ALWAYS confirm budget before start** — L5 is expensive
- **Call L4 first, don't inline** — full composition
- **Recursive loop has hard caps** — max 8 iterations, max 45 min, max 700 credits
- **Peer review is 3 independent passes** — don't batch them
- **Knowledge base is the product, not a report** — full vault structure
- **Playbooks must be actionable** — not just summaries
- **Counter-arguments must be steel-manned** — genuine strongest opposition
- **Memory sync is mandatory** — L5 findings persist
- **Obsidian sync is optional** — ask user
- **Checkpoint after each iteration** — save state, so crash recovery is possible
- **Parallel researchers within iteration** — all 3 run in background
- **Sequential iterations** — don't parallelize across iterations (state matters)

## Error recovery

If L5 crashes mid-loop:
- State is on disk (crew/, sources/, saturation-log.md)
- User can resume by invoking `ultra-research --resume <slug>`
- L5 will read saturation-log.md, find last completed iteration, continue from there
- Lower levels (L1-L4) remain untouched

## No escalation

L5 is the final tier. If user wants more, they can:
- Re-run L5 with a refined/different query
- Manually extend specific playbooks
- Do human research on top of the knowledge base
