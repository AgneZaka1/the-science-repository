# Day 1 — Foundations & Setup (repo-based)

## Goal of the day

By the end of Day 1, every participant has **all the software installed** and a
**working fork of this repository** — accounts created, environment restored,
and both outputs rendering. We use the repository itself as the map: each box in
the architecture diagram is a tool we install and understand today.

> Style: **install-along**. Concept slides are interleaved with explicit
> step-by-step install/exercise slides. Slow is fine — the win is that nobody
> leaves with a broken setup.
>
> RStudio is the environment for Days 1–2. VS Code is introduced on Day 3 only.
> Deep R syntax is Day 2. The Shiny app is **not** part of this workshop.
>
> Two threads run through the day:
>   1. **The kitchen analogy** — the repo is a kitchen; we keep mapping every
>      folder and tool back to it so the structure builds up slowly.
>   2. **Errors are normal** — we normalise red text early and teach how to read
>      it, then pre-empt the usual blockers in a **⚠ Watch out** box on every
>      exercise slide.

---

# Part A — Framing & expectations

## Slide 1 — Welcome

**Title:** The Science Repository
**Subtitle:** One repo for your data, your analysis, and your outputs

**On slide:**

```text
Day 1: Install everything + understand the repository
Day 2: Analyse the data in R
Day 3: Reporting, publication, VS Code, and hypercharge your codebase
```

**Speaker note:**
Today is not about writing R. Today is about understanding the *system* — what
each tool does and how they fit together — and getting it all installed. If your
setup works at the end of today, Days 2 and 3 will be smooth. We've often learned
that setting everything up is one of the hardest steps, so we are spending a day
together on this to get everything up and running. Because the set-up is what
even the best LLMs and AI methods cannot help you with (as long as you do not
want to give them full control of your computer). Also understanding is important! It helps a lot in judging output and not feeling overwhelmed!

---

## Slide 2 — Who knows these words?

**Title:** A quick vocabulary check

**On slide:**

```text
fork        commit        push / pull       branch / merge       stage
repository  RStudio       .Rproj            renv                 snapshot
Quarto      render        .qmd              GitHub Pages         Overleaf
```

**Key line:**

```text
Don't know them yet? Perfect. After today, we hope you do.
```

**Speaker note:**
Ask for a show of hands per word. The point is to lower anxiety: this exact list is
what we will have ticked off by 16:30. We will return to it as the end-of-day
checklist, so it doubles as the promise and the proof.

---

## Slide 3 — What we'll deliberately skip today

**Title:** Setting expectations — *not* today

**On slide:**

```text
Deep R syntax        → Day 2 (objects, functions, dataframes, modelling)
VS Code              → Day 3 (RStudio is our environment for now)
Real data            → Day 2/3 (everything today runs on safe mock data)
Responsible AI use   → Day 3 (the repo's AI guardrails, in context)

Today's single job: install the tools and understand how they fit together.
```

**Speaker note:**
Setting scope up front lowers anxiety and frames the whole day. Keeping scope
tight is intentional — if your setup works by the end of today, you're exactly
where you need to be. Everything on the right is parked for a specific later
slot, not forgotten. We'll come back to this list tomorrow morning.

---

## Slide 4 — The whole system on one picture

**Title:** Every box is a tool we install today

**Visual:** `workshop_info/overall_structure.png`

**On slide:**

```text
Reference management (Zotero) ┐
Programming language (R)      ├─→  RStudio (the GUI)  ─→  Quarto (Publisher) ─→  Website
Documentation (Markdown)      ┘          ↑   ↑                                  └→  Manuscript / Data (OSF)
                                         │   │
Packages + Coding assistants ─→ code ────┘   │
                          GitHub (Version) ──┘
                          renv  (Environment) ┘
```

**Speaker note:**
Keep this diagram visible all day. Every time we install something, point back
to its box. The center is RStudio; everything else feeds into or out of it.
(Presenter: Jannis — intro slides here.)

---

## Slide 5 — Why this stack? Free, open, and yours

**Title:** Every tool today is free and open — on purpose

**On slide:**

```text
R & friends    free; huge community; you keep your analysis   (vs SPSS: £££, closed)
Markdown       plain text; machine-readable; no vendor can lock or change it (vs Word)
Git / GitHub   open standard; the full history is yours to keep and to move
Zotero         free, open reference manager; plugs into Word, Quarto, Overleaf
Quarto         free, open publishing; one source → website, PDF, Word

Open + free + standard = reproducible, shareable, and future-proof.
No licence to expire. No format you can't open in ten years.
```

