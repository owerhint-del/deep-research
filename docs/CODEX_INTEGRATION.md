# Codex CLI Integration (Optional)

How to use OpenAI Codex CLI as an **optional cross-model research channel** for L2+ tiers.

---

## Why add Codex?

Claude is excellent at research, but every single model has blind spots — its training cutoff, which part of the web its search indexes, how it weights sources. Adding a second, independent model closes that gap.

Codex CLI runs **GPT-5.4 with agentic web search** (`-c 'web_search="live"'`). Concretely:

- Different search index than Anthropic's
- Different bias patterns (GPT family vs Claude family)
- Native agentic reasoning for multi-hop browsing
- 89.3% on BrowseComp benchmark (state of the art as of 2026)

When L2+ runs both Claude-based and Codex-based searches in parallel, **disagreements between the two channels surface immediately** and get flagged in `contradictions.md`.

---

## Do I need this?

| Tier | Codex role | Required? |
|------|-----------|-----------|
| L0 | Not used | No |
| L1 | Not used | No |
| L2 | 1 follow-up gap-filler (optional) | No — L2 works without it |
| L3 | Critic + neutral angle (optional) | No — falls back to single-model |
| L4 | Researcher C in the agent crew (optional) | No — crew works without C |
| L5 | In each iteration + fact-checker (optional) | No — still runs, just lower confidence |

**Short answer:** no. The ladder works without Codex. It just becomes single-model at L2+, which means weaker contradiction-detection.

If you already have a ChatGPT Pro subscription ($200/month for GPT-5.4), adding Codex costs you nothing extra on top.

---

## Installation

### 1. Install Codex CLI

**macOS:**

```bash
brew install openai/tap/codex
```

