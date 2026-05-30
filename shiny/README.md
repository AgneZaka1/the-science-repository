# `shiny/` — interactive app

A small Shiny app that lets non-coders explore your data. Reuses the same functions in [`../R/functions/`](../R/functions/) — don't duplicate logic here.

## Run locally

```r
shiny::runApp("shiny/")
```

## Structure

- `app.R` — UI + server in one file. It runs `source(here::here("R", "01_setup.R"))` and calls `get_clean_consumer_data()` + `plot_pi_by_condition()`, so it shares the engine with the website and the paper — no duplicated logic. Split into `ui.R` / `server.R` when it grows past ~300 lines.
- `data/` — mock data the app ships with. **Use synthetic data only** unless you control who can reach the deployed app.

## Deploy

- Free tier: [shinyapps.io](https://www.shinyapps.io/) — `rsconnect::deployApp("shiny/")`.
- Self-hosted: Shiny Server or Posit Connect.

## Important

The deployed app sees whatever data you ship in `shiny/data/`. **Never deploy with real data unless your hosting is access-controlled.** When in doubt, ship the mock.
