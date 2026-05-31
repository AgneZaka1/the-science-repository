# Day 3 — Reporting, Publication & Responsible AI (SKELETON)

> **Status: skeleton.** Day 1 is the worked-out deck. This file collects the
> content moved off Day 1 (running on your own data, and AI guardrails) plus
> placeholders for the rest of Day 3, to be fleshed out later. Day 3 introduces
> VS Code and goes deep on Quarto outputs and responsible AI use.

---

## Outline (to build)

```text
Part A — Recap & roadmap
  - Day 3 roadmap, full workflow map, why reporting lives inside the workflow

Part B — From scripts to outputs
  - exporting figures/tables, reproducible filenames, methods/results from code
  - writing results from model output (regression / moderation / mediation)

Part C — Quarto in depth
  - anatomy of a .qmd, code chunks, options
  - common Quarto errors
  - output formats: HTML / Word / PDF
  - the manuscript pipeline + Overleaf (carry over from Day 1 Slide 34)

Part D — Running on your own data   [MOVED FROM DAY 1]
Part E — Responsible AI use & the repo's guardrails   [MOVED FROM DAY 1]

Part F — VS Code (introduced today)
  - why a second editor, R + Quarto + Git in VS Code, multi-language projects

Part G — Wrap-up
  - reproducibility check, AI-use statement, data protection checkpoint
  - final integrated exercise, how to continue
```

---

# Part D — Running on your own data

## Slide D1 — From mock to your own data: change one path

**Title:** Same code, different data source

**On slide:**

```r
# Day 1 default — reads the committed synthetic dataset:
raw <- load_raw_consumer_data()

# Your own data — point the loader at a file in data/raw/ (gitignored):
raw <- load_raw_consumer_data(project_path("data", "raw", "your_data.csv"))
```

**Speaker note:**
On Day 1 everyone ran on the mock data — it's the *default*, so nothing extra was
needed. To run the same analysis on real data, you change a single line in
`reports/webpage/01-data-preparation.qmd`: pass a path to your own file instead of
calling `load_raw_consumer_data()` with no arguments. Keep that file in
`data/raw/`, which is **gitignored**, so private data never gets committed. The
analysis code itself does not change — only the path you hand the loader.

**To verify when building this slide:**

```text
- load_raw_consumer_data() default = data/mock/consumer_data_raw.csv
  (R/functions/data_loading.R)
- data/raw/ is gitignored (.gitignore: data/raw/**)
- processed/ cache path is data/processed/ regardless of data source
```

---

## Slide D2 — Data protection checkpoint (Day 3)

**Title:** Before you share, upload, or paste into AI

**On slide:**

```text
What is safe to commit, share, upload to Overleaf, or paste into an AI tool?

  Scripts            usually yes
  Raw data           usually no
  Outputs            only if no one can be identified
  Confidential data  never into external AI tools without approval
```

**Speaker note:**
Tie back to the Day 1 `.gitignore` seatbelt: the repo blocks raw/processed by
default, but uploads to AI tools and Overleaf are *your* decision — make it
deliberately.

---

# Part E — Responsible AI use & the repo's guardrails

## Slide E1 — Coding assistants: helpful, with guardrails

**Title:** AI supports the workflow — it doesn't run it

**On slide:**

```text
AI can help: explain code, draft README text, debug errors, suggest comments.

This repo guards your data:
  .claude/settings.json     blocks AI tools from reading raw/processed data
  *.llm.code-workspace      opens the repo with private data hidden from the editor

Rule: AI supports the workflow — it does not receive confidential data.
```

**Speaker note:**
Moved here from Day 1, where it was a distraction. By Day 3, participants have a
real workflow, so AI guardrails land in context. The repo is configured so that
even if you point an assistant at the project, it cannot read `data/raw/` or
`data/processed/`. Structured projects also make AI *more* useful: precise
questions against explicit scripts beat vague prompts.

**To build out:**

```text
- show .claude/settings.json deny rules (what exactly is blocked)
- demo opening via *.llm.code-workspace vs the normal workspace
- an "AI-use statement" template for the manuscript / methods
```

---

# Part F — VS Code (introduce here)

```text
PLACEHOLDER — first introduction of VS Code in the workshop.
  - why a second editor at all (multi-language, extensions, Git UI)
  - the-science-repository.code-workspace vs .llm.code-workspace
  - running R and Quarto from VS Code
  - keep RStudio as the default; VS Code as the "graduate" option
```
