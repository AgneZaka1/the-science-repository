# `reports/` — the recipes you render

This folder holds **only the sources you render**, split by what they produce.
Each subfolder reuses the same engine in [`../R/`](../R/) but formats the results
differently — a webpage needs interactive HTML tables; a paper needs LaTeX.

| Subfolder | Renders to | What it is | More |
| --- | --- | --- | --- |
| [`webpage/`](webpage/) | [`../renders/webpage/`](../renders/webpage/) | A multi-page Quarto **website** — the transparent, click-through analysis. | [webpage/README.md](webpage/README.md) |
| [`manuscript/`](manuscript/) | [`../renders/manuscript/`](../renders/manuscript/) | Quarto recipes that generate the data-driven parts of the **journal paper**. | [manuscript/README.md](manuscript/README.md) |

## The split, in one line

> **`reports/` = recipes. [`renders/`](../renders/) = results.** Recipes never
> contain rendered output; results are never hand-written (except the
> manuscript's prose — see its README).

## Render

```bash
quarto render reports/webpage      # → ../renders/webpage/  (the website)
quarto render reports/manuscript   # → ../renders/manuscript/generated/  (paper inputs)
```

Both pull data and functions from `../R/` by anchoring on the git root, so they
run the same way no matter which folder you start from.
