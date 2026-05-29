# 02_data_processing.R ----------------------------------------------------
# Raw -> clean. Reads from data/mock/ or data/raw/ (controlled by DATA_MODE),
# writes the cleaned object to data/processed/.
#
# Run after: nothing (this is the first script that touches data).

# Sourced via a project-root-relative path so `here` doesn't need to be
# loaded yet. RStudio Projects and the included VS Code workspace both
# open at the project root.
source("R/01_setup.R")

# ---- 1. Load ------------------------------------------------------------
raw <- load_raw_consumer_data("consumer_data_raw.csv")
message("Loaded ", nrow(raw), " rows from ", data_path("consumer_data_raw.csv"))

# ---- 2. Clean -----------------------------------------------------------
clean <- clean_consumer_data(raw)

# Quick sanity checks. These are diagnostics, not gates — adapt as needed.
message("Conditions present: ",
        paste(levels(clean$condition), collapse = ", "))
message("Missing values per scale:")
print(sapply(c("purchase_intention", "perceived_value",
               "price_sensitivity", "brand_trust"),
             function(v) sum(is.na(clean[[v]]))))

# ---- 3. Save ------------------------------------------------------------
dir.create(processed_path(), recursive = TRUE, showWarnings = FALSE)
saveRDS(clean, processed_path("consumer_clean.rds"))

message("Wrote ", processed_path("consumer_clean.rds"))
message("Next: R/03_analysis.R")
