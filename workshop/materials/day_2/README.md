# Day 2 — Morning live demo: *From the console to a report*

A complete, runnable, **live-coding walkthrough** that takes participants from
their very first command (`5 + 7`) to a rendered HTML report — covering data
types, assignment, functions, and packages along the way.

It is deliberately built as a **miniature of the real project** in this
repository, using the **same teaching dataset** (`data/mock/consumer_data_raw.csv`).
By lunch, participants have seen — in small — exactly the machinery they will
work inside all afternoon (`R/01_setup.R` → `R/functions/` → `reports/webpage/`),
and exactly the kind of code an AI assistant will write *for* them on Day 3.

> **The one aim:** not to memorise commands, but to build a mental model strong
> enough to **read, understand, and diagnose** code. That is the skill that makes
> everything after it — the afternoon's analysis, tomorrow's AI assistance —
> safe and productive.

---

## The four acts

The demo is one continuous story told in four moves, plus a visualisation
interlude. Each file is runnable on its own and is heavily commented so it
doubles as a take-home reference.

| Pt. | File | The big idea | ~ time |
| --- | --- | --- | --- |
| **1 · Console** | [`01_console_basics.R`](01_console_basics.R) | R as a calculator → **values & types** → **assignment** (`<-`) → **vectors** → `NA` → **factors** → **functions** → **packages** | 30 min |
| **2 · Script** | [`02_first_script.R`](02_first_script.R) | Why save code. The same ideas, now a **reproducible script** on the real CSV: read → inspect → clean → describe → plot → save. | 25 min |
| **2½ · Visualise** | [`02b_visualisation.R`](02b_visualisation.R) | Build one figure **layer by layer** — data → `aes()` → `geom_*()` → labels — until it's publication-ready. The grammar of graphics, live. The fun part. | 12 min |
| **3 · Functions** | [`03_functions.R`](03_functions.R) + [`04_script_with_functions.R`](04_script_with_functions.R) | Extract the repeated recipes into **named functions** (an "engine") and watch the analysis script shrink to a readable summary. | 20 min |
| **4 · Report** | [`05_report.qmd`](05_report.qmd) | A **Quarto report** that *sources the engine*, runs it, and renders **prose + code + results** into one HTML file. The twin of a real `reports/webpage/` page. | 20 min |

Supporting material:

| File | For whom |
| --- | --- |
| [`FACILITATOR_GUIDE.md`](FACILITATOR_GUIDE.md) | The presenter. Beat-by-beat runbook: what to type, what to say, what to point at, deliberate errors to show, anticipated questions, timing, and cut/extend options. |
| [`PARTICIPANT_HANDOUT.md`](PARTICIPANT_HANDOUT.md) | Participants. A two-page recap: the snippets, a glossary, the five errors you'll meet, and a "concept → where it lives in this repo" map. |
| `05_report.html` | Everyone. A **pre-rendered copy** of the Pt. 4 report — a fallback to show if a live render misbehaves. |

---

## Before the session (facilitator checklist)

1. **Open the project, not loose files.** Double-click `the-science-repository.Rproj`
   so RStudio sets the working directory to the repo root. (`here::here()` and the
   paths in these scripts depend on it.)
2. **Restore packages once:** in the Console, `renv::restore()`. The demo uses
   `readr`, `dplyr`, `ggplot2`, `janitor`, `psych`, `here`, `knitr`, and
   `rprojroot` — all pinned in `renv.lock`.
3. **Check Quarto is installed:** in a terminal, `quarto --version` (any 1.x).
4. **Pre-render the report once** so the fallback HTML is current:
   ```bash
   quarto render workshop/materials/day_2/05_report.qmd
   ```
5. **Open all five files** in RStudio tabs, in order, and **clear the Console**
   (`Ctrl + L`) and **Restart R** (`Session → Restart R`) so you start from a
   genuinely blank slate in front of the room.

---

## How to run each piece

All commands assume the project is open (working directory = repo root).

```r
# Pt. 1 — type lines into the Console live (Cmd/Ctrl + Enter), or:
source("workshop/materials/day_2/01_console_basics.R")

# Pt. 2 — run the whole script ("Source", or Cmd/Ctrl + Shift + Enter)
source("workshop/materials/day_2/02_first_script.R")

# Pt. 2½ — run ONE block at a time and watch the Plots pane build up the figure
#          (don't source it whole — the point is to see each layer appear)

# Pt. 3 — the engine (03) is sourced automatically by 04:
source("workshop/materials/day_2/04_script_with_functions.R")
```

```bash
# Pt. 4 — render the report to HTML (from a terminal at the repo root)
quarto render workshop/materials/day_2/05_report.qmd
```

Acts 2 and 4 write a `pi_by_condition.csv` and `.png` into `_output/`
(git-ignored — they are reproducible). The report renders to a self-contained
`05_report.html` beside the `.qmd`.

---

## How this connects to the rest of the workshop

- **← Day 1** grounded the concepts on slides (what R/RStudio/objects/packages
  *are*). This morning makes them **happen on screen, in order, on real data**.
- **→ This afternoon** participants apply the *exact same pattern* to
  [`reports/webpage/`](../../../reports/webpage/) with their own data. Pt. 4 is a
  one-page rehearsal of `reports/webpage/01-data-preparation.qmd`.
- **→ Day 3** is about coding agents (Claude Code, local models). Everything here
  trains the muscle Day 3 depends on: *reading code you didn't write, predicting
  what it does, and spotting when it's wrong.*

## Keep learning

The workshop is built around the free, open book
**[R for Data Science (2e)](https://r4ds.hadley.nz/)** (a copy is in
[`workshop/literature/`](../../literature/)). The chapters that match this demo:

| This demo | R for Data Science chapter |
| --- | --- |
| Acts 1–2 (console, assignment, names) | [Workflow: basics](https://r4ds.hadley.nz/workflow-basics) |
| Pt. 2 (read & clean) | [Data import](https://r4ds.hadley.nz/data-import) · [Data transformation](https://r4ds.hadley.nz/data-transform) |
| Pt. 2 (the boxplot) | [Data visualisation](https://r4ds.hadley.nz/data-visualize) |
| Pt. 3 (writing functions) | [Functions](https://r4ds.hadley.nz/functions) |
| Pt. 4 (the report) | [Quarto](https://r4ds.hadley.nz/quarto) |

The matching printed cheat sheets are in [`workshop/cheat sheets/`](../../cheat%20sheets/).
