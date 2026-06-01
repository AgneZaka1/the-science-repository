# Presenter guide — Day 2 morning live demo

**Session:** *From the console to a report* · **Block:** ~09:45–12:00 (≈ 2 h 15 m) · **Lead:** Jannis(?) · **Mode:** live coding, projector + RStudio.

This is the runbook for the live walkthrough. It tells you, for each beat, **what
to type**, **what to say**, **what to point at on screen**, the **errors to show
on purpose**, and the **questions you should expect**. The four scripts are your
script; this is your stage direction.

> **Teaching stance for the whole morning.** You are not demonstrating that *you*
> can code. You are modelling how a competent person *reads* code: predict, run,
> check, react to errors calmly. Say your predictions out loud. Be wrong
> sometimes on purpose. The goal is a mental model robust enough to review and
> diagnose code — because tomorrow an AI will write it and they must be able to
> check it.

---

## Before you start (2 minutes, do it while people settle)

- Project open via `the-science-repository.Rproj` (working dir = repo root).
- `Session → Restart R`, then `Ctrl + L` to clear the Console. **Start blank.**
- Five tabs open in order: `01_console_basics.R` … `05_report.qmd`.
- Font size up (Ctrl/Cmd + `+`) so the back row can read it.
- Have `05_report.html` ready in a browser tab as a fallback for Pt. 4.
- One sentence to open: *"Yesterday we talked about what R is. This morning we
  watch it happen — from `5 + 7` to a finished report — on the real dataset
  you'll use this afternoon."*

Draw or show the arc once and refer back to it all morning:

```
   CONSOLE  ──►  SCRIPT  ──►  FUNCTIONS  ──►  REPORT
  (try it)    (save it)     (reuse it)     (publish it)
```

---

## Pt. 1 — The Console  ·  ~30 min  ·  `01_console_basics.R`

**Goal:** values, types, assignment, vectors, `NA`, factors, functions, packages.
Type these **live in the Console** (don't source the file yet — that's the point;
the console is ephemeral). The file is your crib and their take-home copy.

### Beat 1 — R is a calculator (3 min)
- **Type:** `5 + 7`, then `(3 + 4) * 2`, then `2^10`.
- **Say:** *"You type an expression, R answers, the answer is gone. That `[1]`
  prefix will make sense in a minute."*
- **Point at:** the Console only. Environment pane is empty — *"R is remembering
  nothing yet."*

### Beat 2 — Values have a type (5 min)
- **Type:** `class(12)`, `class("scarcity")`, `class(TRUE)`.
- **Say:** *"Every value has a type. Half of all debugging is realising a value
  isn't the type you assumed."*
- **Deliberate error:** type `scarcity_frame` (no quotes) → `object not found`.
  *"No quotes means R thinks it's a name, and goes looking for it. Strings need
  quotes."* This plants the seed for the most common beginner error.
- **Type:** `7 > 3`, `7 == 3`, `"buy" == "buy"`. *"Comparisons give TRUE/FALSE —
  remember this, it's how we'll filter rows later. And it's `==`, not `=`."*

### Beat 3 — Assignment (5 min)
- **Type:** `purchase_intention <- 5.5`. **Point at the Environment pane** — *"Now
  R remembers something. The arrow means: store the right side under the left
  name."* In RStudio, `Alt + -` types `<-` for you.
- **Type:** `purchase_intention + 1`, then reassign `purchase_intention <- 6`.
- **Deliberate error:** `Purchase_intention` (capital P) → `object not found`.
  *"R is case-sensitive and literal. A different spelling is a different thing.
  Most 'object not found' errors are a typo or a line you forgot to run."*

### Beat 4 — Vectors and NA (7 min)
- **Type:** `ages <- c(36, 63, 24, 41, 29)`, then `ages + 1`, `mean(ages)`,
  `ages[1]`, `ages > 30`.
- **Say:** *"Real data is columns, not single numbers. A column is a vector.
  Notice operations hit every element at once — no loops. THAT's what `[1]` was:
  R numbering the elements of a result."*
