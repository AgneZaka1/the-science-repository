# `renders/manuscript/` — the paper (and the Overleaf folder)

This folder is the complete LaTeX paper. It is **self-contained**: everything
[`main.tex`](main.tex) needs lives inside it, so you can sync the whole folder to
Overleaf as a git subtree and co-authors get a paper that compiles.

It is a **mixed workspace** — part hand-written, part machine-generated. The
boundary is the folder you're in:

| Path | Owner | Edit it? |
| --- | --- | --- |
| `main.tex` | You | ✅ Hand-written (preamble + `\input` order). |
| `sections/abstract.tex`, `introduction.tex`, `discussion.tex` | You / co-authors | ✅ Prose. Live-edit here or on Overleaf. |
| `generated/methods.tex`, `results.tex` | `reports/manuscript/*.qmd` | ❌ Generated. Edit the `.qmd`, re-render. |
| `generated/figures/`, `generated/tabs/` | `reports/manuscript/results.qmd` | ❌ Generated figures + model table. |
| `generated/references.bib` | copied from [`../../references/`](../../references/) | ❌ Refreshed on render. |
| `manuscript.pdf` | the LaTeX compiler | ❌ Build output. |

> Rule of thumb: **`sections/` and `main.tex` are yours; everything in
> `generated/` is the machine's.** A render only ever overwrites `generated/`,
> so your prose is safe.

## Build the PDF

1. Refresh the generated parts:
   ```bash
   quarto render reports/manuscript
   ```
2. Compile `main.tex`:
   - **Texifier:** open `main.tex`, ⌘B. Set its output to this folder.
   - **R / tinytex:** `tinytex::latexmk("renders/manuscript/main.tex")` → `manuscript.pdf` here.

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
