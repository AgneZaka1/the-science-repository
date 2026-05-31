# `R/` — the analysis engine

All the R lives here, and **nothing in this folder runs on its own**. It defines
the building blocks; the reports in [`../reports/`](../reports/) call them and do
the actual work (including any saving). One source of truth for the numbers,
reused by the website and the manuscript.

## What's here

| File | What it is |
| --- | --- |
| [`01_setup.R`](01_setup.R) | The entry point. Loads packages, defines paths (`project_path()`, `processed_path()`), the variable glossary, and `source()`s the functions. Every report runs this first. **It never writes files.** |
| [`functions/`](functions/) | Reusable, side-effect-free functions: loading & cleaning, models, plots. |

## How it's used

A report opens with one line that finds the repo root and loads the engine:

```r
source(file.path(rprojroot::find_root(rprojroot::is_git_root), "R", "01_setup.R"))
```

From there it calls functions like `clean_consumer_data()`,
`fit_main_model()`, or `plot_pi_by_condition()`. See
[`functions/README.md`](functions/README.md).

## Conventions

- Build paths with `project_path(...)` (defined in `01_setup.R`, anchored on the
  git root) — never `setwd()` or absolute paths. We use it instead of
  `here::here()` because each report is its own Quarto project, where
  `here::here()` would stop at the report folder rather than the repo root.
- Load data with `load_raw_consumer_data()`; it reads the committed mock data by
  default. To use your own data, pass a different path (see
  [`reports/webpage/01-data-preparation.qmd`](../reports/webpage/01-data-preparation.qmd)).
- Functions are `snake_case`, verb-first (`load_raw_consumer_data()`), and pure
  where possible — take inputs, return outputs, don't save or print. Saving is
  the report's job.

## Why no numbered pipeline scripts?

Earlier versions had `02_data_processing.R` and `03_analysis.R` you ran by hand.
Now the reports orchestrate everything: rendering
[`reports/webpage/01-data-preparation.qmd`](../reports/webpage/01-data-preparation.qmd)
*is* the cleaning step, and it owns the save. That keeps "run the analysis" and
"produce the output" as one reproducible action.
