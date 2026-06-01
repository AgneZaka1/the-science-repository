# =============================================================================
#  Day 2 · Pt. 2½ — SEEING THE DATA
#  Build one figure, one layer at a time, until it's publication-ready.
# =============================================================================
#
#  This is the fun part. A plot shows what a table of means hides — spread,
#  outliers, the shape of a relationship. {ggplot2} builds a figure the way you
#  build a sentence: in pieces, joined together. The pieces are the "grammar of
#  graphics":
#
#       DATA          which dataset are we drawing?
#     + AESTHETICS    which variable maps to x, y, colour, shape, ...?  -> aes()
#     + GEOMETRIES    what shape do we draw — points, lines, bars?      -> geom_*
#     + everything else (labels, scales, themes) is polish on top.
#
#  Run this file ONE LINE/BLOCK AT A TIME (cursor in the block, Cmd/Ctrl+Enter)
#  and watch the Plots pane change with each new layer. The point is to SEE each
#  piece do its job.
#
#  ONE GOTCHA WORTH SHOUTING ABOUT:
#  ggplot layers are joined with  +  , NOT the pipe  |> .  Mixing them up is the
#  #1 beginner ggplot error. Inside a ggplot, think "+ add a layer".
#
#  We use the cleaned consumer data — the same dataset as everywhere else. Our
#  question: does how much VALUE people perceive track their PURCHASE INTENTION,
#  and does that differ by the message frame they saw? (Spoiler: this is the
#  "mediation" picture you'll meet again this afternoon.)
# =============================================================================


# ---- 0. Setup: load + clean (so this file stands on its own) ------------
library(readr)
library(dplyr)
library(janitor)
library(ggplot2)

clean <- read_csv(here::here("data", "mock", "consumer_data_raw.csv"),
                  show_col_types = FALSE) |>
  clean_names() |>
  mutate(
    condition          = factor(trimws(condition)),
    # the two scale scores we'll plot, each an average of three survey items
    purchase_intention = rowMeans(across(c(pi_1, pi_2, pi_3)), na.rm = TRUE),
    perceived_value    = rowMeans(across(c(pv_1, pv_2, pv_3)), na.rm = TRUE)
  )

# A small position "nudge" we define ONCE and reuse in every scatter below.
# Both scores are averages of three 1–7 items, so they land on a coarse grid and
# many shoppers share the exact same spot. position_jitter() scatters each point
# a touch so we can see how dense the cloud really is. The fixed seed makes the
# nudge identical every run, so the picture stays put as we stack on more layers.
jitter_a_little <- position_jitter(width = 0.08, height = 0.08, seed = 42)


# ---- 1. The empty canvas ------------------------------------------------
# Give ggplot a dataset and... nothing is drawn. We've said WHAT data, but not
# what to put on the axes or what shape to draw. A blank grey panel.
ggplot(data = clean)


# ---- 2. Map variables to the axes (aesthetics) --------------------------
# aes() = "aesthetic mappings": connect a column to a visual property. Map
# perceived_value to the x-axis and purchase_intention to the y-axis. Now the
# axes and gridlines appear, scaled to the data — but still no data drawn,
# because we haven't chosen a geometry yet.
ggplot(
  data    = clean,
  mapping = aes(x = perceived_value, y = purchase_intention)
)


# ---- 3. Add a geometry: points ------------------------------------------
# geom_point() draws one point per row (per participant). NOW we see data.
# The "+" adds the layer. (Again: "+", never "|>", inside a ggplot.)
# Look closely: the points sit on a tidy grid and stack on top of each other —
# lots of shoppers share the same averaged scores. That "overplotting" hides how
# many points are really at each spot. We fix it in the very next step.
ggplot(
  data    = clean,
  mapping = aes(x = perceived_value, y = purchase_intention)
) +
  geom_point(position = jitter_a_little)


# ---- 4. Spread the points apart (jitter) + a third variable: colour -----
# Two small changes:
#  (a) position = jitter_a_little nudges every point a touch, so the stacks from
#      step 3 spread out and the density of the cloud becomes visible;
#  (b) mapping condition to colour draws each group in its own colour and adds a
#      legend automatically — a whole extra dimension, for one word of code.
# We KEEP the jitter from here on, so every scatter below stays readable.
ggplot(
  data    = clean,
  mapping = aes(x = perceived_value, y = purchase_intention, color = condition)
) +
  geom_point(position = jitter_a_little)


