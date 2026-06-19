# ============================================================================
# Script:   01_intro_to_r_for_heor.R
# Folder:   scripts/01_basics
# Author:   Kunal Bhadane | M.Pharm, NIPER Guwahati
# Project:  learning-r-for-meta-analysis
# ============================================================================
#
# WHAT THIS SCRIPT DOES
# ----------------------------------------------------------------------------
# This is the entry point of the repository. It loads a real clinical-trial
# dataset (the BCG vaccine trials, used later for the meta-analysis examples)
# and walks through the most basic R operations a HEOR analyst uses every day:
# importing data, inspecting it, computing simple summary statistics, and
# filtering/aggregating with dplyr.
#
# WHY THIS MATTERS IN HEOR / EVIDENCE SYNTHESIS
# ----------------------------------------------------------------------------
# Before any meta-analysis, economic model, or RWE study can be built, the
# analyst has to load, clean, and sanity-check the source data. HEOR teams at
# CROs (IQVIA, ICON, Parexel, Syneos) and HTA-focused firms (Certara) spend a
# large share of their time on exactly this step: confirming study counts,
# checking for missing data, and producing simple descriptive tables before
# any inferential model is fit. Getting this step wrong (e.g. mis-reading
# event counts) silently breaks every downstream result.
#
# WHAT A RECRUITER / HIRING MANAGER SEES
# ----------------------------------------------------------------------------
# - Comfort with base R + tidyverse (dplyr) syntax, the two dialects used
#   interchangeably across CROs.
# - An understanding that data QC precedes modelling -- a maturity signal
#   that separates "took a stats course" from "has done applied work."
# - Clean, reproducible, commented code -- exactly the standard expected in
#   an HEOR analysis report or a regulatory/HTA submission appendix.
# ============================================================================

# --- 1. Load required packages ----------------------------------------------
# dplyr: the standard tidyverse package for data manipulation (filter, mutate,
# summarise). Virtually every HEOR/RWE team in industry uses it.
library(dplyr)

# --- 2. Import the dataset ---------------------------------------------------
# This is the classic BCG (Bacillus Calmette-Guerin) tuberculosis vaccine
# dataset: 13 randomized controlled trials comparing TB incidence in
# vaccinated vs. unvaccinated groups. It is a real, widely-used teaching
# dataset in evidence synthesis (it ships with the R package `metadat`) and
# is the dataset we will run a full meta-analysis on in script 02.
bcg <- read.csv("data/raw/dat_bcg_tb_vaccine.csv")

# --- 3. Inspect the data -----------------------------------------------------
# Always look at your data before doing anything else. In a real project this
# is also where you would check for duplicate trial IDs, implausible counts,
# or unit mismatches between studies.
cat("Number of trials in the dataset:", nrow(bcg), "\n")
str(bcg)     # structure: column types
head(bcg)    # first six rows

# Column meanings (these reflect a standard 2x2 trial table used throughout
# evidence synthesis):
#   trial  - study ID
#   author - first author / study name
#   year   - publication year
#   tpos   - TB cases in the VACCINATED (treatment) group
#   tneg   - non-cases in the vaccinated group
#   cpos   - TB cases in the CONTROL (unvaccinated) group
#   cneg   - non-cases in the control group
#   ablat  - absolute latitude of the study site (a known effect modifier)
#   alloc  - method of treatment allocation (random / alternate / systematic)

# --- 4. Derive simple per-trial statistics -----------------------------------
# A HEOR analyst frequently needs to compute basic trial-level quantities,
# e.g. sample size and crude (unadjusted) event risk per arm, before fitting
# any pooled model. This also doubles as a manual sanity check against the
# more sophisticated effect sizes calculated by metafor in script 02.
bcg_summary <- bcg %>%
  mutate(
    n_treatment   = tpos + tneg,                  # total vaccinated
    n_control     = cpos + cneg,                  # total unvaccinated
    risk_treatment = round(tpos / n_treatment, 4), # crude TB risk, vaccinated
    risk_control    = round(cpos / n_control, 4)   # crude TB risk, unvaccinated
  ) %>%
  select(trial, author, year, n_treatment, n_control,
         risk_treatment, risk_control)

print(bcg_summary)

# --- 5. Basic descriptive statistics across all trials ----------------------
# Quick aggregate numbers are often what goes into the first slide of an
# internal HEOR project update, before the full pooled analysis is ready.
cat("\n--- Dataset-level summary ---\n")
cat("Total trials:                 ", nrow(bcg), "\n")
cat("Earliest publication year:    ", min(bcg$year), "\n")
cat("Latest publication year:      ", max(bcg$year), "\n")
cat("Total participants (approx.): ",
    sum(bcg$tpos + bcg$tneg + bcg$cpos + bcg$cneg), "\n")
cat("Mean crude risk, vaccinated:  ",
    round(mean(bcg_summary$risk_treatment), 4), "\n")
cat("Mean crude risk, unvaccinated:",
    round(mean(bcg_summary$risk_control), 4), "\n")

# --- 6. Save the cleaned summary table ---------------------------------------
# In a real workflow you would save intermediate, analysis-ready tables to
# data/processed/ so the next script doesn't repeat the cleaning step.
write.csv(bcg_summary, "data/processed/bcg_trial_summary.csv", row.names = FALSE)
cat("\nSaved: data/processed/bcg_trial_summary.csv\n")

# ============================================================================
# NEXT STEP -> scripts/02_meta_analysis/01_random_effects_meta_analysis.R
# We will use this same BCG dataset to run a full random-effects
# meta-analysis and quantify the pooled vaccine effect with a 95% CI.
# ============================================================================
