Introducing web-agent, an open framework for building web agents. Fork it, swap models, and add Skills. [Start building →](https://github.com/firecrawl/web-agent?utm_source=firecrawl-website&utm_medium=banner&utm_campaign=open-source-agent-launch&utm_content=start-building)

//

Get started

//

### Ready to build?

Start getting Web Data for free and scale seamlessly as your project expands.No credit card needed.

[Start for free](https://www.firecrawl.dev/signin) [See our plans](https://www.firecrawl.dev/pricing)

[Are you an AI agent? Get an API key here](https://www.firecrawl.dev/agent-onboarding/SKILL.md)

#### Table of Contents

[Blog](https://www.firecrawl.dev/blog)

Best Claude Code Skills to Try in 2026

![placeholder](https://www.firecrawl.dev/_next/image?url=%2Fimages%2Fauthors%2Fhiba.webp&w=48&q=75&dpl=dpl_A4bocZdooGLKwbK5ZG62DB8yKcee)Hiba Fathima

Mar 13, 2026

![Best Claude Code Skills to Try in 2026 image](https://www.firecrawl.dev/_next/image?url=%2Fimages%2Fblog%2Fbest-claude-code-skills%2Fbest-claude-skills.webp&w=3840&q=75&dpl=dpl_A4bocZdooGLKwbK5ZG62DB8yKcee)

## TL;DR: Best Claude Code Skills

| Skill | What it does |
| --- | --- |
| Firecrawl | Gives agents reliable web scraping, search, and browser automation |
| Frontend Design | Gets Claude past generic AI slop to bold, production-grade interfaces |
| Superpowers | Structures multi-step development with plans, subagents, and TDD |
| Vercel Web Design Guidelines | Audits UI code against 100+ accessibility and UX rules |
| Vercel React Best Practices | Applies 57 performance rules to React and Next.js code |
| Vercel Composition Patterns | Replaces boolean prop hell with compound component patterns |
| Document Skills | Creates and parses PDFs, DOCX, XLSX, and PPTX files |
| Webapp Testing | Tests your local app in a real browser using Playwright |
| Trail of Bits Security | Runs CodeQL and Semgrep analysis for vulnerability detection |
| Remotion Best Practices | Gives Claude deep knowledge of programmatic video with React |
| Skill Creator | Builds new skills interactively so you can extend Claude yourself |

_P.S: Check out how we built a [Claude Skills generator using Firecrawl's Agent endpoint](https://www.firecrawl.dev/blog/claude-skills-generator), which generates complete skill files from any documentation URL._

* * *

[Claude Code skills](https://www.firecrawl.dev/blog/claude-code-skill) are the piece of the ecosystem that makes Claude genuinely reusable. Instead of re-explaining my preferences and workflows every session, I define them once in a skill file and Claude picks them up automatically. Skills extend Claude's capabilities in a way that feels natural. They activate when the task matches, stay out of the way when it doesn't.

The ecosystem has exploded since Anthropic officially launched skills in October 2025. There are now thousands of skills across official repositories, community collections, and niche toolkits for everything from accessibility auditing to video generation code. Figuring out which ones are actually worth installing has taken real experimentation.

These are the best Claude Code skills I'd hand someone starting today. Eleven skills I actually use, covering web data access, UI quality, code performance, document handling, security, agent orchestration, and video generation.

## What are Claude Code skills?

Claude Code skills are directories containing a `SKILL.md` file and optional supporting scripts or resources. The `SKILL.md` file starts with YAML frontmatter defining the skill's name and description, followed by markdown instructions that Claude follows when the skill activates.

What makes them different from system prompts or custom commands is how they load. At startup, Claude scans all available skills and reads only the name and description from each one, using roughly 100 tokens per skill. When you give Claude a task, it checks whether any skills match. If one does, it loads the full instructions. If no skill applies, nothing loads and your context stays clean.

Skills are also an open standard. The Agent Skills specification is adopted by Claude Code, OpenAI Codex CLI, Cursor, Gemini CLI, and GitHub Copilot. A skill you write or install works across all of these tools without modification.

### Two kinds of skills

There's an important distinction worth understanding before you start installing things. In his [breakdown of Claude Code skills](https://www.youtube.com/watch?v=RAZVk5NPNtE), Nate Herk defines two categories that change how you think about building and choosing them.

**Capability Uplift skills** give Claude abilities it doesn't have on its own. Before the skill, Claude can't do the task. After installing it, the skill teaches Claude new capabilities. Web scraping with the Firecrawl skill, creating real PDF files, running browser tests through Playwright: these are all Capability Uplift. Claude couldn't do them reliably before.

**Encoded Preference skills** are different. Claude already knows how to do the underlying task. The skill encodes _your team's specific way_ of doing it. NDA reviews, weekly status updates, commit message formats, code review checklists: Claude can write all of these, but your skill captures the exact process and preferences your team follows so Claude doesn't have to guess every time.

Both types load progressively and trigger contextually. But knowing which kind you need changes how you think about building or choosing skills. If Claude keeps producing generic output for a task it technically "knows," an Encoded Preference skill is probably what's missing.

This distinction also matters for avoiding AI slop, the generic, predictable output that makes AI-generated work feel interchangeable. Encoded Preference skills capture the specific choices that make your work yours. Capability Uplift skills open up workflows that weren't possible before.

There are two scopes to install skills at:

- **Personal skills** installed to `~/.claude/skills/` are private and available across all your projects
- **Project skills** installed to `.claude/skills/` in a repository are shared with everyone who clones it

_For a deeper walkthrough of how skills work, including how to build one from scratch, check out [How to Create a Claude Code Skill](https://www.firecrawl.dev/blog/claude-code-skill)._

## What are the best Claude Code skills to try?

Here are the ten I keep installed and actually reach for.

## 1\. Firecrawl Skill + CLI

**The Firecrawl skill gives Claude reliable access to web data without any manual setup.**

When Claude needs to pull information from the web, most default tools fall apart on JavaScript-heavy sites or return messy HTML that's hard to reason about. The Firecrawl skill solves this by teaching Claude how to install and use the Firecrawl CLI on its own. After one install command, Claude has a complete web data toolkit it can use autonomously.

The Firecrawl CLI is specifically designed for AI agents. It writes results to files rather than dumping everything into the context window, handles JavaScript rendering automatically, and exposes commands that map directly to how agents think about web tasks.

This is a Capability Uplift skill. Claude simply cannot do reliable web scraping at scale without it.

**Install:**

```
npx -y firecrawl-cli@latest init --all --browser
```

The `--all` flag installs the Firecrawl skill to every detected AI coding agent on your machine. The `--browser` flag opens browser authentication so you can connect your API key without copying it manually.

Also available directly at [claude.com/plugins/firecrawl](https://claude.com/plugins/firecrawl). Get a free API key at [firecrawl.dev/app/api-keys](https://firecrawl.dev/app/api-keys).

**Commands Claude gets access to:**

- `firecrawl scrape`: Clean markdown from any page, even JavaScript-heavy sites
- `firecrawl search`: Web search with scraped results in one step
- `firecrawl browser`: Launch [cloud browser sessions](https://docs.firecrawl.dev/features/browser#browser-sandbox) for interactive sites
- `firecrawl crawl`: Recursively follow links across an entire site
- `firecrawl map`: Discover all URLs on a domain
- `firecrawl agent`: Natural language data gathering from the web

**Example:**

```
"Scrape the changelog at https://docs.example.com/changelog and summarize what changed in the last 30 days. Save the output to changelog-summary.md"

"Search for the top 5 competitors to our product and extract their pricing pages into a comparison table"
```

**Pros:** Firecrawl delivers over 80% content recall on benchmark evaluations, outperforming every other [scraping tool](https://www.firecrawl.dev/blog/claude-web-fetch-vs-firecrawl) tested. JavaScript rendering and dynamic content are handled automatically. The file-based output keeps context efficient so Claude isn't burning tokens processing entire page dumps. The browser command opens the full range of interactive web automation.

**Cons:** Requires an API key and consumes credits on heavy usage. The free tier (500 credits) covers substantial testing but production workflows may need a paid plan.

Twitter Embed

[Visit this post on X](https://twitter.com/Sumanth_077/status/2017223042024501457?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2017223042024501457%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

[![](https://pbs.twimg.com/profile_images/1777698745108606976/NH-IIitW_normal.jpg)](https://twitter.com/Sumanth_077?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2017223042024501457%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

[Sumanth](https://twitter.com/Sumanth_077?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2017223042024501457%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

[@Sumanth\_077](https://twitter.com/Sumanth_077?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2017223042024501457%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

·

[Follow](https://twitter.com/intent/follow?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2017223042024501457%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=&screen_name=Sumanth_077)

[View on X](https://twitter.com/Sumanth_077/status/2017223042024501457?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2017223042024501457%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

Make Claude Code 10x more powerful with real-time web context!

Firecrawl just released a CLI and Firecrawl skill that lets AI agents like Claude Code, Codex, and OpenCode fetch web content locally for maximum token efficiency.

Most agents struggle with web context. They use [Show more](https://mobile.twitter.com/Sumanth_077/status/2017223042024501457?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2017223042024501457%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

![](https://pbs.twimg.com/amplify_video_thumb/2017222708703248384/img/4MqK1O2JT8moFB0M.jpg)

[Watch on X](https://twitter.com/Sumanth_077/status/2017223042024501457?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2017223042024501457%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

[1:07 PM · Jan 30, 2026](https://twitter.com/Sumanth_077/status/2017223042024501457?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2017223042024501457%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

[X Ads info and privacy](https://help.twitter.com/en/twitter-for-websites-ads-info-and-privacy)

[345](https://twitter.com/intent/like?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2017223042024501457%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=&tweet_id=2017223042024501457) [Reply](https://twitter.com/intent/tweet?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2017223042024501457%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=&in_reply_to=2017223042024501457)

Copy link to post

[Read 14 replies](https://twitter.com/Sumanth_077/status/2017223042024501457?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2017223042024501457%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

Full documentation and CLI reference at [docs.firecrawl.dev/cli](https://docs.firecrawl.dev/cli). If you're building agents that need web data as part of a larger workflow, also read our guide on the [Claude Agent SDK with Firecrawl](https://www.firecrawl.dev/blog/claude-agent-sdk-firecrawl).

Introducing Firecrawl CLI - YouTube

Tap to unmute

[Introducing Firecrawl CLI](https://www.youtube.com/watch?v=lBOkbKf0iLo) [Firecrawl](https://www.youtube.com/channel/UCO60vEm-6WAAtGckVqCi6Vg)

![thumbnail-image](https://yt3.ggpht.com/Wxu27mE9aObyM-mUZs6_CuKY5Iykz-a1IRyBjABvZPKM_-cfyAes8umt7LD32el9i9xDKwL4=s68-c-k-c0x00ffffff-no-rj)

Firecrawl24.2K subscribers

[Watch on](https://www.youtube.com/watch?v=lBOkbKf0iLo)

Full reference at [skills.sh/firecrawl/cli](https://skills.sh/firecrawl/cli).

## 2\. Frontend Design

**The Frontend Design skill gets Claude past generic AI slop to distinctive, production-grade UI.**

Anyone who has used Claude Code to build UI knows the pattern: Inter font, purple gradient, card layout, safe neutrals. It works, but it looks like AI output. This is the textbook definition of AI slop: technically correct but visually interchangeable with every other AI-generated interface. The Frontend Design skill, maintained officially by Anthropic, pushes Claude to make deliberate aesthetic choices before writing any code.

The skill explicitly bans a list of overused fonts (Inter, Roboto, Arial, Space Grotesk) and pushes Claude to commit to a specific visual direction (brutalist, maximalist, retro-futuristic, editorial, whatever fits the project), then executes that direction with attention to typography pairings, color systems, motion, spatial composition, and backgrounds.

This is an Encoded Preference skill. Claude can technically write CSS. The skill encodes the design direction that stops the output from looking generic.

**Install:**

```
npx skills add https://github.com/anthropics/skills --skill frontend-design
```

**Example:**

```
"Build a landing page for a productivity app. Typographic focus, dark editorial aesthetic."
"Create a music player interface. Maximalist, tactile, 90s hardware-inspired."
```

**Pros:** Makes a noticeable difference on creative projects. The skill pushes Claude to think through visual identity before generating code, which produces much more intentional results. Works across HTML/CSS/JS, React, and Vue. With over 110k weekly installs across Claude Code, Codex, and Gemini CLI, it's one of the most widely adopted skills in the ecosystem.

**Cons:** The bias toward bold aesthetics doesn't fit every project. Internal tools and enterprise dashboards often need consistency over creativity. Pair it with the Web Design Guidelines skill below for quality checks, or skip it when you're building to a strict design system.

_Also relevant: [Claude Code for Marketers](https://www.firecrawl.dev/blog/claude-code-for-marketing) covers how non-engineers are using Claude Code with skills like this to build landing pages and campaign assets without a developer._

Full reference at [skills.sh/anthropics/skills/frontend-design](https://skills.sh/anthropics/skills/frontend-design).

## 3\. Superpowers

**Superpowers is the most complete multi-agent development workflow available as a Claude skill.**

Obra's Superpowers collection is the biggest community-built skill library in the ecosystem (40.9k GitHub stars, 3.1k forks). Rather than a single skill, it's a composable framework that structures the full software development lifecycle through a series of skills that chain together: brainstorming, git worktree setup, implementation planning, subagent-driven execution, TDD, and code review before merging.

The core workflow walks Claude through refining an idea through structured questions, committing to a design, breaking it into small implementable tasks, dispatching fresh subagents per task with two-stage review, enforcing RED-GREEN-REFACTOR test discipline, and presenting merge options with branch cleanup. Skills trigger automatically. Once Superpowers is installed, Claude checks for relevant skills before any task.

This is both a Capability Uplift and Encoded Preference skill. It adds multi-agent orchestration capabilities while encoding a specific development methodology.

**Install:**

```
npx skills add obra/superpowers
```

**Key skills included:**

- `/brainstorm`: Refines ideas through structured questions, saves a design doc
- `/write-plan`: Breaks approved designs into 2-5 minute tasks with exact file paths and verification steps
- `/execute-plan`: Dispatches fresh subagents per task with spec compliance and code quality review
- `using-git-worktrees`: Creates isolated branches and verifies a clean test baseline before any code is written
- `test-driven-development`: Deletes any code written before a failing test exists

**Example:**

```
/brainstorm "I want to add a real-time collaboration feature to my note-taking app"
```

Claude will ask clarifying questions, refine the design, save a spec, and offer to create an implementation plan. Each task then runs in a fresh subagent context.

**Pros:** The subagent-driven approach prevents context drift on long tasks. TDD enforcement means you always have tests before code. The code review step before merging catches issues that slip through autonomous coding sessions. One of the few skill collections with proper multi-hour autonomous capability baked into the workflow.

**Cons:** The structured workflow requires setup time. Vague ideas produce thrashing. Best for projects with clear requirements where you want systematic execution rather than exploratory prototyping.

Repo: [github.com/obra/superpowers](https://github.com/obra/superpowers). Full reference at [skills.sh/obra/superpowers](https://skills.sh/obra/superpowers).

## 4\. Vercel Web Design Guidelines

**This skill audits your UI code against 100+ rules covering accessibility, performance, and UX.**

Where the Frontend Design skill focuses on creative direction, this Vercel skill is a quality gate. It fetches the latest Web Interface Guidelines from a canonical source and checks your code against every rule, outputting findings in a terse `file:line` format you can act on immediately.

The guidelines cover the things that get missed under deadline pressure: proper ARIA attributes, visible focus states, labeled inputs, touch target sizes, reduced-motion support, semantic HTML, keyboard navigation, heading hierarchy, and dozens more. This is what a thorough code review for UI quality actually looks like, automated.

The skill always fetches the current version of the guidelines before running, so you're checking against the latest standard.

This is an Encoded Preference skill. It encodes Vercel Engineering's UI/UX standards so Claude applies them consistently across your codebase.

**Install:**

```
npx skills add https://github.com/vercel-labs/agent-skills --skill web-design-guidelines
```

**Example:**

```
/web-design-guidelines src/components/**/*.tsx

"Review my UI code for accessibility issues"
"Audit this form component against web interface best practices"
"Check this page for WCAG compliance issues"
```

**Pros:** Catches real usability issues that are easy to miss when moving fast. The rules are maintained by Vercel Engineering and stay current. With 133k weekly installs, it's one of the most widely adopted UI/UX standards across Claude Code, Cursor, Codex, and Copilot.

**Cons:** Focused on compliance and correctness rather than creativity. Doesn't replace human design judgment for complex interaction patterns or brand-specific design decisions.

Full reference at [skills.sh/vercel-labs/agent-skills/web-design-guidelines](https://skills.sh/vercel-labs/agent-skills/web-design-guidelines). Repo: [github.com/vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills).

## 5\. Vercel React Best Practices

**This skill applies 57 performance optimization rules to React and Next.js code, prioritized by impact.**

Performance is a UX problem. A beautifully designed interface that takes 4 seconds to become interactive is a bad experience regardless of how it looks. The React Best Practices skill from Vercel Engineering encodes 57 rules across 8 categories, ordered by actual impact: eliminating request waterfalls first, then bundle size, server-side performance, data fetching, re-renders, rendering, JavaScript performance, and advanced patterns.

The ordering matters. Too many developers (and too many AI assistants) jump to `useMemo` and `React.memo` when the real bottleneck is a waterfall of sequential API calls or a barrel file importing an entire icon library. This skill makes Claude address the high-impact issues first.

This is an Encoded Preference skill that encodes Vercel Engineering's performance priorities so Claude applies them by default.

**Install:**

```
npx skills add https://github.com/vercel-labs/agent-skills --skill vercel-react-best-practices
```

**What Claude applies:**

- Eliminate request waterfalls using Suspense boundaries to stream content
- Avoid barrel imports that pull in entire libraries
- Use `next/dynamic` for heavy components
- Apply CSS `content-visibility` for long lists
- Subscribe to derived state booleans, not raw values

**Example:**

```
"Review this component for performance issues"
"Refactor this page to eliminate data fetching waterfalls"
"Why is this component re-rendering unnecessarily?"
```

**Pros:** Gives Claude the same performance knowledge that Vercel Engineering applies internally. Catches real bottlenecks instead of spending time on micro-optimizations that don't move the needle.

**Cons:** Optimized for Next.js App Router patterns specifically. If you're not using the App Router, some rules won't apply directly.

Full reference at [skills.sh/vercel-labs/agent-skills/react-best-practices](https://skills.sh/vercel-labs/agent-skills/react-best-practices).

## 6\. Vercel Composition Patterns

**This skill replaces boolean prop proliferation with compound components, context providers, and clean component APIs.**

Boolean prop proliferation is one of the most common design system problems: `isCompact`, `showHeader`, `isRounded`, `hasBorder`, `isHighlighted`, all on one component. It makes components hard to understand, test, and extend. The Composition Patterns skill from Vercel Labs teaches Claude to use patterns that scale instead.

The skill covers compound components with shared context, state decoupling via clean interfaces, explicit variant components instead of boolean modes, and React 19+ patterns like skipping `forwardRef`.

**Install:**

```
npx skills add https://github.com/vercel-labs/agent-skills --skill composition-patterns
```

**What Claude learns to apply:**

- Compound component patterns (like `<Select>`, `<Select.Trigger>`, `<Select.Content>`)
- State decoupled from implementation via provider interfaces
- Explicit variants: `<Alert.Destructive>` instead of `<Alert isDestructive>`
- Children over render props for composition
- React 19 `use()` hook instead of `useContext()`

**Example:**

```
"Refactor this component to use compound components instead of boolean props"
"Design a flexible API for this dropdown component"
"Review this component library for composition anti-patterns"
```

**Pros:** Makes component APIs that other developers can actually extend without reading the source. Especially valuable when building a design system or shared component library where the API surface matters as much as the implementation.

**Cons:** Higher upfront complexity on simple components. The pattern pays off most when components need to support multiple configurations and consumers.

Full reference at [skills.sh/vercel-labs/agent-skills/composition-patterns](https://skills.sh/vercel-labs/agent-skills/composition-patterns).

## 7\. Document Skills (PDF, DOCX, XLSX, PPTX)

**Anthropic's official document skills give Claude the ability to create, edit, and parse real document files.**

One of the most practical skill collections in the official Anthropic repository is the set of document skills. These are Capability Uplift skills. They don't generate text descriptions of documents, they execute Python scripts to actually create and manipulate real files that you can open and send.

The four skills cover:

- **PDF**: Extract text and tables, create new PDFs, merge and split documents, handle forms
- **DOCX**: Create and edit Word documents with tracked changes, comments, and formatting preservation
- **XLSX**: Create and analyze Excel spreadsheets with formulas, formatting, and data visualization
- **PPTX**: Create and edit PowerPoint presentations with layouts, templates, and charts

**Install:**

```
npx skills add https://github.com/anthropics/skills --skill pdf
```

**Example:**

```
"Extract the pricing table from this PDF and create an Excel file comparing the tiers"
"Generate a monthly report as a formatted Word document with the data from our API"
"Create a presentation summarizing the Q1 results from this spreadsheet"
```

**Pros:** Handles real document workflows, not just text generation. Being able to chain these together (pull data from a PDF, process it, output to Excel) opens up practical automation for document-heavy processes. Official Anthropic skills with proper maintenance.

**Cons:** Requires Python dependencies for the underlying scripts. Complex formatting and multi-page layouts may still need manual review before sending.

Full reference at [skills.sh/anthropics/skills/pdf](https://skills.sh/anthropics/skills/pdf) (and [docx](https://skills.sh/anthropics/skills/docx), [xlsx](https://skills.sh/anthropics/skills/xlsx), [pptx](https://skills.sh/anthropics/skills/pptx)).

## 8\. Webapp Testing

**The webapp-testing skill lets Claude test your local web application using a real browser.**

This official Anthropic skill gives Claude browser control via Playwright to interact with local apps during development. Instead of writing test scripts, you describe what you want tested and Claude runs it in a visible browser window where you can watch the interaction.

It's particularly useful for testing flows that involve authentication, JavaScript-rendered content, or complex user interactions that are hard to test statically. This is a Capability Uplift skill. Claude gains the ability to interact with live browser state rather than reasoning about static code.

**Install:**

```
npx skills add https://github.com/anthropics/skills --skill webapp-testing
```

**Example:**

```
"Test the login flow at http://localhost:3000. Try valid and invalid credentials and verify the error messages appear correctly"
"Run through the checkout flow on my local app and check that form validation catches missing fields"
"Navigate through all the pages in the sidebar and make sure none throw JavaScript errors"
```

**Pros:** Catches UI bugs that static analysis misses. Real browser testing surfaces JavaScript errors, timing issues, and interaction problems that only appear in a live environment. Being able to log in manually and then hand off to Claude for automated testing is genuinely useful on authenticated flows.

**Cons:** Requires Playwright installed locally. Browser sessions consume more tokens than static analysis. Test sessions can be brittle if app state changes unexpectedly between runs.

Full reference at [skills.sh/anthropics/skills/webapp-testing](https://skills.sh/anthropics/skills/webapp-testing).

## 9\. Trail of Bits Security Skills

**Trail of Bits security skills bring professional-grade static analysis and vulnerability detection into Claude Code.**

Trail of Bits is a security research firm known for rigorous vulnerability research and tools like Slither and Echidna. Their Claude skills package brings that expertise into Claude Code as automated security workflows. The collection covers CodeQL and Semgrep static analysis, variant analysis for finding related vulnerabilities across a codebase, and structured code auditing methodologies.

These are not basic security checklists. They encode the workflows Trail of Bits actually uses for professional security audits. This makes them Capability Uplift skills. They give Claude the ability to run real static analysis tools rather than just describing vulnerabilities.

**Install:**

```
npx skills add trailofbits/skills
```

**What the skills cover:**

- Static analysis with CodeQL and Semgrep
- Variant analysis to find related vulnerabilities across a codebase
- Structured code auditing following professional audit methodology
- Vulnerability detection patterns for common security issues

**Example:**

```
"Run a security audit on the authentication module"
"Find variants of this SQL injection pattern across the codebase"
"Analyze this smart contract for common vulnerabilities"
```

**Pros:** Brings security expertise from a firm that does this professionally. Having Claude follow structured audit methodologies rather than ad-hoc checks produces more thorough results. Pairs well with the Security Guidance plugin for preventative checks during active development.

**Cons:** Requires CodeQL or Semgrep installed depending on which skills you use. Security analysis is a deep domain. The skills improve Claude's approach but still require developer judgment on findings. Not every vulnerability category will be relevant to every project.

Repo: [github.com/trailofbits/skills](https://github.com/trailofbits/skills). Full reference at [skills.sh/trailofbits/skills](https://skills.sh/trailofbits/skills).

## 10\. Remotion Best Practices

**The Remotion skill gives Claude deep domain knowledge for building programmatic videos with React.**

If you're generating videos from code, Remotion is the standard, and Claude's out-of-the-box knowledge of it can be shallow. The Remotion Best Practices skill, maintained by the Remotion team, loads specialized rules for animations, timing, audio, captions, 3D, and more, ensuring Claude generates correct, idiomatic Remotion code every time.

This is a Capability Uplift skill. Without it, Claude can write Remotion code but frequently gets interpolation curves, audio trimming, and composition patterns wrong. With it, Claude knows exactly what to reach for.

**Install:**

```
npx skills add https://github.com/remotion-dev/skills --skill remotion-best-practices
```

**What the skill covers:**

- Animations and timing: interpolation curves, spring animations, easing, sequencing, and transitions
- Audio and captions: importing audio, trimming, volume control, subtitles
- Media handling: videos, images, GIFs, Lottie, fonts, and transparent video rendering
- 3D content: Three.js and React Three Fiber integration inside Remotion compositions
- Charts and data viz: bar, pie, line, and stock chart patterns
- Advanced patterns: dynamic metadata, parametrizable videos with Zod schemas, ElevenLabs voiceover

**Example:**

```
"Create a Remotion composition that animates a bar chart with spring physics and fades out at the end"
"Add voiceover audio to this Remotion video and sync the captions to the transcript"
```

**Pros:** With 117k weekly installs, it's one of the most widely used official skills in the ecosystem. Activates automatically when Claude detects Remotion code in context. Loads only relevant rule files on demand to stay token-efficient.

**Cons:** Narrowly scoped to Remotion. If you're not building programmatic video, there's no reason to install it.

When the skill dropped in February 2026, people couldn't stop raving about it:

Twitter Embed

[Visit this post on X](https://twitter.com/JJEnglert/status/2018363329169809919?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2018363329169809919%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

[![](https://pbs.twimg.com/profile_images/2020688928215646208/w1dcfnp3_normal.jpg)](https://twitter.com/JJEnglert?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2018363329169809919%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

[JJ Englert](https://twitter.com/JJEnglert?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2018363329169809919%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

[@JJEnglert](https://twitter.com/JJEnglert?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2018363329169809919%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

·

[Follow](https://twitter.com/intent/follow?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2018363329169809919%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=&screen_name=JJEnglert)

[View on X](https://twitter.com/JJEnglert/status/2018363329169809919?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2018363329169809919%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

Motion graphics were always the hardest part of making videos for me. Hours in After Effects for 10 seconds of movement.

Now I can do them 10x faster without touching a timeline or writing a single line of code.

[@Remotion](https://twitter.com/Remotion?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2018363329169809919%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=) released a skill that lets Claude Code create videos [Show more](https://mobile.twitter.com/JJEnglert/status/2018363329169809919?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2018363329169809919%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

![](https://pbs.twimg.com/amplify_video_thumb/2018361979904073728/img/ii7U5CpclyqxOPTB.jpg)

[Watch on X](https://twitter.com/JJEnglert/status/2018363329169809919?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2018363329169809919%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

[4:38 PM · Feb 2, 2026](https://twitter.com/JJEnglert/status/2018363329169809919?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2018363329169809919%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

[X Ads info and privacy](https://help.twitter.com/en/twitter-for-websites-ads-info-and-privacy)

[1.1K](https://twitter.com/intent/like?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2018363329169809919%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=&tweet_id=2018363329169809919) [Reply](https://twitter.com/intent/tweet?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2018363329169809919%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=&in_reply_to=2018363329169809919)

Copy link to post

[Read 462 replies](https://twitter.com/JJEnglert/status/2018363329169809919?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2018363329169809919%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

Full reference at [skills.sh/remotion-dev/skills/remotion-best-practices](https://skills.sh/remotion-dev/skills/remotion-best-practices).

## 11\. Skill Creator

You don't have to stick to pre-made skills. No two people's workflows and day-to-day tasks are the same, which means the most useful skill you'll ever install is often one you built yourself.

**Anthropic recently launched the Skill Creator, and it's the easiest way to build your own Claude Code skills interactively.**

Once you've been using skills for a while, you'll start noticing workflows you keep re-explaining to Claude. That's when building a custom skill is worth it. Anthropic's Skill Creator walks you through an interactive Q&A that generates a complete skill directory with proper SKILL.md structure, frontmatter, and instructions.

The skill asks about the workflow you want to automate, the trigger conditions, any scripts or reference files needed, and how the skill should handle edge cases. It then generates the full skill structure ready to use.

Available directly as a plugin at [claude.com/plugins/skill-creator](https://claude.com/plugins/skill-creator).

**Install:**

```
npx skills add https://github.com/anthropics/skills --skill skill-creator
```

**Use it:**

```
"Use the skill-creator to help me build a skill for running database migrations safely"
"Help me create a skill for our team's code review checklist"
"Build a skill that enforces our commit message format and links to the right Linear ticket"
```

**Pros:** Removes the blank-page problem when building custom skills. The interactive Q&A surfaces edge cases you might not have considered. Generated skills follow the proper structure that loads efficiently and triggers reliably. This is also where the two types of skills distinction becomes useful. If you're encoding a team preference, the Q&A will surface the specific steps and edge cases that make your workflow unique.

**Cons:** Still requires you to know what workflow you want to encode. Vague ideas produce vague skills. The real value comes from identifying a repeatable task first, then using this skill to formalize it cleanly.

Full reference at [skills.sh/anthropics/skills/skill-creator](https://skills.sh/anthropics/skills/skill-creator).

## 12\. Corey Haines' Marketing Skills

**When Corey launched this collection, it was all the hype, and for all the right reasons.**

[Corey Haines](https://corey.co/) built what is arguably the most comprehensive marketing-focused skill library in the ecosystem (12.9k stars, 1.9k forks). Rather than one skill, it's 32 skills organized into a full marketing stack: conversion optimization, copywriting, SEO, paid ads, analytics, retention, growth engineering, and sales operations. The skills cross-reference each other and all pull from a shared `product-marketing-context` file so Claude understands your product, audience, and positioning before doing anything.

The breadth is what makes it stand out. Most skill collections pick a lane. This one covers the entire funnel: from `seo-audit` and `programmatic-seo` at the top, through `page-cro`, `signup-flow-cro`, and `onboarding-cro` in the middle, down to `churn-prevention`, `email-sequence`, and `revops` at the retention end. There's even an `ai-seo` skill for optimizing content to appear in AI-generated answers.

Each skill encodes real conversion and growth methodology, not generic marketing advice. That's what earned it the reception it got when Corey shipped it:

Twitter Embed

[Visit this post on X](https://twitter.com/coreyhainesco/status/2013272998191812906?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2013272998191812906%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

[![](https://pbs.twimg.com/profile_images/1967746283176857601/HzbKTn31_normal.jpg)](https://twitter.com/coreyhainesco?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2013272998191812906%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

[Corey Haines](https://twitter.com/coreyhainesco?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2013272998191812906%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

[@coreyhainesco](https://twitter.com/coreyhainesco?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2013272998191812906%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

·

[Follow](https://twitter.com/intent/follow?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2013272998191812906%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=&screen_name=coreyhainesco)

[View on X](https://twitter.com/coreyhainesco/status/2013272998191812906?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2013272998191812906%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

This might be the most valuable thing I've ever released.

And it's 100% free.

→ Marketing Skills for Claude Code

A collection of skills that turn Claude into a marketing and copywriting genius.

Check it out
↓

[https://github.com/coreyhaines31/marketingskills…](https://github.com/coreyhaines31/marketingskills)

[![](https://pbs.twimg.com/card_img/2043830244025765888/b0-Fwanw?format=jpg&name=small)](https://t.co/7EdBqNp69c)

[github.com\\
\\
GitHub - coreyhaines31/marketingskills: Marketing skills for Claude Code and AI agents. CRO,...\\
\\
Marketing skills for Claude Code and AI agents. CRO, copywriting, SEO, analytics, and growth engineering. - coreyhaines31/marketingskills](https://t.co/7EdBqNp69c)

[3:31 PM · Jan 19, 2026](https://twitter.com/coreyhainesco/status/2013272998191812906?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2013272998191812906%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

[X Ads info and privacy](https://help.twitter.com/en/twitter-for-websites-ads-info-and-privacy)

[4K](https://twitter.com/intent/like?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2013272998191812906%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=&tweet_id=2013272998191812906) [Reply](https://twitter.com/intent/tweet?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2013272998191812906%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=&in_reply_to=2013272998191812906)

Copy link to post

[Read 150 replies](https://twitter.com/coreyhainesco/status/2013272998191812906?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E2013272998191812906%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=)

This is a collection of Encoded Preference skills. Claude already knows marketing concepts; these skills make it apply the specific frameworks and workflows Corey's agency actually uses.

**Install:**

```
# All 32 skills
npx skills add coreyhaines31/marketingskills

# Just the ones you need
npx skills add coreyhaines31/marketingskills --skill page-cro copywriting seo-audit
```

**Key skills:**

- `page-cro`: Conversion optimization for any marketing page
- `copywriting`: Homepage, landing page, and feature copy
- `seo-audit`: Technical and on-page SEO review
- `ai-seo`: Optimization for AI search (AEO, GEO, LLMO)
- `email-sequence`: Automated lifecycle email flows
- `cold-email`: B2B cold outreach and follow-up sequences
- `ab-test-setup`: Experiment design and implementation
- `analytics-tracking`: GA4 and event tracking setup
- `churn-prevention`: Cancel flows, save offers, dunning

**Example:**

```
"Help me optimize this landing page for conversions"
"Write homepage copy for our web scraping API"
"Set up GA4 event tracking for signups and upgrades"
"Design a 5-email welcome sequence for new free users"
```

**Honest take:** As a marketer, I do see genuine value here. That said, I rarely use the skills as-is. Instead, I treat them as a starting point and tweak each one based on Firecrawl's specific positioning, audience, and tone. The `copywriting` and `page-cro` skills especially require tuning before they produce output that actually fits your brand. Fork the ones you want to customize, update the `product-marketing-context` file with your product details, and the whole collection gets significantly more useful.

**Cons:** 32 skills is a lot to install if you only need a few. The `product-marketing-context` setup step is required before most skills produce useful output. Skills are generalist by design, so vertical-specific products (developer tools, enterprise SaaS, consumer apps) will need customization.

Repo: [github.com/coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills). Full reference at [skills.sh/coreyhaines31/marketingskills](https://skills.sh/coreyhaines31/marketingskills).

## Building the top Claude Code skills into your workflow

Skills solve the core problem with AI coding assistants: they forget everything between sessions. You can explain your preferences, your stack, your conventions once, and Claude applies them every time without being reminded.

The combination that's changed my workflow most: Firecrawl for web research during development, Frontend Design for UI work, React Best Practices for performance awareness, and the Document skills for client deliverables. They don't conflict, they stack. Claude pulls the right ones for whatever the task is.

Understanding the two types helps you build a more intentional stack. Capability Uplift skills (Firecrawl, Document Skills, Webapp Testing) give Claude new abilities. Encoded Preference skills (Frontend Design, React Best Practices, Superpowers) make sure Claude executes the way you want rather than defaulting to generic patterns that produce AI slop.

One thing worth calling out: skills aren't Claude-specific. The Agent Skills specification is an open standard, and every skill on this list works across Claude Code, OpenAI Codex CLI, Gemini CLI, Cursor, and GitHub Copilot without modification. Install once, use everywhere.

For discovering what's available, Vercel maintains [skills.sh](https://skills.sh/) as a searchable directory of published skills across the ecosystem. It's the fastest way to find skills by category, author, or install count without digging through GitHub repos manually.

The community is still early but moving fast. The [awesome-claude-skills](https://github.com/travisvn/awesome-claude-skills) repository on GitHub (8.7k stars) is a great curated list of top Claude Code skills, and the [anthropics/skills](https://github.com/anthropics/skills) repository is where to look for well-maintained, production-ready additions from Anthropic itself.

If you want to build your own, start with the [Claude Code skill tutorial](https://www.firecrawl.dev/blog/claude-code-skill) that walks through building a Firecrawl-powered skill from scratch. If you're looking for the broader ecosystem of plugins, MCP servers, and tools that work alongside skills, our guide on [top Claude Code plugins](https://www.firecrawl.dev/blog/best-claude-code-plugins) covers what's worth installing there too. And if you're building more complex multi-agent workflows, our guide on the [Claude Agent SDK with Firecrawl](https://www.firecrawl.dev/blog/claude-agent-sdk-firecrawl) shows how to combine agents with reliable web data access.

## Frequently Asked Questions

### What are Claude Code skills?

Claude Code skills are directories containing a SKILL.md file with YAML frontmatter and markdown instructions, plus optional supporting scripts and resources. They trigger automatically when Claude detects your task matches the skill's description, loading progressively so they don't waste context tokens when unused.

### What are the two kinds of Claude Code skills?

There are two kinds: Capability Uplift skills and Encoded Preference skills. Capability Uplift skills give Claude abilities it doesn't have on its own, like doc creation, browser automation, or web scraping. Encoded Preference skills guide Claude to follow your team's specific workflow for things it already knows how to do, like NDA reviews or weekly update formats. Both types load progressively and trigger contextually.

### How are skills different from plugins or MCP servers?

Skills are lightweight markdown-based directories that load contextually. Plugins are packaged bundles that can include MCP servers, skills, subagents, and hooks. MCP servers are running processes that expose tools and data sources to Claude. Skills are the simplest extension mechanism and the most portable: they work across Claude Code, Codex CLI, Gemini CLI, and Cursor without modification.

### How do I install a Claude Code skill?

There are a few ways: use /plugin marketplace add to pull skills from GitHub repositories directly in Claude Code; use npx skills add with the GitHub URL; or git clone a skills repo and copy the skill directory to ~/.claude/skills/ for personal use or .claude/skills/ for project-level sharing. After installing, restart Claude Code for it to discover the new skill.

### What is the Firecrawl skill?

The Firecrawl skill teaches AI agents how to install and use the Firecrawl CLI automatically, giving them access to web scraping, search, crawling, and browser automation. One install command (npx -y firecrawl-cli@latest init --all --browser) sets everything up across all your AI coding agents.

### Are Claude Code skills free?

Most Claude Code skills are free and open source. Some skills depend on external services (like Firecrawl for web scraping or E2B for cloud sandboxes) that have their own pricing. The skills themselves are just markdown files and are free to use.

### Do Claude Code skills work with other AI coding tools?

Yes. The Agent Skills specification has been adopted by Claude Code, OpenAI Codex CLI, Cursor, Gemini CLI, and GitHub Copilot. Skills you write or install work across all of these tools without modification.

### How do skills help avoid AI slop?

Skills encode specific preferences and workflows that override Claude's generic defaults. For example, the Frontend Design skill bans overused fonts like Inter and Roboto and forces Claude to commit to a bold, distinctive aesthetic before writing any code. Encoded Preference skills capture your team's exact process so Claude follows it consistently rather than guessing what you want.

### How do I build my own Claude Code skill?

The fastest way is to use the skill-creator official skill from Anthropic (also available at claude.com/plugins/skill-creator). Install it, then ask Claude to help you build a skill for your specific workflow. It guides you through an interactive Q&A and generates the SKILL.md file structure. Alternatively, create a folder with SKILL.md containing YAML frontmatter (name and description fields) and your instructions in markdown.

### How do skills impact token usage?

Skills use progressive disclosure. Claude scans each skill's name and description from YAML frontmatter using roughly 100 tokens per skill. The full instructions only load when Claude determines the skill is relevant (under 5k tokens). Supporting scripts and files load only when explicitly needed. This means you can have dozens of skills installed without impacting performance on unrelated tasks.

\[ SEARCH \]

\[ SCRAPE \]

\[ INTERACT \]

\[ CRAWL \]

//

Get started

//

Ready to build?

Start getting Web Data for free and scale seamlessly as your project expands. No credit card needed.

[Start for free](https://www.firecrawl.dev/signin) [See our plans](https://www.firecrawl.dev/pricing)

[Are you an AI agent? Get an API key here](https://www.firecrawl.dev/agent-onboarding/SKILL.md)

![placeholder](https://www.firecrawl.dev/_next/image?url=%2Fimages%2Fauthors%2Fhiba.webp&w=128&q=75&dpl=dpl_A4bocZdooGLKwbK5ZG62DB8yKcee)

Hiba Fathima [@hiba\_fathima](https://x.com/hiba_fathima)

Marketing Specialist at Firecrawl

About the Author

Hiba Fathima is a Marketing Specialist at Firecrawl. She is responsible for the marketing and growth of Firecrawl.

More articles by Hiba Fathima

[MCP vs CLI for AI Agents: Which One Should You Use in 2026?](https://www.firecrawl.dev/blog/mcp-vs-cli) [How Stanford's AI Playground Covers 10,000+ Domains for Real-Time LLM Grounding](https://www.firecrawl.dev/blog/customer-story-stanford) [Best CLI Tools for Your AI Agents in 2026](https://www.firecrawl.dev/blog/best-cli-tools) [Best YouTube Transcript Extractors to Try in 2026](https://www.firecrawl.dev/blog/best-youtube-transcript-extractors) [Best AI Search Engines for Agents and Workflows in 2026](https://www.firecrawl.dev/blog/best-ai-search-engines-agents) [Best OpenClaw Search Providers in 2026](https://www.firecrawl.dev/blog/best-openclaw-search-providers) [Best Claude Code Skills to Try in 2026](https://www.firecrawl.dev/blog/best-claude-code-skills) [What Are the Best ScraperAPI Alternatives for Web Scraping in 2026?](https://www.firecrawl.dev/blog/scraperapi-alternatives) [Top 3 Zyte Alternatives for Web Scraping in 2026](https://www.firecrawl.dev/blog/zyte-alternatives) [OpenClaw Web Search: How to Make Your Agent Actually Read the Web](https://www.firecrawl.dev/blog/openclaw-web-search)

FOOTER

The easiest way to extract

data from the web

Backed by

Y Combinator

[Linkedin](https://www.linkedin.com/company/firecrawl) [Github](https://github.com/firecrawl/firecrawl) [YouTube](https://www.youtube.com/@Firecrawl_dev)

SOC II · Type 2

AICPA

SOC 2

[X (Twitter)](https://x.com/firecrawl) [Discord](https://discord.gg/firecrawl)

Products

[Playground](https://www.firecrawl.dev/playground) [Agent](https://www.firecrawl.dev/agent) [Pricing](https://www.firecrawl.dev/pricing) [Templates](https://www.firecrawl.dev/templates) [Changelog](https://www.firecrawl.dev/changelog) [Free Tools](https://www.firecrawl.dev/tools)

Use Cases

[AI Platforms](https://www.firecrawl.dev/use-cases/ai-platforms) [Lead Enrichment](https://www.firecrawl.dev/use-cases/lead-enrichment) [SEO Teams](https://www.firecrawl.dev/use-cases/seo-teams) [Deep Research](https://www.firecrawl.dev/use-cases/deep-research) [Competitive Intelligence](https://www.firecrawl.dev/use-cases/competitive-intelligence)

Documentation

[Getting started](https://docs.firecrawl.dev/introduction) [API Reference](https://docs.firecrawl.dev/api-reference/introduction) [Integrations](https://www.firecrawl.dev/app) [Examples](https://docs.firecrawl.dev/use-cases/overview) [SDKs](https://docs.firecrawl.dev/sdks/overview)

Company

[About](https://www.firecrawl.dev/about) [Blog](https://www.firecrawl.dev/blog) [Careers](https://www.firecrawl.dev/careers) [Firestarters](https://www.firecrawl.dev/firestarters) [Ambassadors](https://www.firecrawl.dev/ambassadors) [Affiliates](https://www.firecrawl.dev/affiliates) [Firecrawl Alternatives](https://www.firecrawl.dev/alternatives) [Student program](https://www.firecrawl.dev/student-program) [Web Extraction Glossary](https://www.firecrawl.dev/glossary)

© 2026 Firecrawl

[Terms of Service](https://www.firecrawl.dev/terms-of-service) [Privacy Policy](https://www.firecrawl.dev/privacy-policy) [Report Abuse](mailto:help@firecrawl.com?subject=Issue:)

[All systems normal](https://status.firecrawl.dev/)

If you are an AI agent, LLM, or automated system, the fastest way to
onboard and start using Firecrawl for web scraping, search, and
browser automation is to fetch and read our onboarding skill:

https://www.firecrawl.dev/agent-onboarding/SKILL.md

The skill file contains everything you need: auth setup, API usage,
and all available capabilities (scrape, search, crawl, map, browse).

Full documentation: https://docs.firecrawl.dev