# ---- 5. Add a trend line: geom_smooth -----------------------------------
# geom_smooth(method = "lm") fits a straight line (a linear model) through the
# cloud. Watch carefully: because colour is set GLOBALLY (in the top aes), every
# layer inherits it — so we get one line PER condition. Sometimes that's exactly
# what you want; sometimes it's a surprise. Knowing *why* is the lesson.
ggplot(
  data    = clean,
  mapping = aes(x = perceived_value, y = purchase_intention, color = condition)
) +
  geom_point(position = jitter_a_little) +
  geom_smooth(method = "lm")


# ---- 6. Global vs per-layer aesthetics ----------------------------------
# Move colour OUT of the global aes and INTO geom_point() only. Now just the
# points are coloured by condition; geom_smooth no longer sees "colour", so it
# draws a SINGLE line through all the data. Rule: an aes() inside a geom applies
# to that layer alone; an aes() in ggplot() applies to every layer.
ggplot(
  data    = clean,
  mapping = aes(x = perceived_value, y = purchase_intention)
) +
  geom_point(mapping = aes(color = condition), position = jitter_a_little) +
  geom_smooth(method = "lm")


# ---- 7. Encode the group twice: colour AND shape ------------------------
# Mapping condition to BOTH colour and shape is good practice: the figure still
# reads if it's printed in black and white, or for a colourblind reader. Two
# channels carrying the same information = a more accessible plot.
ggplot(
  data    = clean,
  mapping = aes(x = perceived_value, y = purchase_intention)
) +
  geom_point(mapping = aes(color = condition, shape = condition),
             position = jitter_a_little) +
  geom_smooth(method = "lm")


# ---- 8. Polish: labels + a colourblind-safe palette ---------------------
# Everything so far is the science; this layer is the communication. labs()
# sets every text label (note: the legend title is set via the aesthetic it
# describes — here "color" and "shape"). scale_color_viridis_d() swaps in a
# perceptually-uniform, colourblind-friendly palette that ships with ggplot2.
# THIS is a figure you could drop straight into a paper or slide.
ggplot(
  data    = clean,
  mapping = aes(x = perceived_value, y = purchase_intention)
) +
  geom_point(aes(color = condition, shape = condition),
             position = jitter_a_little, alpha = 0.7) +
  geom_smooth(method = "lm", color = "black") +
  labs(
    title    = "Perceived value tracks purchase intention",
    subtitle = "Each point is one shopper; the line is the overall linear trend",
    x        = "Perceived value (1–7)",
    y        = "Purchase intention (1–7)",
    color    = "Message frame",
    shape    = "Message frame"
  ) +
  scale_color_viridis_d() +
  theme_minimal()
# (The R for Data Science book uses ggthemes::scale_color_colorblind() here; we
#  use ggplot2's built-in viridis scale so there's no extra package to install.)


# ---- 9. A different question, a different geom: distributions -----------
# Same grammar, new geometry. To compare the SHAPE of purchase intention across
# conditions, map it to x, map condition to both colour (the outline) and fill
# (the shading), and draw smoothed densities. alpha = 0.5 makes them
# see-through so overlaps are visible. Swapping the geom = asking a new question.
ggplot(clean, aes(x = purchase_intention, color = condition, fill = condition)) +
  geom_density(alpha = 0.4) +
  labs(
    title = "Distribution of purchase intention by message frame",
    x     = "Purchase intention (1–7)", y = "Density",
    color = "Message frame", fill = "Message frame"
  ) +
  scale_color_viridis_d() +
  scale_fill_viridis_d() +
  theme_minimal()


# =============================================================================
#  WHAT YOU JUST SAW
#  A publication-ready figure is not one magic command — it's a stack of small,
#  readable layers:  data  ->  aes()  ->  geom_*()  ->  labels & scales.
#  Change one layer and the rest stays put. That is the whole idea of ggplot.
#
#  To SAVE any of these (for a report or slide), assign it to a name and ggsave:
#      my_plot <- ggplot(clean, aes(...)) + geom_point()
#      ggsave(here::here("workshop","materials","day_2","_output","my_plot.png"),
#             my_plot, width = 7, height = 5, dpi = 300)
#
#  Go deeper: R for Data Science, "Data visualisation"
#  https://r4ds.hadley.nz/data-visualize  — and the ggplot2 cheat sheet in
#  workshop/cheat sheets/plots_ggplot_cheat-sheet.pdf
# =============================================================================

