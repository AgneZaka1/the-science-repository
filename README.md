# The Science Repository

A template for a modern, reproducible science project in R. One git repository
holds the **data**, the **analysis engine**, and two polished outputs built from
it: a **website** that shows the whole analysis transparently, and a **journal
manuscript**. Fork it, rename it, and fill it with your own work.

> 📊 **[Open the full analysis website →](https://your-username.github.io/the-science-repository/renders/webpage/)**
> Every cleaning step, figure, table, and model, rendered from the code in this repo.

---

## What lives where

Start here, then click into any folder's own README for the details.

| Folder | What it holds | More |
| --- | --- | --- |
| [`R/`](R/) | The **analysis engine**: setup + reusable functions. The single source of truth for the numbers. Nothing runs on its own — the reports call it. | [R/README.md](R/README.md) |
| [`data/`](data/) | Your data in three buckets: `mock/` (synthetic, committed), `raw/` and `processed/` (private, gitignored). | [data/README.md](data/README.md) |
| [`reports/`](reports/) | The **recipes you render** — and nothing else. `webpage/` builds the site; `manuscript/` builds the paper. Both reuse the `R/` engine. | [reports/README.md](reports/README.md) |
| [`renders/`](renders/) | The **rendered outputs**: the website in `webpage/`, the compiled paper in `manuscript/`. Don't hand-edit the website; the manuscript folder is mixed (see its README). | [renders/README.md](renders/README.md) |
| [`references/`](references/) | One `references.bib`, shared by the website and the manuscript. | [references/README.md](references/README.md) |
| [`shiny/`](shiny/) | A small interactive app that reuses the same data and functions. | [shiny/README.md](shiny/README.md) |
| [`.claude/`](.claude/) | Permission rules that stop an LLM from reading your raw data. | [.claude/README.md](.claude/README.md) |

The mental model: **`R/` computes, `reports/` present, `renders/` are the
results.** Change a function in `R/` and both the website and the paper update on
the next render — nothing is copied between them.

---

## Start here (first 10 minutes after forking)

1. **Rename the project.** Edit this file's title and the `name` in `the-science-repository.code-workspace`.
2. **Open in RStudio or VS Code** — open the folder, not individual files.
3. **Restore the R environment:**
   ```r
   install.packages("renv")   # only if you don't have it
   renv::restore()            # installs the exact package versions used here
   ```
4. **Copy the env template:** `cp .Renviron.example .Renviron`. Leave `DATA_MODE=mock` (default) or set `real`.
5. **Build the two outputs:**
   ```bash
   quarto render reports/webpage      # → renders/webpage/  (the website)
   quarto render reports/manuscript   # → renders/manuscript/generated/  (paper inputs)
   ```
   Then compile the paper: open [`renders/manuscript/main.tex`](renders/manuscript/) in Texifier (⌘B), or run `tinytex::latexmk("renders/manuscript/main.tex")`.

---

## The example analysis

The template ships with a synthetic consumer decision-making study (300 fake
participants, 5 message-framing conditions). Read it on the
[website](https://your-username.github.io/the-science-repository/renders/webpage/):
data preparation → descriptives → mediation/moderation analysis. Replace the
dataset and the report pages with your own when you fork.

---

## How publishing works

**Website → GitHub Pages.** Pages is served from the repository **root** with
Jekyll on (`_config.yml`). Jekyll renders *this README* as the landing page and
passes the rendered Quarto site in [`renders/webpage/`](renders/webpage/) through
as static files, so it's reachable at `…github.io/<repo>/renders/webpage/`.
Enable it once: **Settings → Pages → Deploy from a branch → `main` / `/ (root)`**.

> Why root and not `/docs`? GitHub Pages can only serve from `/` or `/docs`.
> Serving from root with Jekyll is what lets the site live in `renders/` and lets
> this README be the front door.

**Manuscript → PDF / Overleaf.** `reports/manuscript/*.qmd` generate the
data-driven parts of the paper (the methods/results text, figures, the model
table) into [`renders/manuscript/generated/`](renders/manuscript/); the
hand-written prose lives beside them in `renders/manuscript/sections/`.
[`renders/manuscript/main.tex`](renders/manuscript/) assembles everything into
`renders/manuscript/manuscript.pdf`. Because the whole `renders/manuscript/`
folder is self-contained, you can sync it to Overleaf as a git subtree for
co-authoring. See [renders/manuscript/README.md](renders/manuscript/README.md).

**App → Shiny.** `shiny::runApp("shiny/")` locally, or deploy to shinyapps.io.

---

## Reproducibility & sensitive data

- **R packages** are pinned with [`renv`](https://rstudio.github.io/renv/) (`renv.lock`). Run `renv::restore()` on a new machine; `renv::snapshot()` after installing packages.
- **Real data never gets committed.** Everything under `data/raw/` and `data/processed/` is gitignored, plus every common data extension everywhere except `data/mock/`. See [.gitignore](.gitignore) and [data/README.md](data/README.md).
- **LLM safety.** Open the repo with `the-science-repository.llm.code-workspace` (hides raw/processed from the editor); [`.claude/settings.json`](.claude/settings.json) also blocks tool reads of those folders. Scripts default to `DATA_MODE=mock`.