- **Type:** `scores <- c(4, 5, NA, 7)`, then `mean(scores)` → `NA`.
- **Say:** *"`NA` means 'unknown'. The average of something-including-unknown is
  unknown — R refuses to guess. You tell it to ignore the gap:"* `mean(scores,
  na.rm = TRUE)`. *"You will type `na.rm = TRUE` a thousand times. That's your
  first taste of a function argument."*

### Beat 5 — Factors (4 min)
- **Type:** `condition <- factor(c("control","scarcity","scarcity","control","combined"))`,
  then `condition`, then `levels(condition)`.
- **Say:** *"Categories aren't free text and aren't numbers — they're factors,
  which remember the full set of allowed levels. Get the type right BEFORE
  modelling: a condition stored as 0/1/2 would get averaged like a quantity,
  which is nonsense. Most 'the numbers look wrong' bugs are really type bugs."*

### Beat 6 — Functions (4 min)
- **Type:** `round(3.14159)`, `round(3.14159, digits = 2)`, `round(3.14159, 2)`.
- **Say:** *"`name(arguments)` — when you see a word glued to a parenthesis, it's
  a function call. Arguments can go by position or by name; naming them is
  clearer. That's exactly what `na.rm = TRUE` was."*
- **Type:** `?round` → **point at the Help pane.** *"Every function documents its
  inputs here. Reading help pages is a core skill, not a defeat."*

### Beat 7 — Packages (5 min)
- **Motivate from what they know:** **type** `mean(ages)`, `sd(ages)`,
  `median(ages)`, `min(ages)`, `max(ages)`. *"base R already has every
  descriptive — but one function at a time. In SPSS, one click gave you a whole
  descriptives table. That's exactly what a package fixes: it bundles related
  tools into one."*
- **Type:** `describe(ages)` → `could not find function "describe"`.
  **This is the headline error of the day.** *"This does NOT mean the function
  doesn't exist. It means its package isn't loaded."*
- **Type:** `library(psych)`, then `describe(ages)` → the full SPSS-style table
  (n, mean, sd, median, min, max, range, skew, kurtosis, se) in one call.
  *"One function, the whole descriptives table — and it's a package built for
  exactly our kind of research."*
- **Say:** *"Install once (onto the computer), load every session (into memory).
  Confusing those two is the classic trap. And `renv` in this project pins the
  exact versions — psych included — so this runs the same on every laptop here."*
- Show `psych::describe(ages)` — *"`::` says 'this function, from this package',
  without loading the whole thing."* (glimpse from dplyr arrives in Pt. 2.)

**Transition:** *"We built a tiny table by hand at the bottom of the file. But
real data has 300 rows and arrives in a messy file — and the console forgets
everything when we close it. So we graduate to a script."*

---

## Pt. 2 — The Script  ·  ~25 min  ·  `02_first_script.R`

**Goal:** why code belongs in a saved, re-runnable file; the read → inspect →
clean → describe → visualise → save skeleton, on the real CSV.

Switch to the `02_first_script.R` tab. **Read the header out loud** — especially
the *"restart R and run it top to bottom"* test of reproducibility.

### Beat 1 — Packages & the path (4 min)
- Run the `library(...)` block. *"Same `library()` we just met."*
- Run the `here::here(...)` line and **print `raw_path`**. *"This builds a path
  from the project root, so it works on your laptop and mine. Never paste
  `/Users/yourname/Desktop/...` into a script — it dies on every other
  computer."*

### Beat 2 — Inspect first (5 min)
- Run `glimpse(raw)`, `dim(raw)`, `names(raw)`.
- **Narrate the mess** (this is the "real science reality" moment): mixed-case
  names, the outcome split across `pi_1/pi_2/pi_3`, `-99` codes, trailing spaces
  in `condition`. *"Every real dataset is messy. Looking first is the diagnostic
  step — cleaning blind is how you get silent mistakes."*

### Beat 3 — Clean (7 min)
- Run the `clean <- raw |> ...` block **slowly**. Explain the pipe `|>`:
  *"'take the thing on the left and feed it into the function on the right.' Read
  it as the word 'then': take raw, THEN clean the names, THEN add columns."*
- Explain `rowMeans(across(c(pi_1, pi_2, pi_3)))`: *"the outcome is the average
  of three survey items, one participant per row."*
- **Verify, don't assume:** run the `glimpse(select(...))` and `levels()` lines.
  *"Always check a transformation did what you meant."*

### Beat 4 — Describe & plot (6 min)
- Run the `group_by |> summarise` block. *"This is R's pivot table: split into
  groups, one summary row each."* **Ask the room:** *"Which condition is
  highest?"* (`combined_frame`, ≈ 4.6.)
- Run the `ggplot(...)` block → **point at the Plots pane.** *"A figure shows the
  spread a mean hides. ggplot builds in layers joined by `+`: data and axes,
  then the kind of mark, then labels."*

### Beat 5 — Save (3 min)
- Run the save block. **Point at the Files pane** → `_output/` appears with a CSV
  and PNG. *"Results that live only in the Console vanish. Saved files are what
  the report and tomorrow's write-up will use."*

**Transition:** *"We made one quick boxplot at the very end there. Before we tidy
the code up, let's slow right down on that plotting step — because ggplot is
where a lot of people fall in love with R. Watch a plain scatter turn into a
publication figure, one line at a time."*

---

## Pt. 2½ — Seeing the data  ·  ~12 min  ·  `02b_visualisation.R`

**Goal:** the grammar of graphics, felt rather than explained — **data → `aes()`
→ `geom_*()` → polish**. Run this file **one block at a time**; the whole point
is to watch the Plots pane change with each layer. This is the energy high point
of the morning — keep it quick and visual.

> **Say once, up front, and repeat it:** *"Inside a ggplot, layers join with a
> PLUS sign `+`, not the pipe `|>`. And the `+` goes at the END of a line."*
> This is the single most common ggplot beginner error — inoculate them now.

### Beat 1 — From nothing to points (4 min)
- Run block **1** (`ggplot(data = clean)`) → a blank grey panel. *"We said WHAT
  data, but not what to draw."*
- Run block **2** (add `aes(x = perceived_value, y = purchase_intention)`) →
  axes appear, still no data. *"Now the axes know our variables — but we haven't
  picked a shape to draw."*
- Run block **3** (`+ geom_point()`) → the scatter. *"geom_point draws one point
  per shopper. Three lines, and we can see the relationship."* Then point at the
  grid: *"But see how points stack on a grid? Lots of shoppers share the same
  averaged scores — that's overplotting, and it hides how many points are really
  there. Watch the next step."*

### Beat 2 — More dimensions, and the big 'aha' (4 min)
- Run block **4** (`position = jitter_a_little` + `color = condition`) → the
  points spread apart **and** colour by group, with an automatic legend. *"Two
  small things: we nudge each point a touch so the pile-ups open up, and we
  colour by condition. We keep that jitter for every scatter from here on."*
- Run block **5** (`+ geom_smooth(method = "lm")`) → **five** trend lines.
  **Pause here.** *"Why five? Because colour is set globally, so EVERY layer —
  including the line — is split by condition."*
- Run block **6** (move `color` into `geom_point()`) → **one** trend line. *"Move
  the colour into just the points layer, and the line goes back to one. That's
  the rule: an aesthetic in a geom affects only that geom; in `ggplot()` it
  affects all of them."* This contrast is the conceptual core of the act.

### Beat 3 — Make it publication-ready (3 min)
- Run block **7** (`shape = condition` too) → *"colour AND shape carry the same
  grouping, so the figure still works in black-and-white or for a colourblind
  reader."*
- Run block **8** (`labs()` + `scale_color_viridis_d()` + `theme_minimal()`) →
  the finished figure. *"Same plot, now with real labels and a colourblind-safe
  palette. You could put this straight in a paper. Notice the legend title comes
  from `labs(color = ..., shape = ...)`."*

### Beat 4 — Swap the geom, ask a new question (1 min)
- Run block **9** (`geom_density(alpha = 0.5)`) → overlapping distributions.
  *"Same grammar, different geometry. Change the geom and you've asked a
  completely different question of the same data."*

**Expected, harmless message:** every `geom_smooth()` prints
`` `geom_smooth()` using formula = 'y ~ x' ``. That's information, not an error —
say so, don't let it spook anyone.

**Cut/extend:** *Behind?* Show blocks 3, 5→6 (the aha), and 8 only. *Ahead?* Add
`alpha`/`geom_jitter()` to tackle overplotting, or `facet_wrap(~ condition)` to
split into small multiples — a one-line crowd-pleaser.

**Transition:** *"Look back at the whole morning's shape now: read, inspect,
clean, describe, visualise, save — almost every analysis ever. But the cleaning
and the plotting are recipes we'll want again and again. Copy-paste spreads bugs.
So we name each recipe once."*

---

## Pt. 3 — Functions  ·  ~20 min  ·  `03_functions.R` + `04_script_with_functions.R`

**Goal:** writing your own functions; the "define once, use anywhere" idea; the
payoff of a readable analysis script. This is the conceptual heart for Day 3.

### Beat 1 — Read the engine (8 min)
- Open `03_functions.R`. **Source it** (`Cmd/Ctrl + Shift + S`). *"Nothing
  happened — no output. It only DEFINED functions."* Point at the Environment
  pane: `clean_consumer`, `pi_by_condition`, `plot_pi` (and `apa_msd`, the
  reporting helper we'll meet in Pt. 4) now sit under *Functions*.
- Walk through the anatomy comment: `name <- function(inputs) { body; result }`.
- Note the `package::function()` style and **why**: *"a shared toolbox spells out
  where each function comes from, so it works even if the caller forgot a
  `library()`. The project's real `R/functions/` files look exactly like this."*

### Beat 2 — The payoff (8 min)
- Open `04_script_with_functions.R`. **Put it side by side with `02` if you can.**
- Run it whole. Same table, same plot as Pt. 2.
- **Say:** *"Identical results — but read how short and clear this is. The detail
  is one click away in the functions file. A fix now happens in ONE place, not
  five pasted copies. This is the line between 'code that runs' and 'code you can
  trust and maintain.'"*

### Beat 3 — Name the pattern (4 min)
- **This is the key sentence of the morning:** *"`source()` here does for OUR
  code what `library()` does for other people's: it loads functions so we can
  call them by name. And that two-file split — an engine you define, a script
  that uses it — is exactly how the whole project is built."* Foreshadow Pt. 4
  and the afternoon.

---

## Pt. 4 — The Report  ·  ~20 min  ·  `05_report.qmd`

**Goal:** Quarto weaves prose + code + output into one reproducible document;
it reuses the same engine; it is the twin of a real `reports/webpage/` page.

### Beat 1 — Anatomy of a .qmd (5 min)
- Open `05_report.qmd` in the **Source/Visual editor**.
- Point at the three parts: the **YAML header** (`---` … `---`, the settings),
  the **prose** (plain markdown), the **code chunks** (` ```{r} `).
