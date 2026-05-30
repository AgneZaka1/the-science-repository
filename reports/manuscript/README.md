# `reports/manuscript/` — manuscript recipe

The Quarto sources that generate the **data-driven parts** of the paper: the
methods and results sections, the figures, and the model table. They render into
[`../../renders/manuscript/generated/`](../../renders/manuscript/), where the
hand-written prose and [`main.tex`](../../renders/manuscript/) pick them up.

This folder holds **only the recipes** — no `.tex` output, no figures. Those are
results, and results live under `renders/`.

## Files

| File | What it produces |
| --- | --- |
| [`methods.qmd`](methods.qmd) | `renders/manuscript/generated/methods.tex` (+ copies the shared `.bib` in). |
| [`results.qmd`](results.qmd) | `renders/manuscript/generated/results.tex`, the figures in `generated/figures/`, and the model table in `generated/tabs/`. |
| [`_quarto.yml`](_quarto.yml) | Points `output-dir` at `renders/manuscript/generated/`. |
| [`_fragment.tex`](_fragment.tex) | A one-line Pandoc template (`$body$`) so each `.qmd` renders to an **`\input`-able fragment**, not a standalone document. |

## How it works

Each `.qmd` writes prose with inline numbers pulled live from the data (e.g. the
combined-frame estimate), and saves its figures/table through ordinary R code.
Rendering to LaTeX with the `_fragment.tex` template yields a body-only `.tex`
that [`main.tex`](../../renders/manuscript/) includes with `\input{}`.

```bash
quarto render reports/manuscript    # refresh generated/ in renders/manuscript/
```

Then compile the paper (see
[`../../renders/manuscript/README.md`](../../renders/manuscript/README.md)).

## The ownership rule

A manuscript section is **either** machine-generated **or** hand-written, never
both:

- **Generated here** (`methods.qmd`, `results.qmd`): edit the prose in the
  `.qmd` and re-render. The output in `generated/` carries a do-not-edit banner.
- **Hand-written** (introduction, discussion, abstract): live in
  `renders/manuscript/sections/`, edited directly / on Overleaf. R never touches
  them.
