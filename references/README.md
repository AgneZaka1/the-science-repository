# `references/` — citations, one source of truth

One `references.bib` for the whole repo. The website reads it directly; the
manuscript render copies it into [`../renders/manuscript/generated/`](../renders/manuscript/)
so the Overleaf folder stays self-contained. Edit it in one place, everything
re-cites on the next render.

## The Zotero workflow

1. Install [Better BibTeX](https://retorque.re/zotero-better-bibtex/) in Zotero.
2. In Zotero: right-click your collection → **Export Collection** → format **Better BibLaTeX** → **Keep updated**, export to `references/references.bib`.
3. Zotero now overwrites this file every time you add a reference. Commit the updates.

## Citation keys

Set Better BibTeX to `[auth:lower][year]` so keys look like `smith2020`. Then:

- **Quarto (website):** `[@smith2020]` produces "(Smith, 2020)".
- **LaTeX (manuscript):** `\citep{smith2020}` does the same.

## Citation style

Drop a `.csl` file here (download from the [Zotero style repository](https://www.zotero.org/styles)) and reference it from a `.qmd`'s YAML or the webpage `_quarto.yml`:

```yaml
csl: ../../references/apa.csl
```

LaTeX uses `\bibliographystyle{}` instead — see [`../renders/manuscript/README.md`](../renders/manuscript/README.md).

## Why one shared `.bib`?

So your paper, your website, and your slides all cite the same way. If you fix a reference in Zotero, every output updates the next time you render.