**Other platforms:** see [developers.openai.com/codex/cli](https://developers.openai.com/codex/cli).

### 2. Authenticate

```bash
codex auth login
```

Opens a browser. Log in with your ChatGPT Pro account.

### 3. Verify

```bash
codex --version
# 0.120.0 or higher

codex exec -c 'web_search="live"' --sandbox read-only \
  --skip-git-repo-check --ephemeral \
  "What is the latest stable Node.js LTS version?"
```

Expected: about 60–90 seconds, then a markdown response with the answer.

If this works, Codex is ready.

---

## How the skills use Codex

### The command template

Every skill that uses Codex invokes it via Bash with this exact template:

```bash
codex exec \
  -c 'web_search="live"' \
  --sandbox read-only \
  --skip-git-repo-check \
  --ephemeral \
  -o "/path/to/output.md" \
  "Research prompt goes here"
```

**Flag-by-flag:**

| Flag | What it does | Why |
|------|--------------|-----|
| `-c 'web_search="live"'` | Enables live web search (not cached) | Needed for current info — cached index is stale |
| `--sandbox read-only` | Prevents Codex from writing to your filesystem | Safety — research shouldn't touch code |
| `--skip-git-repo-check` | Don't check for git repo | Codex runs from arbitrary directories |
| `--ephemeral` | Don't save to session history | Keeps sessions clean between research runs |
| `-o <file>` | Write output to this file | Claude reads the file afterwards |

### Per-tier usage

**L2 — single gap-filler (parallel to main L2 layer):**

```bash
codex exec -c 'web_search="live"' --sandbox read-only --skip-git-repo-check --ephemeral \
  -o ".firecrawl/research/<slug>/L2/codex-gap.md" \
  "You are a research assistant. Investigate this specific gap in our current findings: <gap description>. Return 5-10 key facts with URLs. Be concise."
```

Runs **in parallel with the main L2 reflection loop**. Output is merged into L2's `gaps.md`.

**L3 — critic + neutral angle (two calls):**

```bash
# Critic pass
codex exec -c 'web_search="live"' --sandbox read-only --skip-git-repo-check --ephemeral \
  -o ".firecrawl/research/<slug>/L3/codex-critic.md" \
  "Review this research report adversarially. Challenge the main conclusions. Look for what's missing or wrong: <pasted L2 report>"

# Neutral angle
codex exec -c 'web_search="live"' --sandbox read-only --skip-git-repo-check --ephemeral \
  -o ".firecrawl/research/<slug>/L3/codex-angle.md" \
  "Research the question '<original query>' from a neutral/skeptical angle. Find sources that disagree with common consensus."
```

**L4/L5 — Researcher C in the crew:**

Runs as a background agent (no `--ephemeral` so resume works if needed):

```bash
codex exec -c 'web_search="live"' --sandbox read-only --skip-git-repo-check \
  -o ".firecrawl/research/<slug>/L4/codex-researcher-c.md" \
  "<crew prompt with sub-question assignment>"
```

---

## Known limitations

### Latency

| Task | Typical time |
|------|--------------|
| Single question, web search | 60–90 seconds |
| Multi-faceted research prompt | 2–5 minutes |

Codex is **not on the critical path** — it runs in parallel with Claude's own research. If Codex is slow, Claude finishes without it.

### Token/quota overhead

Each Codex call consumes ~100K GPT-5.4 tokens internally. On ChatGPT Pro subscription this is free but counts against weekly usage caps. Heavy L5 use can hit rate limits.

**Mitigation:** skills degrade gracefully. If `codex exec` returns non-zero or times out, the skill logs the failure and continues without Codex output.

### CLI limitations vs ChatGPT UI

The CLI web search is **less powerful** than ChatGPT's full browsing:

- Fewer search queries per call
- No multimodal output (PDF analysis, image search)
- No Deep Research mode (that's ChatGPT Pro UI only, 250 runs/month)

For most research use cases this is fine. For maximum-depth single investigations, use ChatGPT Deep Research through the web UI and feed the output back to Claude as context.

### `resume --last` config inheritance

If you want to continue a previous Codex session with `codex exec resume --last`, note that **configuration flags inherit from the first call**. You can't change `web_search` or `--sandbox` after the first invocation. Set them right the first time.

### Strict web_search values

Only three valid values for `-c 'web_search="..."'`:

- `live` — real web search (what we want)
- `cached` — OpenAI-maintained static index (stale, don't use)
- `disabled` — no search at all

Any other value crashes Codex with exit code 1.

---

## Disabling Codex

If you want to use the skills *without* Codex:

**Option 1 — Don't install it.** The skills check for Codex at invocation; if missing, they skip it.

**Option 2 — Force-disable via env:**

```bash
export DEEP_RESEARCH_DISABLE_CODEX=1
```

Any L2+ skill will skip Codex calls even if installed.

---

## Troubleshooting Codex

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `codex: command not found` | Not installed or PATH missing | `brew install openai/tap/codex`; restart terminal |
| `Error: not authenticated` | Token expired | `codex auth login` |
| Long hangs with no output | Weekly rate limit hit | Disable temporarily (see above); wait for reset |
| Codex returns nonsense | Web search is on `cached` | Ensure `-c 'web_search="live"'` is set |
| Exit code 2 | Invalid flag or config | Check `codex --version` ≥ 0.120.0 |
| `--ephemeral` flag not recognized | Old Codex version | Upgrade: `brew upgrade codex` |

---

## Security

Codex runs with `--sandbox read-only` in all research calls. It cannot:

- Write files outside the `-o` output path
- Execute arbitrary shell commands
- Modify your codebase
- Read environment variables or credentials it wasn't given

The `-o` output file is the only thing Codex writes. Claude reads that file to pull findings back into synthesis.

---

## When NOT to use Codex

- **Sensitive/proprietary research topics** — Codex queries go to OpenAI servers. If your research query contains confidential info, use Claude-only mode.
- **Air-gapped or offline environments** — Codex requires internet + ChatGPT auth.
- **Extremely high-volume automation** — rate limits will hit.

---

## Future improvements

- **Streaming output** — currently we wait for the full `-o` file; streaming would let Claude start synthesizing earlier.
- **MCP-based integration** — wrap Codex as an MCP server so skills can call it via structured tool calls instead of Bash shell-outs.
- **Cost telemetry** — track per-research Codex usage so users can budget.

See [CONTRIBUTING.md](../CONTRIBUTING.md) to help with any of these.
