# Source 19: Get AI Perks — Claude Code Security: AI Vulnerability Scanning in 2026

**URL:** https://www.getaiperks.com/en/articles/claude-code-security
**Type:** security-best-practices
**Date:** 2026
**Quality:** B
**Relevant to:** subq4 (sandboxing, mitigation)

## Key facts

- **Sandboxing quant:** "safely reduce permission prompts by **84%** while increasing safety" — two boundaries:
  - Filesystem isolation (can't access files outside designated dirs)
  - Network isolation (controls external connections)
- **OWASP LLM Top 10** positions prompt injection as #1 LLM risk
- **Human-in-the-loop for patches:** AI identifies problems and proposes fixes but "security professionals make the final call on what gets implemented"
- **"Reasoning models excel at discovery but still need validation before changes hit production systems"** — acknowledges limitation of autonomous remediation

## Key quotes

> "Claude Code's sandboxing features enable two boundaries: filesystem and network isolation. They have been shown to safely reduce permission prompts by 84% while increasing safety."
> "AI in security: reasoning models excel at discovery but still need validation before changes hit production systems."

## Notes

- **84% prompt reduction quant** is concrete, actionable
- Human-in-the-loop requirement on patches is honest limitation
- Complementary to source 13 (offensive side) with defensive mechanisms
