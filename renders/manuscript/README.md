# `renders/manuscript/` — the paper (and the Overleaf folder)

This folder is the complete LaTeX paper. It is **self-contained**: everything
[`manuscript.tex`](manuscript.tex) needs lives inside it, so you can sync the
whole folder to Overleaf as a git subtree and co-authors get a paper that
compiles.

It is a **mixed workspace** — part hand-written, part machine-generated. The
boundary is the folder you're in:

| Path | Owner | Edit it? |
| --- | --- | --- |
| `manuscript.tex` | You | ✅ Hand-written (preamble + `\input` order). |
| `sections/abstract.tex`, `introduction.tex`, `discussion.tex` | You / co-authors | ✅ Prose. Live-edit here or on Overleaf. |
| `generated/methods_and_results.tex` | `reports/manuscript/methods_and_results.qmd` | ❌ Generated LaTeX fragment (methods + results, with figures and the model table). Edit the `.qmd`, re-render. |
| `generated/methods_and_results.docx` | same `.qmd` | ❌ Generated APA-styled **Word** edition of the methods + results. |
| `generated/methods_and_results_files/` | same `.qmd` | ❌ Generated figures the LaTeX fragment references. |
| `generated/references.bib` | copied from [`../../references/`](../../references/) | ❌ Refreshed on render. |
| `manuscript.pdf` | the LaTeX compiler | ❌ Build output. |

> Rule of thumb: **`sections/` and `manuscript.tex` are yours; everything in
> `generated/` is the machine's.** A render only ever overwrites `generated/`,
> so your prose is safe.

## Build the PDF

1. Refresh the generated parts:
   ```bash
   quarto render reports/manuscript
   ```
2. Compile `manuscript.tex`:
   - **Texifier:** open `manuscript.tex`, ⌘B. Set its output to this folder.
   - **R / tinytex:** `tinytex::latexmk("renders/manuscript/manuscript.tex")` → `manuscript.pdf` here.

## The Word edition

The same `quarto render reports/manuscript` that refreshes the LaTeX fragment
also writes `generated/methods_and_results.docx` — a high-quality, APA-styled
**Word** version of the generated methods + results, produced natively by Quarto
(no extra step or script). It covers the *generated* sections only; the
hand-written introduction and discussion stay in LaTeX. Use it when a co-author
works in Track Changes or a journal portal wants `.docx`. Details:
[`../../reports/manuscript/README.md`](../../reports/manuscript/README.md).

## Collaborate on Overleaf

Sync this folder as a git subtree (Overleaf → Menu → Git):

```bash
git remote add overleaf <overleaf-url>
git subtree push --prefix=renders/manuscript overleaf master
git subtree pull --prefix=renders/manuscript overleaf master
```

Co-authors edit the prose in `sections/`; you regenerate `generated/` locally and
push. Because both live in this one folder, Overleaf compiles a figure-complete
PDF. The `.qmd` recipes that feed this folder live in
[`../../reports/manuscript/`](../../reports/manuscript/).
