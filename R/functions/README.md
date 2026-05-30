# `R/functions/` — reusable functions

The engine's building blocks. One file per topic; all of them are `source()`d by
[`../01_setup.R`](../01_setup.R), so reports get them for free.

| File | What's in it |
| --- | --- |
| [`data_loading.R`](data_loading.R) | `load_raw_consumer_data()`, `clean_consumer_data()`, and `get_clean_consumer_data()` (reads the cached clean file or rebuilds it). |
| [`analysis.R`](analysis.R) | `descriptives_by_condition()` and the model fitters (`fit_main_model()`, `fit_mediation_models()`, `fit_moderation_model()`). |
| [`plotting.R`](plotting.R) | `plot_pi_by_condition()`, `plot_mediation_scatter()`, `plot_moderation()` — each returns a ggplot the caller displays or saves. |

Keep functions **pure**: take inputs, return outputs, don't reach into the global
environment, don't save or print. That makes them easy to test, easy to reuse
across the website / manuscript / app, and easy for an LLM to reason about.
