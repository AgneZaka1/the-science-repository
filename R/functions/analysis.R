# analysis.R --------------------------------------------------------------
# Statistical models for the consumer decision-making analysis.
# Part of the engine in R/; sourced (via R/01_setup.R) by every report.

#' Descriptive table of outcomes by condition.
descriptives_by_condition <- function(d) {
  d |>
    dplyr::group_by(condition) |>
    dplyr::summarise(
      n               = dplyr::n(),
      mean_pi         = mean(purchase_intention, na.rm = TRUE),
      sd_pi           = stats::sd(purchase_intention,   na.rm = TRUE),
      mean_pv         = mean(perceived_value,    na.rm = TRUE),
      sd_pv           = stats::sd(perceived_value,      na.rm = TRUE),
      mean_wtp        = mean(willingness_to_pay, na.rm = TRUE),
      prop_choice_yes = mean(choice == "yes",     na.rm = TRUE),
      .groups = "drop"
    )
}

#' Main effect: condition predicts purchase intention.
fit_main_model <- function(d) {
  stats::lm(
    purchase_intention ~ condition + age + gender + income_group,
    data = d
  )
}

#' Three regressions for a conceptual mediation walkthrough.
#'   total: condition -> outcome
#'   a:     condition -> mediator
#'   b:     condition + mediator -> outcome
fit_mediation_models <- function(d) {
  list(
    total = stats::lm(purchase_intention ~ condition + age + gender + income_group, data = d),
    a     = stats::lm(perceived_value    ~ condition + age + gender + income_group, data = d),
    b     = stats::lm(purchase_intention ~ condition + perceived_value + age + gender + income_group, data = d)
  )
}

#' Moderation: condition * price_sensitivity on purchase intention.
fit_moderation_model <- function(d) {
  d$price_sensitivity_c <- as.numeric(scale(d$price_sensitivity, scale = FALSE))
  stats::lm(
    purchase_intention ~ condition * price_sensitivity_c + age + gender + income_group,
    data = d
  )
}
