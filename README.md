# The Science Repository

A template for a modern, reproducible science project in R. Fork this, rename it, and start working.

This is the Day 1 scaffold for the R workshop. By the end of Day 3, the same structure becomes a publishing pipeline (Quarto + LaTeX + GitHub Pages + Shiny) that you can drive with an LLM assistant inside VS Code.

---

## What lives where

| Folder | What you put in it |
| --- | --- |
| [`R/`](R/) | All your R code — analysis scripts and reusable functions. |
| [`data/`](data/) | Your data. `mock/` is committed, `raw/` and `processed/` are gitignored. |
| [`reports/`](reports/) | Quarto sources (`.qmd`) — annotated code that becomes the website. |
| [`docs/`](docs/) | Rendered Quarto output. GitHub Pages serves this folder. **Don't edit by hand.** |
| [`manuscript/`](manuscript/) | LaTeX paper. Renders locally with Texifier/tinytex, syncs to Overleaf. |
| [`shiny/`](shiny/) | A small Shiny app that reuses your data and functions. |
| [`references/`](references/) | One `references.bib` exported from Zotero — used by both Quarto and LaTeX. |
| [`figures/`](figures/) | Plots saved by your scripts. Committed so reviewers can see them without re-running. |
| [`.claude/`](.claude/) | Permission rules that stop the LLM from reading your raw data. |

---

## Start here (first 10 minutes after forking)

1. **Rename the project.** Edit this file's title and update the `name` in `the-science-repository.code-workspace`.
2. **Open in RStudio or VS Code.** Both work. Open the folder, not individual files.
3. **Restore the R environment:**
   ```r
   install.packages("renv")   # only if you don't have it
   renv::restore()            # installs the exact package versions used here
   ```
4. **Copy your env template:** `cp .Renviron.example .Renviron`. Edit `DATA_MODE=mock` (default) or `real`.
5. **Run the pipeline end-to-end:**
   ```bash
   Rscript R/02_data_processing.R   # raw -> clean
   Rscript R/03_analysis.R          # models + figures
   quarto render                    # website -> docs/
   ```

If `renv::restore()` doesn't find a lockfile yet, you're the first author — run `renv::init()` instead. See [Environment management](#environment-management) below.

## The example analysis

The template ships with a synthetic consumer decision-making study (300 fake participants, 5 message-framing conditions). See [`reports/00_walkthrough.qmd`](reports/00_walkthrough.qmd) — it walks through loading, cleaning, descriptives, regression, mediation, and moderation, and renders to HTML/PDF/DOCX from one source. Replace the dataset and the walkthrough with your own when you fork.

---

## How the pieces fit together

```
Zotero ──► references/references.bib ──┐
                                       │
data/  ──► R/  ──► reports/*.qmd ──► docs/   (Quarto → website)
                                  └► manuscript/  (LaTeX → PDF / Overleaf)
                                  └► shiny/       (interactive app)
                                  └► figures/     (static plots)
```

All outputs live in the same repo. One source of truth. One git history.

---

## Environment management

**Primary: `renv` (R packages).** Every project has its own pinned package library. The lockfile (`renv.lock`) goes into git; the actual library does not.

```r
renv::init()      # first time, in a new fork
renv::snapshot()  # after you install new packages — updates the lockfile
renv::restore()   # on a new machine — installs from the lockfile
```

**For Python (later in the workshop):** prefer `conda` for reproducibility across OSes.

```bash
conda create -n science-repo python=3.11
conda activate science-repo
conda env export --from-history > environment.yml   # commit this file
```

You can use renv and conda side by side. renv tracks R; conda tracks Python and any system-level binaries (e.g., `pandoc`, `quarto`, TeX). Don't mix the two for the same language.

---

## Working with an LLM (Day 3)

You will use Claude in VS Code (or Cursor / Continue) to help you write code against this repo. To keep your raw data private:

1. **The LLM only ever sees what VS Code sees.** Open VS Code with `the-science-repository.llm.code-workspace` — this workspace deliberately excludes `data/raw/` and `data/processed/`.
2. **Belt and suspenders:** [`.claude/settings.json`](.claude/settings.json) denies reads on those folders even if you opened the full workspace.
3. **Scripts default to mock data.** As long as `DATA_MODE=mock`, every read goes through `data/mock/`. Flip to `real` only when you're actually running the analysis.

This means: **one copy of every script, no duplication.** Mode is controlled by which workspace you open and one env var.

---

## Sensitive data: the rule

Anything under `data/raw/` or `data/processed/` is gitignored, plus every common data extension (`.csv`, `.sav`, `.xlsx`, `.dta`, `.rds`, …) is gitignored everywhere except `data/mock/`. If you find yourself fighting the .gitignore, you're probably about to commit something you shouldn't.

See [`.gitignore`](.gitignore) for the exact rules and [`data/README.md`](data/README.md) for the mock/raw/processed convention.

---

## Publishing

One source, three folders. `quarto render` produces:

| Output | Lands in | Notes |
| --- | --- | --- |
| Website (HTML) | [`docs/`](docs/) | GitHub Pages → "Deploy from branch" → `main`/`docs`. |
| Paper PDF | [`manuscript/output/`](manuscript/output/) | Auto-moved by [`scripts/post_render.R`](scripts/post_render.R). Needs `tinytex`. |
| Paper DOCX | [`manuscript/output/`](manuscript/output/) | For collaborators who don't use LaTeX. |

The orchestration file is [`reports/00_walkthrough.qmd`](reports/00_walkthrough.qmd) — its YAML lists `html`, `pdf`, and `docx` formats so a single `quarto render` fills every folder.

- **For a hand-crafted journal manuscript:** edit `manuscript/main.tex` instead (Texifier or `tinytex::pdflatex()`), or push to Overleaf via git. See [`manuscript/README.md`](manuscript/README.md).
- **App:** `shiny::runApp("shiny/")` locally, or deploy to shinyapps.io.

Each folder's README walks you through the specifics.