**Speaker note:**
This is the "why" behind the whole day. Closed tools (SPSS, Word) cost money and
can lock your work in a format only they can open — and they can silently change
it under you. Open tools are free, have huge communities (so the error you hit is
already answered somewhere online), and the files are plain text you fully own.
We'll repeat this "why" briefly each time we meet a new tool, rather than
re-arguing it.

---

## Slide 6 — The repo is a kitchen

**Title:** One analogy for the whole repository

**On slide:**

```text
data/         the pantry       →  ingredients you cook with
references/   the cookbook     →  the sources you cite
R/            the kitchen + your techniques  →  reusable functions (how you cook)
reports/      the recipes      →  step-by-step instructions (.qmd files)
renders/      the finished dishes  →  plated and served (website + paper)
renv/         your exact appliances & brands  →  the dish tastes the same in any kitchen
GitHub        the photo-log of every version  →  and how you share with other cooks
```

**Speaker note:**
This is the through-line for the day — keep coming back to it. The repo is a
kitchen. Today we mostly *stock the pantry* and *check the appliances work*; we
actually *cook* on Day 2. The one idea to plant now: you write the recipe once
and prepare the sauce (the numbers) once in the kitchen — then several dishes
(website, paper) are plated from that same sauce. Nothing is re-chopped by hand
for each dish.

---

## Slide 7 — The mental model of this repository

**Title:** One repo = data + engine + two outputs

**On slide:**

```text
R/        computes   → the analysis engine (setup + reusable functions)   — the kitchen
reports/  create     → the recipes you render (webpage + manuscript)      — the recipes
renders/  are results→ the finished website and paper                     — the dishes

Cook the sauce once in R/ and BOTH outputs use it on the next render.
Nothing is copied by hand between them.
```

**Speaker note:**
This is the single most important idea of the repo. `R/` is the source of truth
for the numbers; `reports/` are just different ways to use and
present them; `renders/` are the built products. Change a
function in `R/` and both the website and the paper update on the next render.
We'll see each folder today.

---

## Slide 8 — What lives where

**Title:** A quick tour of the folders (the kitchen, room by room)

**On slide:**

```text
R/           the kitchen: 01_setup.R + functions/   (techniques you reuse)
data/        the pantry:  mock/ (committed)  ·  raw/ & processed/ (private, gitignored)
reports/     the recipes: webpage/  ·  manuscript/  (what you render + the words you write)
renders/     the dishes:  webpage/  ·  manuscript/  (the rendered outputs)
references/  the cookbook: references.bib  (shared by website + manuscript)
renv/        the appliances: pinned package versions (renv.lock)
```

**Speaker note:**
Each folder has its own README — think of it as a label on each shelf. The
top-level README is the front door to the kitchen. We are *not* memorising this —
we're building intuition for where things belong, anchored to the kitchen we just
introduced. Point back to the pantry/recipe/dish mapping as you go.

---

# Part B — GitHub first

## Slide 9 — When something breaks (and it will)

**Title:** Errors are part of the process

**On slide:**

```text
Errors are normal. Everyone in this room will see red text today.
An error message is a clue, not a failure.

When you hit one:
  1. Read it slowly — the answer is usually right there (a path, a name, a missing thing)
  2. Recall the last thing you did — the error points back to it
  3. Copy the exact message into a search engine — someone has hit it before
  4. Ask a neighbour, or ask us
```

**Speaker note:**
Set the tone *before* the first hands-on step. The single biggest predictor of a
smooth day is whether people panic at red text or read it. Normalise it loudly.
Most messages name exactly what's wrong — a missing file, a wrong path, a
function that isn't loaded. Teach the reflex: read → recall last action → search
the exact text → ask. Most red text in the console or terminal is one of a
handful of usual suspects; there's a full reference at the very end of today, and
the ⚠ boxes on each exercise pre-empt the common ones.

---

## Slide 10 — What is Git and GitHub?

**Title:** Version control: the safety net

**On slide:**

```text
Git    = tracks the history of changes in a project folder
GitHub = hosts that project online, so you can share and collaborate

A repository ("repo") = a project folder + its full change history
```

**Speaker note:**
GitHub is not just a cloud drive. It remembers *every* version, who changed
what, and lets several people work on the same project without overwriting each
other. That history is what makes research auditable. In kitchen terms: it's a
photo of the dish at every step, plus the way you hand the recipe to another cook.

---

## Slide 11 — GitHub vocabulary

**Title:** The words you'll hear all day

**On slide:**

