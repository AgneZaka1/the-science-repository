# =============================================================================
#  Day 2 · Pt. 3 — FUNCTIONS (the "engine")
#  Take the recipes from Pt. 2 and define each one ONCE, under a name.
# =============================================================================
#
#  WHAT IS A FUNCTION, AND WHY WRITE OUR OWN?
#  In Pt. 1 we *called* functions other people wrote (mean, round, read_csv).
#  Here we *write* our own. A function packages a sequence of steps under a
#  name, with named inputs, so that:
#     - you describe the recipe once, then reuse it by name;
#     - a fix happens in one place, not in five pasted copies;
#     - the script that uses it reads like a summary, not a wall of detail.
#
#  ANATOMY OF A FUNCTION DEFINITION
#
#     my_function <- function(input1, input2) {   # inputs (arguments)
#       ...steps that use input1, input2...        # body
#       result                                      # the last value is returned
#     }
#
#  Notice this file only DEFINES functions — it reads no files, prints nothing,
#  saves nothing. It is a toolbox. Sourcing it just makes the tools available;
#  the caller decides when and how to use them. That separation — "define here,
#  use there" — is exactly how the real project's  R/functions/  folder works.
#
#  The #' comment lines above each function are documentation: a one-line
#  description and what each argument means. Get into this habit early.
# =============================================================================


#' Clean the raw consumer dataset into an analysis-ready table.
#'
#' @param raw  The raw data frame, straight from read_csv().
#' @return     A cleaned data frame: tidy names, condition as a factor, and a
#'             purchase_intention scale score averaged from the three pi_ items.
clean_consumer <- function(raw) {
  raw |>
    janitor::clean_names() |>
    dplyr::mutate(
      condition = factor(trimws(condition)),
      purchase_intention = rowMeans(
        dplyr::across(c(pi_1, pi_2, pi_3)), na.rm = TRUE
      )
    )
}


#' Summarise purchase intention by experimental condition.
#'
#' @param d  A cleaned data frame (output of clean_consumer()).
#' @return   One row per condition: n, mean and SD of purchase intention.
pi_by_condition <- function(d) {
  d |>
    dplyr::group_by(condition) |>
    dplyr::summarise(
      n              = dplyr::n(),
      mean_intention = mean(purchase_intention, na.rm = TRUE),
      sd_intention   = stats::sd(purchase_intention, na.rm = TRUE),
      .groups = "drop"
    )
}


#' Boxplot of purchase intention by condition.
#'
#' @param d  A cleaned data frame (output of clean_consumer()).
#' @return   A ggplot object (the caller decides whether to print or save it).
plot_pi <- function(d) {
  ggplot2::ggplot(d, ggplot2::aes(x = condition, y = purchase_intention)) +
    ggplot2::geom_boxplot(fill = "grey90") +
    ggplot2::labs(
      title = "Purchase intention by message frame",
      x     = NULL,
      y     = "Purchase intention (1-7)"
    ) +
    ggplot2::theme_minimal()
}


# ---- Reporting helper ----------------------------------------------------
# The engine doesn't only crunch numbers — it can format them too. This one
# writes a mean and SD the way a journal expects, so the *report* (Pt. 4) can
# drop a live, correctly-styled statistic straight into a sentence.

#' Format a vector's mean and SD in APA (7th ed.) style.
#'
#' Returns a string like  "*M* = 4.60, *SD* = 0.96".  Following APA:
#'   - the symbols M and SD are italicised (the *...* renders as italic in the
#'     report; in inline code its result is treated as markdown);
#'   - statistics are given to two decimals;
#'   - the leading zero is kept, because a mean or SD can exceed 1.
#' Only the inner text is returned (no surrounding parentheses), so the sentence
#' that calls it decides on the brackets — e.g.  (`r apa_msd(x)`).
#'
#' @param x       A numeric vector, e.g. clean$purchase_intention.
#' @param digits  Decimal places (default 2 — the APA norm for scale scores).
#' @return        A length-1 character string, ready to use as inline code.
apa_msd <- function(x, digits = 2) {
  m <- mean(x, na.rm = TRUE)
  s <- stats::sd(x, na.rm = TRUE)
  sprintf("*M* = %.*f, *SD* = %.*f", digits, m, digits, s)
}


# -----------------------------------------------------------------------------
#  A NOTE ON  package::function()
#  Inside a shared functions file we write dplyr::mutate() instead of just
#  mutate(). The :: spells out which package each function comes from, so the
#  engine works even if the caller forgot to library(dplyr). The real project's
#  R/functions/ files are written exactly this way, for exactly this reason.
#
#  This file produces no output on its own. To see it in action, open
#  04_script_with_functions.R, which sources this file and USES the three
#  analysis functions; the report 05_report.qmd sources it too and adds
#  apa_msd() inline. Sourcing a file = running it silently to load its
#  definitions, the same way  R/01_setup.R  sources the project's engine.
# =============================================================================
