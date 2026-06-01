# Day 2 · Pt. 1 — The Console

A crash course in the building blocks of R: values, types, assignment, vectors, factors, functions, and packages.

## How to use this file

This is the script the facilitator types *live* in the Console, line by line. Participants can also open it and run it themselves afterwards.

In RStudio: put your cursor on a line and press **Cmd/Ctrl + Enter** to send it to the Console. Watch what comes back.

The golden rule for today: **READ the line → PREDICT the output → RUN it.** If your prediction was wrong, that is the most useful moment of the day.

Lines that start with `#>` show the output you should expect in the Console. Lines marked "TRY THIS (it errors)" are meant to fail — run them on purpose so you learn to read error messages. They are commented out so the whole file still runs top-to-bottom; uncomment to demonstrate.

------------------------------------------------------------------------

## 1. R is a calculator

The simplest thing R does: you type an expression, R evaluates it and prints the answer. Nothing is saved — the result just appears and is gone.

``` r
5 + 7
#> [1] 12
```

Order of operations works like maths. Brackets force the order you want.

``` r
3 + 4 * 2
#> [1] 11
(3 + 4) * 2
#> [1] 14
```

A few more operators you will see all the time:

``` r
10 / 4        # division        #> [1] 2.5
2^10          # power           #> [1] 1024
17 %% 5       # remainder       #> [1] 2
```

The `[1]` in front of the answer is R telling you "this is the 1st element of the result". You will understand why once we meet vectors below.

------------------------------------------------------------------------

## 2. Values have a type

Every value in R is of some *type*. R behaves differently depending on the type, so knowing the type is half of debugging. Ask with `class()`.

``` r
class(12)             #> [1] "numeric"     a number (with decimals allowed)
class("scarcity")     #> [1] "character"   text, ALWAYS in quotes
class(TRUE)           #> [1] "logical"     yes/no: TRUE or FALSE (no quotes)
```

Text values are called "strings" and must be quoted. Without quotes R thinks you are naming an object (see section 3) and looks for one that does not exist:

``` r
"scarcity_frame"      #> [1] "scarcity_frame"
# scarcity_frame      # TRY THIS (it errors): object 'scarcity_frame' not found
```

Logical values are what comparisons return. This is how filtering works later.

``` r
7 > 3                 #> [1] TRUE
7 == 3                # note: == is "is equal to", = is something else  #> [1] FALSE
"buy" == "buy"        #> [1] TRUE
```

Why care? Because a number stored as text cannot be averaged, and a category stored as a number can be averaged when it should not be. Type bugs are the single most common source of "but the numbers look wrong" in real analysis.

------------------------------------------------------------------------

## 3. Assignment: storing a value under a name

So far results vanished. To keep one, give it a name with the arrow `<-`. Read it as: "store the thing on the right under the name on the left."

``` r
purchase_intention <- 5.5
```

Now the name stands in for the value. Notice it appears in the Environment pane (top right) — that pane is the list of everything R currently remembers.

``` r
purchase_intention            #> [1] 5.5
purchase_intention + 1        #> [1] 6.5
```

You can reassign. The new value replaces the old one.

``` r
purchase_intention <- 6.0
purchase_intention            #> [1] 6
```

R is **CASE-SENSITIVE** and **LITERAL**. A different spelling is a different name. Each of these is a separate (mostly non-existent) object:

``` r
# Purchase_intention          # TRY THIS (it errors): object not found
# purchase_intension          # TRY THIS (it errors): typo -> object not found
```

"object not found" almost always means: a typo, or you never created it, or you didn't run the line that creates it. It is not a deep problem.

Naming advice that will save you hours: use short, lower_case, descriptive names. `age`, `mean_age`, `clean_data` — not `x`, `data2`, `finalFINAL`.

------------------------------------------------------------------------

## 4. Vectors: many values under one name

Real data is not single numbers — it is columns. A column is a *vector*: an ordered set of values of the same type. Build one with `c()` ("combine").

``` r
ages <- c(36, 63, 24, 41, 29)
ages                          #> [1] 36 63 24 41 29
```

R is "vectorised": operations apply to every element at once. No loops needed.

``` r
ages + 1                      #> [1] 37 64 25 42 30
ages / 10                     #> [1] 3.6 6.3 2.4 4.1 2.9
```

Functions summarise a whole vector down to one number:

``` r
length(ages)                  #> [1] 5
mean(ages)                    #> [1] 38.6
max(ages)                     #> [1] 63
```

Pick elements by position with square brackets `[ ]`:

``` r
ages[1]                       #> [1] 36     the first element
ages[c(1, 2)]                 #> [1] 36 63  the first two
```

Compare a vector to a value → a vector of TRUE/FALSE. This is the engine behind "keep only the rows where ...".

``` r
ages > 30                     #> [1]  TRUE  TRUE FALSE  TRUE FALSE
```

------------------------------------------------------------------------

## 5. Missing values: NA

Real data has gaps. R marks an unknown value as `NA` ("not available"). NA is contagious on purpose: a calculation that includes an unknown is itself unknown, so R refuses to guess.

``` r
scores <- c(4, 5, NA, 7)
mean(scores)                  #> [1] NA      one value is unknown -> mean unknown
```

You must explicitly tell R to drop the missing values with `na.rm = TRUE`. "rm" = remove. This is an *argument* — more on those in section 7.

``` r
mean(scores, na.rm = TRUE)    #> [1] 5.333333
```

Count how many are missing — a one-liner you will reuse constantly:

``` r
sum(is.na(scores))            #> [1] 1
```

------------------------------------------------------------------------

## 6. Factors: categories with a fixed set of levels