- Read the hidden `setup` chunk comment about `rprojroot::find_root(is_git_root)`:
  *"a report renders from its own folder, so it anchors paths at the git root —
  the exact same line you'll see atop the real report pages."*

### Beat 1b — Numbers that write themselves (4 min)
- Scroll to the sentence reporting `(*M* = 4.60, *SD* = 0.96)`. Point out it is
  **not typed** — in the source it's the inline expression
  `` `r apa_msd(pi_combined)` ``, calling our engine's `apa_msd()` helper, which
  formats the mean and SD in APA 7th-edition style.
- **Say:** *"This is the whole reproducibility promise in one line. The number in
  the prose is computed from the data when the document renders. Change the data,
  re-render, and the sentence corrects itself — no more pasting `M = 4.60` and
  forgetting to update it when the analysis changes."*
- **Optional live demo:** change `digits = 2` to `3` in `apa_msd()` (in
  `03_functions.R`), or point `pi_combined` at a different condition, re-render,
  and watch the sentence update itself. *"That's the difference between a
  document and a report."*
- Tie back: *"And notice `apa_msd()` lives in the engine, not the report — same
  rule as everything else this morning: define once, reuse."*

### Beat 2 — Render it (8 min)
- Click **Render** (or run `quarto render workshop/materials/day_2/05_report.qmd`
  in the Terminal). Talk while it builds: *"Quarto is running every chunk in a
  fresh session and dropping the results into a web page."*
