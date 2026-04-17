[![Simon Willison’s Newsletter](https://substackcdn.com/image/fetch/$s_!ghJ7!,w_40,h_40,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fe68a4ed9-6701-4ace-b17d-00a1fddab42f_450x450.png)](https://simonw.substack.com/)

# [Simon Willison’s Newsletter](https://simonw.substack.com/)

SubscribeSign in

![User's avatar](https://substackcdn.com/image/fetch/$s_!nuWX!,w_64,h_64,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F5a30d45c-fcba-407a-bebf-96f51a8944a4_48x48.jpeg)

Discover more from Simon Willison’s Newsletter

AI, LLMs, web engineering, open source, data science, Datasette, SQLite, Python and more

Over 53,000 subscribers

Subscribe

By subscribing, you agree Substack's [Terms of Use](https://substack.com/tos), and acknowledge its [Information Collection Notice](https://substack.com/ccpa#personal-data-collected) and [Privacy Policy](https://substack.com/privacy).

Already have an account? Sign in

# Agentic Engineering Patterns

### Plus vibe coding my dream macOS presentation app, Gemini 3.1 Pro and lots more

[![Simon Willison's avatar](https://substackcdn.com/image/fetch/$s_!nuWX!,w_36,h_36,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F5a30d45c-fcba-407a-bebf-96f51a8944a4_48x48.jpeg)](https://substack.com/@simonw)

[Simon Willison](https://substack.com/@simonw)

Feb 27, 2026

117

10

6

Share

In this newsletter:

- Writing about Agentic Engineering Patterns

- I vibe coded my dream macOS presentation app

- Adding TILs, releases, museums, tools and research to my blog


Plus 13 links and 7 quotations and 2 notes and 5 guide chapters

Thanks for reading Simon Willison’s Newsletter! Subscribe for free to receive new posts and support my work.

Subscribe

* * *

**Sponsored by Augment Code**: Stop juggling terminals. Living specs. Your agents. One workspace. Augment Code’s new agentic development environment is here. [Build with Intent](https://fandf.co/4rVdYEl).

* * *

### [Writing about Agentic Engineering Patterns](https://simonwillison.net/2026/Feb/23/agentic-engineering-patterns/) \- 2026-02-23

I’ve started a new project to collect and document **[Agentic Engineering Patterns](https://simonwillison.net/guides/agentic-engineering-patterns/)** \- coding practices and patterns to help get the best results out of this new era of coding agent development we find ourselves entering.

I’m using **Agentic Engineering** to refer to building software using coding agents - tools like Claude Code and OpenAI Codex, where the defining feature is that they can both generate and _execute_ code - allowing them to test that code and iterate on it independently of turn-by-turn guidance from their human supervisor.

I think of **vibe coding** using its [original definition](https://simonwillison.net/2025/Mar/19/vibe-coding/) of coding where you pay no attention to the code at all, which today is often associated with non-programmers using LLMs to write code.

Agentic Engineering represents the other end of the scale: professional software engineers using coding agents to improve and accelerate their work by amplifying their existing expertise.

There is so much to learn and explore about this new discipline! I’ve already published a lot [under my ai-assisted-programming tag](https://simonwillison.net/tags/ai-assisted-programming/) (345 posts and counting) but that’s been relatively unstructured. My new goal is to produce something that helps answer the question “how do I get good results out of this stuff” all in one place.

I’ll be developing and growing this project here on my blog as a series of chapter-shaped patterns, loosely inspired by the format popularized by [Design Patterns: Elements of Reusable Object-Oriented Software](https://en.wikipedia.org/wiki/Design_Patterns) back in 1994.

I published the first two chapters today:

- **[Writing code is cheap now](https://simonwillison.net/guides/agentic-engineering-patterns/code-is-cheap/)** talks about the central challenge of agentic engineering: the cost to churn out initial working code has dropped to almost nothing, how does that impact our existing intuitions about how we work, both individually and as a team?

- **[Red/green TDD](https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/)** describes how test-first development helps agents write more succinct and reliable code with minimal extra prompting.


I hope to add more chapters at a rate of 1-2 a week. I don’t really know when I’ll stop, there’s a lot to cover!

#### Written by me, not by an LLM

I have a strong personal policy of not publishing AI-generated writing under my own name. That policy will hold true for Agentic Engineering Patterns as well. I’ll be using LLMs for proofreading and fleshing out example code and all manner of other side-tasks, but the words you read here will be my own.

#### Chapters and Guides

Agentic Engineering Patterns isn’t exactly _a book_, but it’s kind of book-shaped. I’ll be publishing it on my site using a new shape of content I’m calling a _guide_. A guide is a collection of chapters, where each chapter is effectively a blog post with a less prominent date that’s designed to be updated over time, not frozen at the point of first publication.

Guides and chapters are my answer to the challenge of publishing “evergreen” content on a blog. I’ve been trying to find a way to do this for a while now. This feels like a format that might stick.

If you’re interested in the implementation you can find the code in the [Guide](https://github.com/simonw/simonwillisonblog/blob/b9cd41a0ac4a232b2a6c90ca3fff9ae465263b02/blog/models.py#L262-L280), [Chapter](https://github.com/simonw/simonwillisonblog/blob/b9cd41a0ac4a232b2a6c90ca3fff9ae465263b02/blog/models.py#L349-L405) and [ChapterChange](https://github.com/simonw/simonwillisonblog/blob/b9cd41a0ac4a232b2a6c90ca3fff9ae465263b02/blog/models.py#L408-L423) models and the [associated Django views](https://github.com/simonw/simonwillisonblog/blob/b9cd41a0ac4a232b2a6c90ca3fff9ae465263b02/blog/views.py#L775-L923), almost all of which was written by Claude Opus 4.6 running in Claude Code for web accessed via my iPhone.

* * *

### [I vibe coded my dream macOS presentation app](https://simonwillison.net/2026/Feb/25/present/) \- 2026-02-25

I gave a talk this weekend at Social Science FOO Camp in Mountain View. The event was a classic unconference format where anyone could present a talk without needing to propose it in advance. I grabbed a slot for a talk I titled “The State of LLMs, February 2026 edition”, subtitle “It’s all changed since November!”. I vibe coded a custom macOS app for the presentation the night before.

[![A sticky note on a board at FOO Camp. It reads: The state of LLMs, Feb 2026 edition - it's all changed since November! Simon Willison - the card is littered with names of new models: Qwen 3.5, DeepSeek 3.2, Sonnet 4.6, Kimi K2.5, GLM5, Opus 4.5/4.6, Gemini 3.1 Pro, Codex 5.3. The card next to it says Why do Social Scientists think they need genetics? Bill January (it's not all because of AI)](https://substackcdn.com/image/fetch/$s_!OM0r!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F4a1411b7-c255-4605-9a38-b2040a879fa0_1536x1086.jpeg)](https://substackcdn.com/image/fetch/$s_!OM0r!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F4a1411b7-c255-4605-9a38-b2040a879fa0_1536x1086.jpeg)

I’ve written about the last twelve months of development in LLMs in [December 2023](https://simonwillison.net/2023/Dec/31/ai-in-2023/), [December 2024](https://simonwillison.net/2024/Dec/31/llms-in-2024/) and [December 2025](https://simonwillison.net/2025/Dec/31/the-year-in-llms/). I also presented [The last six months in LLMs, illustrated by pelicans on bicycles](https://simonwillison.net/2025/Jun/6/six-months-in-llms/) at the AI Engineer World’s Fair in June 2025. This was my first time dropping the time covered to just three months, which neatly illustrates how much the space keeps accelerating and felt appropriate given the [November 2025 inflection point](https://simonwillison.net/2026/Jan/4/inflection/).

(I further illustrated this acceleration by wearing a Gemini 3 sweater to the talk, which I was given a couple of weeks ago and is already out-of-date [thanks to Gemini 3.1](https://simonwillison.net/2026/Feb/19/gemini-31-pro/).)

I always like to have at least one gimmick in any talk I give, based on the STAR moment principle I [learned at Stanford](https://simonwillison.net/2019/Dec/10/better-presentations/) \- include Something They’ll Always Remember to try and help your talk stand out.

For this talk I had two gimmicks. I built the first part of the talk around coding agent assisted data analysis of Kākāpō breeding season (which meant I got to [show off my mug](https://simonwillison.net/2026/Feb/8/kakapo-mug/)), then did a quick tour of some new pelicans riding bicycles before ending with the reveal that the entire presentation had been presented using a new macOS app I had vibe coded in ~45 minutes the night before the talk.

#### Present.app

The app is called **Present** \- literally the first name I thought of. It’s built using Swift and SwiftUI and weighs in at 355KB, or [76KB compressed](https://github.com/simonw/present/releases/tag/0.1a0). Swift apps are tiny!

It may have been quick to build but the combined set of features is something I’ve wanted for _years_.

I usually use Keynote for presentations, but sometimes I like to mix things up by presenting using a sequence of web pages. I do this by loading up a browser window with a tab for each page, then clicking through those tabs in turn while I talk.

This works great, but comes with a very scary disadvantage: if the browser crashes I’ve just lost my entire deck!

I always have the URLs in a notes file, so I can click back to that and launch them all manually if I need to, but it’s not something I’d like to deal with in the middle of a talk.

This was [my starting prompt](https://gisthost.github.io/?639d3c16dcece275af50f028b32480c7/page-001.html#msg-2026-02-21T05-53-43-395Z):

> Build a SwiftUI app for giving presentations where every slide is a URL. The app starts as a window with a webview on the right and a UI on the left for adding, removing and reordering the sequence of URLs. Then you click Play in a menu and the app goes full screen and the left and right keys switch between URLs

That produced a plan. You can see [the transcript that implemented that plan here](https://gisthost.github.io/?bfbc338977ceb71e298e4d4d5ac7d63c).

In Present a talk is an ordered sequence of URLs, with a sidebar UI for adding, removing and reordering those URLs. That’s the entirety of the editing experience.

[![Screenshot of a macOS app window titled "Present" showing Google Image search results for "kakapo". A web view shows a Google image search with thumbnail photos of kākāpō parrots with captions. A sidebar on the left shows a numbered list of URLs, mostly from simonwillison.net and static.simonwillison.net, with item 4 (https://www.google.com/search?...) highlighted in blue.](https://substackcdn.com/image/fetch/$s_!dCI-!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fc870295b-cd21-46dd-bded-c0d31f429935_2750x1954.jpeg)](https://substackcdn.com/image/fetch/$s_!dCI-!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fc870295b-cd21-46dd-bded-c0d31f429935_2750x1954.jpeg)

When you select the “Play” option in the menu (or hit Cmd+Shift+P) the app switches to full screen mode. Left and right arrow keys navigate back and forth, and you can bump the font size up and down or scroll the page if you need to. Hit Escape when you’re done.

Crucially, Present saves your URLs automatically any time you make a change. If the app crashes you can start it back up again and restore your presentation state.

You can also save presentations as a `.txt` file (literally a newline-delimited sequence of URLs) and load them back up again later.

#### Remote controlled via my phone

Getting the initial app working took so little time that I decided to get more ambitious.

It’s neat having a remote control for a presentation...

So I prompted:

> Add a web server which listens on 0.0.0.0:9123 - the web server serves a single mobile-friendly page with prominent left and right buttons - clicking those buttons switches the slide left and right - there is also a button to start presentation mode or stop depending on the mode it is in.

I have [Tailscale](https://tailscale.com/) on my laptop and my phone, which means I don’t have to worry about Wi-Fi networks blocking access between the two devices. My phone can access

http://100.122.231.116:9123/

directly from anywhere in the world and control the presentation running on my laptop.

It took a few more iterative prompts to get to the final interface, which looked like this:

[![Mobile phone web browser app with large buttons, Slide 4/31 at the top, Prev, Next and Start buttons, a thin bar with a up/down scroll icon and text size + and - buttons and the current slide URL at the bottom.](https://substackcdn.com/image/fetch/$s_!2_US!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F79465561-2d69-4a5d-9695-de32c9497b9d_1320x2162.jpeg)](https://substackcdn.com/image/fetch/$s_!2_US!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F79465561-2d69-4a5d-9695-de32c9497b9d_1320x2162.jpeg)

There’s a slide indicator at the top, prev and next buttons, a nice big “Start” button and buttons for adjusting the font size.

The most complex feature is that thin bar next to the start button. That’s a touch-enabled scroll bar - you can slide your finger up and down on it to scroll the currently visible web page up and down on the screen.

It’s _very_ clunky but it works just well enough to solve the problem of a page loading with most interesting content below the fold.

#### Learning from the code

I’d already [pushed the code to GitHub](https://github.com/simonw/present) (with a big “This app was vibe coded \[...\] I make no promises other than it worked on my machine!” disclaimer) when I realized I should probably take a look at the code.

I used this as an opportunity to document a recent pattern I’ve been using: asking the model to present a linear walkthrough of the entire codebase. Here’s the resulting [Linear walkthroughs](https://simonwillison.net/guides/agentic-engineering-patterns/linear-walkthroughs/) pattern in my ongoing [Agentic Engineering Patterns guide](https://simonwillison.net/2026/Feb/23/agentic-engineering-patterns/), including the prompt I used.

The [resulting walkthrough document](https://github.com/simonw/present/blob/main/walkthrough.md) is genuinely useful. It turns out Claude Code decided to implement the web server for the remote control feature [using socket programming without a library](https://github.com/simonw/present/blob/main/walkthrough.md#request-routing)! Here’s the minimal HTTP parser it used for routing:

```
    private func route(_ raw: String) -> String {
        let firstLine = raw.components(separatedBy: “\r\n”).first ?? “”
        let parts = firstLine.split(separator: “ “)
        let path = parts.count >= 2 ? String(parts[1]) : “/”

        switch path {
        case “/next”:
            state?.goToNext()
            return jsonResponse(”ok”)
        case “/prev”:
            state?.goToPrevious()
            return jsonResponse(”ok”)
```

Using GET requests for state changes like that opens up some fun CSRF vulnerabilities. For this particular application I don’t really care.

#### Expanding our horizons

Vibe coding stories like this are ten a penny these days. I think this one is worth sharing for a few reasons:

- Swift, a language I don’t know, was absolutely the right choice here. I wanted a full screen app that embedded web content and could be controlled over the network. Swift had everything I needed.

- When I finally did look at the code it was simple, straightforward and did exactly what I needed and not an inch more.

- This solved a real problem for me. I’ve always wanted a good way to serve a presentation as a sequence of pages, and now I have exactly that.

- I didn’t have to open Xcode even once!


This doesn’t mean native Mac developers are obsolete. I still used a whole bunch of my own accumulated technical knowledge (and the fact that I’d already installed Xcode and the like) to get this result, and someone who knew what they were doing could have built a far better solution in the same amount of time.

It’s a neat illustration of how those of us with software engineering experience can expand our horizons in fun and interesting directions. I’m no longer afraid of Swift! Next time I need a small, personal macOS app I know that it’s achievable with our existing set of tools.

* * *

### [Adding TILs, releases, museums, tools and research to my blog](https://simonwillison.net/2026/Feb/20/beats/) \- 2026-02-20

I’ve been wanting to add indications of my various other online activities to my blog for a while now. I just turned on a new feature I’m calling “beats” (after story beats, naming this was hard!) which adds five new types of content to my site, all corresponding to activity elsewhere.

Here’s what beats look like:

[![Screenshot of a fragment of a page showing three entries from 30th Dec 2025. First: [RELEASE] "datasette-turnstile 0.1a0 — Configurable CAPTCHAs for Datasette paths usin…" at 7:23 pm. Second: [TOOL] "Software Heritage Repository Retriever — Download archived Git repositories f…" at 11:41 pm. Third: [TIL] "Downloading archived Git repositories from archive.softwareheritage.org — …" at 11:43 pm.](https://substackcdn.com/image/fetch/$s_!qtTk!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Ffd88c3e3-99cf-4622-ba62-934e78cb3c57_1186x412.jpeg)](https://substackcdn.com/image/fetch/$s_!qtTk!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Ffd88c3e3-99cf-4622-ba62-934e78cb3c57_1186x412.jpeg)

Those three are from [the 30th December 2025](https://simonwillison.net/2025/Dec/30/) archive page.

Beats are little inline links with badges that fit into different content timeline views around my site, including the homepage, search and archive pages.

There are currently five types of beats:

- [Releases](https://simonwillison.net/elsewhere/release/) are GitHub releases of my many different open source projects, imported from [this JSON file](https://github.com/simonw/simonw/blob/main/releases_cache.json) that was constructed [by GitHub Actions](https://simonwillison.net/2020/Jul/10/self-updating-profile-readme/).

- [TILs](https://simonwillison.net/elsewhere/til/) are the posts from my [TIL blog](https://til.simonwillison.net/), imported using [a SQL query over JSON and HTTP](https://github.com/simonw/simonwillisonblog/blob/f883b92be23892d082de39dbada571e406f5cfbf/blog/views.py#L1169) against the Datasette instance powering that site.

- [Museums](https://simonwillison.net/elsewhere/museum/) are new posts on my [niche-museums.com](https://www.niche-museums.com/) blog, imported from [this custom JSON feed](https://github.com/simonw/museums/blob/909bef71cc8d336bf4ac1f13574db67a6e1b3166/plugins/export.py).

- [Tools](https://simonwillison.net/elsewhere/tool/) are HTML and JavaScript tools I’ve vibe-coded on my [tools.simonwillison.net](https://tools.simonwillison.net/) site, as described in [Useful patterns for building HTML tools](https://simonwillison.net/2025/Dec/10/html-tools/).

- [Research](https://simonwillison.net/elsewhere/research/) is for AI-generated research projects, hosted in my [simonw/research repo](https://github.com/simonw/research) and described in [Code research projects with async coding agents like Claude Code and Codex](https://simonwillison.net/2025/Nov/6/async-code-research/).


That’s five different custom integrations to pull in all of that data. The good news is that this kind of integration project is the kind of thing that coding agents _really_ excel at. I knocked most of the feature out in a single morning while working in parallel on various other things.

I didn’t have a useful structured feed of my Research projects, and it didn’t matter because I gave Claude Code a link to [the raw Markdown README](https://raw.githubusercontent.com/simonw/research/refs/heads/main/README.md) that lists them all and it [spun up a parser regex](https://github.com/simonw/simonwillisonblog/blob/f883b92be23892d082de39dbada571e406f5cfbf/blog/importers.py#L77-L80). Since I’m responsible for both the source and the destination I’m fine with a brittle solution that would be too risky against a source that I don’t control myself.

Claude also handled all of the potentially tedious UI integration work with my site, making sure the new content worked on all of my different page types and was handled correctly by my [faceted search engine](https://simonwillison.net/2017/Oct/5/django-postgresql-faceted-search/).

#### Prototyping with Claude Artifacts

I actually prototyped the initial concept for beats in regular Claude - not Claude Code - taking advantage of the fact that it can clone public repos from GitHub these days. I started with:

> `Clone simonw/simonwillisonblog and tell me about the models and views`

And then later in the brainstorming session said:

> `use the templates and CSS in this repo to create a new artifact with all HTML and CSS inline that shows me my homepage with some of those inline content types mixed in`

After some iteration we got to [this artifact mockup](https://gisthost.github.io/?c3f443cc4451cf8ce03a2715a43581a4/preview.html), which was enough to convince me that the concept had legs and was worth handing over to full [Claude Code for web](https://code.claude.com/docs/en/claude-code-on-the-web) to implement.

If you want to see how the rest of the build played out the most interesting PRs are [Beats #592](https://github.com/simonw/simonwillisonblog/pull/592) which implemented the core feature and [Add Museums Beat importer #595](https://github.com/simonw/simonwillisonblog/pull/595/changes) which added the Museums content type.

* * *

**Link** 2026-02-18 [The A.I. Disruption We’ve Been Waiting for Has Arrived](https://www.nytimes.com/2026/02/18/opinion/ai-software.html?unlocked_article_code=1.NFA.UkLv.r-XczfzYRdXJ&smid=url-share):

New opinion piece from Paul Ford in the New York Times. Unsurprisingly for a piece by Paul it’s packed with quoteworthy snippets, but a few stood out for me in particular.

Paul describes the [November moment](https://simonwillison.net/2026/Jan/4/inflection/) that so many other programmers have observed, and highlights Claude Code’s ability to revive old side projects:

> \[Claude Code\] was always a helpful coding assistant, but in November it suddenly got much better, and ever since I’ve been knocking off side projects that had sat in folders for a decade or longer. It’s fun to see old ideas come to life, so I keep a steady flow. Maybe it adds up to a half-hour a day of my time, and an hour of Claude’s.
>
> November was, for me and many others in tech, a great surprise. Before, A.I. coding tools were often useful, but halting and clumsy. Now, the bot can run for a full hour and make whole, designed websites and apps that may be flawed, but credible. I spent an entire session of therapy talking about it.

And as the former CEO of a respected consultancy firm (Postlight) he’s well positioned to evaluate the potential impact:

> When you watch a large language model slice through some horrible, expensive problem — like migrating data from an old platform to a modern one — you feel the earth shifting. I was the chief executive of a software services firm, which made me a professional software cost estimator. When I rebooted my messy personal website a few weeks ago, I realized: I would have paid $25,000 for someone else to do this. When a friend asked me to convert a large, thorny data set, I downloaded it, cleaned it up and made it pretty and easy to explore. In the past I would have charged $350,000.
>
> That last price is full 2021 retail — it implies a product manager, a designer, two engineers (one senior) and four to six months of design, coding and testing. Plus maintenance. Bespoke software is joltingly expensive. Today, though, when the stars align and my prompts work out, I can do hundreds of thousands of dollars worth of work for fun (fun for me) over weekends and evenings, for the price of the Claude $200-a-month plan.

He also neatly captures the inherent community tension involved in exploring this technology:

> All of the people I love hate this stuff, and all the people I hate love it. And yet, likely because of the same personality flaws that drew me to technology in the first place, I am annoyingly excited.

* * *

**Link** 2026-02-19 [Gemini 3.1 Pro](https://blog.google/innovation-and-ai/models-and-research/gemini-models/gemini-3-1-pro/):

The first in the Gemini 3.1 series, priced the same as Gemini 3 Pro ($2/million input, $12/million output under 200,000 tokens, $4/$18 for 200,000 to 1,000,000). That’s less than half the price of Claude Opus 4.6 with very similar benchmark scores to that model.

They boast about its improved SVG animation performance compared to Gemini 3 Pro in the announcement!

I tried “Generate an SVG of a pelican riding a bicycle” [in Google AI Studio](https://aistudio.google.com/app/prompts?state=%7B%22ids%22:%5B%221ugF9fBfLGxnNoe8_rLlluzo9NSPJDWuF%22%5D,%22action%22:%22open%22,%22userId%22:%22106366615678321494423%22,%22resourceKeys%22:%7B%7D%7D&usp=sharing) and it thought for 323.9 seconds ( [thinking trace here](https://gist.github.com/simonw/03a755865021739a3659943a22c125ba#thinking-trace)) before producing this one:

[![Whimsical flat-style illustration of a pelican wearing a blue and white baseball cap, riding a red bicycle with yellow-rimmed wheels along a road. The pelican has a large orange bill and a green scarf. A small fish peeks out of a brown basket on the handlebars. The background features a light blue sky with a yellow sun, white clouds, and green hills.](https://substackcdn.com/image/fetch/$s_!kVoO!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F5b728c61-3cf1-4f71-b48f-81f2939228dc_800x600.png)](https://substackcdn.com/image/fetch/$s_!kVoO!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F5b728c61-3cf1-4f71-b48f-81f2939228dc_800x600.png)

It’s good to see the legs clearly depicted on both sides of the frame (should [satisfy Elon](https://twitter.com/elonmusk/status/2023833496804839808)), the fish in the basket is a nice touch and I appreciated this comment in [the SVG code](https://gist.github.com/simonw/03a755865021739a3659943a22c125ba#response):

```
<!-- Black Flight Feathers on Wing Tip -->
<path d="M 420 175 C 440 182, 460 187, 470 190 C 450 210, 430 208, 410 198 Z" fill="#374151" />
```

I’ve [added](https://github.com/simonw/llm-gemini/issues/121) the two new model IDs `gemini-3.1-pro-preview` and `gemini-3.1-pro-preview-customtools` to my [llm-gemini plugin](https://github.com/simonw/llm-gemini) for [LLM](https://llm.datasette.io/). That “custom tools” one is [described here](https://ai.google.dev/gemini-api/docs/models/gemini-3.1-pro-preview#gemini-31-pro-preview-customtools) \- apparently it may provide better tool performance than the default model in some situations.

The model appears to be _incredibly_ slow right now - it took 104s to respond to a simple “hi” and a few of my other tests met “Error: This model is currently experiencing high demand. Spikes in demand are usually temporary. Please try again later.” or “Error: Deadline expired before operation could complete” errors. I’m assuming that’s just teething problems on launch day.

It sounds like last week’s [Deep Think release](https://simonwillison.net/2026/Feb/12/gemini-3-deep-think/) was our first exposure to the 3.1 family:

> Last week, we released a major update to Gemini 3 Deep Think to solve modern challenges across science, research and engineering. Today, we’re releasing the upgraded core intelligence that makes those breakthroughs possible: Gemini 3.1 Pro.

**Update**: In [What happens if AI labs train for pelicans riding bicycles?](https://simonwillison.net/2025/nov/13/training-for-pelicans-riding-bicycles/) last November I said:

> If a model finally comes out that produces an excellent SVG of a pelican riding a bicycle you can bet I’m going to test it on all manner of creatures riding all sorts of transportation devices.

Google’s Gemini Lead Jeff Dean [tweeted this video](https://x.com/JeffDean/status/2024525132266688757) featuring an animated pelican riding a bicycle, plus a frog on a penny-farthing and a giraffe driving a tiny car and an ostrich on roller skates and a turtle kickflipping a skateboard and a dachshund driving a stretch limousine.

I’ve been saying for a while that I wish AI labs would highlight things that their new models can do that their older models could not, so top marks to the Gemini team for this video.

**Update 2**: I used `llm-gemini` to run my [more detailed Pelican prompt](https://simonwillison.net/2025/Nov/18/gemini-3/#and-a-new-pelican-benchmark), with [this result](https://gist.github.com/simonw/a3bdd4ec9476ba9e9ba7aa61b46d8296):

[![Flat-style illustration of a brown pelican riding a teal bicycle with dark blue-rimmed wheels against a plain white background. Unlike the previous image's white cartoon pelican, this pelican has realistic brown plumage with detailed feather patterns, a dark maroon head, yellow eye, and a large pink-tinged pouch bill. The bicycle is a simpler design without a basket, and the scene lacks the colorful background elements like the sun, clouds, road, hills, cap, and scarf from the first illustration, giving it a more minimalist feel.](https://substackcdn.com/image/fetch/$s_!sN9J!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F00ac13d9-d40a-448b-963c-cd535390b8d8_800x600.png)](https://substackcdn.com/image/fetch/$s_!sN9J!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F00ac13d9-d40a-448b-963c-cd535390b8d8_800x600.png)

From the SVG comments:

```
<!-- Pouch Gradient (Breeding Plumage: Red to Olive/Green) -->
...
<!-- Neck Gradient (Breeding Plumage: Chestnut Nape, White/Yellow Front) -->
```

* * *

**Note** [2026-02-19](https://simonwillison.net/2026/Feb/19/recovering-lost-code/)

Reached the stage of parallel agent psychosis where I’ve lost a whole feature - I know I had it yesterday, but I can’t seem to find the branch or worktree or cloud instance or checkout with it in.

... found it! Turns out I’d been hacking on a random prototype in `/tmp` and then my computer crashed and rebooted and I lost the code... but it’s all still there in `~/.claude/projects/` session logs and Claude Code can extract it out and spin up the missing feature again.

* * *

**Quote** 2026-02-20

> Long running agentic products like Claude Code are made feasible by prompt caching which allows us to reuse computation from previous roundtrips and significantly decrease latency and cost. \[...\]
>
> At Claude Code, we build our entire harness around prompt caching. A high prompt cache hit rate decreases costs and helps us create more generous rate limits for our subscription plans, so we run alerts on our prompt cache hit rate and declare SEVs if they’re too low.

[Thariq Shihipar](https://twitter.com/trq212/status/2024574133011673516)

* * *

**Link** 2026-02-20 [ggml.ai joins Hugging Face to ensure the long-term progress of Local AI](https://github.com/ggml-org/llama.cpp/discussions/19759):

I don’t normally cover acquisition news like this, but I have some thoughts.

It’s hard to overstate the impact Georgi Gerganov has had on the local model space. Back in March 2023 his release of [llama.cpp](https://github.com/ggml-org/llama.cpp) made it possible to run a local LLM on consumer hardware. The [original README](https://github.com/ggml-org/llama.cpp/blob/775328064e69db1ebd7e19ccb59d2a7fa6142470/README.md?plain=1#L7) said:

> The main goal is to run the model using 4-bit quantization on a MacBook. \[...\] This was hacked in an evening - I have no idea if it works correctly.

I wrote about trying llama.cpp out at the time in [Large language models are having their Stable Diffusion moment](https://simonwillison.net/2023/Mar/11/llama/#llama-cpp):

> I used it to run the 7B LLaMA model on my laptop last night, and then this morning upgraded to the 13B model—the one that Facebook claim is competitive with GPT-3.

Meta’s [original LLaMA release](https://github.com/meta-llama/llama/tree/llama_v1) depended on PyTorch and their [FairScale](https://github.com/facebookresearch/fairscale) PyTorch extension for running on multiple GPUs, and required CUDA and NVIDIA hardware. Georgi’s work opened that up to a much wider range of hardware and kicked off the local model movement that has continued to grow since then.

Hugging Face are already responsible for the incredibly influential [Transformers](https://github.com/huggingface/transformers) library used by the majority of LLM releases today. They’ve proven themselves a good steward for that open source project, which makes me optimistic for the future of llama.cpp and related projects.

This section from the announcement looks particularly promising:

> Going forward, our joint efforts will be geared towards the following objectives:
>
> - Towards seamless “single-click” integration with the [transformers](https://github.com/huggingface/transformers) library. The `transformers` framework has established itself as the ‘source of truth’ for AI model definitions. Improving the compatibility between the transformers and the ggml ecosystems is essential for wider model support and quality control.
>
> - Better packaging and user experience of ggml-based software. As we enter the phase in which local inference becomes a meaningful and competitive alternative to cloud inference, it is crucial to improve and simplify the way in which casual users deploy and access local models. We will work towards making llama.cpp ubiquitous and readily available everywhere, and continue partnering with great downstream projects.

Given the influence of Transformers, this closer integration could lead to model releases that are compatible with the GGML ecosystem out of the box. That would be a big win for the local model ecosystem.

I’m also excited to see investment in “packaging and user experience of ggml-based software”. This has mostly been left to tools like [Ollama](https://ollama.com/) and [LM Studio](https://lmstudio.ai/). ggml-org released [LlamaBarn](https://github.com/ggml-org/LlamaBarn) last year - “a macOS menu bar app for running local LLMs” - and I’m hopeful that further investment in this area will result in more high quality open source tools for running local models from the team best placed to deliver them.

* * *

**Link** 2026-02-20 [Taalas serves Llama 3.1 8B at 17,000 tokens/second](https://taalas.com/the-path-to-ubiquitous-ai/):

This new Canadian hardware startup just announced their first product - a custom hardware implementation of the Llama 3.1 8B model (from [July 2024](https://simonwillison.net/2024/Jul/23/introducing-llama-31/)) that can run at a staggering 17,000 tokens/second.

I was going to include a video of their demo but it’s so fast it would look more like a screenshot. You can try it out at [chatjimmy.ai](https://chatjimmy.ai/).

They describe their Silicon Llama as “aggressively quantized, combining 3-bit and 6-bit parameters.” Their next generation will use 4-bit - presumably they have quite a long lead time for baking out new models!

* * *

**Link** 2026-02-21 [Andrej Karpathy talks about “Claws”](https://twitter.com/karpathy/status/2024987174077432126):

Andrej Karpathy tweeted a mini-essay about buying a Mac Mini (”The apple store person told me they are selling like hotcakes and everyone is confused”) to tinker with Claws:

> I’m definitely a bit sus’d to run OpenClaw specifically \[...\] But I do love the concept and I think that just like LLM agents were a new layer on top of LLMs, Claws are now a new layer on top of LLM agents, taking the orchestration, scheduling, context, tool calls and a kind of persistence to a next level.
>
> Looking around, and given that the high level idea is clear, there are a lot of smaller Claws starting to pop out. For example, on a quick skim NanoClaw looks really interesting in that the core engine is ~4000 lines of code (fits into both my head and that of AI agents, so it feels manageable, auditable, flexible, etc.) and runs everything in containers by default. \[...\]
>
> Anyway there are many others - e.g. nanobot, zeroclaw, ironclaw, picoclaw (lol @ prefixes). \[...\]
>
> Not 100% sure what my setup ends up looking like just yet but Claws are an awesome, exciting new layer of the AI stack.

Andrej has an ear for fresh terminology (see [vibe coding](https://simonwillison.net/2025/Mar/19/vibe-coding/), [agentic engineering](https://simonwillison.net/2026/Feb/11/glm-5/)) and I think he’s right about this one, too: “ **Claw**“ is becoming a term of art for the entire category of OpenClaw-like agent systems - AI agents that generally run on personal hardware, communicate via messaging protocols and can both act on direct instructions and schedule tasks.

It even comes with an established emoji 🦞

* * *

**Quote** 2026-02-21

> We’ve made GPT-5.3-Codex-Spark about 30% faster. It is now serving at over 1200 tokens per second.

[Thibault Sottiaux](https://twitter.com/thsottiaux/status/2024947946849186064), OpenAI

* * *

**Link** 2026-02-22 [How I think about Codex](https://www.linkedin.com/pulse/how-i-think-codex-gabriel-chua-ukhic):

Gabriel Chua (Developer Experience Engineer for APAC at OpenAI) provides his take on the confusing terminology behind the term “Codex”, which can refer to a bunch of of different things within the OpenAI ecosystem:

> In plain terms, Codex is OpenAI’s software engineering agent, available through multiple interfaces, and an agent is a model plus instructions and tools, wrapped in a runtime that can execute tasks on your behalf. \[...\]
>
> At a high level, I see Codex as three parts working together:
>
> _Codex = Model + Harness + Surfaces_ \[...\]
>
> - Model + Harness = the Agent
>
> - Surfaces = how you interact with the Agent

He defines the harness as “the collection of instructions and tools”, which is notably open source and lives in the [openai/codex](https://github.com/openai/codex) repository.

Gabriel also provides the first acknowledgment I’ve seen from an OpenAI insider that the Codex model family are directly trained for the Codex harness:

> Codex models are trained in the presence of the harness. Tool use, execution loops, compaction, and iterative verification aren’t bolted on behaviors — they’re part of how the model learns to operate. The harness, in turn, is shaped around how the model plans, invokes tools, and recovers from failure.

* * *

**Link** 2026-02-22 [London Stock Exchange: Raspberry Pi Holdings plc](https://www.londonstockexchange.com/stock/RPI/raspberry-pi-holdings-plc/company-page):

Striking graph illustrating stock in the UK Raspberry Pi holding company spiking on Tuesday:

[![Stock price line chart for RASPBERRY PI showing a 3-month daily view from 24 Nov to 16 Feb. The price trends downward from around 325 to a low near 260, then sharply spikes upward. A tooltip highlights ](https://substackcdn.com/image/fetch/$s_!PXyV!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F94a1e345-e0db-41c3-89f9-e25cb3283ae3_1320x1387.jpeg)](https://substackcdn.com/image/fetch/$s_!PXyV!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F94a1e345-e0db-41c3-89f9-e25cb3283ae3_1320x1387.jpeg)

The Telegraph [credited excitement around OpenClaw](https://finance.yahoo.com/news/british-computer-maker-soars-ai-141836041.html):

> Raspberry Pi’s stock price has surged 30pc in two days, amid chatter on social media that the company’s tiny computers can be used to power a popular AI chatbot.
>
> Users have turned to Raspberry Pi’s small computers to run a technology known as OpenClaw, [a viral AI personal assistant](https://www.telegraph.co.uk/business/2026/02/07/i-built-a-whatsapp-bot-and-now-it-runs-my-entire-life/). A flood of posts about the practice have been viewed millions of times since the weekend.

Reuters [also credit a stock purchase by CEO Eben Upton](https://finance.yahoo.com/news/raspberry-pi-soars-40-ceo-151342904.html):

> Shares in Raspberry Pi rose as much as 42% on Tuesday in ‌a record two‑day rally after CEO Eben Upton bought ‌stock in the beaten‑down UK computer hardware firm, halting a months‑long slide, ​as chatter grew that its products could benefit from low‑cost artificial‑intelligence projects.
>
> Two London traders said the driver behind the surge was not clear, though the move followed a filing showing Upton bought ‌about 13,224 pounds ⁠worth of shares at around 282 pence each on Monday.

* * *

**Link** 2026-02-22 [The Claude C Compiler: What It Reveals About the Future of Software](https://www.modular.com/blog/the-claude-c-compiler-what-it-reveals-about-the-future-of-software):

On February 5th Anthropic’s Nicholas Carlini wrote about a project to use [parallel Claudes to build a C compiler](https://www.anthropic.com/engineering/building-c-compiler) on top of the brand new Opus 4.6

Chris Lattner (Swift, LLVM, Clang, Mojo) knows more about C compilers than most. He just published this review of the code.

Some points that stood out to me:

> - Good software depends on judgment, communication, and clear abstraction. AI has amplified this.
>
> - AI coding is automation of implementation, so design and stewardship become more important.
>
> - Manual rewrites and translation work are becoming AI-native tasks, automating a large category of engineering effort.

Chris is generally impressed with CCC (the Claude C Compiler):

> Taken together, CCC looks less like an experimental research compiler and more like a competent textbook implementation, the sort of system a strong undergraduate team might build early in a project before years of refinement. That alone is remarkable.

It’s a long way from being a production-ready compiler though:

> Several design choices suggest optimization toward passing tests rather than building general abstractions like a human would. \[...\] These flaws are informative rather than surprising, suggesting that current AI systems excel at assembling known techniques and optimizing toward measurable success criteria, while struggling with the open-ended generalization required for production-quality systems.

The project also leads to deep open questions about how agentic engineering interacts with licensing and IP for both open source and proprietary code:

> If AI systems trained on decades of publicly available code can reproduce familiar structures, patterns, and even specific implementations, where exactly is the boundary between learning and copying?

* * *

[Agentic Engineering Patterns](https://simonwillison.net/guides/agentic-engineering-patterns/) >

### [Red/green TDD](https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/) \- 2026-02-23

“ **Use red/green TDD**“ is a pleasingly succinct way to get better results out of a coding agent.

TDD stands for Test Driven Development. It’s a programming style where you ensure every piece of code you write is accompanied by automated tests that demonstrate the code works.

The most disciplined form of TDD is test-first development. You write the automated tests first, confirm that they fail, then iterate on the implementation until the tests pass. \[... [279 words](https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/)\]

* * *

**Quote** 2026-02-23

> Nothing humbles you like telling your OpenClaw “confirm before acting” and watching it speedrun deleting your inbox. I couldn’t stop it from my phone. I had to RUN to my Mac mini like I was defusing a bomb.
>
> [![Screenshot of a WhatsApp or similar messaging conversation showing a user repeatedly trying to stop an AI agent (appearing to be ](https://substackcdn.com/image/fetch/$s_!lBpG!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fffc15897-fe54-48c8-a51b-37c98829f515_1200x600.jpeg)](https://substackcdn.com/image/fetch/$s_!lBpG!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fffc15897-fe54-48c8-a51b-37c98829f515_1200x600.jpeg)
>
> I said “Check this inbox too and suggest what you would archive or delete, don’t action until I tell you to.” This has been working well for my toy inbox, but my real inbox was too huge and triggered compaction. During the compaction, it lost my original instruction 🤦‍♀️

[Summer Yue](https://twitter.com/summeryue0/status/2025836517831405980)

* * *

**Note** [2026-02-23](https://simonwillison.net/2026/Feb/23/reply-guy/)

The latest scourge of Twitter is AI bots that reply to your tweets with generic, banal commentary slop, often accompanied by a question to “drive engagement” and waste as much of your time as possible.

I just [found out](https://twitter.com/simonw/status/2025918174894673986) that the category name for this genre of software is **reply guy** tools. Amazing.

* * *

**Quote** 2026-02-23

> The paper asked me to explain vibe coding, and I did so, because I think something big is coming there, and I’m deep in, and I worry that normal people are not able to see it and I want them to be prepared. But people can’t just read something and hate you quietly; they can’t see that you have provided them with a utility or a warning; they need their screech. You are distributed to millions of people, and become the local proxy for the emotions of maybe dozens of people, who disagree and demand your attention, and because you are the one in the paper you need to welcome them with a pastor’s smile and deep empathy, and if you speak a word in your own defense they’ll screech even louder.

[Paul Ford](https://ftrain.com/leading-thoughts), on writing about vibe coding for the New York Times

* * *

[Agentic Engineering Patterns](https://simonwillison.net/guides/agentic-engineering-patterns/) >

### [Writing code is cheap now](https://simonwillison.net/guides/agentic-engineering-patterns/code-is-cheap/) \- 2026-02-23

The biggest challenge in adopting agentic engineering practices is getting comfortable with the consequences of the fact that _writing code is cheap now_.

Code has always been expensive. Producing a few hundred lines of clean, tested code takes most software developers a full day or more. Many of our engineering habits, at both the macro and micro level, are built around this core constraint.

At the macro level we spend a great deal of time designing, estimating and planning out projects, to ensure that our expensive coding time is spent as efficiently as possible. Product feature ideas are evaluated in terms of how much value they can provide _in exchange for that time_ \- a feature needs to earn its development costs many times over to be worthwhile! \[... [661 words](https://simonwillison.net/guides/agentic-engineering-patterns/code-is-cheap/)\]

* * *

**Link** 2026-02-23 [Ladybird adopts Rust, with help from AI](https://ladybird.org/posts/adopting-rust/):

Really interesting case-study from Andreas Kling on advanced, sophisticated use of coding agents for ambitious coding projects with critical code. After a few years hoping Swift’s platform support outside of the Apple ecosystem would mature they switched tracks to Rust their memory-safe language of choice, starting with an AI-assisted port of a critical library:

> Our first target was **LibJS** , Ladybird’s JavaScript engine. The lexer, parser, AST, and bytecode generator are relatively self-contained and have extensive test coverage through [test262](https://github.com/tc39/test262), which made them a natural starting point.
>
> I used [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and [Codex](https://openai.com/codex/) for the translation. This was human-directed, not autonomous code generation. I decided what to port, in what order, and what the Rust code should look like. It was hundreds of small prompts, steering the agents where things needed to go. \[...\]
>
> The requirement from the start was byte-for-byte identical output from both pipelines. The result was about 25,000 lines of Rust, and the entire port took about two weeks. The same work would have taken me multiple months to do by hand. We’ve verified that every AST produced by the Rust parser is identical to the C++ one, and all bytecode generated by the Rust compiler is identical to the C++ compiler’s output. Zero regressions across the board.

Having an existing conformance testing suite of the quality of `test262` is a huge unlock for projects of this magnitude, and the ability to compare output with an existing trusted implementation makes agentic engineering much more of a safe bet.

* * *

[Agentic Engineering Patterns](https://simonwillison.net/guides/agentic-engineering-patterns/) >

### [First run the tests](https://simonwillison.net/guides/agentic-engineering-patterns/first-run-the-tests/) \- 2026-02-24

Automated tests are no longer optional when working with coding agents.

The old excuses for not writing them - that they’re time consuming and expensive to constantly rewrite while a codebase is rapidly evolving - no longer hold when an agent can knock them into shape in just a few minutes.

They’re also _vital_ for ensuring AI-generated code does what it claims to do. If the code has never been executed it’s pure luck if it actually works when deployed to production. \[... [355 words](https://simonwillison.net/guides/agentic-engineering-patterns/first-run-the-tests/)\]

* * *

**Link** 2026-02-24 [go-size-analyzer](https://github.com/Zxilly/go-size-analyzer):

The Go ecosystem is _really_ good at tooling. I just learned about this tool for analyzing the size of Go binaries using a pleasing treemap view of their bundled dependencies.

You can install and run the tool locally, but it’s also compiled to WebAssembly and hosted at [gsa.zxilly.dev](https://gsa.zxilly.dev/) \- which means you can open compiled Go binaries and analyze them directly in your browser.

I tried it with a 8.1MB macOS compiled copy of my Go [Showboat](https://github.com/simonw/showboat) tool and got this:

). A tooltip is visible over \_\_zdebug\_line \_\_DWARF showing: Section: \_\_zdebug\_line \_\_DWARF, Size: 404.44 KB, File Size: 404.44 KB, Known size: 0 B, Unknown size: 404.44 KB, Offset: 0x52814a – 0x58d310, Address: 0x1005c014a – 0x1005c5310, Memory: false, Debug: true. The treemap uses green for main/generated packages, blue-gray for unknown sections, and shades of purple/pink for standard library packages.”>

[![Treemap visualization of a Go binary named ](https://substackcdn.com/image/fetch/$s_!VFZI!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fa8255f5b-5865-494c-8fd7-b3496afe3599_2530x1852.jpeg)](https://substackcdn.com/image/fetch/$s_!VFZI!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fa8255f5b-5865-494c-8fd7-b3496afe3599_2530x1852.jpeg)

* * *

[Agentic Engineering Patterns](https://simonwillison.net/guides/agentic-engineering-patterns/) >

### [Linear walkthroughs](https://simonwillison.net/guides/agentic-engineering-patterns/linear-walkthroughs/) \- 2026-02-25

Sometimes it’s useful to have a coding agent give you a structured walkthrough of a codebase.

Maybe it’s existing code you need to get up to speed on, maybe it’s your own code that you’ve forgotten the details of, or maybe you vibe coded the whole thing and need to understand how it actually works.

Frontier models with the right agent harness can construct a detailed walkthrough to help you understand how code works. \[... [525 words](https://simonwillison.net/guides/agentic-engineering-patterns/linear-walkthroughs/)\]

* * *

**Quote** 2026-02-25

> It’s also reasonable for people who entered technology in the last couple of decades because it was good job, or because they enjoyed coding to look at this moment with a real feeling of loss. That feeling of loss though can be hard to understand emotionally for people my age who entered tech because we were addicted to feeling of agency it gave us. The web was objectively awful as a technology, and genuinely amazing, and nobody got into it because programming in Perl was somehow aesthetically delightful.

[Kellan Elliott-McCrea](https://laughingmeme.org/2026/02/09/code-has-always-been-the-easy-part.html), Code has _always_ been the easy part

* * *

**Link** 2026-02-25 [Claude Code Remote Control](https://code.claude.com/docs/en/remote-control):

New Claude Code feature dropped yesterday: you can now run a “remote control” session on your computer and then use the Claude Code for web interfaces (on web, iOS and native desktop app) to send prompts to that session.

It’s a little bit janky right now. Initially when I tried it I got the error “Remote Control is not enabled for your account. Contact your administrator.” (but I _am_ my administrator?) - then I logged out and back into the Claude Code terminal app and it started working:

```
claude remote-control
```

You can only run one session on your machine at a time. If you upgrade the Claude iOS app it then shows up as “Remote Control Session (Mac)” in the Code tab.

It appears not to support the `--dangerously-skip-permissions` flag (I passed that to `claude remote-control` and it didn’t reject the option, but it also appeared to have no effect) - which means you have to approve every new action it takes.

I also managed to get it to a state where every prompt I tried was met by an API 500 error.

[![Screenshot of a "Remote Control session" (Mac:dev:817b) chat interface. User message: "Play vampire by Olivia Rodrigo in music app". Response shows an API Error: 500 {"type":"error","error":{"type":"api_error","message":"Internal server error"},"request_id":"req_011CYVBLH9yt2ze2qehrX8nk"} with a "Try again" button. Below, the assistant responds: "I'll play "Vampire" by Olivia Rodrigo in the Music app using AppleScript." A Bash command panel is open showing an osascript command: osascript -e 'tell application "Music" activate set searchResults to search playlist "Library" for "vampire Olivia Rodrigo" if (count of searchResults) > 0 then play item 1 of searchResults else return "Song not found in library" end if end tell'](https://substackcdn.com/image/fetch/$s_!78cZ!,w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fe5ddb36f-67f0-4a72-990d-b919600a78ea_1320x2397.jpeg)](https://substackcdn.com/image/fetch/$s_!78cZ!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fe5ddb36f-67f0-4a72-990d-b919600a78ea_1320x2397.jpeg)

Restarting the program on the machine also causes existing sessions to start returning mysterious API errors rather than neatly explaining that the session has terminated.

I expect they’ll iron out all of these issues relatively quickly. It’s interesting to then contrast this to solutions like OpenClaw, where one of the big selling points is the ability to control your personal device from your phone.

Claude Code still doesn’t have a documented mechanism for running things on a schedule, which is the other killer feature of the Claw category of software.

**Update**: I spoke too soon: also today Anthropic announced [Schedule recurring tasks in Cowork](https://support.claude.com/en/articles/13854387-schedule-recurring-tasks-in-cowork), Claude Code’s [general agent sibling](https://simonwillison.net/2026/Jan/12/claude-cowork/). These do include an important limitation:

> Scheduled tasks only run while your computer is awake and the Claude Desktop app is open. If your computer is asleep or the app is closed when a task is scheduled to run, Cowork will skip the task, then run it automatically once your computer wakes up or you open the desktop app again.

I really hope they’re working on a Cowork Cloud product.

* * *

**Link** 2026-02-25 [tldraw issue: Move tests to closed source repo](https://github.com/tldraw/tldraw/issues/8082):

It’s become very apparent over the past few months that a comprehensive test suite is enough to build a completely fresh implementation of any open source library from scratch, potentially in a different language.

This has worrying implications for open source projects with commercial business models. Here’s an example of a response: tldraw, the outstanding collaborative drawing library (see [previous coverage](https://simonwillison.net/2023/Nov/16/tldrawdraw-a-ui/)), are moving their test suite to a private repository - apparently in response to [Cloudflare’s project to port Next.js to use Vite in a week using AI](https://blog.cloudflare.com/vinext/).

They also filed a joke issue, now closed to [Translate source code to Traditional Chinese](https://github.com/tldraw/tldraw/issues/8092):

> The current tldraw codebase is in English, making it easy for external AI coding agents to replicate. It is imperative that we defend our intellectual property.

Worth noting that tldraw aren’t technically open source - their [custom license](https://github.com/tldraw/tldraw?tab=License-1-ov-file#readme) requires a commercial license if you want to use it in “production environments”.

**Update**: Well this is embarrassing, it turns out the issue I linked to about removing the tests was [a joke as well](https://github.com/tldraw/tldraw/issues/8082#issuecomment-3964650501):

> Sorry folks, this issue was more of a joke (am I allowed to do that?) but I’ll keep the issue open since there’s some discussion here. Writing from mobile
>
> - moving our tests into another repo would complicate and slow down our development, and speed for us is more important than ever
>
> - more canvas better, I know for sure that our decisions have inspired other products and that’s fine and good
>
> - tldraw itself may eventually be a vibe coded alternative to tldraw
>
> - the value is in the ability to produce new and good product decisions for users / customers, however you choose to create the code

* * *

**Quote** 2026-02-26

> If people are only using this a couple of times a week at most, and can’t think of anything to do with it on the average day, it hasn’t changed their life. OpenAI itself admits the problem, talking about a ‘capability gap’ between what the models can do and what people do with them, which seems to me like a way to avoid saying that you don’t have clear product-market fit.
>
> Hence, OpenAI’s ad project is partly just about covering the cost of serving the 90% or more of users who don’t pay (and capturing an early lead with advertisers and early learning in how this might work), but more strategically, it’s also about making it possible to give those users the latest and most powerful (i.e. expensive) models, in the hope that this will deepen their engagement.

[Benedict Evans](https://www.ben-evans.com/benedictevans/2026/2/19/how-will-openai-compete-nkg2x), How will OpenAI compete?

* * *

**Link** 2026-02-26 [Google API Keys Weren’t Secrets. But then Gemini Changed the Rules.](https://trufflesecurity.com/blog/google-api-keys-werent-secrets-but-then-gemini-changed-the-rules):

Yikes! It turns out Gemini and Google Maps (and other services) share the same API keys... but Google Maps API keys are designed to be public, since they are embedded directly in web pages. Gemini API keys can be used to access private files and make billable API requests, so they absolutely should not be shared.

If you don’t understand this it’s very easy to accidentally enable Gemini billing on a previously public API key that exists in the wild already.

> What makes this a privilege escalation rather than a misconfiguration is the sequence of events.
>
> 1. A developer creates an API key and embeds it in a website for Maps. (At that point, the key is harmless.)
>
> 2. The Gemini API gets enabled on the same project. (Now that same key can access sensitive Gemini endpoints.)
>
> 3. The developer is never warned that the keys’ privileges changed underneath it. (The key went from public identifier to secret credential).

Truffle Security found 2,863 API keys in the November 2025 Common Crawl that could access Gemini, verified by hitting the `/models` listing endpoint. This included several keys belonging to Google themselves, one of which had been deployed since February 2023 (according to the Internet Archive) hence predating the Gemini API that it could now access.

Google are working to revoke affected keys but it’s still a good idea to check that none of yours are affected by this.

* * *

**Quote** 2026-02-26

> It is hard to communicate how much programming has changed due to AI in the last 2 months: not gradually and over time in the “progress as usual” way, but specifically this last December. There are a number of asterisks but imo coding agents basically didn’t work before December and basically work since - the models have significantly higher quality, long-term coherence and tenacity and they can power through large and long tasks, well past enough that it is extremely disruptive to the default programming workflow. \[...\]

[Andrej Karpathy](https://twitter.com/karpathy/status/2026731645169185220)

* * *

[Agentic Engineering Patterns](https://simonwillison.net/guides/agentic-engineering-patterns/) >

### [Hoard things you know how to do](https://simonwillison.net/guides/agentic-engineering-patterns/hoard-things-you-know-how-to-do/) \- 2026-02-26

Many of my tips for working productively with coding agents are extensions of advice I’ve found useful in my career without them. Here’s a great example of that: **hoard things you know how to do**.

A big part of the skill in building software is understanding what’s possible and what isn’t, and having at least a rough idea of how those things can be accomplished.

These questions can be broad or quite obscure. Can a web page run OCR operations in JavaScript alone? Can an iPhone app pair with a Bluetooth device even when the app isn’t running? Can we process a 100GB JSON file in Python without loading the entire thing into memory first? \[... [1,467 words](https://simonwillison.net/guides/agentic-engineering-patterns/hoard-things-you-know-how-to-do/)\]

* * *

Thanks for reading Simon Willison’s Newsletter! Subscribe for free to receive new posts and support my work.

Subscribe

* * *

#### Subscribe to Simon Willison’s Newsletter

Launched 3 years ago

AI, LLMs, web engineering, open source, data science, Datasette, SQLite, Python and more

Subscribe

By subscribing, you agree Substack's [Terms of Use](https://substack.com/tos), and acknowledge its [Information Collection Notice](https://substack.com/ccpa#personal-data-collected) and [Privacy Policy](https://substack.com/privacy).

[![Ashish Sahu's avatar](https://substackcdn.com/image/fetch/$s_!y3WL!,w_32,h_32,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fefa0f2bb-982d-4651-a29a-e70ff18d809f_1282x1284.jpeg)](https://substack.com/profile/92263995-ashish-sahu)[![Yvonne's avatar](https://substackcdn.com/image/fetch/$s_!bf6V!,w_32,h_32,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fc22a8a6e-1165-4b10-a549-2f20fa12f806_144x144.png)](https://substack.com/profile/152784923-yvonne)[![Corine's avatar](https://substackcdn.com/image/fetch/$s_!Oq1F!,w_32,h_32,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F0ff198ee-d5de-450e-aca4-a3dfb2df4981_144x144.png)](https://substack.com/profile/308893221-corine)[![Paul Carter's avatar](https://substackcdn.com/image/fetch/$s_!0hfw!,w_32,h_32,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Ff143ea88-f3d9-4daa-8126-55af6282611a_144x144.png)](https://substack.com/profile/12328971-paul-carter)[![Smit Soni's avatar](https://substackcdn.com/image/fetch/$s_!8mE5!,w_32,h_32,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fa219260e-c8e1-4505-8599-32614b9587e6_1080x589.jpeg)](https://substack.com/profile/175607674-smit-soni)

117 Likes∙

[6 Restacks](https://substack.com/note/p-189200830/restacks?utm_source=substack&utm_content=facepile-restacks)

117

10

6

Share

#### Discussion about this post

CommentsRestacks

![User's avatar](https://substackcdn.com/image/fetch/$s_!TnFC!,w_32,h_32,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack.com%2Fimg%2Favatars%2Fdefault-light.png)

[![Agent Autopsies's avatar](https://substackcdn.com/image/fetch/$s_!Gm_o!,w_32,h_32,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fd4917af7-f48d-42e0-9ce5-5c5d2a649f08_1024x1024.png)](https://substack.com/profile/469021646-agent-autopsies?utm_source=comment)

[Agent Autopsies](https://substack.com/profile/469021646-agent-autopsies?utm_source=substack-feed-item)

[Mar 27](https://simonw.substack.com/p/agentic-engineering-patterns/comment/234099992 "Mar 27, 2026, 9:14 AM")

Came across your Newsletter Simon,

Really great, factual and technically deep content. People tend to skip from crawling to sprinting then wonder why their agent doesnt perform how they want! My own agent yesterday tricked me on a non-binary problem!!!!

Like

Reply

Share

[![Chris Merck's avatar](https://substackcdn.com/image/fetch/$s_!xs3F!,w_32,h_32,c_fill,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fad3377ca-e117-4bbe-9587-d89890756014_450x450.jpeg)](https://substack.com/profile/9217248-chris-merck?utm_source=comment)

[Chris Merck](https://substack.com/profile/9217248-chris-merck?utm_source=substack-feed-item)

[Mar 4](https://simonw.substack.com/p/agentic-engineering-patterns/comment/223169760 "Mar 4, 2026, 7:20 PM")

Thanks for the link on the Go treeview tool. --- This inspired me to build one this morning for visualizing the space inside of firmware for STM32 and ESP32. [https://merck.substack.com/p/elfvis-binary-size-treemap-viewer](https://merck.substack.com/p/elfvis-binary-size-treemap-viewer)

Like

Reply

Share

[8 more comments...](https://simonw.substack.com/p/agentic-engineering-patterns/comments)

TopLatestDiscussions

[First impressions of Claude Cowork, Anthropic’s general agent](https://simonw.substack.com/p/first-impressions-of-claude-cowork)

[Plus Fly’s new Sprites.dev addresses both developer sandboxes and API sandboxes at the same time](https://simonw.substack.com/p/first-impressions-of-claude-cowork)

Jan 12•[Simon Willison](https://substack.com/@simonw)

125

8

5

![](https://substackcdn.com/image/fetch/$s_!9FDC!,w_320,h_213,c_fill,f_auto,q_auto:good,fl_progressive:steep,g_center/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fb623c988-ddee-421c-bf6b-e0db37df76f1_2803x2250.jpeg)

[Claude Skills are awesome, maybe a bigger deal than MCP](https://simonw.substack.com/p/claude-skills-are-awesome-maybe-a)

[Plus Claude Haiku 4.5](https://simonw.substack.com/p/claude-skills-are-awesome-maybe-a)

Oct 17, 2025•[Simon Willison](https://substack.com/@simonw)

347

13

29

![](https://substackcdn.com/image/fetch/$s_!MHgW!,w_320,h_213,c_fill,f_auto,q_auto:good,fl_progressive:steep,g_center/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F47dcd73a-5c5e-4319-82b7-24cd38091570_2054x1036.jpeg)

[The lethal trifecta for AI agents](https://simonw.substack.com/p/the-lethal-trifecta-for-ai-agents)

[Plus reviews of two new papers about prompt injection, and Anthropic's tips on building multi-agent LLM systems](https://simonw.substack.com/p/the-lethal-trifecta-for-ai-agents)

Jun 17, 2025•[Simon Willison](https://substack.com/@simonw)

326

4

6

![](https://substackcdn.com/image/fetch/$s_!YdeF!,w_320,h_213,c_fill,f_auto,q_auto:good,fl_progressive:steep,g_center/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fe4527818-c50d-41a4-92a4-2d5b710faaa9_2092x1046.jpeg)

See all

### Ready for more?

Subscribe