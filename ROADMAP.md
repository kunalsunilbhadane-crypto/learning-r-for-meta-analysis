# Glossary: HEOR & Evidence Synthesis Terms Used in This Repository

A quick-reference glossary of terms used throughout this repository's
scripts and comments — written in plain language, with a pointer to where
each concept is demonstrated in code.

| Term | Plain-language meaning | Demonstrated in |
|---|---|---|
| **Effect size** | A single number summarising the difference (or association) between two groups in one study, e.g. a risk ratio or a mean difference | `scripts/02_meta_analysis/` |
| **Risk ratio (RR)** | Ratio of event risk in one group vs. another (RR = 1 means no difference) | `scripts/02_meta_analysis/` |
| **Log scale (for ratios)** | Ratios are analysed on the log scale because logs make their sampling distribution approximately normal — a standard statistical convenience, always converted back for reporting | `scripts/02_meta_analysis/` |
| **Fixed-effect model** | Assumes every study estimates one single true effect; differences between studies are due only to chance | `docs/ROADMAP.md` (Month 2) |
| **Random-effects model** | Assumes the true effect varies between studies (different populations, settings); more realistic for most real-world evidence synthesis | `scripts/02_meta_analysis/` |
| **Heterogeneity** | How much studies disagree with each other, beyond what chance alone would explain | `scripts/02_meta_analysis/` |
| **I² statistic** | Percentage of total variability across studies due to real heterogeneity rather than chance (0% = none, >75% = substantial) | `scripts/02_meta_analysis/` |
| **tau² (tau-squared)** | The estimated variance of true effects across studies, in a random-effects model | `scripts/02_meta_analysis/` |
| **Q-test (Cochran's Q)** | A formal hypothesis test for the presence of heterogeneity | `scripts/02_meta_analysis/` |
| **Meta-regression** | Extending a meta-analysis to test whether a study-level variable (e.g. region, dose, year) explains some of the heterogeneity | `scripts/02_meta_analysis/` |
| **Forest plot** | The standard chart showing each study's effect estimate and CI as a line, plus a pooled "diamond" summary at the bottom | `scripts/03_forest_plots/` |
| **Funnel plot** | A scatter plot used to visually assess publication bias (asymmetry suggests missing studies) | `docs/ROADMAP.md` (Month 2) |
| **Kaplan-Meier (KM) estimator** | A non-parametric method for estimating the probability of "surviving" (not having the event) past each time point, accounting for censoring | `scripts/04_survival_analysis/` |
| **Censoring** | When a patient's true event time is unknown because follow-up ended before the event occurred (e.g. study ended, lost to follow-up) | `scripts/04_survival_analysis/` |
| **Median survival time** | The time point at which 50% of the cohort has experienced the event; the standard summary statistic for time-to-event data (not the mean) | `scripts/04_survival_analysis/` |
| **Log-rank test** | The standard hypothesis test for comparing two or more Kaplan-Meier survival curves | `scripts/04_survival_analysis/` |
| **Cox proportional hazards model** | A regression model for time-to-event data that estimates how covariates affect the hazard (instantaneous risk) of the event, while adjusting for confounders | `scripts/05_hazard_ratios/` |
| **Hazard ratio (HR)** | The ratio of hazards between two groups from a Cox model; HR < 1 means lower risk, HR > 1 means higher risk, in the comparison group | `scripts/05_hazard_ratios/` |
| **Proportional hazards (PH) assumption** | The Cox model's core assumption that the hazard ratio between groups stays constant over the whole follow-up period | `scripts/05_hazard_ratios/` |
| **Schoenfeld residuals** | The standard diagnostic test (`cox.zph()`) used to check whether the PH assumption holds | `scripts/05_hazard_ratios/` |
| **Overall survival (OS)** | Time from a defined starting point (e.g. randomisation/diagnosis) to death from any cause — the most common primary endpoint in oncology HTA | `scripts/04_survival_analysis/`, `scripts/05_hazard_ratios/` |
| **Progression-free survival (PFS)** | Time from start to disease progression or death, whichever comes first | `docs/ROADMAP.md` (Month 4) |
| **Real-world evidence (RWE)** | Evidence on treatment effects generated from data collected outside a randomised trial (e.g. claims, EHRs, registries) | `docs/ROADMAP.md` (Month 5) |
| **Health Technology Assessment (HTA)** | The formal process used by bodies like NICE, ICER, CADTH, and PBAC to evaluate the clinical and economic value of a health technology, usually for reimbursement decisions | README, `docs/ROADMAP.md` |
| **Network meta-analysis (NMA)** | A meta-analysis method for comparing 3+ treatments simultaneously, including treatments never compared head-to-head in any single trial, using a shared comparator network | `docs/ROADMAP.md` (Month 3) |
