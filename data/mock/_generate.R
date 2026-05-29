# _generate.R --------------------------------------------------------------
# Generates `consumer_data_raw.csv` — a synthetic Consumer Decision-Making
# dataset for the workshop. Run from the project root:
#
#   Rscript data/mock/_generate.R
#
# What's baked in (so the analysis storyline actually finds something):
#   1. condition -> perceived_value -> purchase_intention   (mediation)
#   2. price_sensitivity moderates condition -> purchase_intention
#   3. brand_trust has one reverse-scored item (bt_3_r)
#   4. Realistic messiness: inconsistent gender labels, -99 missing codes,
#      mixed-case column names, trailing whitespace, a few NAs.
#
# Re-running with the same seed produces an identical file.

set.seed(20260602)

N           <- 300
conditions  <- c("control", "scarcity_frame", "sustainability_frame",
                 "social_proof_frame", "combined_frame")
products    <- c("electronics", "food", "clothing", "services")

# ---- latent traits -------------------------------------------------------
participant_id    <- sprintf("P%03d", seq_len(N))
condition         <- sample(conditions, N, replace = TRUE)
age               <- round(rnorm(N, 38, 13)); age <- pmin(pmax(age, 18), 75)
gender_latent     <- sample(c("woman", "man", "non_binary", "prefer_not"),
                            N, replace = TRUE, prob = c(0.46, 0.46, 0.05, 0.03))
income_latent     <- sample(c("low", "medium", "high"),
                            N, replace = TRUE, prob = c(0.3, 0.5, 0.2))
product_category  <- sample(products, N, replace = TRUE)

# Latent constructs (z-scored)
price_sens_lat <- rnorm(N)
sust_conc_lat  <- rnorm(N)
brand_trust_lat <- rnorm(N)

# Condition effect on perceived_value (a-path of mediation)
cond_effect_pv <- c(control = 0, scarcity_frame = 0.2,
                    sustainability_frame = 0.35, social_proof_frame = 0.5,
                    combined_frame = 0.7)[condition]

perc_value_lat <- 0.3 * sust_conc_lat + 0.2 * brand_trust_lat +
                  cond_effect_pv + rnorm(N, 0, 0.7)

# Purchase intention: indirect via PV + small direct + moderation by PS
cond_effect_pi <- c(control = 0, scarcity_frame = 0.05,
                    sustainability_frame = 0.10, social_proof_frame = 0.15,
                    combined_frame = 0.20)[condition]

purchase_lat <- 0.55 * perc_value_lat +
                cond_effect_pi -
                0.25 * price_sens_lat +
                # moderation: condition effect attenuated when PS is high
                -0.20 * price_sens_lat * cond_effect_pi +
                rnorm(N, 0, 0.6)

# ---- convert latents to 1-7 Likert items with noise ----------------------
to_likert <- function(latent, mean = 4, sd = 1.2) {
  raw <- mean + latent * sd + rnorm(length(latent), 0, 0.8)
  as.integer(pmin(pmax(round(raw), 1), 7))
}

# Items per scale (3 items each; small inter-item noise around shared latent)
make_items <- function(latent, k = 3, mean = 4, sd = 1.2) {
  vapply(seq_len(k), function(i) to_likert(latent, mean, sd),
         integer(length(latent)))
}

ps_items <- make_items(price_sens_lat)
sc_items <- make_items(sust_conc_lat)
bt_items <- make_items(brand_trust_lat)
pv_items <- make_items(perc_value_lat)
pi_items <- make_items(purchase_lat)

# Reverse-code bt_3 so participants have to undo it during cleaning.
bt_items[, 3] <- 8L - bt_items[, 3]

# Single-item scales
pq_single  <- to_likert(0.4 * perc_value_lat + 0.3 * brand_trust_lat)
psn_single <- to_likert(0.5 * cond_effect_pv + 0.2 * sust_conc_lat,
                        mean = 4, sd = 1.0)

# Behavioural outcomes
wtp_euros <- round(40 + 10 * purchase_lat + 5 * perc_value_lat +
                   rnorm(N, 0, 8), 2)
wtp_euros <- pmax(wtp_euros, 0)

choice    <- as.integer(plogis(purchase_lat - 0.5) > runif(N))
n_products <- pmin(pmax(round(2 + 0.8 * purchase_lat + rnorm(N, 0, 1)), 0L), 5L)

# ---- assemble (still tidy at this point) ---------------------------------
df <- data.frame(
  ParticipantID  = participant_id,
  Condition      = condition,
  Age            = age,
  Gender         = gender_latent,
  IncomeGroup    = income_latent,
  ProductCategory = product_category,
  ps_1 = ps_items[, 1], ps_2 = ps_items[, 2], ps_3 = ps_items[, 3],
  sc_1 = sc_items[, 1], sc_2 = sc_items[, 2], sc_3 = sc_items[, 3],
  bt_1 = bt_items[, 1], bt_2 = bt_items[, 2], bt_3_r = bt_items[, 3],
  pv_1 = pv_items[, 1], pv_2 = pv_items[, 2], pv_3 = pv_items[, 3],
  perceived_quality      = pq_single,
  perceived_social_norm  = psn_single,
  pi_1 = pi_items[, 1], pi_2 = pi_items[, 2], pi_3 = pi_items[, 3],
  willingness_to_pay = wtp_euros,
  choice             = choice,
  number_products_bought = n_products,
  stringsAsFactors = FALSE
)

# ---- inject realistic messiness ------------------------------------------
# 1. Inconsistent gender labels
gender_messy <- df$Gender
gender_messy[gender_messy == "woman"] <- sample(
  c("woman", "Woman", "W", "female", "Female"),
  sum(gender_messy == "woman"), replace = TRUE
)
gender_messy[gender_messy == "man"] <- sample(
  c("man", "Man", "M", "male", "Male"),
  sum(gender_messy == "man"), replace = TRUE
)
gender_messy[gender_messy == "non_binary"] <- sample(
  c("non-binary", "Non-binary", "NB"),
  sum(gender_messy == "non_binary"), replace = TRUE
)
gender_messy[gender_messy == "prefer_not"] <- "Prefer not to say"
df$Gender <- gender_messy

# 2. Trailing whitespace in one column
df$Condition <- paste0(df$Condition, sample(c("", " "), N, replace = TRUE, prob = c(0.85, 0.15)))

# 3. -99 missing codes in income + a couple of explicit NAs in age
i_missing_income <- sample(seq_len(N), 8)
df$IncomeGroup[i_missing_income] <- "-99"
i_missing_age <- sample(seq_len(N), 4)
df$Age[i_missing_age] <- NA

# 4. A handful of NAs scattered across Likert items
likert_cols <- c("ps_1", "ps_2", "ps_3", "sc_1", "sc_2", "sc_3",
                 "bt_1", "bt_2", "bt_3_r", "pv_1", "pv_2", "pv_3",
                 "pi_1", "pi_2", "pi_3")
for (col in likert_cols) {
  idx <- sample(seq_len(N), 3)
  df[[col]][idx] <- NA
}

# ---- write ---------------------------------------------------------------
out_path <- file.path("data", "mock", "consumer_data_raw.csv")
write.csv(df, out_path, row.names = FALSE, na = "")
message("Wrote ", nrow(df), " rows to ", out_path)
