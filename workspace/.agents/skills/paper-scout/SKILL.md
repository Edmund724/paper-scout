---
name: paper-scout
description: "Scout a recent pool of papers, filter aggressively, deeply investigate the most promising ones, write Lark DocxXML, and create a fresh Feishu doc for each run."
user-invocable: true
---

# paper-scout

Paper Scout is a two-speed paper reading workflow:

- first, scan broadly to identify what matters in a large recent pool
- then, investigate deeply only where the expected value is high

The goal is not to summarize everything. The goal is to help a user understand what matters now, what deserves attention, and which papers justify deeper investment.

## When To Use This Skill

Use this skill when the user wants a recent-paper brief that combines:

- broad scouting across a large candidate pool
- strong filtering
- a small shortlist worth noticing
- a few deep investigations with stronger analysis
- delivery to Feishu docs

This skill defaults to Hugging Face papers via `hf papers`, but it may be used with other configured sources when the workspace instructions or run trigger allow it.

## Required Companion Skills

Before source discovery, load `hf-cli`.

Before creating Feishu docs, load `lark-doc`. Before notifying the user of the delivered doc, load `lark-im`.

During Phase 4 (deep investigation), load and follow `paper-scout-deep-dive`.

During Phase 5 (synthesis and writing), load and follow `paper-scout-feishu-doc`.

Use this `paper-scout` skill as the main operating method throughout the run.

## Core Principles

### Filter Hard

Do not produce a padded report. If the period is weak, cover fewer papers.

### Use Adaptive Effort

Spend little time on mediocre candidates and more time on genuinely promising ones.

### Be Skeptical But Not Cynical

Look for red flags, overstated claims, weak baselines, shallow repos, or missing evidence, but do not force criticism where it is not warranted.

### Investigate Beyond The Paper Selectively

Project pages, repos, model cards, and dataset cards are valuable when a paper looks especially promising. They are not mandatory for every paper.

### Avoid Repeating Prior Deep Dives

Previously deep-dived papers should not be deep-dived again. Previously shortlisted papers may reappear unless they are clearly outdated or no longer relevant.

### Preserve User Trust

Prefer accurate judgment, clear rationale, and honest uncertainty over false confidence.

## Workspace Contract

The workspace root is the reading agent's home directory; the agent runs from here, and every path below is relative to it.

```text
.
├── papers/<area>/<title-slug>-<id>.md          # downloaded paper markdown bank
├── repos/<area>/<repo-name>/                    # cloned repos for code inspection
├── runs/
│   ├── INDEX.md                                 # compact dedup/coverage log
│   └── <area>/<title-slug>-<id>-deep-dive.md    # durable analysis notes
└── drafts/                                      # freeform scratch + working DocxXML
```

### Areas

`papers/`, `repos/`, and `runs/` are organized into free-form, evolving research-area folders (kebab-case, e.g. `vla/`, `world-models/`, `spatial-intelligence/`). Areas are not a fixed taxonomy and not date partitions. Create an area when a theme recurs; put each paper in exactly one area; fold a thin one-stray-paper area into a broader one rather than creating a singleton. Reuse the same area name across `papers/`, `repos/`, and `runs/` so a paper's markdown, its repo, and its notes all live under matching areas. Co-locating related work this way is deliberate — it makes the cross-paper reasoning in `paper-scout-deep-dive` cheap.

### Naming

Lead filenames with a human-readable slug from the paper title or repo name so the bank is browsable, and keep the arXiv/HF id as a trailing suffix (dedup keys on the id):

- `papers/vla/robosemanticbench-2606.02277.md`
- `repos/spatial-intelligence/TVRBench/` (actual upstream repo name; add an id suffix only on collision)
- `runs/vla/robosemanticbench-2606.02277-deep-dive.md`

### Directory Roles

