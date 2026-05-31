# data_loading.R ----------------------------------------------------------
# Functions for loading and cleaning the consumer dataset.
# Part of the engine in R/; sourced (via R/01_setup.R) by every report.

#' Load the raw consumer dataset (defaults to the committed mock data).
#'
#' @param path Path to the CSV to read. Defaults to the synthetic
#'   `data/mock/consumer_data_raw.csv`. To run the analysis on your own data,
#'   pass a different path — e.g. `project_path("data", "raw", "my_data.csv")`
#'   (`data/raw/` is gitignored, so private data never gets committed).
load_raw_consumer_data <- function(path = project_path("data", "mock", "consumer_data_raw.csv")) {
  readr::read_csv(path, show_col_types = FALSE)
}

#' Clean the raw consumer dataset.
#'
#' Steps (in order):
#'   1. `janitor::clean_names()` — snake_case column names.
#'   2. Trim whitespace in `condition`.
#'   3. Recode messy `gender` labels into 4 canonical categories.
#'   4. Replace `-99` in `income_group` with `NA`; set ordered factor.
#'   5. Reverse-code `bt_3_r` -> `bt_3` (8 - x).
#'   6. Compute scale means (`price_sensitivity`, `sustainability_concern`,
#'      `brand_trust`, `perceived_value`, `purchase_intention`).
#'   7. Cast `condition`, `product_category`, `choice` to factors with
#'      explicit level orders.
clean_consumer_data <- function(raw) {
  d <- janitor::clean_names(raw)

  d$condition <- trimws(d$condition)

  gender_lookup <- c(
    "woman" = "woman", "Woman" = "woman", "W" = "woman",
    "female" = "woman", "Female" = "woman",
    "man" = "man", "Man" = "man", "M" = "man",
    "male" = "man", "Male" = "man",
    "non-binary" = "non_binary", "Non-binary" = "non_binary", "NB" = "non_binary",
    "Prefer not to say" = "prefer_not_to_say"
  )
  d$gender <- factor(unname(gender_lookup[d$gender]),
                     levels = c("woman", "man", "non_binary", "prefer_not_to_say"))

  d$income_group <- dplyr::na_if(d$income_group, "-99")
  d$income_group <- factor(d$income_group, levels = c("low", "medium", "high"),
                           ordered = TRUE)

  d$bt_3 <- 8L - d$bt_3_r

  scale_mean <- function(df, items) {
    rowMeans(df[, items], na.rm = TRUE)
  }
  d$price_sensitivity      <- scale_mean(d, c("ps_1", "ps_2", "ps_3"))
  d$sustainability_concern <- scale_mean(d, c("sc_1", "sc_2", "sc_3"))
  d$brand_trust            <- scale_mean(d, c("bt_1", "bt_2", "bt_3"))
  d$perceived_value        <- scale_mean(d, c("pv_1", "pv_2", "pv_3"))
  d$purchase_intention     <- scale_mean(d, c("pi_1", "pi_2", "pi_3"))

  d$condition <- factor(
    d$condition,
    levels = c("control", "scarcity_frame", "sustainability_frame",
               "social_proof_frame", "combined_frame")
  )
  d$product_category <- factor(d$product_category)
  d$choice <- factor(d$choice, levels = c(0, 1), labels = c("no", "yes"))

  d
}

#' Variables required for the main analysis (used to filter complete cases).
main_analysis_vars <- function() {
  c("purchase_intention", "condition", "perceived_value",
    "price_sensitivity", "age", "gender", "income_group")
}

#' Get the cleaned dataset.
#'
#' Reads the cached `data/processed/consumer_clean.rds` if it exists, otherwise
#' rebuilds it from raw. The data-preparation report
#' (`reports/webpage/01-data-preparation.qmd`) writes that cache; every report
#' downstream calls this helper, so a single page renders even if the cache
#' isn't there yet and a full render reuses the cache.
get_clean_consumer_data <- function() {
  cache <- processed_path("consumer_clean.rds")
  if (file.exists(cache)) readRDS(cache) else clean_consumer_data(load_raw_consumer_data())
}
