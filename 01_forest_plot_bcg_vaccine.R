# ============================================================================
# Script:   01_cox_proportional_hazards.R
# Folder:   scripts/05_hazard_ratios
# Author:   Kunal Bhadane | M.Pharm, NIPER Guwahati
# Project:  learning-r-for-meta-analysis
# ============================================================================
#
# WHAT THIS SCRIPT DOES
# ----------------------------------------------------------------------------
# Fits a Cox proportional hazards model on the same lung cancer dataset used
# in script 04, to calculate ADJUSTED hazard ratios (HRs) for sex, age, and
# ECOG performance status, and checks the proportional-hazards assumption
# that the Cox model depends on.
#
# WHY THIS MATTERS IN HEOR / EVIDENCE SYNTHESIS / RWE
# ----------------------------------------------------------------------------
# The hazard ratio is the single most frequently reported effect measure in
# oncology and chronic-disease HEOR work. Unlike a KM/log-rank comparison
# (script 04), a Cox model lets you:
#   1. Adjust for confounders (age, performance status, comorbidities) --
#      essential in RWE studies, where treatment groups are not randomised.
#   2. Quantify the SIZE of the effect (e.g. "HR = 1.6"), not just whether a
#      difference is statistically significant.
# This exact workflow (univariate KM -> adjusted Cox model -> assumption
# check) is the standard structure of the survival-analysis section in an
# RWE manuscript or an oncology HTA clinical-effectiveness submission.
#
# WHAT A RECRUITER / HIRING MANAGER SEES
# ----------------------------------------------------------------------------
# - Ability to move beyond univariate description to a multivariable,
#   confounder-adjusted model -- the level of analysis CROs are actually
#   hired by pharma/payers to deliver.
# - Awareness that Cox models carry a testable assumption (proportional
#   hazards) and that this should always be checked, not assumed --  a
#   frequently-probed interview question for HEOR/biostatistics-adjacent
#   roles.
# - Correct interpretation of HR > 1 vs. HR < 1 in plain clinical language,
#   which is what ultimately goes into a non-technical HTA summary or
#   payer-facing slide.
# ============================================================================

library(survival)
library(survminer)

# --- 1. Load the data ---------------------------------------------------------
lung <- read.csv("data/raw/lung_cancer_survival.csv")
lung$event <- ifelse(lung$status == 2, 1, 0)   # 1 = death, 0 = censored
lung$sex   <- factor(lung$sex, levels = c("Male", "Female"))

# Drop rows with missing covariates -- Cox regression (like most regression
# methods) requires complete cases on all model variables. In a real project
# you would investigate WHY data are missing before simply dropping rows;
# here we do a simple complete-case analysis for clarity.
lung_cc <- lung[complete.cases(lung[, c("time", "event", "sex", "age", "ph.ecog")]), ]
cat("Patients in complete-case analysis:", nrow(lung_cc), "of", nrow(lung), "\n")

# --- 2. Fit the (adjusted) Cox proportional hazards model ---------------------
# Model: hazard of death as a function of sex, age, and ECOG performance
# status (ph.ecog: 0 = fully active, higher = more disabled) -- a standard
# adjustment set for a lung cancer survival analysis.
cox_model <- coxph(Surv(time, event) ~ sex + age + ph.ecog, data = lung_cc)
print(summary(cox_model))

# --- 3. Extract and interpret hazard ratios -----------------------------------
# exp(coef) converts the model's log-hazard coefficients into hazard ratios
# (HR). This is the number that actually gets reported and discussed.
hr_table <- data.frame(
  variable = names(coef(cox_model)),
  HR       = round(exp(coef(cox_model)), 3),
  CI_lower = round(exp(confint(cox_model))[, 1], 3),
  CI_upper = round(exp(confint(cox_model))[, 2], 3),
  p_value  = round(summary(cox_model)$coefficients[, "Pr(>|z|)"], 4)
)
cat("\n--- Hazard Ratio Table ---\n")
print(hr_table)

cat("\n--- Plain-language interpretation ---\n")
cat(sprintf(
  "Female sex: HR = %.2f (95%% CI %.2f-%.2f) -> being female is associated\n  with a %.0f%% LOWER hazard of death versus male, adjusting for age and ECOG.\n",
  hr_table$HR[1], hr_table$CI_lower[1], hr_table$CI_upper[1],
  (1 - hr_table$HR[1]) * 100
))
cat(sprintf(
  "ECOG performance status: HR = %.2f per 1-point increase -> each 1-point\n  worsening in ECOG score is associated with a %.0f%% HIGHER hazard of death.\n",
  hr_table$HR[3], (hr_table$HR[3] - 1) * 100
))

# --- 4. Check the proportional hazards assumption -----------------------------
# The Cox model assumes the hazard ratio between groups is CONSTANT over
# time (proportional hazards). The Schoenfeld residuals test (cox.zph) is
# the standard diagnostic check -- a low p-value (<0.05) for any covariate
# means the PH assumption is violated for that variable, and a more flexible
# model (e.g. time-varying coefficients, stratified Cox model) should be
# considered. Reviewers at HTA bodies specifically look for this check.
ph_test <- cox.zph(cox_model)
cat("\n--- Proportional Hazards Assumption Check (Schoenfeld residuals) ---\n")
print(ph_test)

if (any(ph_test$table[, "p"] < 0.05, na.rm = TRUE)) {
  cat("-> At least one covariate shows evidence against the PH assumption.\n")
  cat("   In a real analysis, consider a stratified Cox model or adding a\n")
  cat("   time-by-covariate interaction term.\n")
} else {
  cat("-> No strong evidence against the proportional hazards assumption.\n")
  cat("   The Cox model is an appropriate choice for this dataset.\n")
}

# Save the Schoenfeld residual plots -- a standard diagnostic figure
# included in the supplementary material of survival-analysis manuscripts.
png("images/schoenfeld_residuals_diagnostic.png", width = 1000, height = 800, res = 120)
plot(ph_test)
dev.off()
cat("\nSaved: images/schoenfeld_residuals_diagnostic.png\n")

# --- 5. Forest plot of the hazard ratios --------------------------------------
# ggforest() produces the standard "HR forest plot" seen in nearly every
# published Cox regression table -- this is the figure a clinician or HTA
# reviewer will look at first, before reading the numeric table.
hr_forest <- ggforest(cox_model, data = lung_cc,
                       main = "Adjusted Hazard Ratios: Overall Survival (Lung Cancer Cohort)")
png("images/hazard_ratio_forest_plot.png", width = 1000, height = 600, res = 120)
print(hr_forest)
dev.off()
cat("Saved: images/hazard_ratio_forest_plot.png\n")

# --- 6. Save the model object --------------------------------------------------
saveRDS(cox_model, "data/processed/cox_model_lung_cancer.rds")
write.csv(hr_table, "data/processed/hazard_ratio_table.csv", row.names = FALSE)

# ============================================================================
# REPOSITORY COMPLETE (v1) -- see README.md for the full workflow summary and
# docs/ROADMAP.md for how this repository will expand over the next 6 months
# (NMA, parametric survival extrapolation, cost-effectiveness modelling).
# ============================================================================
