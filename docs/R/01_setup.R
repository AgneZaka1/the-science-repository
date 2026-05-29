# 01_setup.R --------------------------------------------------------------
# Packages, paths, helpers, variable names. Source this first.
# Every other R script and the Quarto walkthrough source this file, so the
# project has exactly one place that decides "what packages do we use" and
# "what is the outcome variable called."

# ---- 1. Packages --------------------------------------------------------
required_packages <- c(
  "here",        # project-based paths
  "readr",       # read_csv()
  "dplyr",       # data wrangling
  "tidyr",       # pivots
  "janitor",     # clean_names()
  "ggplot2",     # plots
  "broom",       # tidy() model output
  "knitr"        # tables in Quarto
)

to_install <- setdiff(required_packages, rownames(installed.packages()))
if (length(to_install) > 0) install.packages(to_install)

invisible(lapply(required_packages, library, character.only = TRUE))

# ---- 2. Paths -----------------------------------------------------------
# `here::here()` always starts at the project root, no matter where the
# script is sourced from. Never use setwd() or absolute paths.

data_mode <- function() {
  mode <- Sys.getenv("DATA_MODE", unset = "mock")
  if (!mode %in% c("mock", "real")) {
    stop("DATA_MODE must be 'mock' or 'real' (got '", mode, "'). Edit your .Renviron.")
  }
  mode
}

data_path <- function(...) {
  subdir <- if (data_mode() == "mock") "mock" else "raw"
  base   <- Sys.getenv("RAW_DATA_DIR", unset = "")
  if (data_mode() == "real" && nzchar(base)) {
    file.path(base, ...)
  } else {
    here::here("data", subdir, ...)
  }
}

processed_path <- function(...) here::here("data", "processed", ...)
figure_path    <- function(...) here::here("figures", ...)

# ---- 3. Variable names (project glossary) -------------------------------
# Keeping these in one place means renaming a variable touches one file,
# not twenty.
id_var        <- "participant_id"
outcome_var   <- "purchase_intention"
mediator_var  <- "perceived_value"
moderator_var <- "price_sensitivity"
predictor_var <- "condition"

# ---- 4. Reproducibility -------------------------------------------------
set.seed(20260602)

# ---- 5. Load project functions ------------------------------------------
source(here::here("R", "functions", "data_loading.R"))
source(here::here("R", "functions", "analysis.R"))
source(here::here("R", "functions", "plotting.R"))

message("Setup complete. DATA_MODE = ", data_mode(),
        ". Project root: ", here::here())
