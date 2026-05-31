# Day 1 — Timeplan & slide-to-session mapping

Companion to [day_one_slides.md](day_one_slides.md). This maps every slide to one
of the four 90-minute sessions and checks that the deck's shape matches the day's
rhythm.

## Design principles (from the brief)

1. **Each session opens with a short intro** — orient people before they touch a keyboard.
2. **Each session closes with the exercise(s)** for that block — so hands-on work lands
   right before a break.
3. **Exercises are timed to finish with room to spare**; if they overrun, they spill into
   the following break (worst case = a longer coffee break / lunch), never into the next
   session's teaching.
4. **The toolchain is front-loaded by risk**: browser-only work in the morning (low risk),
   local installs at midday (highest risk, most buffer), the render payoff after lunch, and
   a deliberate catch-up buffer at the end of the day so **nobody leaves with a broken setup**.

## The fixed grid

| Time | Block | Session theme | Slides | Parts |
|------|-------|---------------|--------|-------|
| 09:00–10:30 | **I** | Foundations & GitHub | 1–19 | A + B |
| 10:30–11:00 | ☕ | Coffee break | — | — |
| 11:00–12:30 | **II** | R, RStudio & your repo *(the install session)* | 20–26 | C |
| 12:30–13:30 | 🍽 | Lunch | — | — |
| 13:30–15:00 | **III** | Environment, docs & publishing | 27–38 | D + E + F |
| 15:00–15:30 | ☕ | Coffee break | — | — |
| 15:30–17:00 | **IV** | Second output, wrap-up & catch-up | 39–42 | F + G |

Parts map almost 1:1 onto sessions, which is a good sign the deck already has the
right joints.

---

## Session I — 09:00–10:30 · Foundations & GitHub

**Slides 1–19 (Parts A + B). All browser-based — no local installs yet.**

| Phase | Slides | What happens | ~min |
|-------|--------|--------------|------|
| **Intro / framing** | 1–8 | Welcome, vocab check, what we skip, the system diagram, why open-source, the kitchen analogy, mental model, folder tour | 25 |
| **Teach** | 9, 10, 11, 14 | Errors-are-normal, what Git/GitHub is, the vocabulary, fork vs branch | 15 |
| **Exercises** | 12, 13, 15, 16, 17 | Create account → fork → turn on Pages → first commit → the picture of what happened | 35 |
| **Safety coda** | 18, 19 | What must never go on GitHub · how `.gitignore` protects you | 8 |
| Buffer | — | absorbs slow signups / verification emails | ~7 |

- **Intro ✓ / Exercise close ✓** — opens on framing, the hands-on cluster (12–17) lands late
  in the session, then a short 2-slide safety coda.
- **Overflow strategy:** the slowest exercise here is account creation (verification emails);
  if it runs over it eats the 10:30 coffee break, not Session II.
- **Optional tightening:** if you want the session to end *exactly* on an exercise, move the
  data-protection coda (18, 19) to just before the commit exercise (16) — it reads as
  "here's what's safe to commit, now commit." Left as-is, it's a calm conceptual close.

---

## Session II — 11:00–12:30 · R, RStudio & your repo *(the install session)*

**Slides 20–26 (Part C). Highest-risk session — first local installs and Git auth.**

| Phase | Slides | What happens | ~min |
|-------|--------|--------------|------|
| **Intro** | 20 | R (engine) vs RStudio (cockpit) | 5 |
| **Exercise** | 21 | Install R then RStudio; the `1 + 1` check | 20 |
| **Exercise** | 22 | Clone your fork — *the fiddliest step of the day* (PAT / GitHub Desktop) | 30 |
| **Orientation coda** | 23 (opt), 24, 26 | How projects are created · always open via `.Rproj` · the four RStudio panes | 12 |
| Buffer / catch-up | — | absorbs admin-rights, OS-blocked installers, auth failures | ~23 |

- **Intro ✓ / Exercise close ⚠** — note this is the one session where the heavy exercises sit
  in the *middle*, not the very end. That's deliberate and unavoidable: you must install
  RStudio (21) before you can orient inside it (24, 26), and the clone (22) happens *through*
  RStudio's New Project dialog. Treat 24 + 26 as a short "settle and orient" close while
  stragglers finish cloning.
- **This session has the most buffer on purpose.** Install + auth is where people get stuck;
  the slide notes flag it ("budget time for it, normalise the frustration").
- **Overflow strategy:** if the clone overruns, it spills into lunch (60 min) — and that's
  fine, because the next exercise (`renv::restore`) doesn't start until Session III.