```text
Fork    Make your own copy of someone else's repo on GitHub
Clone   Download a repo to your computer
Stage   Pick which changes go into the next commit
Commit  Save a labelled snapshot of the staged changes
Push    Send your commits up to GitHub
Pull    Bring GitHub's changes down to your computer
Branch  A separate line of work
Merge   Combine work from different branches
```

**Speaker note:**
Don't worry about memorising. Today you'll *fork* once, then *stage*, *commit*,
and *push* small changes. Branches and merges become real on Day 2 when you
collaborate in pairs.
Staging tip — especially useful with AI: stage your changes *before* you ask an
LLM to review or before you accept its edits, then look at the diff of what's
staged. Staging makes "what exactly changed?" an explicit, reviewable step
rather than a leap of faith.

---

## Slide 12 — EXERCISE: create a GitHub account

**Title:** Step 1 — get an account

**On slide:**

```text
1. Go to  github.com
2. Sign up (use an email you'll keep — ideally your university email)
3. Verify your email
4. Pick a username you're happy to share publicly
```

**Check:**

```text
Can you log in and see your (empty) GitHub dashboard?
```

**⚠ Watch out (common blockers):**

```text
- Verification email can be slow or land in spam — check both.
- Some corporate/university mail servers block the verification link;
  have a fallback personal email ready.
- The username becomes part of your public website URL later — choose
  something you won't regret printing on a paper.
```

**Speaker note:**
If anyone already has an account, great — just log in. Check out the GitHub
*Student/Education* benefits here (free Pro features, private Pages) — worth
applying for with a university email, and relevant when we turn on Pages shortly.

---

## Slide 13 — EXERCISE: fork the repository

**Title:** Step 2 — make it yours

**On slide:**

```text
1. Open:  github.com/thedataflowcompany/the-science-repository
2. Click  "Fork"  (top right)
3. Keep the name, click "Create fork"
4. You now have:  github.com/<your-awesome-username>/the-science-repository
```

**Key sentence:**

```text
A fork is your own independent copy. You can change it freely
without touching the original.
```

**⚠ Watch out (common blockers):**

```text
- If you've forked this repo before, GitHub won't fork it twice —
  just open your existing copy.
- Don't accidentally fork into an organisation; fork into your own account.
```

**Later — starting your *own* project (not today):**

```text
Forking keeps a visible link to this template — ideal for the workshop.
For your own real project, start a clean, independent repo instead:
  1. Code → Download ZIP   (a snapshot with no fork link)
  2. Create a NEW repo on GitHub — public, or private if your data or project demands it
  3. Copy the files in, commit, and push
Today we all stay on the public fork.
```

**Speaker note:**
Everyone now owns a complete copy of the template — data, engine, and outputs.
This is the starting point for the whole three days. You can pull in new changes
from the original repository. You can even contribute back to the original
repository. Let's say you find a cool new software — you can let us know by
contributing back to the repository you forked from.
On the inevitable "is my public repo findable?" question: treat public as public.
GitHub repos and Pages sites *can* be crawled and indexed, so "nobody has the
link" is not privacy. The real protection is structural — the `.gitignore` keeps
raw/processed data out of the repo entirely, so even a public repo never contains
private data. If the *project itself* must stay hidden, use a private repo
(GitHub Education gives you private Pages).

---

## Slide 14 — Fork vs branch

**Title:** Two ways to make a copy — for different reasons

**On slide:**

```text
Fork    an independent copy under YOUR account
        → your own project, evolves on its own
        → optional: contribute changes back to the original

Branch  a parallel line of work INSIDE one repo
        → meant to be merged back into that same repo
        → how teammates work in parallel without clashing (Day 2)
```

**Speaker note:**
Quick mental rule: you *fork* to take a project and make it your own; you
*branch* to do a piece of work that you intend to fold back in. Today everyone
forks. Tomorrow, in pairs, you'll branch and merge inside your fork.
Forks have metal pieces that are not supposed to come together again; a branch may
decide to grow back into the tree.

---

## Slide 15 — EXERCISE: turn on your website

**Title:** Step 3 — publish your analysis website

**On slide:**

```text
In YOUR fork on GitHub:
1. Settings → Pages
2. Source: "Deploy from a branch"
3. Branch: main   ·   Folder: / (root)   → Save
4. Wait ~1 minute, then open:
   https://<your-username>.github.io/the-science-repository/renders/webpage/
```

**⚠ Watch out (common blockers):**

```text
- GitHub Pages on a FREE account needs a PUBLIC repo. Your fork of a public
  template is public by default, so you're fine. A private repo needs
  GitHub Pro / Education for Pages.
- First build takes 1–2 minutes. A 404 usually means the build isn't done
  yet, or the URL is wrong — it must end with  /renders/webpage/ .
```

