Introducing GPT-5.4 \| OpenAI

March 5, 2026

[Product](https://openai.com/news/product-releases/) [Release](https://openai.com/research/index/release/)

# Introducing GPT‑5.4

Designed for professional work

Loading…

Share

Today, we’re releasing **GPT‑5.4** in ChatGPT (as GPT‑5.4 Thinking), the API, and Codex. It’s our most capable and efficient frontier model for professional work. We’re also releasing **GPT‑5.4 Pro** in ChatGPT and the API, for people who want maximum performance on complex tasks.

GPT‑5.4 brings together the best of our recent advances in reasoning, coding, and agentic workflows into a single frontier model. It incorporates the industry-leading coding capabilities of [GPT‑5.3‑Codex⁠](https://openai.com/index/introducing-gpt-5-3-codex/) while improving how the model works across tools, software environments, and professional tasks involving spreadsheets, presentations, and documents. The result is a model that gets complex real work done accurately, effectively, and efficiently—delivering what you asked for with less back and forth.

In ChatGPT, GPT‑5.4 Thinking can now provide an upfront plan of its thinking, so you can **adjust course mid-response** while it’s working **,** and arrive at a final output that’s more closely aligned with what you need without additional turns. GPT‑5.4 Thinking also improves **deep web research,** particularly for highly specific queries, while **better maintaining context** for questions that require longer thinking. Together, these improvements mean higher-quality answers that arrive faster and stay relevant to the task at hand.

In Codex and the API, GPT‑5.4 is the first general-purpose model we’ve released with native, state-of-the-art **computer-use capabilities**, enabling agents to operate computers and carry out complex workflows across applications. It supports up to **1M tokens of context**, allowing agents to plan, execute, and verify tasks across long horizons. GPT‑5.4 also improves how models work across large ecosystems of tools and connectors with **tool search**, helping agents find and use the right tools more efficiently without sacrificing intelligence. Finally, GPT‑5.4 is our **most token efficient reasoning model** yet, using significantly fewer tokens to solve problems when compared to GPT‑5.2—translating to reduced token usage and faster speeds.

Together with advances in general reasoning, coding, and professional knowledge work, GPT‑5.4 enables more reliable agents, faster developer workflows, and higher-quality outputs across ChatGPT, the API, and Codex.

|     |     |     |     |
| --- | --- | --- | --- |
|  | **GPT-5.4** | **GPT-5.3-Codex** | **GPT-5.2** |
| GDPval (wins or ties) | 83.0% | 70.9% | 70.9% |
| SWE-Bench Pro (Public) | 57.7% | 56.8% | 55.6% |
| OSWorld-Verified | 75.0% | 74.0%\* | 47.3% |
| Toolathlon | 54.6% | 51.9% | 46.3% |
| BrowseComp | 82.7% | 77.3% | 65.8% |

\*Previously reported as 64.7%. GPT‑5.3‑Codex achieves 74.0% with a newly introduced API parameter that preserves the original image resolution.

## Knowledge work

Building on GPT‑5.2’s general reasoning capabilities, GPT‑5.4 delivers even more consistent and polished results on real-world tasks that matter to professionals.

On [GDPval⁠](https://openai.com/index/gdpval/), which tests agents’ abilities to produce well-specified knowledge work across 44 occupations, GPT‑5.4 achieves a new state of the art, matching or exceeding industry professionals in **83.0%** of comparisons, compared to **70.9%** for GPT‑5.2.

GDPval
Knowledge work tasks

GPT-5.4 ProGPT-5.4GPT-5.2 ProGPT-5.20%20%40%60%80%100%Win rate vs industry professional82.0%83.0%74.1%70.9%69.2%70.8%60.0%49.8%Industry expert baselineIndustry expert baselineWinsTies

_In GDPval, models attempt well-specified knowledge work spanning 44 occupations from the top 9 industries contributing to U.S. GDP. Tasks request real work products, such as sales presentations, accounting spreadsheets, urgent care schedules, manufacturing diagrams, or short videos. Reasoning effort was set to xhigh for GPT‑5.4 and heavy for GPT‑5.2 (a slightly lower level in ChatGPT)._

> “GPT-5.4 is the best model we’ve ever tried. It’s now top of the leaderboard on our APEX-Agents benchmark, which measures model performance for professional services work. It excels at creating long-horizon deliverables such as slide decks, financial models, and legal analysis, delivering top performance while running faster and at a lower cost than competitive frontier models.”

— Brendan Foody, CEO at Mercor

We put a particular focus on improving GPT‑5.4’s ability to create and edit spreadsheets, presentations, and documents. On an internal benchmark of spreadsheet modeling tasks that a junior investment banking analyst might do, GPT‑5.4 achieves a mean score of **87.3%**, compared to **68.4%** for GPT‑5.2. On a set of presentation evaluation prompts, human raters preferred presentations from GPT‑5.4 **68.0%** of the time over those from GPT‑5.2 due to stronger aesthetics, greater visual variety, and more effective use of image generation.

![Side by side example of spreadsheet outputs from GPT-5.2 vs GPT-5.4](https://images.ctfassets.net/kftzwdyauwt9/6HIfga5zjofGwccjVeZA2e/fcca68f123b1110c7b4f275caa2d3669/Spreadsheet_-_desktop_-_light.png?w=3840&q=90&fm=webp)

_Documents were generated with reasoning effort set to xhigh_

You can try these capabilities in ChatGPT using GPT‑5.4 Thinking or Pro. If you’re an Enterprise customer, we recommend using our newly released [ChatGPT for Excel add-in⁠(opens in a new window)](https://chatgpt.com/apps/spreadsheets/?openaicom-did=e6fb49f0-df14-4583-9bd7-194ca2996b78&openaicom_referred=true), which was also launched today. We've also updated our [spreadsheet⁠(opens in a new window)](https://github.com/openai/skills/tree/main/skills/.curated/spreadsheet) and [presentation skills⁠(opens in a new window)](https://github.com/openai/skills/tree/main/skills/.curated/slides) available in Codex and the API.

To make GPT‑5.4 better at real-world work, we continued our progress at driving down hallucinations and errors. GPT‑5.4 is our most factual model yet: on a set of de-identified prompts where users flagged factual errors, GPT‑5.4’s individual claims are 33% less likely to be false and its full responses are 18% less likely to contain any errors, relative to GPT‑5.2.

> “GPT-5.4 sets a new bar for document-heavy legal work. On our BigLaw Bench eval, it scored 91%. Compared to other models, GPT-5.4 is currently better at structuring complex transactional analysis, maintaining accuracy across lengthy contracts, and delivering the high level of detail legal practitioners require.”

— Niko Grupen, Head of Applied Research at Harvey

## Computer use and vision

GPT‑5.4 is our first general-purpose model with native **computer-use capabilities** and marks a major step forward for developers and agents alike. It’s the best model currently available for developers building agents that complete real tasks across websites and software systems.

We’ve designed GPT‑5.4 to be performant across a wide range of computer-use workloads. It is excellent at writing code to operate computers via libraries like Playwright, as well as issuing mouse and keyboard commands in response to screenshots. Its behavior is steerable via developer messages, meaning that developers can adjust behavior to suit particular use cases. Developers can even configure the model’s safety behavior to suit different levels of risk tolerance by specifying custom confirmation policies.

The model’s performance and flexibility are reflected across benchmarks that test computer use across different settings. On **OSWorld-Verified**, which measures a model’s ability to navigate a desktop environment through screenshots and keyboard/mouse actions, GPT‑5.4 achieves a state-of-the-art **75.0%** success rate, far exceeding GPT‑5.2’s **47.3%**, and surpassing human performance at **72.4%.** **1**

On **WebArena-Verified**, which tests browser use, GPT‑5.4 achieves a leading **67.3%** success rate when using both DOM- and screenshot-driven interaction, compared to GPT‑5.2’s **65.4%**. On **Online-Mind2Web**, which also tests browser use, GPT‑5.4 achieves a **92.8%** success rate using screenshot-based observations alone, improving over ChatGPT Atlas’s Agent Mode, which achieves a success rate of **70.9%**.

OSWorld-Verified

010203040Number of tool yields20%40%60%80%AccuracyGPT-5.4GPT-5.2

_A tool yield is when an assistant yields to await tool responses. If 3 tools are called in parallel, followed by 3 more tools called in parallel, the number of yields would be 2. Tool yields are a better proxy of latency than tool calls because they reflect the benefits of parallelization._

GPT‑5.4 interprets screenshots of a browser interface and interacts with UI elements through coordinate-based clicking to send emails and schedule a calendar event. **Video is not sped up.**

GPT‑5.4’s improved computer use is built on the model’s improved general visual perception capabilities. On **MMMU-Pro**, a test of a model’s visual understanding and reasoning, GPT‑5.4 achieves an **81.2%** success rate without tool use, an improvement overGPT‑5.2’s **79.5%**. Improved visual perception also translates into better document parsing capabilities. On **OmniDocBench**, GPT‑5.4 without reasoning effort achieves an average error (measured by normalized edit distance between model prediction and ground truth) of **0.109**, improved from GPT‑5.2’s **0.140**.

MMMU Pro (no tools)

GPT-5.4GPT-5.20%20%40%60%80%100%Accuracy81.2%79.5%

OmniDocBench

GPT-5.4GPT-5.200.050.10.150.2Average error (lower is better)0.140.11

_MMMUPro was run with reasoning effort set to xhigh. OmniDocBench was run with reasoning effort set to none, to reflect low-cost, low-latency performance._

We’re also improving visual understanding for dense, high-resolution images where full fidelity matters. Starting with GPT‑5.4, we’re introducing an `original` image [input detail⁠(opens in a new window)](https://developers.openai.com/api/docs/guides/images-vision/#specify-image-input-detail-level) level which supports full-fidelity perception up to 10.24M total pixels or 6000-pixel maximum dimension, whichever is lower; the `high` image input detail level now supports up to 2.56M total pixels or a 2048-pixel maximum dimension. In early testing with API users, we observed strong gains in localization ability, image understanding, and click accuracy when using `original` or `high` detail.

> “In our evals measuring computer use performance across ~30K HOA and property tax portals, GPT-5.4 achieved a 95% success rate on the first attempt and 100% within three attempts, compared to ~73–79% with prior CUA models. It also completed sessions ~3x faster while using ~70% fewer tokens, materially improving reliability and cost efficiency at scale."

— Dod Fraser, CEO at Mainstay

In the API, developers can access these capabilities using the updated `computer` tool. Please see our [updated documentation⁠(opens in a new window)](https://developers.openai.com/api/docs/guides/latest-model) for recommended best practices.

## Coding

GPT‑5.4 combines the coding strengths of GPT‑5.3‑Codex with leading knowledge work and computer-use capabilities, which matter most on longer-running tasks where the model can use tools, iterate, and push work further with less manual intervention. It matches or outperforms GPT‑5.3‑Codex on SWE-Bench Pro while being lower latency across reasoning efforts.

SWE-Bench Pro (public)

05001,0001,5002,000Estimated latency (seconds)40%45%50%55%60%AccuracyGPT-5.4GPT-5.3-CodexGPT-5.2

_We estimate latency by looking at the production behavior of our models, and simulating this offline. The latency estimate accounts for tool call duration (code execution time), sampled tokens, and input tokens. Real-world latency may vary substantially, and depends on many factors not captured in our simulation. Reasoning efforts were swept from none to xhigh._

When toggled on, /fast mode in Codex delivers up to 1.5x faster token velocity with GPT‑5.4. It’s the same model and the same intelligence, just faster. That means users can move through coding tasks, iteration, and debugging while staying in flow. Developers can access GPT‑5.4 at the same fast speeds via the API by using [priority processing⁠(opens in a new window)](https://developers.openai.com/api/docs/guides/priority-processing).

In evaluation and internal testing we found that GPT‑5.4 excels at complex frontend tasks, with noticeably more aesthetic and more functional results than any models we’ve launched previously.

As a demonstration of the model’s improved computer-use and coding capabilities working in tandem, we’re also releasing an experimental Codex skill called “ [Playwright (Interactive)⁠(opens in a new window)](https://github.com/openai/skills/tree/main/skills/.curated/playwright-interactive)”. This allows Codex to visually debug web and Electron apps; it can even be used to test an app it’s building, as it’s building it.

Theme park simulation game made with GPT‑5.4 from a single lightly specified prompt, using Playwright Interactive for browser playtesting and image generation for the isometric asset set. The simulation includes tile-based path placement, ride and scenery construction, guest pathfinding, queueing, and ride cycles, while park metrics like money, guest count, happiness, cleanliness, and rating rise or fall based on how the layout performs and how guests respond to it. Playwright was used to automate browser playtests by building and expanding the park, placing and removing paths and attractions, checking camera navigation, and verifying that guests, queues, ride states, and UI metrics updated correctly over several rounds of play.

`Prompt:``Use $playwright-interactive and $imagegen. Create an interactive isometric theme park simulation game that I can build and navigate in the browser. Use imagegen to establish the overall visual vision and generate the game’s assets, including rides, paths, terrain, trees, water, food stalls, decorations, buildings, icons, and UI illustrations. The world should feel cohesive, polished, and visually rich, with a premium art direction that works well from an isometric perspective. Let me place and remove paths, add attractions, position scenery, and move around the park smoothly while monitoring guest activity, ride status, and park growth. Include believable guest movement, simple park management systems like money, cleanliness, queueing, and happiness, and make the experience feel playful, clear, and complete rather than like a rough prototype. Prioritize charm, readability, and strong game feel over realism.`

`When play testing, be sure to build and expand a park through several rounds of play, verify that placement and navigation work smoothly, confirm that guests react to the park layout and attractions, and ensure the visuals, UI, and interactions feel stable and cohesive.`

00:00

> “GPT-5.4 is currently the leader on our internal benchmarks. Our engineers find it to be more natural and assertive than previous models. It works through ambiguous problems without second-guessing itself, and it's proactive about parallelizing work to keep things moving.”

— Lee Robinson, VP of Developer Education at Cursor

## Tool use

With GPT‑5.4, we’ve significantly improved how models work with external tools. Agents can now operate across larger tool ecosystems, choose the right tools more reliably, and complete multi-step workflows with lower cost and latency.

#### Tool search

In the API, GPT‑5.4 introduces [**tool search** ⁠(opens in a new window)](https://developers.openai.com/api/docs/guides/tools-tool-search), which allows models to work efficiently when given many tools.

Previously, when a model was given tools, all tool definitions were included in the prompt upfront. For systems with many tools, this could add thousands—or even tens of thousands—of tokens to every request, increasing cost, slowing responses, and crowding the context with information the model might never use.

With tool search, GPT‑5.4 instead receives a lightweight list of available tools along with a tool search capability. When the model needs to use a tool, it can look up that tool’s definition and append it to the conversation at that moment.

This approach dramatically reduces the number of tokens required for tool-heavy workflows and preserves the cache, making requests faster and cheaper. It also enables agents to reliably work with much larger tool ecosystems. For MCP servers that may contain tens of thousands of tokens of tool definitions, the efficiency gains can be substantial.

To demonstrate the efficiency gains, we evaluated 250 tasks from Scale’s [MCP Atlas⁠(opens in a new window)](https://scale.com/leaderboard/mcp_atlas) benchmark with all 36 MCP servers enabled in two modes: (1) exposing every MCP function directly in the model context, and (2) placing all MCP servers behind tool search. The tool-search configuration reduced total token usage by 47% while achieving the same accuracy.

Example token savings from tool search

010,00020,00030,00040,00050,00060,00070,00080,00090,000100,000110,000120,000130,000TokensWith tool searchWithout tool search65,320123,139Upfront Input TokensOutput TokensInput Tokens From Tool Outputs

_Example token counts come from averaging 250 tasks in the MCP-Atlas public dataset._

#### Agentic tool calling

GPT‑5.4 also improves **tool calling**, making it more accurate and efficient when deciding when and how to use tools during reasoning, particularly in the API.  Compared to GPT‑5.2, it achieves higher accuracy in fewer turns on Toolathlon, a benchmark that tests how well AI agents can use real-world tools and APIs to complete multi-step tasks. For example, an agent needs to read emails, extract assignment attachments, upload them, grade them and record results in a spreadsheet.

Toolathlon

0510152025303540Number of tool yields0%20%40%60%AccuracyGPT-5.4GPT-5.2

_A tool yield is when an assistant yields to await tool responses. If 3 tools are called in parallel, followed by 3 more tools called in parallel, the number of yields would be 2. Tool yields are a better proxy of latency than tool calls because they reflect the benefits of parallelization._

For latency-sensitive use cases where reasoning effort None is preferred, GPT‑5.4 further improves upon its predecessors.

𝜏²-bench Telecom
(without reasoning)

GPT-5.4GPT-5.2GPT-5.1GPT-4.10%10%20%30%40%50%60%70%Accuracy64.3%57.2%45.2%43.6%

_In_ [_τ2-bench⁠_ ⁠(opens in a new window)](https://arxiv.org/pdf/2506.07982) _, a model must use tools to accomplish a customer service task, where there may be a simulated user who can communicate and take actions on the world state. Reasoning effort was set to None._

#### Improved web search

GPT‑5.4 is better at agentic web search. On BrowseComp, a measurement of how well AI agents can persistently browse the web to find hard-to-locate information, GPT‑5.4 leaps 17%abs over GPT‑5.2, and GPT‑5.4 Pro sets a new state of the art of 89.3%.

In practice, this means GPT‑5.4 Thinking is stronger at answering questions that require pulling together information from many sources on the web. It can more persistently search across multiple rounds to identify the most relevant sources, particularly for “needle-in-a-haystack” questions, and synthesize them into a clear, well-reasoned answer.

BrowseComp

GPT-5.4 ProGPT-5.4GPT-5.2 ProGPT-5.20%20%40%60%80%100%Accuracy89.3%82.7%77.9%65.8%

_In BrowseComp, we used a search blocklist excluding websites containing benchmark answers from evaluation to prevent contamination and ensure a fair measure of performance. GPT‑5.4 was measured on a later date than GPT‑5.2, so scores reflect changes in the model, our search system, and state of the internet. GPT‑5.4 was tested with a longer, updated blocklist. Models use the ChatGPT search tool, which can have small differences from API search._

> “GPT-5.4 xhigh is the new state of the art for multi-step tool use. Zapier runs some of the most rigorous tool use benchmarks in the industry, testing models across hundreds of advanced real-world workflows. GPT-5.4 finished the job where previous models gave up - the most persistent model to date.”

— Wade, CEO at Zapier

## Steerability

Similarly to how Codex outlines its approach when it starts working, GPT‑5.4 Thinking in ChatGPT will now outline its work with a preamble for longer, more complex queries. You can also add instructions or adjust its direction mid-response. This makes it easier to guide the model toward the exact outcome you want without starting over or requiring multiple additional turns. This feature is available now on [chatgpt.com⁠(opens in a new window)](http://chatgpt.com/?openaicom-did=e6fb49f0-df14-4583-9bd7-194ca2996b78&openaicom_referred=true) and the Android app, coming soon to the iOS app.

The model can also think longer on difficult tasks while maintaining stronger awareness of earlier steps in the conversation. This allows it to handle longer workflows and more complex prompts while keeping answers coherent and relevant throughout.

00:00

_This video was sped up for illustrative purposes._

## Safety

Over recent months, we’ve continued improving the safeguards we introduced with GPT‑5.3‑Codex while preparing GPT‑5.4 for deployment. Similar to GPT‑5.3‑Codex, we are treating GPT‑5.4 as High cyber capability under our Preparedness Framework, and we are deploying it with the corresponding protections as documented in the [system card⁠(opens in a new window)](https://deploymentsafety.openai.com/gpt-5-4-thinking). These include an expanded cyber safety stack, including monitoring systems, trusted access controls, and asynchronous blocking for higher-risk requests for customers on Zero Data Retention (ZDR) surfaces, alongside ongoing investment in the broader security ecosystem.

Because cybersecurity capabilities are inherently dual-use, we maintain a precautionary approach to deployment while continuing to calibrate our policies and classifiers. For certain customers on ZDR surfaces, request-level blocking remains part of our cyber risk mitigation stack; because classifiers are still improving, some false positives may occur as we continue refining these safeguards. These updates aim to improve how safeguards operate in practice, including reducing unnecessary refusals and overly caveated responses, while preserving strong protections against misuse.

We’ve continued our safety research on Chain-of-Thought (CoT) monitorability to better understand how models reason and help detect potential misbehavior. As part of this work, we introduce a new open-source evaluation, [CoT controllability⁠](https://openai.com/index/reasoning-models-chain-of-thought-controllability/),  measuring whether models can deliberately obfuscate their reasoning to evade monitoring. We find that GPT‑5.4 Thinking’s ability to control its CoT is low, which is a positive property for safety, suggesting that the model lacks the ability to hide its reasoning and that CoT monitoring remains an effective safety tool.

## Availability and pricing

GPT‑5.4 is rolling out gradually today across ChatGPT and Codex. In the API, GPT‑5.4 is available now as `gpt-5.4`. GPT‑5.4 Pro is also available in the API as `gpt-5.4-pro` for developers who need maximum performance on the most complex tasks.

In ChatGPT, GPT‑5.4 Thinking is available starting today to ChatGPT Plus, Team, and Pro users, replacing GPT‑5.2 Thinking. GPT‑5.2 Thinking will remain available for three months for paid users in the model picker under the Legacy Models section, after which it will be retired on June 5, 2026. Those on Enterprise and Edu plans can enable early access via admin settings. GPT‑5.4 Pro is available to Pro and Enterprise plans. [Context windows⁠(opens in a new window)](https://help.openai.com/en/articles/11909943-gpt-53-and-54-in-chatgpt) in ChatGPT for GPT‑5.4 Thinking remain unchanged from GPT‑5.2 Thinking.

GPT‑5.4 is our first mainline reasoning model that incorporates the frontier coding capabilities of GPT‑5.3‑codex and that is rolling out across ChatGPT, the API and Codex. We're calling it GPT‑5.4 to reflect that jump, and to simplify the choice between models when using Codex. Over time, you can expect our Instant models and Thinking models to evolve at different speeds.

GPT‑5.4 in Codex includes experimental support for the 1M context window. Developers can try this by configuring `model_context_window` and `model_auto_compact_token_limit`. Requests that exceed the standard 272K context window count against usage limits at 2x the normal rate.

In the API, GPT‑5.4 is priced higher per token than GPT‑5.2 to reflect its improved capabilities, while its greater token efficiency helps reduce the total number of tokens required for many tasks. Batch and Flex pricing are available at half the standard API rate, while Priority processing is available at twice the standard API rate.

|     |     |     |     |
| --- | --- | --- | --- |
| **API model** | **Input price** | **Cached input price** | **Output price** |
| gpt-5.2 | $1.75 / M tokens | $0.175 / M tokens | $14 / M tokens |
| gpt-5.4 | $2.50 / M tokens | $0.25 / M tokens | $15 / M tokens |
| gpt-5.2-pro | $21 / M tokens | - | $168 / M tokens |
| gpt-5.4-pro | $30 / M tokens | - | $180 / M tokens |

## Evaluations

##### Professional

|     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- |
| **Eval** | **GPT‑5.4** | **GPT‑5.4**<br>**Pro** | **GPT‑5.3-Codex** | **GPT‑5.2** | **GPT‑5.2**<br>**Pro** |
| GDPval | 83.0% | 82.0% | 70.9% | 70.9% | 74.1% |
| FinanceAgent v1.1 | 56.0% | 61.5% | 54.0% | 59.5% | — |
| Investment Banking Modeling Tasks (Internal) | 87.3% | 83.6% | 79.3% | 68.4% | 71.7% |
| OfficeQA | 68.1% | — | 65.1% | 63.1% | — |

##### Coding

|     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- |
| **Eval** | **GPT‑5.4** | **GPT‑5.4**<br>**Pro** | **GPT‑5.3-Codex** | **GPT‑5.2** | **GPT‑5.2**<br>**Pro** |
| SWE-Bench Pro (Public) | 57.7% | — | 56.8% | 55.6% | — |
| Terminal-Bench 2.0 | 75.1% | — | 77.3% | 62.2% | — |

##### Computer use and vision

|     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- |
| **Eval** | **GPT‑5.4** | **GPT‑5.4**<br>**Pro** | **GPT‑5.3-Codex** | **GPT‑5.2** | **GPT‑5.2**<br>**Pro** |
| OSWorld-Verified | 75.0% | — | 74.0% | 47.3% | — |
| MMMU Pro (no tools) | 81.2% | — | — | 79.5% | — |
| MMMU Pro (with tools) | 82.1% | — | — | 80.4% | — |

##### Tool use

|     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- |
| **Eval** | **GPT‑5.4** | **GPT‑5.4**<br>**Pro** | **GPT‑5.3-Codex** | **GPT‑5.2** | **GPT‑5.2**<br>**Pro** |
| BrowseComp | 82.7% | 89.3% | 77.3% | 65.8% | 77.9% |
| MCP Atlas | 67.2% | — | — | 60.6% | — |
| Toolathlon | 54.6% | — | 51.9% | 45.7% | — |
| Tau2-bench Telecom | 98.9% | — | — | 98.7% | — |

##### Academic

|     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- |
| **Eval** | **GPT‑5.4** | **GPT‑5.4**<br>**Pro** | **GPT‑5.3-Codex** | **GPT‑5.2** | **GPT‑5.2**<br>**Pro** |
| Frontier Science Research | 33.0% | 36.7% | — | 25.2% | — |
| FrontierMath Tier 1–3 | 47.6% | 50.0% | — | 40.7% | — |
| FrontierMath Tier 4 | 27.1% | 38.0% | — | 18.8% | 31.3% |
| GPQA Diamond | 92.8% | 94.4% | 92.6% | 92.4% | 93.2% |
| Humanity's Last Exam (no tools) | 39.8% | 42.7% | — | 34.5% | 36.6% |
| Humanity's Last Exam (with tools) | 52.1% | 58.7% | — | 45.5% | 50.0% |

##### Long context

|     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- |
| **Eval** | **GPT‑5.4** | **GPT‑5.4**<br>**Pro** | **GPT‑5.3-Codex** | **GPT‑5.2** | **GPT‑5.2**<br>**Pro** |
| Graphwalks BFS 0K–128K | 93.0% | — | — | 94.0% | — |
| Graphwalks BFS 256K–1M | 21.4% | — | — | — | — |
| Graphwalks parents 0–128K (accuracy) | 89.8% | — | — | 89.0% | — |
| Graphwalks parents 256K–1M (accuracy) | 32.4% | — | — | — | — |
| OpenAI MRCR v2 8-needle 4K–8K | 97.3% | — | — | 98.2% | — |
| OpenAI MRCR v2 8-needle 8K–16K | 91.4% | — | — | 89.3% | — |
| OpenAI MRCR v2 8-needle 16K–32K | 97.2% | — | — | 95.3% | — |
| OpenAI MRCR v2 8-needle 32K–64K | 90.5% | — | — | 92.0% | — |
| OpenAI MRCR v2 8-needle 64K–128K | 86.0% | — | — | 85.6% | — |
| OpenAI MRCR v2 8-needle 128K–256K | 79.3% | — | — | 77.0% | — |
| OpenAI MRCR v2 8-needle 256K–512K | 57.5% | — | — | — | — |
| OpenAI MRCR v2 8-needle 512K–1M | 36.6% | — | — | — | — |

##### Abstract reasoning

|     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- |
| **Eval** | **GPT‑5.4** | **GPT‑5.4**<br>**Pro** | **GPT‑5.3-Codex** | **GPT‑5.2** | **GPT‑5.2**<br>**Pro** |
| ARC-AGI-1 (Verified) | 93.7% | 94.5% | — | 86.2% | 90.5% |
| ARC-AGI-2 (Verified) | 73.3% | 83.3% | — | 52.9% | 54.2% (high) |

##### Evals without reasoning

|     |     |     |     |
| --- | --- | --- | --- |
| **Eval** | **GPT‑5.4**<br>**(none)** | **GPT‑5.2**<br>**(none)** | **GPT-4.1** |
| OmniDocBench (normalized edit distance) | 0.109 | 0.140 | — |
| Tau2-bench Telecom | 64.3% | 57.2% | 43.6% |

Evals were run with reasoning effort set to xhigh, except where specified otherwise. Benchmarks were conducted in a research environment, which may provide slightly different output from production ChatGPT in some cases.

- [2026](https://openai.com/news/?tags=2026)

## Author

OpenAI

## Footnotes

1 Human performance reported in [OSWorld: Benchmarking Multimodal Agents for Open-Ended Tasks in Real Computer Environments⁠(opens in a new window)](https://arxiv.org/abs/2404.07972).

## Keep reading

[View all](https://openai.com/news/)

![Agents SDK Art Card 1080x1080](https://images.ctfassets.net/kftzwdyauwt9/5TSaPxrSFnEbj3nQWfcSmY/661e54575d7318437e10a7914d2a2777/Agents_SDK__Art_Card_1080x1080.png?w=3840&q=90&fm=webp)

[The next evolution of the Agents SDK\\
\\
ProductApr 15, 2026](https://openai.com/index/the-next-evolution-of-the-agents-sdk/)

![Frame](https://images.ctfassets.net/kftzwdyauwt9/4WgF2ZNhX87m2V41wkUHVP/f95d574cf9718ef06525350a89b7346b/Frame.png?w=3840&q=90&fm=webp)

[Codex now offers pay-as-you-go pricing for teams\\
\\
ProductApr 2, 2026](https://openai.com/index/codex-flexible-pricing-for-teams/)

![Shopping-ArtCard-1x1](https://images.ctfassets.net/kftzwdyauwt9/806BheYr2EcDfIzRdDbKI/8fd7be28e6ce0a58cfcbfbd4a256bffd/Shopping-ArtCard-1x1.png?w=3840&q=90&fm=webp)

[Powering Product Discovery in ChatGPT\\
\\
ProductMar 24, 2026](https://openai.com/index/powering-product-discovery-in-chatgpt/)