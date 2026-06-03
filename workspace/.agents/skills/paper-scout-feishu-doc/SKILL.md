---
name: paper-scout-feishu-doc
description: "Structure and write the Paper Scout brief as a Feishu document using lark-cli (v2 DocxXML). Covers document sections, callouts, grids, tables, LaTeX, and the v2 delivery command sequence."
user-invocable: false
---

# paper-scout-feishu-doc

This skill governs how the Paper Scout brief is written and delivered as a Feishu document. It is used during Phase 5 (synthesis and writing) and Phase 6 (delivery) of the main `paper-scout` skill.

This skill owns the **brief's structure and editorial standards** — which sections exist, what goes in each, and the quality bar. It does **not** own the Lark document format. The installed `lark-doc` skill is the authoritative source for DocxXML syntax, escaping, and command flags. Load it before any delivery work and follow its references. This separation is deliberate: when `lark-cli` changes, the format details update in one place, not here.

---

## Before You Start

Load `lark-doc` before any writing or delivery work, and follow its references (`lark-doc-xml.md` for syntax, `lark-doc-create.md` / `lark-doc-update.md` for commands, `lark-doc-style.md` for visual richness). Load `lark-im` before the delivery notification — the brief is delivered to the user by direct message, not filed into a folder.

The current `lark-doc` skill uses the **v2 API with DocxXML** as the default content format. All `docs +create`, `docs +fetch`, and `docs +update` commands must carry `--api-version v2`. Author the brief as DocxXML.

Feishu renders DocxXML with real visual structure — callouts, grids, tables with styled cells, inline LaTeX. Use it. A brief that is nothing but flat bullet lists misses the platform entirely.

**Brief-specific rules (defer to `lark-doc` for everything else):**

- The document title is the `<title>` element at the very start of the content. There is no `--title` flag in v2. Do not repeat the title anywhere else in the body.
- Feishu generates a table of contents automatically from headings. Use a sensible `<h1>`/`<h2>` hierarchy.
- Callout children must be block elements (`<p>`, headings, lists, `<checkbox>`, `<blockquote>`) — not bare text, and not tables or code blocks.
- In DocxXML, tags are never escaped, but `<`, `>`, and `&` inside text content must be written as `&lt;`, `&gt;`, `&amp;`. Paper titles, math, and code snippets frequently contain these — escape them in text, and see `lark-doc-xml.md` for the full rule.

---

## Document Structure

The brief is **organized by theme**, not as one flat list. The top-level shape is: a whole-pool synthesis, then one `<h1>` section per theme that emerged this run, with that theme's shortlist and deep dives nested inside it. Derive the themes from the papers each run — do not hardcode them.

### 1. Opening Synthesis (Required)

Write 2–4 sentences answering: *What mattered this period?*

This is a judgment about the whole pool, not a summary. What were the dominant themes? What was the standout paper? What should the user notice before reading further? Name the themes the rest of the doc will use.

If a paper was clearly exceptional this period, wrap the synthesis in a standout callout:

```xml
<callout emoji="✅" background-color="light-green">
  <p><b>Standout this week:</b> [Title] is the clearest example of [trend/contribution]. [One sentence on why.]</p>
</callout>
```

If the period was weak, say so in plain prose. Do not pad.

---

### 2. Theme Sections (The Body)

One `<h1>` per theme that actually emerged from the pool (e.g. "Video & World Models", "Embodied / Robotics", "Multimodal LLMs", "Autonomous Driving"). Each theme section contains, in order:

1. A short **mini-synthesis** (1–3 sentences) on what this theme showed this run.
2. The theme's **lightly-noticed papers** (worth a mention, not a deep dive) as a shortlist table — omit the table if the theme has none.
3. Any **deep dives** for the theme, nested as `<h2>` under the `<h1>`.

Rules:

- Put each paper in **exactly one** theme. Derive themes from the papers; do not force papers into a fixed taxonomy.
- Fold thin themes (one stray paper) into a broader theme or a catch-all rather than creating a one-line section.
- If the pool does not cluster cleanly at all, fall back to a single `<h1>` "Highlights" section containing one shortlist table and the deep dives.

#### Per-theme shortlist table

Use a standard DocxXML `<table>` so each cell can hold links, bold text, and short lists cleanly. Give it a header row in `<thead>` and use `<colgroup>` to set column widths. One table per theme (the papers in that theme only).

Four columns: Paper, Key Contribution, Why It Matters, Links.

```xml
<table>
  <colgroup>
    <col width="200"/>
    <col width="230"/>
    <col width="230"/>
    <col width="90"/>
  </colgroup>
  <thead>
    <tr>
      <th background-color="light-gray">Paper</th>
      <th background-color="light-gray">Key Contribution</th>
      <th background-color="light-gray">Why It Matters</th>
      <th background-color="light-gray">Links</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>Title</b> (Author et al., 2025)</td>
      <td>One sentence — the specific thing the paper did.</td>
      <td>One sentence — why this user should care.</td>
      <td><a href="url">HF</a> / <a href="url">PDF</a></td>
    </tr>
  </tbody>
</table>
```