- Open the resulting `05_report.html`. Scroll through: the folded code, the
  `kable` table, the figure with its caption. *"Nothing here was copied from the
  Console. Re-render and every number updates itself. That's reproducibility you
  can hand to a reviewer."*
- **If the live render misbehaves:** open the pre-rendered `05_report.html` tab.
  Don't lose momentum debugging in front of the room — show the result, move on.

### Beat 3 — The bridge (7 min)
- Open `reports/webpage/01-data-preparation.qmd` next to the demo report.
  *"Recognise it? Same skeleton — source the engine, call functions, narrate.
  This is the grown-up version, and it's your afternoon."*
- Close the loop to the morning arc: **console → script → functions → report.**
- **Day 3 hook:** *"Tomorrow a coding agent will write files like these for you.
  The whole reason we went slowly today is so you can READ what it writes,
  predict what it does, and catch it when it's wrong. That judgement is the job
  — the typing is the part we're automating."*

---

## Pacing, cuts, and extensions

| If you're… | Do this |
| --- | --- |
| **On time** | Run as written. Take the break between Pt. 2½ and Pt. 3 — right after the visualisation high. |
| **Behind** | In Pt. 1, cut the `data.frame()` section (Beat after packages) and the `seq()`/`%%` extras. In Pt. 2½, show only blocks 3, 5→6, and 8. In Pt. 4, **show the pre-rendered HTML** instead of live-rendering. Never cut the `could not find function` and `object not found` error demos, or the Pt. 2½ "five lines vs one line" aha — they pay off all week. |
| **Ahead / advanced room** | Pt. 1: show `summary(demo)` and `str()`. Pt. 2: add a second `geom` or `facet_wrap(~ gender)`. Pt. 3: have them spot that `clean_consumer()` only does *part* of the real cleaning (compare to `R/functions/data_loading.R`) — a great "read and diagnose" exercise. Pt. 4: toggle `code-fold: true` and re-render. |

