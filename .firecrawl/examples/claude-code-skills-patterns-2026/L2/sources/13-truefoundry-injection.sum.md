# Source 13: TrueFoundry — Prompt Injection and AI Agent Security Risks: A Claude Code Guide

**URL:** https://www.truefoundry.com/blog/claude-code-prompt-injection
**Type:** security-vendor-blog
**Date:** 2026 (post Mar 31 source leak)
**Quality:** A
**Relevant to:** subq4 (security failures, debugging)

## Key facts

- **OWASP Top 10 for Agentic Applications 2026** — top 5: agent goal hijacking (prompt injection), tool misuse, identity/privilege abuse, insecure output handling, supply chain compromise. "All five have been demonstrated against Claude Code or its ecosystem in real-world attacks."
- **Claude Code source leak March 31, 2026:** 512,000 lines of TypeScript exposed via npm
- **Adversa deny-rule bypass** (bashPermissions.ts): hard cap 50 subcommands — exceed it and Claude Code defaults to asking permission instead of blocking. PoC: 50 no-op `true` subcommands + curl. With `--dangerously-skip-permissions` active, curl would execute without prompt. **Patched in Claude Code v2.1.90**
- Primary detection: input filtering at gateway layer, Lasso Security open-source hook for runtime tool-output scanning
- **InversePrompt** (2025) — command injection via whitelisted commands

## Key quotes

> "Prompt injection is the leading AI agent security risk in 2026. It doesn't require code execution, a network exploit, or a compromised credential."
> "An attacker places malicious instructions somewhere Claude Code will read them — a comment in a file, a description in a ticket, a response from an API — and waits for the agent to follow those instructions."

## Notes

- **Concrete CVE data** — major gap-fill from L1
- Source leak + deny-rule bypass are real production incidents
- v2.1.90 patch date anchors the fix timeline