Keep "Key Contribution" and "Why It Matters" distinct — contribution is what they did, relevance is why it matters to this user. Do not write the same sentence twice.

Do not put deep-dived papers in the shortlist table. Each paper appears exactly once: deep-dived papers are their own `<h2>` narrative sections below, lightly-noticed papers are table rows here. If every paper in a theme is deep-dived, omit the table for that theme.

---

### 3. Deep Dive Sections (nested under each theme)

Each deep-dived paper is an `<h2>` inside its theme's `<h1>` section, separated by `<hr/>`. These are the substantive heart of the brief: they must reflect the deeper analysis from `paper-scout-deep-dive` — the reimplementation-level mechanism, the evidence assessment, and what the code and related-work investigation revealed — not a polished restatement of the abstract.

**Write each deep dive as fluent, connective prose, not a filled-in template.** There is no fixed set of sub-headers. Let the structure follow the paper: one with a clean pipeline may warrant an ordered list of stages; one whose interest is a single surprising result may be three tight paragraphs. Sub-headings (`<h3>`) are allowed where a long dive genuinely needs sign-posting, but they must emerge from this paper's shape — never the same five headers stamped onto every paper.

Whatever the shape, a deep dive must still deliver the substance, woven into the narrative:

- **The core claim**, stated specifically — what the paper actually shows, not the abstract's framing.
- **The mechanism**, at enough detail that a reader could approximately reimplement it: inputs/outputs, the major stages, the key equations or loss terms, and the non-obvious design choices *and why* they were made.
- **The evidence**, assessed rather than transcribed: concrete numbers, the magnitude of the gain, where it does not win, and any red flags. Write "outperforms X by Y% on Z", never "achieves state-of-the-art".
- **What the investigation found**: for papers with code, what reading the implementation revealed (does it match the paper? undocumented tricks? discrepancies? the result of any lightweight check). For papers without code, the comparative positioning against the 1–3 related papers — what is genuinely new versus the closest prior art.
- **A grounded verdict**: how credible and how novel the work is, and a clear call — read in full / skim / build on / track follow-ups / skip — with the reason.

Header for each dive: the paper title as the `<h2>`, with author, year, and links on the immediately following paragraph.

```xml
<h2>Paper Title</h2>
<p>Author et al. (2025) · <a href="url">HF</a> · <a href="url">PDF</a></p>
```

Use the platform where it earns its place, not as decoration: inline `<latex>` for an equation the paper centers on, a two-column `<grid>` to contrast a prior approach with this one, a `<table>` for a genuine multi-way comparison, and callouts for a standout result or a real caveat. A dive that is nothing but flat paragraphs misses the platform; a dive that forces a table and three callouts onto a simple result is noise. Judgment over checklist. Syntax reminders (full rules in `lark-doc-xml.md`):

```xml
<p>The objective is <latex>\mathcal{L} = \mathcal{L}_{\text{CE}} + \lambda \mathcal{L}_{\text{KL}}</latex>.</p>
```

```xml
<grid>
  <column width-ratio="0.5"><p><b>Prior approach</b></p><p>What prior work did.</p></column>
  <column width-ratio="0.5"><p><b>This paper</b></p><p>What this paper does differently.</p></column>
</grid>
```

For a pipeline, an ordered list reads well: `<ol><li seq="auto">…</li></ol>`. Where a diagram would beat prose for an architecture or data flow, a Feishu whiteboard is available (see `lark-doc` / `lark-whiteboard`).

---

### 4. Cross-Cutting Observations (Optional)

Theme grouping is already the structure of the brief, so this is **not** where themes are introduced. Add a short closing `<h1>` only when there is a pattern that cuts *across* themes worth naming — a convergence, a notable absence, a shift from prior runs, or a scope note about what was filtered out.

Write as an observation in prose, not a bullet list. One or two paragraphs. Skip it entirely if there is nothing cross-cutting to say.

---

## Callout Reference

Use callouts for things that demand attention, not as decoration. Three types are useful for paper briefs. Callout children must be block elements; see `lark-doc-xml.md` for the supported attributes and color names.

**Standout paper or exceptional finding:**
```xml
<callout emoji="✅" background-color="light-green">
  <p>[Content]</p>
</callout>
```

**Caveat, red flag, or important limitation:**
```xml
<callout emoji="⚠️" background-color="light-yellow">
  <p>[Content]</p>
</callout>
```

**Notable insight or key insight:**
```xml
<callout emoji="💡" background-color="light-blue">
  <p>[Content]</p>
</callout>
```

---

## Delivery

