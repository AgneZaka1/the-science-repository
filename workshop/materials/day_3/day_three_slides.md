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

# Part C — Quarto in depth

> Only the **output-formats** slides are written out here (they explain the Word
> output added to the repo). The rest of Part C — anatomy of a `.qmd`, chunk
> options, common Quarto errors — is still to be built.

## Slide C1 — One source, LaTeX and Word

**Title:** Hit Render — get the paper in two formats

**On slide:**

```text
The GENERATED sections (methods + results) live in ONE Quarto file.
One render → two formats, both straight from the R/ engine. Nothing copied by hand.

  reports/manuscript/methods_and_results.qmd     methods + results (markdown + R)
        │   quarto render reports/manuscript   (or the Render button)
        ├─▶ LaTeX   generated/methods_and_results.tex   →  manuscript.tex → PDF / Overleaf
        └─▶ Word    generated/methods_and_results.docx  →  APA-styled .docx

Hand-written intro & discussion stay in sections/*.tex (LaTeX, Overleaf-edited).
Change a function or a sentence → re-render → both formats update.
```

**Speaker note:**
This is the Day 1 promise — *one source → HTML, PDF, Word* (Slide 33) — made
concrete for the paper. Note the split the repo is careful about: the file is
named `methods_and_results` because everything in it is **generated** from the
data, while the introduction and discussion are **hand-written** LaTeX in
`sections/`. The figures and numbers come from the `R/` engine, so no output can
drift from the analysis. Word matters because co-authors and journal submission
portals often live in `.docx`, not LaTeX — and the next slide shows that it's
the *same render*, not a separate tool.

---

## Slide C2 — One `quarto render`, two formats

**Title:** The knit-to-Word magic, declared in YAML

**On slide:**

```text
A real render (the RStudio / VS Code Render button works too) — no script:

  quarto render reports/manuscript
        ├─▶ generated/methods_and_results.tex    vector PDF figures, booktabs table
        └─▶ generated/methods_and_results.docx   300-dpi PNG figures, Word table

It's just two formats in the YAML (_quarto.yml):
  format:
    latex:  { template: _fragment.tex }      # body-only fragment for manuscript.tex
    docx:   { reference-doc: reference.docx } # APA styling for Word

Quarto renders the SAME .qmd each way:
  - markdown headings + @fig-/@tbl- cross-references work in both
  - figures: vector PDF for LaTeX, embedded PNG for Word — no manual export

Use Word for: Track-Changes co-authors · .docx-only submission portals.
```

**Speaker note:**
This is the "click Render, get Word" experience from the R Markdown days, now in
Quarto: the Word output isn't a post-processing script, it's a second `format:`
in the YAML, so one render produces both. Only the *generated* sections go to
Word; the hand-written intro/discussion stay LaTeX-only. The APA look comes from
`reference.docx` (swap in your journal's template). For APA-exact citations, drop
an `apa.csl` into `references/` and add `csl:` to the `docx` format.

**To build out:**

```text
- live demo: hit Render → open methods_and_results.docx side by side with the PDF
- contrast with the website's HTML output (same engine, different format)
- where Word breaks down vs LaTeX (fine equation / table control)
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