- `papers/`: downloaded paper markdown, organized by area
- `repos/`: cloned repositories for code inspection, organized by area
- `runs/`: durable per-run analysis notes (by area) plus `INDEX.md`
- `runs/INDEX.md`: the persistent, compact coverage log and dedup source of truth
- `drafts/`: freeform scratch and working Lark DocxXML; overwrite freely, nothing here is durable. The final delivered DocxXML is archived to `../reports/`.

The bank is living — kept to a working size as runs accumulate. How to prune it is governed by a separate skill (not yet written); do not invent pruning rules here.

## State Rules

Before serious scouting or investigation, inspect `runs/INDEX.md`.

Use the log to identify:

- papers already deep-dived
- recently covered time windows
- recent Feishu doc links
- repeated themes or stale follow-ups

Deep-dived papers should not be deep-dived again unless the workspace instructions or current run trigger explicitly override that rule.

## Investigation Boundaries

### Allowed

- download paper markdown locally, for example with `hf papers read <id> > <path>`
- inspect project pages
- inspect linked GitHub repositories
- clone repositories locally
- scan codebases and documentation
- inspect Hugging Face model cards or dataset cards

### Not Allowed By Default

- do not run repositories
- do not download models
- do not download datasets
- do not perform heavyweight execution or benchmarking

If the workspace instructions or current run trigger explicitly expand permissions, follow them. Otherwise keep investigation read-only and lightweight.

## Phase 0: Preflight

Before scouting:

1. Load `hf-cli`.
2. Confirm the directory layout (`papers/`, `repos/`, `runs/`, `drafts/`) exists, and create whatever is missing.
3. Inspect `runs/INDEX.md` if present.
4. Verify the output and scratch directories are available.
5. Before delivery work later in the run, remember to load `lark-doc` and `lark-im`.

If source access or delivery readiness is broken, stop early and explain the blocker.

## Phase 1: Source Discovery

Start from the configured recent-paper source. By default, this is `hf papers`.

Gather a broad recent pool and preserve enough metadata to support later selection, such as:

- title
- paper id and any alternative identifiers
- authors
- abstract or summary snippet
- links to project pages, repos, model cards, or dataset cards when available

The initial pool can be large. Do not investigate each item deeply. If you persist the candidate pool to disk, write it to `drafts/` (it is scratch and may be overwritten) — never to `runs/`, which holds only durable notes.

## Phase 2: Fast Scan

Use a lightweight scan to identify promising candidates efficiently.

During fast scan:

- read enough to judge novelty, relevance, plausibility, and likely value
- notice bigger-picture patterns across the pool
- identify papers that are clearly weak, derivative, or outside scope
- surface candidates worth mentioning even if they do not justify a deep dive

At this phase, speed matters. Avoid expensive investigation unless a paper is already emerging as unusually promising.

## Phase 3: Selection

Select two nested sets:

- a shortlist worth noticing
- a smaller set worth deep investigation

Use importance and user relevance as the main criteria. Use diversity as a tie-breaker if the top candidates are too homogeneous.

Signals that strengthen a paper's case include:

- unusually strong or surprising idea
- clear relevance to the user's interests
- practical usefulness
- credible evidence
- signs that the work may influence future papers or workflows
- code or project artifacts that make deeper inspection more worthwhile

Signals that weaken a paper's case include:

- vague contribution
- hype without evidence
- weak or suspicious evaluation
- unclear novelty
- shallow or missing supporting artifacts when they matter

The exact quotas come from the workspace instructions or current run trigger. If the period is weak, select fewer papers.

## Phase 4: Deep Investigation

For each selected deep-dive candidate, load and follow the `paper-scout-deep-dive` skill.

That skill defines the full investigation process: section inventory, motivation and contribution analysis, method walkthrough, experimental evidence assessment, artifact inspection, and bottom-line judgment. Follow it in full for every deep-dive paper.

A light summary of what the skill covers:

