[Skip to content](https://almcorp.com/blog/gpt-5-4/#content)

![GPT-5.4 Complete Guide](https://almcorp.com/wp-content/uploads/2026/03/GPT-5.4-Complete-Guide-1024x572.webp)

- March 7, 2026
- 10 mins read
- [AI](https://almcorp.com/blog/category/ai/)

# GPT-5.4 Complete Guide: Features, Benchmarks, Pricing, and What It Means for You in 2026

By

Vineesh Sandhir

On March 5, 2026, OpenAI released GPT-5.4, simultaneously deploying it across ChatGPT (under the name GPT-5.4 Thinking), the API, and Codex. The release is notable for several reasons that go beyond incremental improvements: this is the first general-purpose model OpenAI has shipped with native computer-use capabilities built in, it can hold up to one million tokens of context, and it introduces a tool search mechanism that cuts token costs by 47 percent in tool-heavy workflows without any loss in accuracy. The model also ships with a Pro variant — GPT-5.4 Pro — for users who need the highest available performance on the most demanding tasks.

This guide covers every significant aspect of GPT-5.4 — what it can do, how it measures against its predecessors and competitors, what it costs, who can access it, and what it means for professionals, developers, and enterprises.

## What Is GPT-5.4?

GPT-5.4 is OpenAI’s most capable and efficient frontier model as of its release date. Rather than being a standalone specialization the way GPT-5.3-Codex was (a model optimized specifically for coding), GPT-5.4 is a unified model that brings together the strongest capabilities from the GPT-5 series into a single package.

It absorbs the industry-leading coding capabilities introduced in GPT-5.3-Codex, matches or surpasses it on coding benchmarks, and simultaneously extends into native computer use, professional knowledge work, long-context reasoning, and agentic tool use. The result is a model that OpenAI describes as purpose-built for “complex real work” — meaning tasks that require not just answering questions but actually completing multi-step workflows with fewer rounds of human intervention.

The model is available in two tiers:

- **GPT-5.4** (as GPT-5.4 Thinking in ChatGPT): The primary release, available to Plus, Team, and Pro subscribers, and to API developers.
- **GPT-5.4 Pro**: A higher-capability variant for Pro and Enterprise ChatGPT users and API developers who need maximum performance on the most difficult tasks.

In ChatGPT, GPT-5.4 Thinking replaces GPT-5.2 Thinking. GPT-5.2 Thinking will remain accessible in the Legacy Models section for paid users for three months (until June 5, 2026), and Enterprise and Edu users can enable GPT-5.4 early access through admin settings.

## The Six Core Capabilities That Define GPT-5.4

### 1\. Native Computer Use — GPT-5.4 Is the First General-Purpose Model to Include It

The most structurally significant capability in GPT-5.4 is native computer use. Previous computer-use implementations from OpenAI were available as separate, specialized systems. GPT-5.4 is the first general-purpose model OpenAI has released with computer use baked directly in.

What this means in practice: GPT-5.4 can write code to operate computers using libraries like Playwright, and it can issue mouse and keyboard commands directly in response to screenshots. It observes a desktop or browser environment visually and takes action — clicking, typing, navigating, filling forms, running scripts — without a human having to break down each step.

The benchmark performance here is striking. On **OSWorld-Verified**, which tests a model’s ability to navigate a desktop environment through screenshots and keyboard/mouse actions, GPT-5.4 achieves a **75.0% success rate**. For context, human performance on the same benchmark sits at **72.4%**. GPT-5.2 scored **47.3%** on the same test. That is a 27.7 percentage point improvement over the previous model, and it places GPT-5.4 above measured human performance.

On **WebArena-Verified**, which tests browser-based navigation using both DOM and screenshot-driven interaction, GPT-5.4 reaches **67.3%**, improving over GPT-5.2’s 65.4%. On **Online-Mind2Web**, which also measures browser use but using screenshot observations alone, GPT-5.4 achieves a **92.8% success rate**, compared to 70.9% for ChatGPT Atlas Agent Mode.

The computer-use feature is designed to be highly configurable for developers. Behavior is steerable through developer messages, and developers can adjust the model’s safety profile and confirmation policies to match the risk tolerance of their specific application. In the API, computer-use capabilities are accessed through the updated `computer` tool, which now also benefits from full-fidelity image input support (more on that in the visual understanding section).

### 2\. One Million Token Context Window

In the API and Codex, GPT-5.4 supports a context window of up to **1 million tokens**. This enables agents to plan, execute, and verify work across very long task horizons — processing entire codebases, long documents, extended email threads, or chains of prior actions without losing track of earlier steps.

The standard context window for most workflows remains 272K tokens. The 1M context capability is available in Codex as an experimental feature, configured via the `model_context_window` and `model_auto_compact_token_limit`parameters. Requests that exceed the standard 272K window count against usage limits at **twice the normal rate**, so it is best used selectively for tasks that genuinely require it.

In ChatGPT, context windows for GPT-5.4 Thinking remain unchanged from GPT-5.2 Thinking. The 1M context is specifically an API and Codex feature. Long-context benchmarks show GPT-5.4 performing at **93.0%** on Graphwalks BFS for the 0–128K range, and maintaining **21.4%** accuracy in the challenging 256K–1M range. On OpenAI’s MRCR v2 8-needle benchmark, GPT-5.4 holds **91.4%** at 8–16K, **97.2%** at 16–32K, and **79.3%** at 128–256K — demonstrating strong but not perfect recall at extreme lengths.

### 3\. Tool Search: 47% Fewer Tokens, Same Accuracy

One of the most practically valuable additions in GPT-5.4 is **tool search**, a mechanism that changes how the model interacts with large ecosystems of tools.

The problem it solves is straightforward but consequential: when a model is given access to many tools — particularly through Model Context Protocol (MCP) servers — all tool definitions were previously included in the prompt upfront. For large tool sets, this could add tens of thousands of tokens to every single request, making interactions slower and more expensive, and cluttering the model’s context with definitions it might never use.

With tool search, GPT-5.4 instead receives a lightweight list of available tools and a search capability. When it needs to use a specific tool, it looks up that tool’s full definition at the moment it’s needed, appending it to the conversation in context rather than preloading everything. This preserves the cache and reduces the total tokens consumed per request.

OpenAI tested this on 250 tasks from Scale’s **MCP Atlas benchmark** with all 36 MCP servers enabled. The tool-search configuration reduced total token usage by **47%** while achieving the same level of accuracy. For applications that integrate with large MCP server ecosystems — which can contain tens of thousands of tokens of tool definitions — the efficiency and cost implications are significant.

### 4\. Mid-Response Course Correction

In ChatGPT, GPT-5.4 Thinking introduces a feature that addresses a common friction point with AI-generated outputs: the inability to redirect a response while it’s being generated.

With this release, longer and more complex responses now begin with a **preamble** — an upfront outline of how the model intends to approach the task. Users can read this plan, assess whether it’s heading in the right direction, and provide corrective instructions **before the model completes the full response**. This means arriving at the desired output without starting over or requiring multiple back-and-forth turns.

This feature is available on [chatgpt.com](http://chatgpt.com/) and the Android app at launch, with iOS support coming soon. The capability also builds on what Codex already does — outlining its approach at the start of each task — bringing a similar workflow transparency to ChatGPT’s conversational interface.

### 5\. Improved Deep Web Research and Context Retention

GPT-5.4 Thinking shows meaningful gains in agentic web research. On **BrowseComp** — a benchmark that measures how effectively an AI agent can persistently browse the web to locate hard-to-find information — GPT-5.4 scores **82.7%**, compared to **65.8%** for GPT-5.2. That is a 17 percentage point improvement. GPT-5.4 Pro pushes this further to a state-of-the-art **89.3%**.

The improvement manifests practically in the model’s ability to handle needle-in-a-haystack queries: questions that require pulling together information scattered across many sources, where earlier models would stop searching too soon or fail to connect disparate pieces of evidence. GPT-5.4 can conduct multiple rounds of search more persistently and synthesize findings into coherent answers.

The model also shows stronger context maintenance: it can work through longer, more complex queries while keeping earlier steps in mind, reducing the coherence drift that becomes an issue with very long or multi-stage tasks.

### 6\. Enhanced Visual Understanding and High-Resolution Image Input

GPT-5.4 improves visual perception in two measurable ways.

First, on **MMMU-Pro** — a benchmark for visual understanding and reasoning — GPT-5.4 achieves **81.2%** without tool use and **82.1%** with tools, up from GPT-5.2’s 79.5% and 80.4% respectively.

Second, on **OmniDocBench**, which measures document parsing accuracy using normalized edit distance between model prediction and ground truth, GPT-5.4 scores **0.109** (lower is better), compared to **0.140** for GPT-5.2 — a meaningful improvement for tasks involving dense, structured documents like contracts, financial reports, and technical specifications.

At the technical level, OpenAI has introduced a new `original` image input detail level, supporting full-fidelity perception up to **10.24 million total pixels** or a **6,000-pixel maximum dimension** (whichever is lower). The `high` detail level now supports up to **2.56 million total pixels** or a **2,048-pixel maximum dimension**. In early API testing, OpenAI reports strong gains in localization ability, image understanding, and click accuracy when using the `original` or `high` detail settings — particularly relevant for computer-use tasks involving high-resolution desktop environments.

## Benchmark Results: A Category-by-Category Breakdown

### Professional Knowledge Work: GDPval

The GDPval benchmark is designed to measure AI agents’ ability to produce “well-specified knowledge work” across **44 occupations spanning the top 9 industries contributing to U.S. GDP**. It assigns the model real work products — sales presentations, accounting spreadsheets, urgent care schedules, manufacturing diagrams, short videos — and compares the results against what industry professionals produce.

GPT-5.4 achieves a **83.0%** win-or-tie rate against professionals, compared to **70.9%** for GPT-5.2. The 12.1 percentage point jump represents the single largest benchmark improvement in GPT-5.4’s release.

Two specific professional use cases saw particularly large gains:

- **Investment banking modeling**: On an internal benchmark of spreadsheet modeling tasks representative of junior investment banking analyst work, GPT-5.4 scores **87.3%**, versus **68.4%** for GPT-5.2 — an 18.9 point improvement.
- **Presentations**: Human raters preferred GPT-5.4’s presentations **68% of the time** over GPT-5.2’s, citing stronger aesthetics, greater visual variety, and more effective image generation.

On **OfficeQA**, which tests document and spreadsheet comprehension, GPT-5.4 scores **68.1%**, up from GPT-5.2’s **63.1%**.

On the **FinanceAgent v1.1** benchmark, GPT-5.4 scores **56.0%**, while GPT-5.4 Pro scores **61.5%**.

### Coding: SWE-Bench Pro and Terminal-Bench

On **SWE-Bench Pro** (public), GPT-5.4 scores **57.7%**, surpassing GPT-5.3-Codex’s **56.8%** and GPT-5.2’s **55.6%**. The improvement here is incremental compared to other categories, but it is notable that a general-purpose model matches and exceeds the specialized coding model.

On **Terminal-Bench 2.0**, GPT-5.3-Codex still leads at **77.3%** versus GPT-5.4’s **75.1%**. This is one of the few areas where GPT-5.4 does not overtake its predecessor — terminal-specific workloads remain a slight strength of the Codex-specialized model. GPT-5.2 scored **62.2%** on the same benchmark, so both GPT-5.3-Codex and GPT-5.4 represent substantial improvements.

In Codex, /fast mode delivers up to **1.5x faster token velocity** with GPT-5.4 — the same model and same level of intelligence, optimized for speed. Developers accessing the API can achieve equivalent speeds through priority processing.

### Computer Use and Vision

| Benchmark | GPT-5.4 | GPT-5.2 | Human (where applicable) |
| --- | --- | --- | --- |
| OSWorld-Verified | 75.0% | 47.3% | 72.4% |
| WebArena-Verified | 67.3% | 65.4% | — |
| Online-Mind2Web | 92.8% | — | — |
| MMMU-Pro (no tools) | 81.2% | 79.5% | — |
| MMMU-Pro (with tools) | 82.1% | 80.4% | — |
| OmniDocBench (error) | 0.109 | 0.140 | — |

The OSWorld result is the headline figure: GPT-5.4 surpasses measured human performance on desktop navigation for the first time in a general-purpose OpenAI model.

### Tool Use

On **Toolathlon**, which tests an agent’s ability to use real-world tools and APIs across multi-step tasks (such as reading emails, extracting attachments, uploading files, grading content, and recording results in a spreadsheet), GPT-5.4 scores **54.6%** versus **46.3%** for GPT-5.2 — an 8.3 point improvement. It achieves this accuracy in fewer tool turns, meaning it reaches correct results with less back-and-forth with external systems.

On **MCP Atlas**, GPT-5.4 scores **67.2%**, compared to **60.6%** for GPT-5.2.

On **Tau2-bench Telecom**, GPT-5.4 scores **98.9%** with reasoning, and **64.3%** without reasoning effort (None setting), compared to GPT-5.2’s **57.2%** at the same setting.

### Academic Benchmarks

GPT-5.4 shows meaningful gains on hard academic evaluations:

- **GPQA Diamond** (graduate-level science): **92.8%**, up slightly from GPT-5.2’s **92.4%**
- **Humanity’s Last Exam (with tools)**: **52.1%**, up from GPT-5.2’s **45.5%**
- **Humanity’s Last Exam (no tools)**: **39.8%**, up from **34.5%**
- **FrontierMath Tier 1–3**: **47.6%**, up from **40.7%**
- **FrontierMath Tier 4**: **27.1%**, up from **18.8%**
- **ARC-AGI-1 (Verified)**: **93.7%**, up from **86.2%**
- **ARC-AGI-2 (Verified)**: **73.3%**, up from **52.9%** — a 20.4 point gain
- **Frontier Science Research**: **33.0%**, up from **25.2%**

The ARC-AGI-2 improvement (from 52.9% to 73.3%) is one of the most striking figures in this release. ARC-AGI-2 was specifically designed to be resistant to raw pattern-matching and to require general abstract reasoning, making gains here particularly meaningful as a signal about the model’s underlying reasoning quality.

### Factual Accuracy and Hallucination Reduction

On a set of de-identified prompts where users had previously flagged factual errors:

- GPT-5.4’s individual claims are **33% less likely to be false** compared to GPT-5.2
- GPT-5.4’s full responses are **18% less likely to contain any errors** compared to GPT-5.2

This makes GPT-5.4 OpenAI’s most factually accurate model as of its release.

## GPT-5.4 vs. GPT-5.2: What Actually Changed

The table below summarizes the key comparison across the benchmarks where both models were tested with comparable settings:

| Category | GPT-5.2 | GPT-5.4 | Change |
| --- | --- | --- | --- |
| GDPval | 70.9% | 83.0% | +12.1 pts |
| SWE-Bench Pro | 55.6% | 57.7% | +2.1 pts |
| OSWorld-Verified | 47.3% | 75.0% | +27.7 pts |
| BrowseComp | 65.8% | 82.7% | +16.9 pts |
| ARC-AGI-2 | 52.9% | 73.3% | +20.4 pts |
| Toolathlon | 46.3% | 54.6% | +8.3 pts |
| GPQA Diamond | 92.4% | 92.8% | +0.4 pts |
| HLE (with tools) | 45.5% | 52.1% | +6.6 pts |
| IB Modeling | 68.4% | 87.3% | +18.9 pts |

The pattern is clear: GPT-5.4’s most significant improvements are in computer use, professional knowledge work, abstract reasoning, and agentic web research. Gains on pure reasoning benchmarks like GPQA Diamond are smaller, because GPT-5.2 was already near the ceiling. The gains on agentic and applied benchmarks — where real-world complexity is higher — are considerably larger.

The other major change is structural: GPT-5.4 is also more **token-efficient**. It uses significantly fewer tokens to solve problems compared to GPT-5.2. Despite a higher per-token price, the total tokens required for many tasks are lower, which partially offsets the cost increase in practice.

## GPT-5.4 Pro: Performance at the Top End

GPT-5.4 Pro is available to ChatGPT Pro and Enterprise plan holders, as well as via the API (`gpt-5.4-pro`). On most standard benchmarks GPT-5.4 and GPT-5.4 Pro perform comparably — the Pro variant is optimized specifically for the most complex tasks.

Where GPT-5.4 Pro shows clear separation:

| Benchmark | GPT-5.4 | GPT-5.4 Pro |
| --- | --- | --- |
| BrowseComp | 82.7% | **89.3%** |
| ARC-AGI-2 | 73.3% | **83.3%** |
| ARC-AGI-1 | 93.7% | **94.5%** |
| GPQA Diamond | 92.8% | **94.4%** |
| HLE (with tools) | 52.1% | **58.7%** |
| FrontierMath Tier 4 | 27.1% | **38.0%** |
| Frontier Science Research | 33.0% | **36.7%** |
| FinanceAgent v1.1 | 56.0% | **61.5%** |

On FrontierMath Tier 4 — the hardest tier of an advanced mathematics benchmark — GPT-5.4 Pro scores 38.0% versus GPT-5.4’s 27.1%. On BrowseComp, the Pro variant sets a new state of the art at 89.3%. These are the use cases where paying for the Pro tier makes a quantifiable difference.

It is worth noting that on the GDPval professional work benchmark, GPT-5.4 (83.0%) slightly edges out GPT-5.4 Pro (82.0%). For everyday professional work, the standard GPT-5.4 is the more capable tool.

## Pricing: Full API Cost Breakdown

GPT-5.4 is priced higher per token than GPT-5.2, reflecting its expanded capabilities. Token efficiency partially offsets this — fewer tokens are required for many tasks.

### Standard API Pricing

| Model | Input (per 1M tokens) | Cached Input | Output (per 1M tokens) |
| --- | --- | --- | --- |
| gpt-5.2 | $1.75 | $0.175 | $14.00 |
| **gpt-5.4** | **$2.50** | **$0.25** | **$15.00** |
| gpt-5.2-pro | $21.00 | — | $168.00 |
| **gpt-5.4-pro** | **$30.00** | — | **$180.00** |

### Additional Pricing Tiers

- **Batch and Flex processing**: Half the standard API rate
- **Priority processing**: Twice the standard API rate (same speeds as /fast mode in Codex)
- **Data Residency and Regional Processing**: Standard rate + 10%
- **1M context window (Codex, experimental)**: Requests exceeding 272K tokens count at **2x the normal rate**

The pricing for gpt-5.4-pro is a significant step up from gpt-5.4. At $30/M input and $180/M output, it is best suited for workflows where maximum performance on the most difficult tasks justifies the cost — complex financial modeling, frontier science research, or agentic workflows involving high-stakes multi-step decisions.

For cost-sensitive use cases, Batch pricing at half the standard rate makes GPT-5.4 much more accessible for bulk processing. For latency-sensitive deployments, priority processing at twice the standard rate delivers the fastest available response times.

## Who Can Access GPT-5.4 and How

### In ChatGPT

- **Plus, Team, and Pro users**: GPT-5.4 Thinking is available immediately, replacing GPT-5.2 Thinking as the default reasoning model.
- **Enterprise and Edu plan users**: Can enable GPT-5.4 Thinking via early access in admin settings.
- **GPT-5.4 Pro**: Available to Pro and Enterprise plan holders.
- **GPT-5.2 Thinking**: Remains in the Legacy Models section for paid users until **June 5, 2026**, after which it will be retired.

The context window in ChatGPT for GPT-5.4 Thinking is unchanged from GPT-5.2 Thinking — the 1M context capability is a Codex and API feature, not a ChatGPT interface feature at this time.

### In the API

GPT-5.4 is available now as the model identifier `gpt-5.4`. GPT-5.4 Pro is available as `gpt-5.4-pro`. Standard API documentation covers the updated `computer` tool for computer-use access, the new image `original` detail level, and tool search configuration.

### In Codex

GPT-5.4 is rolling out gradually in Codex, where it replaces GPT-5.3-Codex as the primary model. The naming change to GPT-5.4 in Codex reflects the consolidation of the Codex-specific coding capabilities into the main model line, simplifying model selection for developers using Codex.

## GPT-5.4 in Codex: What Developers Need to Know

For developers using Codex, GPT-5.4 represents a meaningful workflow upgrade across several dimensions.

**Speed**: /fast mode in Codex provides up to **1.5x faster token velocity** — the same model, same intelligence, optimized for speed. This is particularly useful for interactive coding sessions where waiting for responses breaks concentration. API developers can access the same speeds through priority processing.

**Frontend development**: OpenAI reports that GPT-5.4 excels at complex frontend tasks, producing “more aesthetic and more functional results than any models launched previously” — an assessment backed by human evaluation showing GPT-5.4 presentations preferred 68% of the time over GPT-5.2 outputs.

**Visual debugging with Playwright**: OpenAI is also releasing an experimental Codex skill called **Playwright (Interactive)**, which allows Codex to visually debug web and Electron apps by observing what they look like during execution. The model can use this to test an application as it builds it — catching rendering issues and functional problems in real time rather than waiting for a separate test run.

**Long-context workflows**: With experimental support for 1M context in Codex (configured via `model_context_window` and `model_auto_compact_token_limit`), developers can now run Codex on tasks that require processing large amounts of prior context — reviewing entire repositories, maintaining awareness across long development sessions, or handling projects with extensive documentation.

The practical implication for development teams: GPT-5.4 in Codex is positioned as a single model that handles reasoning-heavy planning tasks and coding-heavy execution tasks without switching between different specialized models.

## Safety, Security, and Chain-of-Thought Monitorability

OpenAI classifies GPT-5.4 as **High cyber capability** under its Preparedness Framework and deploys it with corresponding protections. These include:

- An expanded cyber safety stack
- Monitoring systems
- Trusted access controls
- Asynchronous blocking for higher-risk requests on Zero Data Retention (ZDR) surfaces
- Request-level blocking for certain customers on ZDR surfaces as part of the cyber risk mitigation stack

One of the more technically significant aspects of the GPT-5.4 safety profile is its performance on **Chain-of-Thought (CoT) controllability**. OpenAI has introduced a new open-source evaluation measuring whether models can deliberately obfuscate their reasoning to evade monitoring. The finding for GPT-5.4 is notable: **the model’s ability to control its CoT is low**, which is identified as a positive safety property.

In plain terms: the model appears unable to strategically hide its reasoning in its chain of thought. If a model could deliberately mask its thinking to avoid detection, monitoring its reasoning would provide a false sense of security. GPT-5.4’s low CoT controllability means that CoT monitoring — reading what the model is thinking as it works — remains a meaningful and effective safety tool.

Separately, **agentic misalignment monitorability** for GPT-5.4 Thinking is near **100%** — meaning that in tests of scenarios where a model might act against intended goals during agentic tasks, the monitoring system correctly identifies these cases with very high reliability.

OpenAI notes that cybersecurity capabilities are inherently dual-use (the same features that help security researchers can also assist bad actors) and maintains a precautionary deployment approach. Some false positives in request-level blocking may occur as classifiers continue to be refined.

## Real-World Use Cases: Where GPT-5.4 Fits in Your Workflow

### Knowledge Workers and Business Professionals

The GDPval improvement — from 70.9% to 83.0% across 44 occupations — signals that GPT-5.4 is more capable of handling professional output without requiring extensive human cleanup. Specific use cases where the improvement is measurable include:

- **Financial modeling**: The 87.3% score on investment banking modeling tasks (versus 68.4% for GPT-5.2) means the model is completing complex spreadsheet work at a quality level closer to what a trained analyst would produce.
- **Presentations**: Human raters preferred GPT-5.4 presentations 68% of the time over GPT-5.2, with the edge attributed to stronger visual variety and image integration.
- **Document-heavy tasks**: The improved OmniDocBench score (0.109 vs 0.140) translates to better parsing of contracts, reports, and technical documents.

### Developers and Engineering Teams

- **Agentic pipelines**: Computer-use capabilities mean developers can now build agents that interact with software environments directly — filling forms, navigating UIs, running desktop applications — using a general-purpose model rather than a separate specialized system.
- **Tool-heavy applications**: Tool search’s 47% token reduction in large MCP ecosystems makes GPT-5.4 considerably cheaper to run in production for applications connected to many external services.
- **Faster iteration**: /fast mode and priority processing enable the kind of rapid back-and-forth that makes interactive development workflows more fluid.

### Researchers and Analysts

- **Web research**: The 17-point BrowseComp improvement means the model is more effective at finding information that requires persistence across multiple searches — a practical gain for competitive analysis, due diligence, and literature review tasks.
- **Scientific reasoning**: Improved HLE and Frontier Science Research scores show incremental gains at the frontier of scientific knowledge.
- **Long documents**: The 1M context window (in the API) allows processing of very large documents or document sets in a single context.

### Enterprises

The combination of native computer use, a unified model for coding and reasoning, improved accuracy, and the existing enterprise security and compliance infrastructure (ZDR, Data Residency endpoints) positions GPT-5.4 as a capable foundation for enterprise automation workflows. The configurable confirmation policies for computer use allow organizations to set risk tolerance at the application level rather than relying on one-size-fits-all behavior.

## The Significance of a Unified Model

It is worth taking a moment to assess why OpenAI chose the name GPT-5.4, and what the naming signals about their strategy. The jump from the specialized GPT-5.3-Codex to GPT-5.4 as the main model line reflects a deliberate decision to consolidate: rather than maintaining separate specialized tracks (one for reasoning, one for coding), OpenAI is moving toward a single model that performs at or above the specialist models in each domain.

This consolidation has practical implications for developers who have been managing which model to call for which task. With GPT-5.4, the choice is simpler: it handles reasoning-heavy queries, coding tasks, computer use, and document work at frontier performance levels, all from a single model identifier.

OpenAI has also stated explicitly that over time, the Instant models (faster, lighter) and Thinking models (deeper reasoning) will evolve at different speeds. GPT-5.4 sits in the Thinking model line — the reasoning-first track — and its naming reflects a maturing model family where each version represents a meaningful capability step rather than a naming convention reset.

## What Changes, What Stays the Same

A few things are worth flagging for users who are already on GPT-5.2 or GPT-5.3-Codex:

**What changes:**

- GPT-5.4 Thinking replaces GPT-5.2 Thinking as the default ChatGPT reasoning model for Plus, Team, and Pro users
- Codex now runs on GPT-5.4 rather than GPT-5.3-Codex
- Computer use is now natively available in a general-purpose model for the first time
- Tool search is a new API parameter — existing integrations are not automatically affected, but adopting it can reduce costs significantly

**What stays the same:**

- ChatGPT context windows for GPT-5.4 Thinking are unchanged from GPT-5.2 Thinking
- GPT-5.2 Thinking remains available in Legacy Models through June 5, 2026
- Batch and Flex pricing remain at half the standard rate
- API model identifiers follow the established `gpt-5.x` pattern

## What This Release Tells Us About the Trajectory

GPT-5.4 scores 75% on OSWorld — above human baseline — which is a data point worth sitting with. Desktop navigation, form completion, and multi-application workflows are tasks that most people do as a background function of their work, without thinking much about them. A model that can do this reliably opens up automation possibilities that previously required either custom robotic process automation (RPA) tooling or specialized AI systems that couldn’t generalize.

The 33% reduction in individual false claims and 18% reduction in error-containing responses also represents steady progress on a problem that has been a persistent limitation. At 83% on GDPval, there are still 17% of professional tasks where the output does not match industry professional quality — and error rates, while improved, are not zero. The trajectory is clear; the gap has not fully closed.

Where GPT-5.4 sits in the broader competitive landscape is also meaningful context. The release coincides with active capability development from Anthropic, Google DeepMind, and others. OpenAI’s decision to release a unified model that performs at frontier on coding, reasoning, computer use, and professional work simultaneously is a statement about model architecture direction as much as it is about benchmarks.

The fact that GPT-5.4’s ARC-AGI-2 score jumped from 52.9% to 73.3% — on a benchmark specifically designed to resist surface-level pattern matching — is the kind of signal that researchers tracking general reasoning progress watch closely. ARC-AGI-2 was intended to remain difficult for systems that were pattern-matching their way to high scores. A 20-point gain suggests something more substantive is happening in the model’s abstract reasoning capabilities.

GPT-5.4 marks a point where the distance between what AI can reliably produce and what professionals routinely deliver has narrowed considerably across a wide range of work. The tools professionals use to do their jobs, the documents they work in, the software environments they navigate, and the research they conduct are all areas where this model’s performance is now measurably closer to human baseline — and in several specific cases, above it.

## Frequently Asked Questions About GPT-5.4

**Q: What is GPT-5.4 and when was it released?**

GPT-5.4 is OpenAI’s most capable general-purpose frontier model as of March 2026. It was released on March 5, 2026, simultaneously across ChatGPT (as GPT-5.4 Thinking), the OpenAI API, and Codex. It is the first OpenAI general-purpose model with native computer-use capabilities and supports a context window of up to 1 million tokens in the API and Codex.

**Q: What is the difference between GPT-5.4 and GPT-5.4 Pro?**

GPT-5.4 is the standard tier of the model, available to ChatGPT Plus, Team, and Pro users, and via the API as `gpt-5.4`. GPT-5.4 Pro is a higher-performance variant available to ChatGPT Pro and Enterprise users and via the API as `gpt-5.4-pro`. GPT-5.4 Pro scores significantly higher on the most demanding benchmarks — 89.3% on BrowseComp (vs 82.7%), 83.3% on ARC-AGI-2 (vs 73.3%), and 38.0% on FrontierMath Tier 4 (vs 27.1%). The Pro tier is priced at $30/M input and $180/M output tokens.

**Q: How does GPT-5.4 compare to GPT-5.2?**

GPT-5.4 shows substantial improvements over GPT-5.2 on most benchmarks. Key improvements: GDPval (professional work) from 70.9% to 83.0%, OSWorld-Verified (computer use) from 47.3% to 75.0%, BrowseComp (web research) from 65.8% to 82.7%, ARC-AGI-2 (abstract reasoning) from 52.9% to 73.3%, and a 27.7-point gain on desktop navigation. It also produces 33% fewer false claims and 18% fewer error-containing responses than GPT-5.2.

**Q: How does GPT-5.4 compare to GPT-5.3-Codex?**

GPT-5.4 incorporates the coding capabilities of GPT-5.3-Codex and either matches or surpasses it on most benchmarks. On SWE-Bench Pro, GPT-5.4 scores 57.7% versus GPT-5.3-Codex’s 56.8%. On Terminal-Bench 2.0, GPT-5.3-Codex still leads at 77.3% versus 75.1%. On GDPval, GPT-5.4 at 83.0% significantly outperforms GPT-5.3-Codex at 70.9%. GPT-5.4 also adds computer use and tool search capabilities that GPT-5.3-Codex did not include.

**Q: What is GPT-5.4’s pricing on the API?**

Standard pricing for GPT-5.4 is $2.50 per million input tokens, $0.25 per million cached input tokens, and $15.00 per million output tokens. GPT-5.4 Pro is priced at $30.00 per million input tokens and $180.00 per million output tokens (no cached input pricing). Batch and Flex processing are available at half the standard rate; Priority processing is at twice the standard rate. Data Residency and Regional Processing endpoints carry a 10% surcharge.

**Q: What is GPT-5.4’s “computer use” capability?**

GPT-5.4 can operate computers by writing code using libraries like Playwright, and by issuing mouse and keyboard commands in response to screenshots. It is the first OpenAI general-purpose model with this capability built in natively. On OSWorld-Verified (desktop navigation benchmark), GPT-5.4 achieves 75.0%, above human performance of 72.4%. On WebArena-Verified (browser use), it reaches 67.3%. Developers access computer use via the updated `computer` tool in the API.

**Q: What is GPT-5.4’s context window?**

In the API and Codex, GPT-5.4 supports up to 1 million tokens of context (experimental in Codex via `model_context_window`configuration). The standard window is 272K tokens. Requests beyond 272K count at 2x the normal usage rate. In ChatGPT, the context window for GPT-5.4 Thinking is unchanged from GPT-5.2 Thinking.

**Q: What is tool search and why does it matter?**

Tool search is a new mechanism in GPT-5.4 that allows the model to receive a lightweight list of available tools and look up specific tool definitions on demand rather than having all tool definitions preloaded in the prompt. Tested across 250 tasks from Scale’s MCP Atlas benchmark with 36 MCP servers enabled, tool search reduced total token usage by 47% while maintaining the same accuracy. For applications using large MCP server ecosystems, this is a significant cost and latency reduction.

**Q: Which ChatGPT plans include GPT-5.4?**

GPT-5.4 Thinking is available to ChatGPT Plus, Team, and Pro subscribers starting March 5, 2026. Enterprise and Edu plan holders can enable it through admin settings as an early access feature. GPT-5.4 Pro is available to Pro and Enterprise plan holders. GPT-5.2 Thinking remains available in Legacy Models for paid users until June 5, 2026.

**Q: Does GPT-5.4 replace GPT-5.3-Codex in Codex?**

Yes. GPT-5.4 is rolling out in Codex as the primary model, replacing GPT-5.3-Codex. OpenAI states that the naming jump to GPT-5.4 reflects the incorporation of GPT-5.3-Codex’s capabilities into the main model line, simplifying model selection for developers.

**Q: What is the mid-response course correction feature?**

In ChatGPT, GPT-5.4 Thinking displays a preamble at the beginning of complex responses — an outline of how it plans to approach the task. Users can read this plan and provide course-correction instructions before the model completes the full response. This allows users to steer the output toward what they want without starting over, available now on [chatgpt.com](http://chatgpt.com/) and Android, coming soon to iOS.

**Q: How has GPT-5.4 improved factual accuracy?**

On a set of prompts where users previously flagged factual errors, GPT-5.4’s individual claims are 33% less likely to be false compared to GPT-5.2, and its full responses are 18% less likely to contain any errors. On the SimpleQA factual accuracy benchmark, the model shows consistent improvement. GPT-5.4 is described by OpenAI as their most factually accurate model as of its release.

**Q: What are GPT-5.4’s image input capabilities?**

GPT-5.4 introduces a new `original` image input detail level supporting full-fidelity perception up to 10.24 million total pixels or a 6,000-pixel maximum dimension. The `high` detail level now supports up to 2.56 million total pixels or a 2,048-pixel maximum dimension. Early API testing shows strong gains in localization, image understanding, and click accuracy at these higher detail settings, particularly for computer-use tasks.

**Q: What safety measures does GPT-5.4 have?**

OpenAI classifies GPT-5.4 as High cyber capability and deploys it with an expanded cyber safety stack, monitoring systems, trusted access controls, and asynchronous blocking for higher-risk requests on Zero Data Retention surfaces. The model’s Chain-of-Thought controllability is assessed as low — meaning the model appears unable to strategically obfuscate its reasoning to evade monitoring, which OpenAI identifies as a positive safety property. Agentic misalignment monitorability is near 100% for GPT-5.4 Thinking.

**Q: Is GPT-5.4 available for free ChatGPT users?**

At launch, GPT-5.4 Thinking is available to paid ChatGPT plans (Plus, Team, Pro, Enterprise, Edu). Free-tier access details have not been announced as of the release date.

**Q: What is the GDPval benchmark and what does GPT-5.4’s 83% score mean?**

GDPval tests an AI agent’s ability to complete well-specified professional knowledge work across 44 occupations spanning the top 9 industries contributing to U.S. GDP. Tasks include real deliverables like sales presentations, accounting spreadsheets, urgent care schedules, and manufacturing diagrams. GPT-5.4’s 83.0% score means it matches or exceeds industry professionals in 83 out of 100 comparisons. GPT-5.2 scored 70.9% on the same benchmark.

**Q: Can I still use GPT-5.2 Thinking after GPT-5.4 launches?**

Yes, for a period. GPT-5.2 Thinking will remain available in the Legacy Models section of ChatGPT for paid users for three months after GPT-5.4’s launch, with retirement scheduled for June 5, 2026. In the API, `gpt-5.2` continues to be available with no announced retirement date at this time.

**Q: How does GPT-5.4 affect Codex’s /fast mode?**

In Codex, /fast mode delivers up to 1.5x faster token velocity with GPT-5.4. It is the same model running at higher speed, not a separate model with reduced capability. API developers can access the same fast processing through priority processing at twice the standard API rate.

**Q: What is Chain-of-Thought monitorability and why does OpenAI emphasize it?**

Chain-of-Thought monitorability refers to whether a monitoring system can reliably infer safety-relevant information about a model’s behavior by reading its chain of thought — the step-by-step reasoning it produces. If a model could deliberately hide or mislead in its reasoning, monitoring that reasoning would be unreliable as a safety tool. OpenAI’s assessment that GPT-5.4 has low CoT controllability suggests the model lacks this ability, meaning its reasoning is genuinely transparent to monitors. This is part of OpenAI’s broader safety research on how to keep increasingly capable reasoning models reliably observable.

_GPT-5.4 is available now on [chatgpt.com](http://chatgpt.com/) for Plus, Team, and Pro users, and as `gpt-5.4` and `gpt-5.4-pro` in the OpenAI API. For developers, full documentation on the updated `computer` tool, image detail levels, and tool search configuration is available at [developers.openai.com](http://developers.openai.com/)._

About The Author

![Vineesh Sandhir](https://almcorp.com/wp-content/uploads/2026/02/1516789684729.webp)

[Vineesh Sandhir](https://almcorp.com/blog/author/vineesh/)

Vineesh Sandhir is the VP – Operations of ALM Corp. He is an accomplished digital marketer/entrepreneur with over 20 years of experience. He has led multinational teams and spearheaded a broad spectrum of award-winning projects in over 40 different verticals globally. He has comprehensive and multi-faceted experience in digital marketing , with C-Level experience managing large teams and senior team members.

[Linkedin](https://www.linkedin.com/in/vineeshsandhir/ "Linkedin")

Latest Posts

[View All Posts](https://almcorp.com/blog/)

[![Snap Cuts 16% of Staff](https://almcorp.com/wp-content/uploads/elementor/thumbs/Snap-Cuts-16-of-Staff-rm2nvtv7fzctq8j96rwdekuoc78f4bs39qmr3d835k.webp)](https://almcorp.com/blog/snap-layoffs-16-percent-staff/)

- [Social Media](https://almcorp.com/blog/category/social-media/)

- 9 mins read

[Snap Cuts 16% of Staff: What the Layoffs Mean for Snapchat, AI, Advertisers, and Profitability](https://almcorp.com/blog/snap-layoffs-16-percent-staff/)

- ALM Corp

[![Privacy-First Personalization](https://almcorp.com/wp-content/uploads/elementor/thumbs/Privacy-First-Personalization-rm2o04ykrn94xw9z14xtbzpqcrzzedvsv29va0u4mw.webp)](https://almcorp.com/blog/privacy-first-personalization-zero-party-data-competitive-advantage/)

- [Blog](https://almcorp.com/blog/category/blog/)

- 9 mins read

[Privacy-First Personalization: How Zero-Party Data Improves Trust, Accuracy, and Marketing Performance](https://almcorp.com/blog/privacy-first-personalization-zero-party-data-competitive-advantage/)

- ALM Corp

[![Marketing Automation Trends 2026](https://almcorp.com/wp-content/uploads/elementor/thumbs/Marketing-Automation-Trends-2026-rm2ob1v44e6zqwf9aurva8kenu7erv7lp2ytvonke0.webp)](https://almcorp.com/blog/marketing-automation-trends-2026/)

- [Online Marketing](https://almcorp.com/blog/category/online-marketing/)

- 9 mins read

[Marketing Automation Trends 2026: How Scheduled Workflows Are Becoming Self-Optimizing Systems](https://almcorp.com/blog/marketing-automation-trends-2026/)

- ALM Corp