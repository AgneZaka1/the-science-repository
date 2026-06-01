# Day 2 handout — *From the console to a report*

A two-page memory aid for this morning's live demo. Keep it next to you this
afternoon. The full, commented code is in the five files in this folder; this is
the distilled version.

> **The mindset that matters most:** for every line, **read it → predict the
> result → run it → check.** When the prediction is wrong, you just learned
> something. This is also exactly how you check code an AI writes for you.

---

## The arc

```
   CONSOLE  ──►  SCRIPT  ──►  FUNCTIONS  ──►  REPORT
  (try it)    (save it)     (reuse it)     (publish it)
```

The console is a calculator (great for trying, forgets everything). A script is
a lab notebook (saved, re-runnable, shareable). Functions are named recipes you
define once. A Quarto report weaves prose + code + results into one document.

---

## The building blocks (Act 1)

```r
5 + 7                      # R evaluates and prints; nothing is saved

class(12)                  # "numeric"   — every value has a TYPE
class("scarcity")          # "character" — text, always in quotes
class(TRUE)                # "logical"   — TRUE / FALSE (no quotes)

x <- 5.5                   # ASSIGNMENT: store the right side under a name
                           # (RStudio shortcut for <- is  Alt + -)

ages <- c(36, 63, 24)      # a VECTOR: many values of one type = a column
mean(ages)                 # functions summarise a whole vector
ages > 30                  # comparison -> a vector of TRUE/FALSE

scores <- c(4, 5, NA, 7)   # NA = "unknown"; it spreads on purpose
mean(scores)               # -> NA
mean(scores, na.rm = TRUE) # tell R to ignore the gap (na.rm is an ARGUMENT)

condition <- factor(c("control", "scarcity"))  # a FACTOR: fixed categories
levels(condition)          # the allowed values it remembers

round(3.14, digits = 2)    # a FUNCTION call: name(arguments)
?round                     # read any function's documentation (Help pane)

mean(ages); sd(ages); min(ages); max(ages)   # base R: one statistic at a time
library(psych)             # load a PACKAGE (do it once per session)
describe(ages)             # psych bundles the whole descriptives table in one
                           # call (the familiar SPSS-style output)
psych::describe(ages)      # package::function() names where a function lives
```

**Why types matter:** a number stored as text can't be averaged; a category
stored as a number gets averaged when it shouldn't be. Most "the numbers look
wrong" bugs are really **type** bugs. Check types *before* you model.

---

## The analysis skeleton (Acts 2–3)

Almost every analysis is these six moves. In Pt. 2 we did them by hand; in Pt. 3
we named the recipes and called them.

```r
library(readr); library(dplyr); library(ggplot2); library(janitor)

# READ — a portable path from the project root, never /Users/you/Desktop/...
raw <- read_csv(here::here("data", "mock", "consumer_data_raw.csv"))

glimpse(raw)               # INSPECT first — look before you touch anything

clean <- raw |>            # |>  the pipe: "take the left, feed it in" (= "then")
  clean_names() |>
  mutate(
    condition = factor(trimws(condition)),
    purchase_intention = rowMeans(across(c(pi_1, pi_2, pi_3)), na.rm = TRUE)
  )

clean |>                   # DESCRIBE — group_by + summarise = a pivot table
  group_by(condition) |>
  summarise(mean_intention = mean(purchase_intention, na.rm = TRUE))

ggplot(clean, aes(x = condition, y = purchase_intention)) +  # VISUALISE
  geom_boxplot() + theme_minimal()       # layers joined with +

write_csv(summary, "..."); ggsave("...") # SAVE — results shouldn't only live
                                         # in the Console
```

**Writing your own function** (Act 3) — define a recipe once, reuse it by name:

```r
clean_consumer <- function(raw) {     # inputs (arguments)
  raw |> janitor::clean_names() |> ...  # body
}                                       # the last value is returned

source("03_functions.R")   # run a file to LOAD its functions
clean <- clean_consumer(raw)           # now call it like any other function
```

`source()` does for *your* code what `library()` does for other people's.

---

## Building a plot in layers (Act 2½)

A ggplot is **data + aesthetic mappings + geometries**, stacked with `+`:

