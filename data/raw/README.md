# `data/raw/` — the original, untouched

Drop your raw data files here. Everything in this folder except this README is gitignored.

## Rules

- **Read-only.** Your scripts read from here; they never write here.
- **Original format.** If you received a `.sav`, keep it as `.sav`. Convert downstream.
- **No edits by hand.** If a value is wrong, fix it in `reports/webpage/01-data-preparation.qmd` and its linked `R/functions/data_loading.R` so the correction is documented and reproducible.

## Getting raw data onto a new machine

The raw files don't come with the repo. Common patterns:

- Download from OSF / your institution's storage, drop into this folder.
- Sync with `rclone` or `osfr::osf_download()` in a setup script.
- For sensitive data, store the path in `.Renviron` and copy manually.

When you set up a new fork, document here (in this README, after you fork) where your real data comes from.