All `docs` commands carry `--api-version v2`. Content is DocxXML; for multi-line content pass `--content @drafts/brief.xml` or `--content -` (stdin) — write the brief to `drafts/` first.

### Create the doc as the bot

```bash
lark-cli docs +create --api-version v2 \
  --content @drafts/brief.xml
```

The bot owns the resulting doc. There is **no `--parent-token`** and no configured folder/wiki destination — do not add one. The `<title>` element inside the content sets the document title (there is no `--title` flag). Capture `data.document.document_id` and `data.document.url` from the response.

### Append sections for long briefs

Create a skeleton first (title + opening synthesis + the theme `<h1>` headings), then append each theme's body and deep dives with the `document_id` (not the url):

```bash
lark-cli docs +update --api-version v2 \
  --doc "<document_id>" \
  --command append \
  --content @drafts/section.xml
```

### Notify the user

Load `lark-im` and send the user a direct message containing the doc `url` via `lark-cli im +messages-send`. Resolve the recipient from the identity `lark-cli` exposes; follow `lark-im` for the exact invocation. Delivery is complete only once this DM is confirmed. If no recipient can be resolved or the send fails, stop and report it.

### Typical sequence

1. Create the doc as the bot with the opening synthesis and the theme `<h1>` headings; capture `document_id` and `url`.
2. For each theme, append its mini-synthesis + shortlist table (lightly-noticed papers), then its deep-dive `<h2>` sections.
3. Append the cross-cutting observations section if present.
4. DM the `url` to the user via `lark-im` and confirm delivery.
5. Archive the delivered DocxXML to `../reports/<YYYY-MM-DD>-<slug>.docxxml` and record the `url` in `runs/INDEX.md`.

---

## What Not To Do

- Do not omit the `<title>` element — there is no `--title` flag in v2, so the title must live in the content.
- Do not repeat the title as an `<h1>` after the `<title>` — it duplicates the heading.
- Do not put bare text directly inside a `<callout>`; wrap it in `<p>` or another block element. Do not put tables or code blocks inside a callout.
- Do not use a Markdown `>` blockquote expecting a callout. Use the `<callout>` tag.
- Do not use `overwrite` to fix a brief mid-run. Use `append`, or the block-level edit commands documented in `lark-doc-update.md`.
- Do not write "the paper achieves state-of-the-art." Write the number, the benchmark, and the comparison.
- Do not use a flat bullet list for the entire brief. Themes are `<h1>` sections, shortlists are `<table>`s, deep dives are `<h2>` narrative sections.
- Do not stamp every deep dive with the same fixed sub-headers (What It Does / How It Works / Evidence / Code / Judgment). Write narrative whose shape follows the paper.
- Do not list a deep-dived paper in a shortlist table or add "→ see deep dive" pointers. Each paper appears exactly once — deep dives are `<h2>` sections; shortlist tables hold only lightly-noticed papers.
- Do not present one giant shortlist table for the whole pool. Split the shortlist by theme, one table per theme.
- Do not hardcode the theme list. Derive it from the pool each run; fall back to a single "Highlights" section if the pool does not cluster.
- Do not ship a deep dive that just restates the abstract and method. It must reflect the reimplementation-level mechanism, the evidence assessment, and what the code revealed.
- Do not skip the opening synthesis. The user should understand what mattered before scrolling to individual papers.
- Do not hand-author low-level XML escaping from memory. Follow `lark-doc-xml.md`.

---

## Checklist Before Delivery

- [ ] `lark-doc` loaded and its references followed
- [ ] Content authored as DocxXML; all commands use `--api-version v2`
- [ ] `<title>` element present and matches the configured title pattern; not duplicated in the body
- [ ] Opening synthesis written — 2–4 sentences on what mattered this period, naming the themes
- [ ] Body organized into per-theme `<h1>` sections (or a single "Highlights" fallback); each paper in exactly one theme and appearing exactly once (deep dives as `<h2>` narrative, lightly-noticed papers as shortlist rows; no "see deep dive" pointers)
- [ ] Each theme has a mini-synthesis; lightly-noticed papers go in a per-theme shortlist `<table>` with specific contribution and relevance columns (omitted if none)
- [ ] Each deep dive is fluent narrative (no fixed five-header template) carrying mechanism at reimplementation detail, assessed evidence with concrete numbers, code/related-work findings, and a grounded verdict
- [ ] Callouts used for standout papers and notable caveats — not decoratively
- [ ] `<latex>` used for any equations the paper centers on
- [ ] `<grid>` / `<whiteboard>` used where a comparison or diagram genuinely aids understanding
- [ ] `<`, `>`, `&` in text content escaped per `lark-doc-xml.md`
- [ ] Doc created as the bot via `docs +create --api-version v2` (no `--parent-token`); long briefs appended via `docs +update --api-version v2 --command append`
- [ ] Doc link DM'd to the user via `lark-im` and delivery confirmed
- [ ] Document `url` recorded for the coverage log
