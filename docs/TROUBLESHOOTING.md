# Troubleshooting

Common issues and fixes. Organized by *where* the problem shows up.

---

## Install issues

### `firecrawl: command not found`

- Restart terminal (PATH caching)
- Or `source ~/.zshrc` / `source ~/.bashrc`
- Or manually check where installed: `ls /opt/homebrew/bin/firecrawl` (Apple Silicon) or `ls /usr/local/bin/firecrawl` (Intel Mac)

### `install.sh: Permission denied`

```bash
chmod +x scripts/install.sh
bash scripts/install.sh
```

### Skills not appearing in `/` slash menu

1. Restart Claude Code (common cause — skill cache stale)
2. Check files exist: `ls ~/.claude/skills/research/SKILL.md`
3. Check SKILL.md frontmatter is valid:

   ```yaml
   ---
   name: research
   description: ...
   user_invocable: true
   ---
   ```

4. Check no YAML parse errors in frontmatter (quotes, indentation)

### `claude --version` not found

Claude Code not installed. Get it from [claude.com/claude-code](https://claude.com/claude-code).

---

## API key issues

### Firecrawl: "authentication failed"

1. Check status: `firecrawl --status`
2. Re-auth: `firecrawl config`
3. Or set env var: `export FIRECRAWL_API_KEY="fc-YOUR_KEY"`
4. Verify key at [firecrawl.dev dashboard](https://www.firecrawl.dev)

### Tavily: "rate limit exceeded" / "quota exhausted"

Free tier is 1,000 searches/month. Research heavy on Tavily (L4/L5) can burn 300+ credits per run.

- Check dashboard: [tavily.com](https://tavily.com) → account → usage
- Wait for monthly reset, or upgrade plan
- Temporarily: use L0/L1 only (minimal Tavily usage)

### Tavily MCP not connecting

1. Check `~/.claude.json` has the server block:

   ```json
   "tavily": {
     "type": "http",
     "url": "https://mcp.tavily.com/mcp/?tavilyApiKey=tvly-..."
   }
   ```

2. Key is URL-embedded — a typo silently fails
3. Restart Claude Code after editing `~/.claude.json`
4. From Claude Code, ask: "what MCP servers are connected?"

### Codex: "not authenticated"

```bash
codex auth login
```

If browser won't open automatically, copy-paste the URL it prints.

---

## Runtime issues (during research)

### <a name="l2-hollow-synthesis"></a>L2 produces a report but `.firecrawl/.../L2/sources/` is empty

**This is a known bug in v0.1 — "hollow synthesis".**

The model skipped the scrape step and synthesized directly from search snippets.

**Symptoms:**

- `L2/report.md` cites `[L2-XYZ]` but no matching file in `L2/sources/`
- `L2/bibliography.md` is missing or empty
- Report content is suspiciously generic compared to L1

**Mitigation:**

1. Re-run — often the second attempt works
2. Explicitly instruct: "after searching, scrape each URL with firecrawl scrape before writing the report"
3. Upgrade to v0.2 (has explicit verification checkpoints — planned)

### Firecrawl timeouts on specific URLs

Some sites (Reddit, LinkedIn, paywalled) are slow or block scraping.

- Firecrawl `--extract-depth basic` (default) usually handles this
- For harder sites: `firecrawl scrape <url> --extract-depth advanced`
- Skip the URL — set `exclude_domains: [linkedin.com]` in Tavily searches

### Tavily returns 0 results

- Query too specific — broaden the terms
- Check for typos in the query
- Try `topic=general` vs leaving it out
- Use `time_range=year` to widen time window

### Codex hangs for > 5 minutes

- Weekly rate limit hit — wait ~1 hour
- Or disable Codex: `export DEEP_RESEARCH_DISABLE_CODEX=1`
- Or check Codex version: `codex --version` should be ≥ 0.120.0

### Research artifacts in wrong directory

All artifacts write to `.firecrawl/research/<slug>/` **in whatever directory Claude Code was launched from**.

If you want them in a specific place, `cd` there before launching Claude Code.

### Report is in wrong language

Claude auto-detects from the query. If you want a specific language, add to prompt:

- `"respond in English"` for English
- `"отвечай по-русски"` for Russian
- Etc.

---

## Performance issues

### L4/L5 takes way longer than expected

Expected: L4 ~40 min, L5 1+ hour. If significantly longer:

- Check Tavily rate-limit (may be retrying silently)
- Check Codex is not timing out on every call
- Consider downgrading: maybe L3 is sufficient for your actual need

### Main conversation becomes sluggish

`.firecrawl/research/<slug>/` can hold 100MB+ of scraped content. Claude Code should only reference specific files, not auto-load everything.

If Claude keeps pulling the whole folder into context:

- Start a fresh conversation
- Reference specific files: `"synthesize from research/<slug>/L2/report.md"` not `"from the research folder"`

### `firecrawl` consumes high memory

Large scrapes (50+ pages in parallel) can spike RAM. Reduce `--limit` on search, or run scrapes sequentially instead of parallel.

---

## Output quality issues

### Report cites sources that don't exist

The model hallucinated a citation. Mitigation:

- Re-run — usually a one-time issue
- Check that source files in `.firecrawl/.../sources/` are non-empty
- Upgrade to v0.2 (verification checkpoints)

### Contradictions file is empty but sources obviously disagree

L2's contradiction detection missed something. Mitigation:

- Ask directly: "look at `L2/sources/01-*.md` and `L2/sources/05-*.md` — do they agree on X?"
- Consider upgrading to L3 for the critic agent's independent pass

### Confidence grading looks wrong (all H, nothing M/L)

Known behavior when sources are highly consistent. Mitigation:

- L3 critic agent explicitly checks for overconfidence
- Prompt: "re-read the report and downgrade any claim that has only 1-2 sources behind it"

### Report mixes English and Russian randomly

Sources in different languages. Mitigation:

- Add `"all output in English"` / `"весь вывод на русском"` to prompt
- Post-process: ask Claude to "translate the entire report to Russian"

---

## Git/repo issues

### `.firecrawl/research/` ends up in git

Your `.gitignore` should exclude it. Check:

```bash
grep firecrawl .gitignore
# Should output: .firecrawl/
```

If already committed:

```bash
git rm -r --cached .firecrawl/research
echo ".firecrawl/research/" >> .gitignore
git commit -m "untrack research artifacts"
```

### Secrets accidentally committed

If you committed a Tavily/Firecrawl key to git:

1. **Rotate the key immediately** at the respective dashboard
2. Remove from history: use [git-filter-repo](https://github.com/newren/git-filter-repo) or [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)
3. Force-push cleaned history (coordinate with collaborators)

---

## When to open an issue

If your problem isn't here:

1. Check [GitHub issues](https://github.com/hint-shu/deep-research/issues) for duplicates
2. Open a new issue with:
   - Exact command you ran
   - Exact error (paste, don't paraphrase)
   - `firecrawl --version`, `claude --version`, `codex --version` (if using)
   - OS (macOS / Linux / WSL)
   - Relevant `.firecrawl/research/<slug>/` contents (redact sensitive)

---

## Filing a security issue

If you find a way for the skills to leak credentials, execute unwanted commands, or access data they shouldn't — **don't open a public issue**. Email directly (see SECURITY.md — to be added) or use GitHub's private security advisory feature.
