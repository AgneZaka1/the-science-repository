# `renders/` — the rendered outputs

The finished products built from [`../reports/`](../reports/). Two targets, two
subfolders.

| Subfolder | What it is | Hand-edit? | Built by |
| --- | --- | --- | --- |
| [`webpage/`](webpage/) | The Quarto **website** (HTML + assets). GitHub Pages serves it at `…/renders/webpage/`. | **No** — 100% generated. | `quarto render reports/webpage` |
| [`manuscript/`](manuscript/) | The **journal paper**: `main.tex`, prose, generated parts, and the compiled `manuscript.pdf`. Synced to Overleaf. | **Mixed** — see its README. | `quarto render reports/manuscript` + a LaTeX compile |

## Two different rules

- **`webpage/` is disposable.** Delete it and `quarto render reports/webpage`
  rebuilds it exactly. Never edit it by hand.
- **`manuscript/` is a mixed workspace.** It holds hand-written prose
  (`main.tex`, `sections/*.tex`) *and* machine-generated files (`generated/`).
  Don't "clean" it blindly — read [manuscript/README.md](manuscript/README.md)
  first.

Everything here is committed to git (see [.gitignore](../.gitignore)): the
website so GitHub Pages can serve it, the manuscript so reviewers and Overleaf
have the whole paper.
