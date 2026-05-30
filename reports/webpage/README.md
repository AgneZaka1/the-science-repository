# `reports/webpage/` — website recipe

The Quarto sources for the project **website**. Rendering writes the finished
site to [`../../renders/webpage/`](../../renders/webpage/) (set by `output-dir`
in [`_quarto.yml`](_quarto.yml)).

## The pages

| File | Page | What it does |
| --- | --- | --- |
| [`index.qmd`](index.qmd) | Overview | Landing page: the study, how to read the site, how it's built. |
| [`01-data-preparation.qmd`](01-data-preparation.qmd) | Data preparation | Loads raw → cleans → **saves** `data/processed/consumer_clean.rds`. |
| [`02-descriptives.qmd`](02-descriptives.qmd) | Descriptives | Reads the cleaned data → summary table + first figures. |
| [`03-analysis.qmd`](03-analysis.qmd) | Analysis | Main effect, mediation, moderation. |
| [`about.qmd`](about.qmd) | About | Reproducibility, data-protection, and AI-use statements. |

## How the data flows

`01-data-preparation.qmd` is the only page that **writes** the cleaned dataset;
the others read it via `get_clean_consumer_data()` (in
[`../../R/functions/data_loading.R`](../../R/functions/data_loading.R)), which
reuses the cached file or rebuilds it if it's missing. So a full
`quarto render reports/webpage` cleans once (page 1 runs first) and every later
page reuses the result. Each page also renders standalone.

## Render

```bash
quarto render reports/webpage          # whole site
quarto render reports/webpage/03-analysis.qmd   # one page
```

## Adding pages (e.g. multiple studies)

Add a `.qmd` and list it in the `sidebar` in [`_quarto.yml`](_quarto.yml). To
mirror a multi-study project, nest pages under a section — e.g. a
`01-data-preparation.qmd` overview linking to `01-data-preparation-study1.qmd`,
`-study2.qmd`, and so on.