**Two checkpoints to pause and read the room:**
1. End of Pt. 1 — *"Can everyone tell a function call from an object?"*
2. End of Pt. 3 — *"Can everyone see why we'd write a function instead of
   pasting?"* If not, slow down before Quarto.

---

## Errors you might hit live (and the fast fix)

| Symptom | Cause | Fix |
| --- | --- | --- |
| `could not find function "describe"` / `glimpse` / `clean_names` | package not loaded | run the `library(...)` line for that package |
| `object 'clean' not found` in Pt. 2/4 | ran a later line before an earlier one | Source the whole file, or run from the top |
| `cannot open file ... consumer_data_raw.csv` | project not open / wrong working dir | confirm the title bar shows the project; reopen the `.Rproj` |
| `could not find function "clean_consumer"` in Pt. 4 | `03_functions.R` not sourced | the `source(...)` line near the top must run first |
| ggplot: `Cannot add ggproto objects together`, or a layer "errors" on its own | used `|>` between layers instead of `+`, or put `+` at the **start** of a line | join layers with `+`, and keep `+` at the **end** of each line |
| Quarto render fails | stale cache or wrong dir | run from repo root; delete `workshop/materials/day_2/.quarto/`; fall back to the pre-rendered HTML |
| `there is no package called 'renv'` on a fresh laptop | environment not restored | `install.packages("renv"); renv::restore()` |

**Model the recovery, not just the fix.** When something breaks, say: *"Good —
let's read the message. What is it actually telling us?"* That habit is half of
what you're teaching.

---

## Anticipated questions

- **"Is `<-` different from `=`?"** For assignment they mostly behave the same;
  `<-` is the R convention and reads clearly as "store under". Inside a function
  call, `=` means "set this argument", e.g. `na.rm = TRUE`. Use `<-` to make
  objects, `=` to set arguments.
- **"Why `|>` and not `%>%`?"** `|>` is base R's native pipe (R ≥ 4.1) — no
  package needed. `%>%` from `magrittr`/tidyverse is older and nearly equivalent;
  they'll see both in the wild.
- **"Do I have to write functions?"** Not on day one. But the moment you copy a
  block of code a second time, a function is the honest fix.
- **"Is this how real analysis looks?"** Yes — point at `R/` and
  `reports/webpage/`. This demo is a faithful small version of it.
- **"Can't the AI just do all this?"** It can write it. It cannot decide whether
  it's *right*. That's why today exists. (Segue to Day 3.)
- **"SPSS gave me output immediately — why all this?"** SPSS clicks vanish; a
  script is a permanent, shareable, re-runnable record. Slower to start, far more
  reusable and auditable later. (Optional Slide A in the Day 2 deck.)
