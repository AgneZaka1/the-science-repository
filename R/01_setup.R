# 01_setup.R --------------------------------------------------------------
# Packages, paths, helpers, variable names. The reusable engine's entry point.
# Every report (reports/webpage/*.qmd and reports/manuscript/*.qmd) runs
# `source(here::here("R", "01_setup.R"))` first, so the project has exactly one
# place that decides "what packages do we use" and "what is the outcome
# variable called." This file defines things; it never writes files — the
# reports own every save.

# ---- 1. Packages --------------------------------------------------------
required_packages <- c(
  "rprojroot",   # find the repo root from any sub-folder (see project_path)
  "readr",       # read_csv()
  "dplyr",       # data wrangling
  "tidyr",       # pivots
  "janitor",     # clean_names()
  "ggplot2",     # plots
  "broom",       # tidy() model output
  "knitr"        # tables in Quarto
)

to_install <- setdiff(required_packages, rownames(installed.packages()))
if (length(to_install) > 0) install.packages(to_install, repos = "https://cloud.r-project.org")

invisible(lapply(required_packages, library, character.only = TRUE))

# ---- 2. Paths -----------------------------------------------------------
# `project_path()` always resolves from the repository root (the git root), no
# matter which sub-folder a report renders from. We anchor on .git rather than
# `here::here()` because each report is its own Quarto project, and here::here()
# would stop at the report's folder instead of the repo root. Never use setwd()
# or absolute paths.

project_path <- function(...) {
  file.path(rprojroot::find_root(rprojroot::is_git_root), ...)
}

processed_path <- function(...) project_path("data", "processed", ...)

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
source(project_path("R", "functions", "data_loading.R"))
source(project_path("R", "functions", "analysis.R"))
source(project_path("R", "functions", "plotting.R"))

message("Setup complete. Project root: ", project_path())
