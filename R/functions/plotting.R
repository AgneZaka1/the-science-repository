# plotting.R --------------------------------------------------------------
# ggplot2 helpers. Each function returns a plot object so the caller decides
# whether to display it or save it.

#' Distribution of purchase intention by condition.
plot_pi_by_condition <- function(d) {
  ggplot2::ggplot(d, ggplot2::aes(x = condition, y = purchase_intention)) +
    ggplot2::geom_jitter(width = 0.15, alpha = 0.25) +
    ggplot2::stat_summary(fun = mean, geom = "point", size = 3, colour = "firebrick") +
    ggplot2::stat_summary(fun.data = ggplot2::mean_cl_normal,
                          geom = "errorbar", width = 0.15, colour = "firebrick") +
    ggplot2::labs(x = NULL, y = "Purchase intention (1–7)") +
    ggplot2::theme_minimal()
}

#' Mediator (perceived value) vs outcome (purchase intention), coloured by condition.
plot_mediation_scatter <- function(d) {
  ggplot2::ggplot(d, ggplot2::aes(x = perceived_value, y = purchase_intention,
                                  colour = condition)) +
    ggplot2::geom_jitter(width = 0.05, height = 0.05, alpha = 0.5) +
    ggplot2::geom_smooth(method = "lm", se = FALSE) +
    ggplot2::labs(x = "Perceived value", y = "Purchase intention",
                  colour = NULL) +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "bottom")
}

#' Moderation: condition effect at low/mean/high price sensitivity.
plot_moderation <- function(d) {
  ps_breaks <- stats::quantile(d$price_sensitivity, c(.16, .5, .84), na.rm = TRUE)
  d$ps_band <- cut(d$price_sensitivity,
                   breaks = c(-Inf, ps_breaks[1], ps_breaks[3], Inf),
                   labels = c("low PS", "mid PS", "high PS"))
  ggplot2::ggplot(stats::na.omit(d[, c("condition", "purchase_intention", "ps_band")]),
                  ggplot2::aes(x = condition, y = purchase_intention, colour = ps_band)) +
    ggplot2::stat_summary(fun.data = ggplot2::mean_cl_normal,
                          geom = "pointrange",
                          position = ggplot2::position_dodge(width = 0.4)) +
    ggplot2::labs(x = NULL, y = "Purchase intention",
                  colour = "Price sensitivity") +
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "bottom")
}