Some columns are categories, not free text: an experimental condition, a gender, an income band. R has a special type for these — the *factor*. A factor remembers the full set of allowed categories (its "levels"), even ones that don't appear in this particular sample.

``` r
condition <- c("control", "scarcity", "scarcity", "control", "combined")
condition                     #> [1] "control"  "scarcity" ...   (just text)

condition <- factor(condition)
condition                     #> Levels: combined control scarcity
levels(condition)             #> [1] "combined" "control"  "scarcity"
```

Why bother? Because models and plots treat factors as groups to compare, whereas they treat plain text inconsistently and treat numbers as quantities. "control" coded as 0/1/2 would be averaged like a number — meaningless. Getting types right *before* modelling prevents silent, wrong results.

------------------------------------------------------------------------

## 7. Functions: asking R to do something

A function is a named, reusable instruction. You "call" it by writing its name followed by parentheses. Whatever you put inside the parentheses are the *arguments* — the inputs.

```         
function_name( argument1, argument2, ... )
```

Rule of thumb: when you see a name immediately followed by `( )`, it is a function call.

``` r
round(3.14159)                #> [1] 3
round(3.14159, digits = 2)    #> [1] 3.14
```

Arguments can be given by position or by name. These two are identical:

``` r
round(3.14159, 2)             #> [1] 3.14   (2 lands in the 2nd slot, "digits")
round(digits = 2, x = 3.14159)#> [1] 3.14   (named -> order doesn't matter)
```

Naming arguments makes code readable and is how we passed `na.rm` above.

``` r
seq(from = 1, to = 10, by = 2)#> [1] 1 3 5 7 9
```

Don't know what arguments a function takes? Ask R. This opens the Help pane.

``` r
# ?round            # uncomment to open documentation for round()
```

Reading help pages is a core skill — every function's inputs are listed there.

------------------------------------------------------------------------

## 8. Packages: borrowing more functions

Everything so far is "base R" — built in. base R already gives you every common descriptive statistic, each as its own function:

``` r
mean(ages)                    #> [1] 38.6
sd(ages)                      #> [1] 15.10960
median(ages)                  #> [1] 36
min(ages); max(ages)          #> [1] 24    then    #> [1] 63
```

So nothing is missing — but in SPSS one click gives you a whole descriptives table at once, whereas here you would call each statistic separately. This is exactly what packages are for: the community has written thousands of them, each bundling related functionality into one ready-made tool.

`{psych}` is a package built for psychological and behavioural research. Its `describe()` returns the FULL descriptives table — n, mean, sd, median, min, max, range, skew, kurtosis, standard error — in a single call. The familiar SPSS-style output, from one function.

A package is **INSTALLED** once onto your computer, then **LOADED** in each session you want it. Two different actions — and confusing them causes the classic beginner error.

``` r
# install.packages("psych")   # do this ONCE (already installed for this project)
library(psych)                # do this EVERY session you need it

describe(ages)
#>    vars n mean    sd median trimmed   mad min max range skew kurtosis   se
#> X1    1 5 38.6 15.11     36    38.6 10.38  24  63    39 0.61    -1.43 6.76
```

THE classic beginner error: call a package's function before loading the package, and R says:

```         
could not find function "describe"
```

That almost always means "the package isn't loaded", NOT "this function does not exist". The fix is `library(<package>)`, not panic.

You can also reach into a package WITHOUT loading it, using `::` ("namespace"). This says explicitly "the describe function from the psych package":

``` r
psych::describe(ages)
```

We will lean on a handful of packages all morning:

| Package | Purpose | Key functions |
|----|----|----|
| `readr` | reading data files | `read_csv` |
| `dplyr` | transforming data | `mutate`, `summarise`, `group_by`, `glimpse` |
| `ggplot2` | making figures | `ggplot` |
| `janitor` | cleaning messy names | `clean_names` |
| `psych` | descriptives | `describe` |

Where do packages come from, and why does this project "just work" on a fresh computer? This repository pins exact package versions with `{renv}` (see `renv.lock`). `renv::restore()` installs that exact set, so the analysis is reproducible — the same code, the same packages, the same results.

------------------------------------------------------------------------

## 9. A data frame: the shape of real data

Columns (vectors) of the same length, side by side, make a *data frame* — R's version of a spreadsheet or an SPSS data view. Rows are observations (here, participants); columns are variables.

``` r
demo <- data.frame(
  participant_id     = c("P001", "P002", "P003"),
  condition          = factor(c("control", "scarcity", "combined")),
  age                = c(36, 63, 24),
  purchase_intention = c(4.2, 5.1, 6.0)
)
demo
#>   participant_id condition age purchase_intention
#> 1           P001   control  36                4.2
#> 2           P002  scarcity  63                5.1
#> 3           P003  combined  24                6.0
```

Reach a single column with the `$` sign — it comes back as a vector:

``` r
demo$age                      #> [1] 36 63 24
mean(demo$age)                #> [1] 41
```

Everything we just did by hand — types, vectors, factors, NA, functions — is exactly what you do to a real dataset, only the dataset has 300 rows and 25 columns and arrives in a messy file. That is Pt. 2.

------------------------------------------------------------------------

## Recap

- R evaluates expressions; `<-` saves a result under a name.
- Every value has a type (numeric / character / logical / factor); type bugs cause "wrong-looking numbers".
- A column is a vector; a table of vectors is a data frame.
- NA means unknown and spreads; use `na.rm = TRUE` to ignore it.
- Functions are `name(arguments)`; packages bundle extra functions you `library()` in once per session.

**NEXT:** `02_first_script.R` — the same ideas, on the real consumer dataset, saved as a script you can re-run.