```r
ggplot(clean, aes(x = perceived_value, y = purchase_intention)) +  # data + axes
  geom_point(aes(color = condition),                  # one point per row,
             position = position_jitter(0.08, 0.08)) +# nudged apart, by group
  geom_smooth(method = "lm") +           # a linear trend line
  labs(x = "Perceived value", y = "Purchase intention", color = "Frame") +
  scale_color_viridis_d() +              # a colourblind-safe palette
  theme_minimal()
```

- **`+`, not `|>`** — inside a ggplot, layers join with `+`, and the `+` goes at
  the **end** of the line. (Mixing these up is the #1 ggplot error.)
- **Points piling up on a grid?** Nudge them apart with
  `position = position_jitter(width = .08, height = .08)` (or use `geom_jitter()`)
  so you can see how dense the cloud really is.
- An `aes()` in **`ggplot()`** applies to every layer; an `aes()` inside a
  **`geom_*()`** applies to that layer only.
- Swap the geom to ask a new question: `geom_boxplot()`, `geom_histogram()`,
  `geom_density(alpha = 0.5)`, `geom_col()`.
- Save the last plot you drew with
  `ggsave("figure.png", width = 7, height = 5, dpi = 300)`.

## The report (Act 4)

A `.qmd` file = **YAML header** (settings) + **prose** + **code chunks**:

````
---
title: "A first reproducible report"
format: html
---

Some explanation in plain text.

```{r}
knitr::kable(pi_by_condition(clean))   # the result drops into the page
```
````

**Inline code** puts a live number *inside a sentence* — write a little R
expression in the prose and its result is dropped in at render time:

````
... highest in the combined-frame condition (`r apa_msd(pi_combined)`).
````

renders as: *... highest in the combined-frame condition (M = 4.60, SD = 0.96).*
Here `apa_msd()` is a helper in `03_functions.R` that formats a mean and SD in
APA 7th-edition style (italic *M* and *SD*, two decimals). Change the data,
re-render, and the sentence corrects itself.

Render the whole document (`quarto render ...` or the **Render** button) → an
HTML page where every number was produced by code, never copy-pasted. Re-render
and it all updates itself.

---

## The five errors you *will* meet — and what they mean

| Message | Almost always means | First thing to try |
| --- | --- | --- |
| `object 'x' not found` | typo, or you never ran the line that creates `x` | check spelling/case; run from the top |
| `could not find function "f"` | the package isn't **loaded** (not "doesn't exist") | `library(<package>)` |
| `cannot open file ...` | wrong path / project not open | open the `.Rproj`; use `here::here()` |
| `unexpected symbol` / `unexpected ')'` | a typo: missing comma, bracket, or quote | look at the line *before* the one flagged |
| result is `NA` | a missing value crept into a calculation | add `na.rm = TRUE`, or check the data |

**Errors are information, not failure.** Read the message; it usually names the
problem. (This is the most useful habit you'll build all week.)

---

## Where each idea lives in the real project (your afternoon)

| You learned… | …it lives in the project here |
| --- | --- |
| packages + paths + the "engine" entry point | [`R/01_setup.R`](../../../R/01_setup.R) |
| writing functions (clean / model / plot) | [`R/functions/`](../../../R/functions/) |
| the read → inspect → clean → save story | [`reports/webpage/01-data-preparation.qmd`](../../../reports/webpage/01-data-preparation.qmd) |
| describe + visualise | [`reports/webpage/02-descriptives.qmd`](../../../reports/webpage/02-descriptives.qmd) |
| the dataset + what every column means | [`data/mock/codebook.md`](../../../data/mock/codebook.md) |

This afternoon you do the grown-up version of Pt. 4 on your own data.

## Keep learning — R for Data Science (free, in `workshop/literature/`)

- [Workflow basics](https://r4ds.hadley.nz/workflow-basics) — Acts 1–2
- [Data transformation](https://r4ds.hadley.nz/data-transform) — cleaning
- [Data visualisation](https://r4ds.hadley.nz/data-visualize) — the plot
- [Functions](https://r4ds.hadley.nz/functions) — Pt. 3
- [Quarto](https://r4ds.hadley.nz/quarto) — Pt. 4

Matching cheat sheets are in [`workshop/cheat sheets/`](../../cheat%20sheets/).
