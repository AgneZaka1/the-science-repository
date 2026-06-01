# =============================================================================
#  Day 2 · Pt. 3 (payoff) — THE SAME ANALYSIS, USING THE ENGINE
#  Compare this file to 02_first_script.R. Same result, a fraction of the code.
# =============================================================================
#
#  This is the whole point of writing functions. The detailed recipes now live
#  in 03_functions.R; here we just load the data, call them by name, and save.
#  The script reads like a table of contents for the analysis — you can see the
#  shape of the work at a glance, and the messy details are one click away.
#
#  This is exactly the pattern you will meet in the project this afternoon:
#     R/01_setup.R          loads packages and source()s the function files
#     R/functions/*.R       define clean_consumer_data(), the models, the plots
#     reports/webpage/*.qmd  call those functions and tell the story
#  We have just built a two-file version of that same idea.
# =============================================================================


# ---- 1. Packages and the engine -----------------------------------------
library(readr)
library(dplyr)
library(ggplot2)

# source() runs another R file silently, here to load our functions.
# After this line, clean_consumer(), pi_by_condition() and plot_pi() exist
# in the Environment, ready to call — just like library() makes functions
# available, but for our own code. (03_functions.R also defines apa_msd(); we
# don't need it here, but the report in Pt. 4 uses it for inline reporting.)
source(here::here("workshop", "materials", "day_2", "03_functions.R"))


# ---- 2. Read -> clean -> describe -> plot --------------------------------
# Read the raw data, then hand it to each function in turn.
raw   <- read_csv(here::here("data", "mock", "consumer_data_raw.csv"),
                  show_col_types = FALSE)
clean <- clean_consumer(raw)        # the cleaning recipe from 03_functions.R

pi_summary <- pi_by_condition(clean)  # the summary recipe
fig_pi     <- plot_pi(clean)          # the plotting recipe

print(pi_summary)
print(fig_pi)


# ---- 3. Save the outputs -------------------------------------------------
out_dir <- here::here("workshop", "materials", "day_2", "_output")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

write_csv(pi_summary, file.path(out_dir, "pi_by_condition.csv"))
ggsave(file.path(out_dir, "pi_by_condition.png"),
       fig_pi, width = 7, height = 4, dpi = 300)

message("Done — same outputs as Pt. 2, built from named functions.")


# =============================================================================
#  WHAT CHANGED, AND WHY IT MATTERS
#  Pt. 2 and Pt. 4 produce identical results. But Pt. 4:
#    - is shorter and easier to read at a glance;
#    - has no copy-pasted logic, so a fix happens in exactly one place;
#    - reuses the same engine a report can also call (next: 05_report.qmd).
#
#  This is the difference between "code that runs" and "code you can maintain,
#  review, and trust" — the mindset you'll need on Day 3 when an AI assistant
#  writes code like this *for* you and your job is to read and check it.
# =============================================================================
