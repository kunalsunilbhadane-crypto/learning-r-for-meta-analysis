# Learning R for Meta-Analysis: A HEOR & Evidence Synthesis Portfolio

[![R](https://img.shields.io/badge/R-4.3%2B-276DC3?logo=r)](https://www.r-project.org/)
[![metafor](https://img.shields.io/badge/metafor-meta--analysis-0a7029)](https://www.metafor-project.org/)
[![survival](https://img.shields.io/badge/survival-time--to--event-c0392b)](https://cran.r-project.org/package=survival)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**A structured, evidence-synthesis-first R learning portfolio**, built by an M.Pharm
student at NIPER Guwahati working toward a career in **Health Economics &
Outcomes Research (HEOR)**, **Health Technology Assessment (HTA)**, **Evidence
Synthesis**, and **Real-World Evidence (RWE)**.

This is not a generic "data science learning" repository. Every script here is
built around methods and outputs that show up directly in HEOR job
descriptions at CROs and consultancies such as IQVIA, ICON, Parexel, Syneos
Health, and Certara: meta-analysis, forest plots, survival analysis, and
hazard ratio estimation — using real, publicly available clinical datasets.

---

## Why this repository exists

Most student R portfolios show generic data-science exercises (Titanic
survival prediction, iris classification). Recruiters for HEOR/HTA/Evidence
Synthesis roles are not looking for that — they are looking for evidence that
a candidate already understands **how clinical and economic evidence is
analysed and reported** in real submissions. This repository is built
specifically to demonstrate that, using:

- The **same R packages** used in real systematic reviews and HTA submissions
  (`metafor`, `survival`, `survminer`)
- The **same statistical vocabulary** used in HEOR job postings (I², tau²,
  random-effects model, hazard ratio, Kaplan-Meier, log-rank test, Cox
  proportional hazards)
- **Heavily commented code**, written so each script doubles as a study note
  explaining *what* the code does, *why* it matters in HEOR, and *how* a
  recruiter would read the skill being demonstrated

## Who this is for

- Recruiters / hiring managers screening for HEOR, HTA, Evidence Synthesis,
  RWE, or Biostatistics-adjacent roles
- Fellow pharmacy / life-sciences students starting their own R learning
  journey toward HEOR
- Me — this repository is also my own structured study log, built to evolve
  for at least six months (see [`docs/ROADMAP.md`](docs/ROADMAP.md))

---

## Repository structure

```
learning-r-for-meta-analysis/
├── README.md                      <- you are here
├── LICENSE
├── data/
│   ├── raw/                       <- original, untouched public datasets
│   │   ├── dat_bcg_tb_vaccine.csv         (13-trial BCG vaccine meta-analysis dataset)
│   │   └── lung_cancer_survival.csv       (NCCTG lung cancer survival dataset)
│   └── processed/                 <- cleaned tables & saved model objects
├── scripts/
│   ├── 01_basics/                 <- R fundamentals, applied to HEOR data
│   ├── 02_meta_analysis/          <- random-effects meta-analysis (metafor)
│   ├── 03_forest_plots/           <- publication-style forest plots
│   ├── 04_survival_analysis/      <- Kaplan-Meier survival curves
│   └── 05_hazard_ratios/          <- Cox proportional hazards models
├── images/                        <- all generated plots (PNG)
└── docs/
    ├── ROADMAP.md                 <- 6-month commit / learning plan
    ├── GLOSSARY.md                <- HEOR/evidence-synthesis term glossary
    └── DATA_DICTIONARY.md         <- variable-level documentation for both datasets
```

---

## Datasets used (both public, de-identified, citation-appropriate)

| Dataset | Source | Used for |
|---|---|---|
| **BCG vaccine trials** (13 RCTs) | Classic meta-analysis teaching dataset, distributed with the R package [`metadat`](https://wviechtb.github.io/metadat/) (`dat.bcg`) | Random-effects meta-analysis, forest plot, meta-regression |
| **NCCTG lung cancer cohort** (228 patients) | Built into R's base [`survival`](https://cran.r-project.org/package=survival) package (`survival::lung`) | Kaplan-Meier survival analysis, Cox proportional hazards, hazard ratios |

No proprietary, scraped, or patient-identifiable data is used anywhere in
this repository. Full variable definitions are in
[`docs/DATA_DICTIONARY.md`](docs/DATA_DICTIONARY.md).

---

## Workflow walkthrough

### 1 — R basics for HEOR (`scripts/01_basics/`)
Loads and QCs the BCG trial dataset, computes crude per-trial risks, and
produces a clean summary table. Establishes the data-QC habits expected
before any pooled analysis.

### 2 — Random-effects meta-analysis (`scripts/02_meta_analysis/`)
Calculates a log risk ratio and variance for each of the 13 BCG trials,
pools them with a DerSimonian-Laird random-effects model, reports I² / tau² /
Q-test heterogeneity statistics, and runs an exploratory meta-regression on
study latitude.

**Headline result:** Pooled Risk Ratio = **0.49** (95% CI: 0.35–0.70) — BCG
vaccination associated with a 51% reduction in TB risk across 13 trials,
with substantial heterogeneity (I² = 92.1%) partly explained by study
latitude.

### 3 — Forest plot (`scripts/03_forest_plots/`)
Generates a submission-style forest plot from the model above using
`metafor::forest()`.

![Forest plot of BCG vaccine trials](images/forest_plot_bcg_vaccine.png)

### 4 — Kaplan-Meier survival analysis (`scripts/04_survival_analysis/`)
Fits and plots Kaplan-Meier overall survival curves by sex on the lung
cancer cohort, with a risk table and log-rank test.

![Kaplan-Meier survival curves by sex](images/kaplan_meier_lung_cancer_by_sex.png)

**Headline result:** Median OS = 426 days (female) vs. 270 days (male);
log-rank p = 0.0013.

### 5 — Cox proportional hazards & hazard ratios (`scripts/05_hazard_ratios/`)
Fits a multivariable Cox model (sex + age + ECOG performance status),
checks the proportional-hazards assumption with Schoenfeld residuals, and
produces an adjusted hazard-ratio forest plot.

![Hazard ratio forest plot](images/hazard_ratio_forest_plot.png)

**Headline result:** Adjusted HR (female vs. male) = **0.57** (95% CI:
0.41–0.80, p < 0.001) — female sex associated with a 43% lower hazard of
death, adjusting for age and ECOG status.

---

## How to run this yourself

```bash
git clone https://github.com/<your-username>/learning-r-for-meta-analysis.git
cd learning-r-for-meta-analysis
```

Install the required packages (Debian/Ubuntu users can use the faster apt
route; everyone else can use `install.packages()`):

```r
# Option A: from CRAN (any OS)
install.packages(c("metafor", "metadat", "survival", "survminer",
                    "ggplot2", "dplyr", "gridExtra"))
```

```bash
# Option B: Debian/Ubuntu, via apt (faster, pre-compiled binaries)
sudo apt-get install -y r-cran-metafor r-cran-metadat r-cran-survminer \
                         r-cran-ggplot2 r-cran-gridextra r-cran-dplyr
```

Then run each script in order from the repository root:

```bash
Rscript scripts/01_basics/01_intro_to_r_for_heor.R
Rscript scripts/02_meta_analysis/01_random_effects_meta_analysis.R
Rscript scripts/03_forest_plots/01_forest_plot_bcg_vaccine.R
Rscript scripts/04_survival_analysis/01_kaplan_meier_lung_cancer.R
Rscript scripts/05_hazard_ratios/01_cox_proportional_hazards.R
```

All scripts are self-contained, run end-to-end without errors, and write
their outputs to `data/processed/` and `images/`.

---

## Skills demonstrated (recruiter-facing summary)

| Skill | Where | Why HEOR teams care |
|---|---|---|
| Data QC & wrangling (base R + dplyr) | Script 01 | Every analysis starts here; errors here break everything downstream |
| Random-effects meta-analysis (`metafor`) | Script 02 | Core SLR/HTA methodology |
| Heterogeneity assessment (I², tau², Q-test) | Script 02 | Required reporting element in every HTA submission |
| Meta-regression | Script 02 | Explains heterogeneity using study-level covariates |
| Forest plot construction | Script 03 | The standard visual of evidence synthesis |
| Kaplan-Meier estimation & log-rank testing | Script 04 | Standard for OS/PFS endpoints in oncology HTA & RWE |
| Censored-data handling | Script 04 | A common error point for junior analysts — explicitly addressed |
| Cox proportional hazards modelling | Script 05 | Confounder-adjusted effect estimation, the RWE workhorse |
| Hazard ratio interpretation & reporting | Script 05 | The most-cited effect measure in oncology HEOR literature |
| PH assumption diagnostics (Schoenfeld residuals) | Script 05 | Shows methodological rigor beyond "running a model" |

---

## Roadmap

This repository is designed to evolve over time, not be a one-off upload. See
[`docs/ROADMAP.md`](docs/ROADMAP.md) for the full 6-month commit plan,
covering network meta-analysis, parametric survival extrapolation,
cost-effectiveness modelling, and a Shiny-based interactive HTA dashboard.

## Related repositories

This repository is part of a broader portfolio. See the suggested companion
repositories in [`docs/ROADMAP.md`](docs/ROADMAP.md#suggested-companion-repositories).

## License

This project is licensed under the MIT License — see [`LICENSE`](LICENSE).
All datasets used are public and redistributable; see
[`docs/DATA_DICTIONARY.md`](docs/DATA_DICTIONARY.md) for sourcing details.

## Author

**Kunal Bhadane** — M.Pharm student, NIPER Guwahati.
Interested in HEOR, HTA, Pharmacoeconomics, Evidence Synthesis, RWE, and
Meta-analysis. Connect on [LinkedIn](#) | [GitHub](#).
