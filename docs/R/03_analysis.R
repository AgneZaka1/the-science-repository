# 03_analysis.R -----------------------------------------------------------
# Descriptives, main model, mediation, moderation. Saves figures to
# `figures/` and a tidy model table to `data/processed/`.
#
# Run after: R/02_data_processing.R

source("R/01_setup.R")

clean <- readRDS(processed_path("consumer_clean.rds"))

# ---- 1. Descriptives ----------------------------------------------------
desc <- descriptives_by_condition(clean)
print(desc)

# ---- 2. Main model ------------------------------------------------------
fit_main <- fit_main_model(clean)
print(broom::tidy(fit_main, conf.int = TRUE))

# ---- 3. Mediation -------------------------------------------------------
med <- fit_mediation_models(clean)
print(broom::tidy(med$a,     conf.int = TRUE))
print(broom::tidy(med$b,     conf.int = TRUE))

# ---- 4. Moderation ------------------------------------------------------
fit_mod <- fit_moderation_model(clean)
print(broom::tidy(fit_mod, conf.int = TRUE))

# ---- 5. Figures ---------------------------------------------------------
dir.create(figure_path(), showWarnings = FALSE)

ggplot2::ggsave(figure_path("fig_01_pi_by_condition.png"),
                plot_pi_by_condition(clean),
                width = 7, height = 4, dpi = 200)
ggplot2::ggsave(figure_path("fig_02_mediation_scatter.png"),
                plot_mediation_scatter(clean),
                width = 7, height = 4, dpi = 200)
ggplot2::ggsave(figure_path("fig_03_moderation.png"),
                plot_moderation(clean),
                width = 7, height = 4, dpi = 200)

# ---- 6. Save tidy model table for the report ----------------------------
tidy_models <- dplyr::bind_rows(
  total       = broom::tidy(med$total, conf.int = TRUE),
  mediator    = broom::tidy(med$a,     conf.int = TRUE),
  outcome_w_m = broom::tidy(med$b,     conf.int = TRUE),
  moderation  = broom::tidy(fit_mod,   conf.int = TRUE),
  .id = "model"
)
saveRDS(tidy_models, processed_path("tidy_models.rds"))

message("Analysis complete. See `figures/` and `data/processed/tidy_models.rds`.")
