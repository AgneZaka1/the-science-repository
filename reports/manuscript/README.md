# `reports/manuscript/` — manuscript recipe

The Quarto source that generates the **data-driven parts** of the paper — the
methods and results sections, with their figures and the model table. One file,
[`methods_and_results.qmd`](methods_and_results.qmd), renders to **two formats at
once**:

- **LaTeX** — a body-only fragment that [`manuscript.tex`](../../renders/manuscript/)
  pulls in with `\input{}`, feeding the LaTeX / Overleaf / PDF path.
- **Word** — a self-contained, APA-styled `.docx`: the "knit to Word" output of
  the generated sections.

Both come from one `quarto render` (or the **Render** button in RStudio / VS
Code), and both land in [`../../renders/manuscript/generated/`](../../renders/manuscript/),
beside the hand-written prose. This folder holds **only the recipe** — no `.tex`
or `.docx` output, no figures. Those are results, and results live under
`renders/`.

```bash
quarto render reports/manuscript    # → generated/methods_and_results.tex  AND  .docx
```

No PDF is built here — Overleaf or your local LaTeX engine compiles
`manuscript.tex` (see [`../../renders/manuscript/README.md`](../../renders/manuscript/README.md)).

## Files

| File | What it is |
| --- | --- |
| [`methods_and_results.qmd`](methods_and_results.qmd) | The generated methods + results, in Quarto markdown. Numbers, figures, and the model table all come live from the [`R/`](../../R/) engine. Renders to `.tex` **and** `.docx`. |
| [`_quarto.yml`](_quarto.yml) | Declares the two output formats and points `output-dir` at `renders/manuscript/generated/`. |
| [`_fragment.tex`](_fragment.tex) | A one-line Pandoc template (`$body$`) so the **LaTeX** output is an `\input`-able fragment, not a standalone document. (The Word output ignores it.) |
| [`reference.docx`](reference.docx) | The Word **style template** (APA-style) whose fonts and headings the `.docx` output adopts. Replace it with your journal's, or delete it for plain Word styling. |

## How it works

`methods_and_results.qmd` writes prose with inline numbers pulled live from the
data (e.g. the combined-frame estimate), and produces its figures and table from
ordinary R code chunks. Quarto then renders it to each format the right way:

- **Figures** — vector PDF for LaTeX, 300-dpi PNG embedded for Word. Same chunk,
  no manual exporting; cross-references (`@fig-…`, `@tbl-models`) work in both.
- **Table** — a booktabs/longtable in LaTeX, a native Word table in `.docx`.
- The LaTeX fragment carries a do-not-edit banner and is `\input` by
  `manuscript.tex`; the figures it references sit in
  `generated/methods_and_results_files/`.

For APA-exact citations in the Word output, drop an `apa.csl` into
[`../../references/`](../../references/) and add `csl:` to the `docx` format in
[`_quarto.yml`](_quarto.yml) (see the references README).

## The ownership rule

A manuscript section is **either** machine-generated **or** hand-written, never
both:

- **Generated here** (`methods_and_results.qmd`): edit the prose in the `.qmd`
  and re-render. The LaTeX output in `generated/` carries a do-not-edit banner.
- **Hand-written** (introduction, discussion, abstract): live in
  `renders/manuscript/sections/`, edited directly / on Overleaf. R never touches
  them. Naming the generated file `methods_and_results` keeps that line crisp:
  what's in it is generated; everything in `sections/` is yours.
