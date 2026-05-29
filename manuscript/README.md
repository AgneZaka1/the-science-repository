# `manuscript/` — paper outputs

The static, paper-style version of your work. Two routes land here:

1. **Auto-rendered from the walkthrough.** `quarto render` produces
   `output/walkthrough.pdf` and `output/walkthrough.docx` from
   [`../reports/00_walkthrough.qmd`](../reports/00_walkthrough.qmd). A
   post-render hook ([`../scripts/post_render.R`](../scripts/post_render.R))
   moves them out of `docs/` and into here. **This is the easy path.**
2. **Hand-written LaTeX in [`main.tex`](main.tex).** Use this when you need
   journal-specific formatting (a class file, a specific bibliography
   style, custom title pages). The walkthrough's figures in
   [`../figures/`](../figures/) and the shared `.bib` work the same way.

Pick whichever fits the destination. Internal report or working PDF → the
walkthrough route. Journal submission → hand-written LaTeX, often via
Overleaf.

## Files

- `main.tex` — hand-written paper.
- `output/` — rendered PDFs and DOCX (from both routes). Committed so
  reviewers can read without compiling.

## Render locally

**Option A — Texifier (paid, macOS, what we use in the workshop):**
Open `main.tex` in [Texifier](https://www.texifier.com/). Hit ⌘B. Output lands in `output/`.

**Option B — tinytex (free, works in R):**

```r
install.packages("tinytex")
tinytex::install_tinytex()   # one-time, installs a portable TeX
tinytex::pdflatex("manuscript/main.tex", clean = TRUE)
```

Both produce the same PDF. Texifier is nicer for writing; `tinytex` is nicer for "render this from a script."

## Collaborate via Overleaf

Overleaf has built-in git integration:

1. On Overleaf, create a project → **Menu** → **Git** → copy the URL.
2. Locally, in this `manuscript/` folder:
   ```bash
   git remote add overleaf <overleaf-url>
   git subtree push --prefix=manuscript overleaf master
   ```
3. Pull collaborator changes back with `git subtree pull --prefix=manuscript overleaf master`.

Treat Overleaf as a remote for the `manuscript/` subtree only. The rest of the repo stays on GitHub.

## Citations

The `.bib` and `.csl` files live in [`../references/`](../references/) and are shared with Quarto reports. In `main.tex`:

```latex
\bibliography{../references/references}
\bibliographystyle{apa}
```