- **Build a section inventory first.** List every section and where it will appear in the analysis. This prevents important content from being silently skipped.
- **Work through the full paper.** Do not stop at the method section. Experiments, ablations, and appendices contain the evidence that tests the claims.
- **Write specific analysis notes.** The goal is not to summarize. It is to understand the paper well enough to write a genuinely useful brief section.
- **Inspect artifacts selectively.** Repos, model cards, and project pages add value when the paper is genuinely promising. Do not let artifact inspection become a detour.
- **Situate against related work.** Especially when a paper ships no code, pull in 1–3 key related or prior papers and reason comparatively. This is what turns a code-less deep dive into analysis rather than a polished summary.
- **Write a bottom-line judgment.** Is it worth the user's time? Should they track follow-up work? Be direct.

Save analysis notes for each paper to `runs/<area>/<title-slug>-<id>-deep-dive.md`. These notes feed Phase 5 directly.

Do not let deep investigation turn into a full reproduction effort.

## Phase 5: Synthesis And Writing

Load and follow the `paper-scout-feishu-doc` skill.

That skill defines the document structure, visual hierarchy, formatting conventions, and quality standards for the final brief. Follow it for layout and writing decisions.

A light summary of what the skill covers:

- **Open with a synthesis.** The user should understand what mattered this period before reading individual papers.
- **Cover each paper exactly once.** Deep-dived papers are their own narrative sections; lightly-noticed papers appear only as rows in a per-theme shortlist table. No paper is both a table row and a section, so there are no "see deep dive" pointers.
- **Write each deep dive as fluent narrative.** No fixed section template — each paper is flowing prose at the depth it warrants, still carrying the mechanism, evidence, code/related-work findings, and a clear verdict, but woven together rather than slotted into identical sub-headers.
- **Use rich formatting where it earns its place.** Tables, callouts, latex, and horizontal rules where they aid the reader; not as decoration on every paper.
- **Be specific, not promotional.** Every claim should be grounded in what the paper actually says or what the analysis found.

Writing tone and depth are controlled by the workspace instructions or current run trigger. The reasoning standard should remain high regardless of style choice.

## Phase 6: Delivery

Before delivery, load `lark-doc` and `lark-im`.

Write the brief as Lark DocxXML into `drafts/` first.

Create the Feishu doc **as the bot** with `lark-cli docs +create --api-version v2` — the bot owns the doc. There is no configured folder/wiki destination and no `--parent-token`. Capture the resulting document URL.

Then **send the user a direct message** with the doc link using `lark-cli im +messages-send`. Load `lark-im` for how to address and send to the user, and resolve the recipient from the identity `lark-cli` exposes. Delivery is complete only once the DM is sent and confirmed. If you cannot determine a recipient or the send fails, stop and report the blocker rather than finishing silently.

After the DM is confirmed, archive the delivered DocxXML to `../reports/` as `YYYY-MM-DD-<slug>.docxxml`, and preserve the document URL for logging.

## Phase 7: Logging And Optional Cleanup

After successful delivery, append a new entry to `runs/INDEX.md`.

Each run entry should record:

- run date and time
- period covered
- resulting Feishu doc link
- shortlisted papers
- deep-dived papers
- useful identifiers for each paper
- a brief rationale for deep-dive selections when practical

The log should be written newest first when convenient for readability.

The bank (`papers/`, `repos/`) is living and meant to stay a working size, but how to prune it is governed by a separate skill that is not yet written. Do not invent pruning rules here. Scratch never accumulates in `runs/`: intermediate artifacts live in `drafts/` and are overwritten run to run.

## Final Checklist

Before finishing a run, confirm:

- required companion skills were loaded at the right times
- the workspace state was checked before serious work
- previously deep-dived papers were not repeated
- the shortlist was filtered aggressively rather than padded
- deep investigation stayed read-only and lightweight
- the final brief reflects both broad scouting and deeper analysis, with each paper appearing exactly once (no table-plus-section duplication)
- the doc was created as the bot and its link was delivered to the user by direct message
- `runs/INDEX.md` was updated

If any of these failed, say so clearly instead of implying the run was complete.
