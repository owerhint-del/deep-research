# Installation Guide

Complete setup for the Deep Research ladder on macOS, Linux, and Windows (WSL).

---

## Overview

Three installation paths:

| Path | When to use | Time |
|------|-------------|------|
| **A. Quick** | You want to try it immediately, already have Claude Code | 5 min |
| **B. Full** | You want all six tiers including L5 with Codex | 20 min |
| **C. Manual** | You want to audit each step, or `install.sh` fails | 30 min |

---

## Prerequisites

All paths require:

| Tool | Check with | Install if missing |
|------|-----------|--------------------|
| Claude Code | `claude --version` | [claude.com/claude-code](https://claude.com/claude-code) |
| git | `git --version` | Usually preinstalled; `brew install git` / `apt install git` |
| Bash 4+ or Zsh | `echo $SHELL` | macOS/Linux default |

Optional but recommended:

| Tool | Used by |
|------|---------|
| `jq` | Install scripts, JSON inspection |
| `curl` | API tests |

---

## Path A — Quick install (5 min)

```bash
git clone https://github.com/YOUR_USERNAME/deep-research.git
cd deep-research
bash scripts/install.sh
```

The script:

1. Copies each `skills/<name>/` to `~/.claude/skills/<name>/`
2. Verifies Claude Code can see them (`claude skill list`)
3. Prints the next steps (API keys, test command)

After the script finishes, skip to [API Keys Setup](#api-keys-setup).

---

## Path B — Full install (20 min)

### 1. Install Firecrawl CLI

**macOS (Homebrew):**

```bash
brew install firecrawl
```

**Linux / WSL:**

```bash
curl -fsSL https://install.firecrawl.dev | bash
```

**Alternative (npm, any platform):**

```bash
npm install -g @mendable/firecrawl-cli
```

Verify:

```bash
firecrawl --version
# Should print: 1.12.2 (or higher)
```

### 2. Install Tavily MCP (via Claude Code)

Tavily runs as an MCP server that Claude Code connects to. The cleanest way is to add it via your Claude Code MCP config.

Open `~/.claude.json` (or create it) and add Tavily under `mcpServers`:

```json
{
  "mcpServers": {
    "tavily": {
      "type": "http",
      "url": "https://mcp.tavily.com/mcp/?tavilyApiKey=YOUR_TAVILY_KEY_HERE"
    }
  }
}
```

> ⚠️ **Security note:** `~/.claude.json` stays on your machine. Never commit it anywhere. Your API key goes in this file and nowhere else in this project.

Restart Claude Code to pick up the new MCP server.

### 3. (Optional) Install OpenAI Codex CLI

Only needed if you want the cross-model channel for L2+.

```bash
# macOS
brew install openai/tap/codex

# Other platforms: see https://developers.openai.com/codex/cli
```

Log in with your ChatGPT account (must be Pro tier for GPT-5.4):

```bash
codex auth login
```

Verify:

```bash
codex --version
codex exec -c 'web_search="live"' --sandbox read-only \
  --skip-git-repo-check --ephemeral \
  "What is the latest stable Node.js version?"
```

If this returns a sensible answer, Codex is ready.

### 4. Clone and install skills

```bash
git clone https://github.com/YOUR_USERNAME/deep-research.git
cd deep-research
bash scripts/install.sh
```

Continue to [API Keys Setup](#api-keys-setup).

---

## Path C — Manual install (30 min)

Use this path if `install.sh` fails or you want full audit.

### 1. Copy skills manually

```bash
cp -r skills/quick-research     ~/.claude/skills/
cp -r skills/research           ~/.claude/skills/
cp -r skills/deep-research      ~/.claude/skills/
cp -r skills/expert-research    ~/.claude/skills/
cp -r skills/academic-research  ~/.claude/skills/
cp -r skills/ultra-research     ~/.claude/skills/
```

### 2. Verify Claude Code sees them

Open Claude Code in any directory, type `/` — you should see `/quick-research`, `/research`, `/deep-research`, `/expert-research`, `/academic-research`, `/ultra-research` in the list.

If not:

- Restart Claude Code
- Check `~/.claude/skills/` has the files
- Check each `SKILL.md` starts with proper frontmatter (`---\nname: ...\n`)

---

## API Keys Setup

### Firecrawl

**Option 1 — OAuth (easiest):**

```bash
firecrawl config
```

Opens a browser, sign in or sign up, done.

**Option 2 — manual key:**

1. Go to [firecrawl.dev](https://www.firecrawl.dev), sign up
2. Copy your API key (`fc-...`)
3. Set it:

```bash
# In your shell profile (~/.zshrc or ~/.bashrc):
export FIRECRAWL_API_KEY="fc-YOUR_KEY_HERE"
```

Or use `firecrawl -k fc-YOUR_KEY ...` on every call.

Verify:

```bash
firecrawl --status
# Should show: Authenticated: yes
```

### Tavily

1. Sign up at [tavily.com](https://tavily.com)
2. Get your API key (`tvly-...`)
3. Edit `~/.claude.json` — replace `YOUR_TAVILY_KEY_HERE` with your actual key (see step 2 of Path B)
4. Restart Claude Code

Verify: in Claude Code, ask `what MCP servers are connected?` — you should see `tavily` listed.

### Codex CLI (optional)

```bash
codex auth login
```

Follow the browser flow. No env var needed — Codex stores auth locally.

---

## First test run

In any directory, start Claude Code and run:

```
/quick-research what's the latest stable version of Bun
```

Expected: ~1 minute, you get a short answer with 3–5 cited sources.

If it fails, jump to [docs/TROUBLESHOOTING.md](TROUBLESHOOTING.md).

---

## Verification checklist

Run each command, all should succeed:

```bash
claude --version              # Claude Code installed
firecrawl --status            # Firecrawl auth OK
firecrawl search "test" --limit 1   # Firecrawl search works
codex --version               # (Optional) Codex installed
ls ~/.claude/skills/research/SKILL.md   # Skills copied
```

From inside Claude Code:

```
/quick-research test query    # L0 works
mcp__tavily__tavily_search    # Tavily MCP accessible
```

---

## Upgrade

```bash
cd deep-research
git pull
bash scripts/install.sh       # Re-run install (it's idempotent)
```

---

## Uninstall

```bash
rm -rf ~/.claude/skills/quick-research
rm -rf ~/.claude/skills/research
rm -rf ~/.claude/skills/deep-research
rm -rf ~/.claude/skills/expert-research
rm -rf ~/.claude/skills/academic-research
rm -rf ~/.claude/skills/ultra-research
```

Your research artifacts in `.firecrawl/research/` in individual projects are yours to keep or delete.

---

## Troubleshooting common install issues

| Symptom | Cause | Fix |
|---------|-------|-----|
| `firecrawl: command not found` | PATH not updated | Restart terminal, or `source ~/.zshrc` |
| Skills not listed in Claude Code | MCP/skill cache stale | Restart Claude Code; check `~/.claude/skills/` |
| Tavily: "authentication failed" | Wrong key in `~/.claude.json` | Re-copy key from tavily.com dashboard |
| Codex: "not authenticated" | Token expired | Re-run `codex auth login` |
| `install.sh: Permission denied` | Missing execute bit | `chmod +x scripts/install.sh` |

Full troubleshooting: [docs/TROUBLESHOOTING.md](TROUBLESHOOTING.md).
