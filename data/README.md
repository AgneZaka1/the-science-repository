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

## Using your own data

The analysis reads `data/mock/consumer_data_raw.csv` by default. To run it on your
own data, drop your file in `raw/` (gitignored) and point the loader at it in
[`reports/webpage/01-data-preparation.qmd`](../reports/webpage/01-data-preparation.qmd):

```r
raw <- load_raw_consumer_data(project_path("data", "raw", "your_data.csv"))
```

Everything downstream stays identical.

## Why this split exists

- **Privacy:** real data never leaves your machine. The .gitignore enforces it.
- **Collaboration:** anyone who forks this repo can run the full pipeline against `mock/` without asking you for files.
- **LLM safety:** the assistant only ever sees `mock/` — it cannot read what it cannot see.

See the root [README](../README.md) and [`.claude/`](../.claude/README.md) for the LLM workflow.
