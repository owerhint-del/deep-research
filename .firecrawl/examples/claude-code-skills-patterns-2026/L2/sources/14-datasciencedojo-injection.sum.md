# Source 14: Data Science Dojo — Prompt Injection & Claude Computer Use: 2026 Guide

**URL:** https://datasciencedojo.com/blog/prompt-injection-explained/
**Type:** tech-education-blog
**Date:** 2026
**Quality:** B
**Relevant to:** subq4 (injection incident types)

## Key facts

- **February 2026 OpenClaw incident:** attacker used prompt injection on coding agent, resulting in **unauthorized software installed on users' systems**. "No complex malware. Just text that the model treated as valid instructions."
- Taxonomy:
  - **Direct prompt injection** — attacker inputs directly
  - **Indirect prompt injection** — malicious text in content agent reads (emails, tickets, webpages)
  - **Stored prompt injection** — like stored XSS — malicious instructions in persistent data (user profile, blog post, support ticket) activate when consumed later
- **Anthropic's own admission on computer use:** "Claude can interpret screenshots from computers connected to the internet, it's possible that it may be exposed to content that includes prompt injection attacks"
- "Moves prompt injection from a theoretical model-level concern to a systems-level security problem"

## Key quotes

> "There was no complex malware. Just text that the model treated as valid instructions, which led to unauthorized software being installed."
> "When Claude can take screenshots of live websites, read emails, and act on what it sees — any page it browses becomes a potential attack surface."

## Notes

- **OpenClaw = open-source fork** (not Anthropic Claude directly) but shares format/architecture
- Stored prompt injection via skill description is implicit risk — skills are persistent content that's loaded every session
