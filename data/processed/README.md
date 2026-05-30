# `data/processed/` — outputs of your cleaning pipeline

Everything here is produced by your scripts. It is gitignored because it is reproducible: anyone with `data/raw/` and your code can rebuild it.

## Rules

- **Never edit by hand.** If something looks wrong, fix the script.
- **Always overwriteable.** Deleting this folder and rerunning the pipeline must give the same result.
- **One file per analytical unit.** `consumer_clean.rds`, `items_long.rds`, `scales_wide.rds` — not one giant `everything.rds`.

If you find yourself wanting to commit a processed file because re-running takes too long, use a small caching helper (`cache/`) instead — or push the slow step into a separate script that runs once.
