# `data/mock/` — synthetic, shareable

Small fake datasets that mirror the schema of your real data. **Committed to git** and visible to anyone who forks the repo (including the LLM on Day 3).

## What ships with the template

| File | What it is |
| --- | --- |
| [`consumer_data_raw.csv`](consumer_data_raw.csv) | 300-row synthetic consumer decision-making dataset. Deliberately messy. |
| [`codebook.md`](codebook.md) | Variable descriptions, baked-in effects, list of messes. |
| [`_generate.R`](_generate.R) | The generator. Re-run any time. |

Replace these with your own mock data when you fork. Use the codebook + generator as a template.

## How to make mock data

1. Match column names, types, and ranges exactly to your real data.
2. Keep it small (a few hundred rows is plenty).
3. Use `set.seed()` so the mock is reproducible.
4. Bake in the effects you want to teach — otherwise the analysis examples won't find anything.

See [`_generate.R`](_generate.R) for a worked example. Re-run any time:

```bash
Rscript data/mock/_generate.R
```

## What NOT to put here

Anything derived from real respondents, even aggregated. If in doubt, generate fresh synthetic data instead.
