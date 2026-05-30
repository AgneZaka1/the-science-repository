# `data/` — three buckets, one rule

| Subfolder | What goes here | Tracked in git? |
| --- | --- | --- |
| [`mock/`](mock/) | Small, synthetic, safe-to-share data with the same schema as the real thing. | **Yes** — always committed. |
| [`raw/`](raw/) | The original data, exactly as you received it. Never edit by hand. | **No** — content is gitignored. |
| [`processed/`](processed/) | Cleaned, joined, derived data produced by your scripts. | **No** — content is gitignored. |

## The rule

> **Raw data is read-only. Processed data is reproducible from raw data. Mock data is what the world sees.**

If a render fails after you delete `data/processed/`, that's a feature — the
data-preparation report ([`reports/webpage/01-data-preparation.qmd`](../reports/webpage/01-data-preparation.qmd))
rebuilds it from `mock/`, so the pipeline has to stay reproducible.

## Switching between mock and real

The reports read from `data/mock/` by default. To use the real data, set `DATA_MODE=real` in your `.Renviron`:

```
DATA_MODE=real
```

Then `R/01_setup.R` resolves `data_path("consumer_data_raw.csv")` to `data/raw/consumer_data_raw.csv`. Everything else in the analysis stays identical.

## Why this split exists

- **Privacy:** real data never leaves your machine. The .gitignore enforces it.
- **Collaboration:** anyone who forks this repo can run the full pipeline against `mock/` without asking you for files.
- **LLM safety:** the assistant only ever sees `mock/` — it cannot read what it cannot see.

See the root [README](../README.md) and [`.claude/`](../.claude/README.md) for the LLM workflow.
