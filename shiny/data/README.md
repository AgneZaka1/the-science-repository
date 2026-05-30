# `shiny/data/` — data the app ships with

Synthetic only. Whatever lives here gets deployed with the app.

The app in [`../app.R`](../app.R) doesn't read this folder directly — it reuses
the project engine, which loads the same mock dataset the analysis uses:

```r
source(here::here("R", "01_setup.R"))
consumer <- get_clean_consumer_data()   # reads data/mock/ by default
```

That keeps one source of truth in [`../../data/mock/`](../../data/mock/) and
avoids drift. If you'd rather ship a standalone copy with a deployed app, put a
synthetic CSV here and read it explicitly — never deploy real data.
