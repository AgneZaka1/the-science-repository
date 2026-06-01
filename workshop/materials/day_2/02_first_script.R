# =============================================================================
#  Day 2 · Pt. 2 — THE SCRIPT
#  From throwaway console commands to a saved, re-runnable analysis.
# =============================================================================
#
#  WHY MOVE FROM THE CONSOLE TO A SCRIPT?
#  The console is a calculator: great for trying things, useless as a record.
#  A script is a lab notebook: it states exactly what data came in, what we did
#  to it, and what came out — so anyone (a reviewer, a collaborator, future-you,
#  or tomorrow's AI assistant) can re-run it and get the same result.
#
#  THE TEST OF A GOOD SCRIPT: restart R (Session > Restart R) and run the whole
#  file top to bottom. If it works from a clean slate, it is reproducible. If it
#  only works because something is "already in the Environment", it is fragile.
#
#  HOW TO RUN: open this file in RStudio with the project (.Rproj) open, then
#  click "Source" (top-right of the editor) or press Cmd/Ctrl + Shift + Enter.
#
#  Notice the layout below: a header that says what the script is for, then
#  numbered sections in the order they run. This is the same shape as the real
#  analysis engine in  R/01_setup.R  and  R/functions/  — we are building a
#  miniature of it by hand so the afternoon's project makes sense.
# =============================================================================


# ---- 1. Packages --------------------------------------------------------
# Load the extra functions we need for this session. (They are already
# installed for this project via renv — see renv.lock.)
library(readr)    # read_csv()    — read the data file
library(dplyr)    # glimpse(), mutate(), group_by(), summarise() — wrangling
library(janitor)  # clean_names() — tidy messy column names
library(ggplot2)  # ggplot()      — figures


# ---- 2. Read the raw data -----------------------------------------------
# A file path that works on *any* computer. here::here() starts at the project
# root (the folder with the .Rproj file) and builds the path from there, so we
# never hard-code "/Users/yourname/Desktop/...". This is the single most
# important habit for code that runs on someone else's machine.
#
# We read the SAME teaching dataset the whole project uses: 300 simulated
# shoppers, each shown a product framed by one of five messages.
raw_path <- here::here("data", "mock", "consumer_data_raw.csv")
raw <- read_csv(raw_path, show_col_types = FALSE)


# ---- 3. Inspect before you touch anything -------------------------------
# Look first. Cleaning blind is how mistakes happen. Four questions, four tools:
glimpse(raw)        # what columns exist, and what type is each?
dim(raw)            # how many rows (participants) x columns (variables)?
head(raw)           # what do the first few rows actually look like?
names(raw)          # what are the column names? (notice: mixed case, messy)

# Things to notice out loud while looking at glimpse(raw):
#   - Column names are inconsistent: "ParticipantID", "Condition", "ps_1"...
#   - The outcome is split across three items: pi_1, pi_2, pi_3 (a Likert scale)
#   - Some values are -99 (a missing-data code, not a real value)
#   - Condition has trailing spaces ("control " with a space)
# A real dataset is always a little messy. That is normal, not a failure.


# ---- 4. Clean it --------------------------------------------------------
# We transform the raw data into an analysis-ready table. Each step is one
# readable line. clean = the result; raw stays untouched (never overwrite raw).
clean <- raw |>                                   # |> is the "pipe": take the
                                                  # thing on the left and feed
                                                  # it into the function below
  clean_names() |>                                # ParticipantID -> participant_id
  mutate(
    condition = factor(trimws(condition)),        # trim spaces, make a factor
    # The outcome, purchase intention, is the average of three survey items.
    # rowMeans works across the three columns, one participant (row) at a time.
    purchase_intention = rowMeans(
      across(c(pi_1, pi_2, pi_3)), na.rm = TRUE
    )
  )

# Did it work? Inspect again — always verify a transformation, never assume.
glimpse(select(clean, participant_id, condition, age, purchase_intention))
levels(clean$condition)                           # the five framing conditions


# ---- 5. Describe ---------------------------------------------------------
# The first real question: does purchase intention differ by message frame?
# group_by() + summarise() is the "pivot table" of R: split into groups, then
# compute one summary row per group.
pi_summary <- clean |>
  group_by(condition) |>
  summarise(
    n              = n(),                                  # group size
    mean_intention = mean(purchase_intention, na.rm = TRUE),
    sd_intention   = sd(purchase_intention,   na.rm = TRUE),
    .groups = "drop"
  )

print(pi_summary)
# Read the table: which condition has the highest mean? The "combined_frame"
# row should stand out. A model would test whether that gap is more than noise
# — that is the afternoon's job. For now we are just looking.


# ---- 6. Visualise --------------------------------------------------------
# A plot shows what a table can hide: spread, outliers, overlap between groups.
# ggplot builds a figure in layers, joined with +  :
#   ggplot(data, aes(...))  what data, and which variable maps to which axis
#   + geom_*()              what kind of mark to draw
#   + labs(...)             human-readable labels
fig_pi <- ggplot(clean, aes(x = condition, y = purchase_intention)) +
  geom_boxplot(fill = "grey90") +
  labs(
    title = "Purchase intention by message frame",
    x     = NULL,
    y     = "Purchase intention (1-7)"
  ) +
  theme_minimal()

print(fig_pi)   # in RStudio the figure appears in the Plots pane (bottom right)


# ---- 7. Save the outputs ------------------------------------------------
# Results should not live only in the Console — they vanish when R closes.
# Save them to files so the report (Act 4) and tomorrow's write-up can use them.
# We write into a demo output folder; here::here() keeps the path portable.
out_dir <- here::here("workshop", "materials", "day_2", "_output")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

write_csv(pi_summary, file.path(out_dir, "pi_by_condition.csv"))
ggsave(file.path(out_dir, "pi_by_condition.png"),
       fig_pi, width = 7, height = 4, dpi = 300)

message("Done. Wrote outputs to: ", out_dir)


# =============================================================================
#  STEP BACK AND LOOK AT THE SHAPE OF THIS SCRIPT
#  read -> inspect -> clean -> describe -> visualise -> save.
#  That is the skeleton of almost every analysis you will ever write.
#
#  But notice something: the cleaning logic and the plotting logic are recipes
#  we will want again — in a report, in a second analysis, tomorrow. Copy-paste
#  is how mistakes spread (fix a bug in one copy, miss the other four).
#  The fix is to give each recipe a NAME and define it once. That is Pt. 3.
# =============================================================================