- **Pre-empt:** remind people the day before to sort admin rights and to install
  Git ([git-scm.com](https://git-scm.com)) so the "Git option greyed out" blocker doesn't cost the room time.

---

## Session III — 13:30–15:00 · Environment, docs & publishing

**Slides 27–38 (Parts D + E + F). The "while it installs, learn the why" session.**

| Phase | Slides | What happens | ~min |
|-------|--------|--------------|------|
| **Intro** | 27, 28 | The "works on my machine" problem · what renv does | 8 |
| **Exercise (background)** | 29 | Kick off `renv::restore()` — runs 5–15 min unattended | 3 to launch |
| **Teach (while it restores)** | 30, 31 | README the front door · Markdown, lightly | 8 |
| **Teach (while it restores)** | 32–37 | The recipe → ingredients → cook pipeline: what it takes, Quarto, the report pages, the three data buckets, Zotero, two outputs | 25 |
| **Exercise** | 38 | `quarto render reports/webpage` — **the Day 1 finish line** | 12 |
| Buffer | — | render troubleshooting | ~14 |

- **Intro ✓ / Exercise close ✓** — opens on the renv "why", closes on the marquee render.
- **The clever bit:** `renv::restore()` (29) is slow and unattended, so kick it off *first*
  and let it churn in the background through the docs/publishing concept slides (30–37). By
  the time you reach the render (38), packages are installed — no dead waiting.
- **Hard dependency:** the render (38) needs `renv::restore` (29) to have finished. Keeping
  both in this session (with the concept slides masking the wait) makes the sequencing safe.
- **Optimization if you're ahead:** if the clone finished early in Session II, you can launch
  `renv::restore` right before lunch so it completes *over* lunch — then Session III is
  restore-free and you go straight from concepts to render.
- **Overflow strategy:** a slow render spills into the 15:00 coffee break.

---

## Session IV — 15:30–17:00 · Second output, wrap-up & catch-up

**Slides 39–42 (rest of Part F + Part G). Deliberately a buffer/wrap session.**

| Phase | Slides | What happens | ~min |
|-------|--------|--------------|------|
| **Optional exercise** | 39 | Install `tinytex`, render the manuscript PDF, the Overleaf hand-off | 15 |
| **Reference** | 40 | The day's common blockers and their fixes | 5 |
| **Wrap** | 41 | End-of-Day-1 checklist — run live as an exit check | 10 |
| **Wrap** | 42 | Tomorrow: analyse the data in R | 5 |
| **Catch-up / optional support** | — | finish everyone's renders, mop up broken installs, re-run the checklist | ~55 |

- This session is **intentionally light on new content and heavy on buffer** — it directly
  serves Day 1's whole goal ("nobody leaves with a broken setup"). The deck already calls
  for "optional afternoon support"; this is its home.
- **Movable content:** slide 39 (manuscript) is explicitly flagged as moveable to Day 3. If
  the room is behind, cut it entirely and use the time for catch-up — nothing on the
  checklist depends on it.
- **End the day on slide 41**, the checklist, mirroring the morning's vocabulary promise
  (slide 2). Anyone with unticked boxes is steered to the support time still left in the room.

---

## Alignment check — does the deck fit the grid?

**Good fits**
- Parts map cleanly onto sessions (A+B → I, C → II, D+E+F → III, F+G → IV), so no slide
  has to be torn out of its narrative context to fit a timeslot.
- Risk is front-loaded sensibly: browser-only (I) → local installs (II) → render (III) →
  buffer (IV). The two heaviest exercises (clone, renv) sit before the two longest breaks
  (lunch, coffee).
- Three of four sessions open on an intro and close on an exercise as requested.

**Flags / things to confirm**
1. **Session II ends on orientation slides (24, 26), not an exercise.** This is the one
   unavoidable exception — see the note in that session. Acceptable, but worth deciding
   consciously.
2. **Slide 25 is missing** from the deck (numbering jumps 24 → 26). Confirm it was
   intentionally removed and not an orphaned cut; renumber if you want a clean sequence.
3. **Render (38) depends on `renv::restore` (29).** Both are in Session III by design — keep
   them in that order and don't split them across the coffee break.
4. **Two optional slides (23, 39)** are your release valves. Cut them first if any session
   runs long.

**At-a-glance exercise load per session**

| Session | Exercises | Risk | Buffer |
|---------|-----------|------|--------|
| I | account, fork, Pages, commit (4× browser) | low | small |
| II | install R/RStudio, clone (2× local) | **high** | **large** |
| III | renv restore (background), render | medium | medium |
| IV | manuscript (optional) | low | **large (by design)** |