**Speaker note:**
This is the payoff moment. The website was rendered from the code in the repo,
and GitHub is now serving *your* copy of it. Nobody wrote any HTML — it came from
the analysis. If anyone made their repo private, this is where it bites — point
them back to the Education benefit from the account-creation step.

---

## Slide 16 — EXERCISE: your first commit

**Title:** Step 4 — edit the README link and commit

**On slide:**

```text
The README points to the project's website. Make it point to YOURS.

1. Open README.md on GitHub → click the pencil (edit)
2. Find the website link near the top
3. Replace the URL with your own github.io address (from the previous step)
4. Scroll down → "Commit changes"
   Message:  "Point website link to my fork"
```

**Speaker note:**
That edit-and-commit you just did *is* a commit, done entirely in the browser.
You've changed your repo and saved a labelled snapshot of it. This is the core
GitHub loop, in miniature. (Editing on GitHub commits straight to `main`; when we
work locally later, you'll stage → commit → push as separate steps.)

---

## Slide 17 — Forks, commits, merges — the picture

**Title:** What just happened, visually

**On slide:**

```text
template repo  ──fork──▶  your repo  ──commit──▶  your repo (new snapshot)
                                          │
                                          └── GitHub Pages rebuilds your site

Later (Day 2): branch ──▶ work ──▶ merge back into main
```

**Speaker note:**
You forked (copied), committed (snapshotted a change), and GitHub republished.
On Day 2 we add branches and merges so two people can work at once. Same loop,
more people.

---

## Slide 18 — What must NEVER go on GitHub

**Title:** Data protection checkpoint

**On slide:**

```text
Usually safe to commit:        Usually NOT safe:
  scripts / code                 real / identifiable participant data
  README & docs                  passwords, tokens, API keys
  mock (synthetic) data          ethics docs with sensitive details
  rendered outputs               anything confidential

Rule of thumb:
  Scripts can be shared.  Raw data usually cannot.
  Outputs depend on whether anyone can be identified.
```

**Speaker note:**
This repo is built to enforce that. The next slide shows how `.gitignore`
protects you automatically.

---

## Slide 19 — How the repo protects you: `.gitignore`

**Title:** Real data can't be committed by accident

**On slide:**

```text
data/mock/        committed     (synthetic, safe — everyone uses this today)
data/raw/         gitignored    (your real data — never leaves your machine)
data/processed/   gitignored    (cleaned data — also stays local)

.gitignore also blocks common data file types everywhere except mock/.
```

**Speaker note:**
For day one of this workshop we use the mock dataset, so there's no risk.
Tomorrow you can also bring your own data if you want to learn on your own data.
In your own projects, `.gitignore` is the seatbelt: raw and processed data simply
won't be pushed, even if you forget.

---

## ☕ Coffee break — 10:30–11:00  *(end of Session I)*

**On slide:**

```text
Back at 11:00.

✓ So far: GitHub account · your fork · website live on Pages · first commit
→ Next: install R & RStudio, then clone your fork to your own laptop
```

**Speaker note:**
Everything so far has been in the browser — nothing installed on the laptop yet.
Use the break to help anyone whose account verification or Pages build is still
catching up, so the whole room starts the install session together. Coffee runs
to 11:00.

---

# Part C — R + RStudio

## Slide 20 — R vs RStudio

**Title:** The engine and the cockpit

**On slide:**

```text
R        = the programming language that does the work (the engine)
RStudio  = the environment you work in: write code, see data,
           run scripts, view plots, manage the project (the cockpit)

You can run R without RStudio — but RStudio makes everything visible.
```

**Speaker note:**
They are two separate installs. We install both. We are *not* learning R syntax
today — that's Day 2. Today we just need it working.

---

## Slide 21 — EXERCISE: install R and RStudio

**Title:** Step 5 — install the software

**On slide:**

```text
Go to: https://posit.co/download/rstudio-desktop (has links to both)

1. Install R:        cran.r-project.org   (pick your OS, latest version)
2. Install RStudio:  posit.co/download/rstudio-desktop  (free Desktop)
3. Open RStudio — it finds R automatically
```

**Check:**

```text
Does RStudio open without errors?
In the Console, type 1 + 1 and press Enter → you should see [1] 2
```

**⚠ Watch out (common blockers):**

```text
- Install R FIRST, then RStudio (RStudio needs R to exist).
- University laptops often need admin rights — sort this out before today.
- Mac: pick the build for your chip (Apple Silicon vs Intel). If macOS
  blocks the installer, right-click → Open, or allow it in
  System Settings → Privacy & Security.
- Antivirus on Windows can quarantine the installer — allow it.
```

**Speaker note:**
This is where setup problems surface, so go slowly and help neighbours. The
1 + 1 check confirms RStudio actually found R — and it's your first command in
the Console.

---

## Slide 22 — EXERCISE: get the repo onto your laptop

**Title:** Step 6 — clone your fork

**On slide:**

```text
Cloning = downloading YOUR fork (with its full history) to your machine.

In RStudio:
  File → New Project → Version Control → Git
  Repository URL: https://github.com/<your-username>/the-science-repository
  → Create Project

Two ways to handle the GitHub login — pick one:

  A. GitHub Desktop (easiest today)
     Install desktop.github.com → sign in (in the browser) → File → Clone
     No Personal Access Token to set up.

  B. Personal Access Token / PAT (the sustainable, long-term setup)
     In the R Console:
        usethis::create_github_token()   # opens GitHub to create the token
        gitcreds::gitcreds_set()         # paste it once; RStudio remembers it
     Alternative:
        Go to Github/Settings/Developer Settings/Personal Access Tokens/PAT
```

```text
Heads up: this is the fiddliest step of the whole day. That's expected —
we will get everyone through it. Take a breath; ask for help.
```

**⚠ Watch out (common blockers):**

```text
- If the "Git" option is greyed out, Git isn't installed → install from
  git-scm.com, restart RStudio.
- FIRST TIME ONLY — tell Git who you are (same email as GitHub):
    git config --global user.name  "Your Name"
    git config --global user.email "you@university.edu"
- Pushing over HTTPS no longer accepts your password. When asked, paste a
  Personal Access Token (option B), or use GitHub Desktop (option A) which
  signs you in through the browser and handles credentials for you.
```

**Speaker note:**
Cloning is the mirror image of forking: fork copies on GitHub, clone copies to
your laptop. The identity + token setup is the single most common place people
get stuck — budget time for it, normalise the frustration, and have the PAT steps
on a cheatsheet. Recommend the two paths honestly: **GitHub Desktop unblocks you
fastest today** (browser sign-in, no token, plus nice visual diffs and a
branch/merge view that helps later). The **PAT is what survives long-term** —
it works in RStudio's Git pane, the terminal, and scripts, and won't depend on a
separate app being installed. Keep RStudio's Git pane as the default for
day-to-day commits; offer Desktop to anyone fighting authentication.

---

## Slide 23 — (Optional) Start a project from scratch

**Title:** How RStudio Projects get created

**On slide:**

```text
File → New Project → …
  1. New Directory       a brand-new empty project folder
  2. Existing Directory  wrap a project around a folder you already have
  3. Version Control     clone from GitHub (what we just did)

Every option produces a  .Rproj  file = the project's anchor.
```

**Speaker note:**
Optional detour for the curious — useful so they understand that "clone from
GitHub" is just one of three ways to get a `.Rproj`. For their own future
projects, option 1 or 2 is common; for collaborative work, version control from
the start is best.

---

## Slide 24 — Open the project, not the files

**Title:** Always open via the .Rproj

**On slide:**

```text
the-science-repository.Rproj   ← double-click THIS

Opening the project (not single files) tells R:
  - where the project root is
  - where data, scripts, and outputs live
  → file paths work the same on everyone's computer
```

**Speaker note:**
The number-one beginner trap is "R can't find my file". Opening the project
fixes most of it, because paths are anchored to the project root, not your
Desktop.

---

## Slide 26 — RStudio in 60 seconds

**Title:** The four panes (and the Terminal)

**On slide:**

```text
Source       where you write and save scripts
Console      where R runs R commands
Environment  the objects currently in memory
Files/Plots/Packages/Help   manage files, see figures, read docs
R project set-up  You change settings in your R project.

Terminal tab (next to Console): your computer's command line —
  this is where git and `quarto render` commands run.
```

**Speaker note:**
That's all you need today. The one addition worth flagging: the **Console** runs
*R* code, while the **Terminal** runs *system* commands (git, quarto). People mix
these up constantly — when we render later, that goes in the Terminal, not the
Console.

---

## 🍽 Lunch — 12:30–13:30  *(end of Session II)*

**On slide:**

```text
Back at 13:30.

✓ So far: R & RStudio installed · fork cloned · project open via the .Rproj
→ Next: restore the exact packages, then the publishing pipeline and your
        first local render
```

**Speaker note:**
The hardest part of the day — installs and Git authentication — is now behind us.
Use the long break to get any remaining laptops cloned and opened via the
`.Rproj`, so everyone is on the same footing for the afternoon. Lunch runs to
13:30.

---

# Part D — Environment control (renv)

## Slide 27 — The "works on my machine" problem

**Title:** Why pinning package versions matters

**On slide:**

```text
Same code + different package versions = different (or broken) results.

"It works on my laptop but not yours."
"It worked last year but not today."
```

**Speaker note:**
Two layers of reproducibility, one clean analogy:
- **Git/GitHub** version your *code* — every change to your scripts is tracked.
- **renv** versions your *packages* — the exact libraries your code depends on.
You need both; pinned code running on drifting packages still breaks.
In kitchen terms: `renv` pins the exact appliances and ingredient brands so the
dish tastes the same in every kitchen.
Concretely: I already built and tested this repo. Installing every package by
hand on each of your laptops would take forever and still drift. Instead I took a
*snapshot* of exactly what's installed (`renv.lock`), and you'll restore that
same snapshot in one command.

---

## Slide 28 — What renv does

**Title:** renv = a locked, per-project package library

**On slide:**

```text
renv.lock     records the exact version of every package this project uses
renv/         a private package library just for this project
.Rprofile     activates renv automatically when the project opens

→ Everyone restores the SAME versions. No more version drift.
```

**Speaker note:**
`renv` is the "Environment Control" box in the diagram. Each project gets its own
isolated set of packages, described precisely in `renv.lock`.

---

## Slide 29 — EXERCISE: restore the environment

**Title:** Step 7 — install the exact packages

**On slide:**

```r
install.packages("renv")   # only if RStudio doesn't prompt you
renv::restore()            # installs every package at the pinned version
```

**Check:**

```text
renv reads renv.lock and installs what's missing.
This can take a few minutes — that's normal.
When it finishes, you have every package the project needs.
```

**⚠ Watch out (common blockers):**

```text
- If prompted "Do you want to proceed? [y/N]" — type y and Enter.
- First restore can compile packages from source. Mac users may be asked to
  install the Xcode Command Line Tools — accept it.
- It can take 5–15 min on a fresh machine. Let it finish; don't interrupt.
- Needs a stable internet connection — conference Wi-Fi can stall it.
```

**Speaker note:**
Run this in the Console (it's R code). This is the moment everyone's environment
becomes identical. Later, after adding a package, you'd run `renv::snapshot()` to
record it — but not today.

---

# Part E — Documentation

## Slide 30 — README: the front door

**Title:** Every project explains itself

**On slide:**

```text
The top-level README tells you:
  - what the project is
  - what lives in each folder
  - how to set up and render

Every folder also has its OWN README (R/, data/, reports/, renders/...).
```

**Speaker note:**
If you open this project in six months, the README gets you back in. When you
fork for your own work, you rewrite the README first. And it's not write-once: the
README is *living documentation* — every time the project's structure or setup
changes, the README is the thing you update so it never lies to future-you.

---

## Slide 31 — Markdown, lightly

**Title:** READMEs are written in Markdown

**On slide:**

```text
# Heading            **bold**        *italic*
- bullet             [link](url)     `code`

Plain text + a few symbols → clean, readable docs.
It's the "Documentation" box in the diagram.

Why Markdown?  It's plain text, which means:
  - machine-readable and diff-able → Git can track every change
  - open → no app owns it; it opens anywhere, today and in ten years
  - nobody can silently re-format or lock it (unlike a .docx)
```

**Speaker note:**
You already used Markdown when you edited the README on GitHub. It's deliberately
simple — the same syntax shows up in Quarto in a moment. The deeper "why" is the
one from this morning's open-source slide: plain text is yours forever. A Word
file depends on Word; Markdown depends on nothing. That's why our docs, and soon
our reports, are plain text.

---

# Part F — Publishing: recipe → ingredients → outputs

## Slide 32 — What it takes to produce an output

**Title:** A recipe, its ingredients, and a cook

**On slide:**

```text
.qmd recipe       text + code chunks that say what to do      ┐
R/ functions      the techniques (the numbers / the sauce)    │
data/             the ingredients                             ├─ go into the dish
references.bib    the citations                               ┘
        │  quarto render   (the cook follows the recipe)
        ▼
   website  /  manuscript
```

**Speaker note:**
Transition slide. We've installed the tools — now, what does it actually take to
produce an output? A **recipe** (the `.qmd` pages), the **ingredients** (data and
references), and a **cook** (Quarto, running the `R/` engine). The next slides go
in that order: first the recipe and how it's read, then the ingredients it pulls
in, then the cook that combines them — so nothing appears out of nowhere.

---

## Slide 33 — What is Quarto? (the cook)

**Title:** Quarto = prose + code → polished output

**On slide:**

```text
A .qmd file mixes:
  - text (Markdown)
  - R code chunks
  - the results those chunks produce (tables, figures, numbers)

Quarto runs the code and weaves results into the finished document.

Why Quarto (and not R Markdown)?  Quarto is R Markdown's successor:
  - one engine for R, Python, and Julia (not R-only)
  - one source → HTML, PDF, Word, slides, whole websites
  - actively developed, batteries included (citations, cross-references)
```

**Speaker note:**
Quarto is the "Publisher" box — the cook that follows the recipe. The key idea:
your figures and tables are *not* pasted in — they're generated when the document
renders, straight from the `R/` engine. No copy-paste, no stale numbers. On the
"why Quarto": if people know R Markdown, Quarto is the same idea grown up — one
tool for many languages and many output formats, still free and open.

---

## Slide 34 — The recipe pages, read in order

**Title:** A report is a recipe, read top to bottom

**On slide:**

```text
reports/webpage/
  01-data-preparation.qmd   load + clean the data        → writes the processed cache
  02-descriptives.qmd       summarise it                 → uses the cache
  03-analysis.qmd           model it                     → uses the cache

Each page runs top → bottom. Setup first, results last.
They all call the shared functions in  R/functions/  (the kitchen techniques).
```

**Speaker note:**
Start with the scripts, because they drive everything else. This ordering —
prepare, describe, analyse — is the backbone of the whole analysis, and the same
order you'll work in on Day 2. Code always executes from the top down; nothing
later works if something earlier failed. The crucial dependency: `01-data-prep`
must run before the others because it *prepares the ingredients* — it pulls in the
data and writes the processed cache that `02` and `03` then consume. That's our
bridge to the next slide, where we look at exactly which ingredients it pulls in.

---

## Slide 35 — Ingredient 1: the three data buckets

**Title:** raw → processed → mock (what 01-data-preparation handles)

**On slide:**

```text
data/raw/        original data, exactly as received — never hand-edited (private)
data/processed/  cleaned, analysis-ready — created BY a script, can be rebuilt (private)
data/mock/       synthetic stand-in — committed, safe to share, used in the workshop
```

**Speaker note:**
Now we zoom into the ingredients that `01-data-preparation` from the last slide
actually pulls in. Raw is input you never touch; processed is output a script
creates; mock is the public, synthetic version we all run today. How it flows:
by default the project reads from **mock** (no setup needed — `mock` is the
default mode). When the website renders, `01-data-preparation` cleans the data and
*writes the cache* `data/processed/consumer_clean.rds`; the later pages reuse it.
So `processed/` fills itself when you render — you don't create it by hand. In
kitchen terms: raw is the produce as delivered, processed is your mise en place,
mock is the practice ingredients we cook with today. (Switching to real data swaps
the *source* to `data/raw/`; that's a Day 2/3 topic.)

---

## Slide 36 — Ingredient 2: Zotero and citations

**Title:** Manage references once, cite everywhere

**On slide:**

```text
Zotero      collects your papers and generates citations
   │  export
   ▼
references/references.bib      ONE shared bibliography
   │
   ├──▶ used by the website
   └──▶ used by the manuscript

Why Zotero?  Free and open (vs paid managers), and it plugs into
Word, Quarto, and Overleaf — one library, cited everywhere.
```

**Speaker note:**
The second ingredient — the cookbook. You keep your library in Zotero, export a
`.bib` file into `references/`, and *both* outputs cite from the same source.
Change a reference once, it updates everywhere — no re-typing citations into two
documents. The "why" fits the open-source thread: Zotero is free and integrates
across the tools we use, so your library isn't trapped in one program.

---

## Slide 37 — Two outputs from one engine

**Title:** Website and manuscript, same numbers

**On slide:**

```text
reports/webpage/      ──quarto render──▶  renders/webpage/      (HTML website)
reports/manuscript/   ──quarto render──▶  renders/manuscript/   (LaTeX → PDF paper)

Both reuse R/. Same data, same functions, two presentations.
```

**Speaker note:**
A website needs clickable HTML tables; a journal needs LaTeX. The repo formats
the same results two ways — two dishes plated from the same sauce. This is the
right-hand side of the diagram: Report Output.

---

## Slide 38 — EXERCISE: render the website

**Title:** Step 8 — build the site locally

**On slide:**

```bash
quarto render reports/webpage
```

```text
→ rebuilds renders/webpage/
Open renders/webpage/index.html to see it.
(Quarto ships inside RStudio — no separate install needed.)
```

**⚠ Watch out (common blockers):**

```text
- Run this in the TERMINAL tab, not the R Console.
- Render the WHOLE site (reports/webpage), not a single page — the first
  page builds the data/processed cache the others depend on.
- If "quarto: command not found", update RStudio (recent versions bundle
  Quarto) or install from quarto.org.
```

**Speaker note:**
This is the same render that GitHub ran for your Pages site. Now you can do it on
your own laptop and preview before pushing. If it builds, your R + renv + Quarto
chain is fully working — that's the **Day 1 finish line**. The manuscript (LaTeX)
is the next, optional slide; if we're short on time it moves to Day 3 and nothing
today depends on it.

---

## ☕ Coffee break — 15:00–15:30  *(end of Session III)*

**On slide:**

```text
Back at 15:30.

✓ So far: environment restored · website rendered locally — the Day 1 finish line
→ Next: the optional second output (the PDF manuscript), common blockers, and
        the end-of-day checklist
```

**Speaker note:**
If `quarto render reports/webpage` worked, the core Day 1 chain — R + renv +
Quarto — is fully working for that person. Use the break to get anyone whose
render failed across the line, so the final session is wrap-up and catch-up
rather than firefighting. Coffee runs to 15:30.

---

## Slide 39 — (Optional, if time) The manuscript: LaTeX + Overleaf

**Title:** The second output — the paper, and how co-authors join in

**On slide:**

```text
The website is today's finish line. The manuscript is the SAME engine, second dish.

To build the PDF you need a LaTeX engine (one-time install):
  in the R Console:
    install.packages("tinytex")
    tinytex::install_tinytex()

Then:
  quarto render reports/manuscript
    → generates the data-driven parts (methods, results, figures, tables)
    → renders/manuscript/main.tex assembles them into manuscript.pdf

Overleaf:
  the self-contained renders/manuscript/ folder can sync to Overleaf
  → online, collaborative LaTeX writing with co-authors
```

**⚠ Watch out (common blockers):**

```text
- tinytex downloads a full LaTeX distribution — needs internet and a few minutes.
- The manuscript needs the LaTeX engine above; the WEBSITE never does.
- Short on time? Skip this — we cover LaTeX + Overleaf properly on Day 3.
```

**Speaker note:**
This slide is movable: if the room is fast, we install `tinytex` and render the
PDF today so people see both outputs from one engine; if not, we move the whole
thing to Day 3 — nothing on the checklist depends on it. The point either way:
the manuscript folder is self-contained, so it can live on Overleaf for
co-authoring while the data-driven parts still come from your R code. We go deeper
on Day 3.

---

# Part G — Wrap-up

## Slide 40 — Quick reference: common blockers

**Title:** The day's usual suspects (and the fix)

**On slide:**

```text
"Git option greyed out"        → install Git (git-scm.com), restart RStudio
"Authentication failed" on push→ use a Personal Access Token, not a password
"Could not find function"      → package not loaded → did renv::restore() finish?
"cannot open file ... raw/..." → you're in real mode; default is mock (do nothing)
Website shows 404              → wait for the build; URL ends /renders/webpage/
"quarto: command not found"    → update RStudio / install from quarto.org
A single page won't render     → render the whole reports/webpage folder
```

**Speaker note:**
The catch-all reference for the day — pairs with the "errors are normal" slide
from the morning. Most Day 1 pain is one of these seven, and a structured error
message is a clue, not a failure. Read it, search the exact text, then ask. This
is also the page to point at during the optional afternoon support.

---

## Slide 41 — End-of-Day-1 checklist

**Title:** Before you leave today

**On slide:**

```text
[ ] GitHub account created
[ ] Repository forked to your account
[ ] GitHub Pages on → your website loads
[ ] First commit made (README link points to your site)
[ ] R and RStudio installed
[ ] Fork cloned and opened via the .Rproj
[ ] renv::restore() finished successfully
[ ] quarto render reports/webpage works locally
```

**Speaker note:**
Remember the words from this morning's vocabulary check? This is the same list,
now as done/not-done. Run through it as an exit check. Anyone with unticked boxes
should grab the optional support session — it helps for Day 2 if all of this works.

---

## Slide 42 — Tomorrow

**Title:** Day 2 — analyse the data in R

**On slide:**

```text
With the scaffold in place, tomorrow we:
  - work inside R/ and the report pages
  - import, clean, and inspect the data
  - build descriptives, figures, and models
  - use branches and merges to collaborate in pairs
```

**Speaker note:**
Everything we installed today becomes the workbench for Day 2 — the kitchen is
stocked and the appliances work; tomorrow we cook. The structure you set up is
what makes the analysis easy to follow and easy to share. Bring your own data if
you want.
