# Data Dictionary

Both datasets in this repository are **public, de-identified, and widely
used in statistics/evidence-synthesis teaching and methods research**. No
proprietary, scraped, or individually identifiable data is used.

---

## 1. `data/raw/dat_bcg_tb_vaccine.csv`

**Source:** Classic meta-analysis dataset of 13 randomized controlled trials
of the BCG (Bacillus Calmette-Guerin) vaccine against tuberculosis. This
dataset is distributed with the R package
[`metadat`](https://wviechtb.github.io/metadat/) as `dat.bcg`, and is one of
the most widely used teaching datasets in meta-analysis methodology
(originally compiled by Colditz et al. 1994, and used extensively in the
`metafor` package documentation and in Cochrane methods training material).

| Column | Type | Description |
|---|---|---|
| `trial` | integer | Study ID (1–13) |
| `author` | character | First author / study label |
| `year` | integer | Publication year |
| `tpos` | integer | Number of TB cases in the **vaccinated (treatment)** group |
| `tneg` | integer | Number of non-cases in the vaccinated group |
| `cpos` | integer | Number of TB cases in the **unvaccinated (control)** group |
| `cneg` | integer | Number of non-cases in the control group |
| `ablat` | integer | Absolute latitude of the study site (degrees) — a known effect modifier, used in the meta-regression example |
| `alloc` | character | Method of treatment allocation: `random`, `alternate`, or `systematic` |

**Used in:** `scripts/01_basics/`, `scripts/02_meta_analysis/`,
`scripts/03_forest_plots/`

---

## 2. `data/raw/lung_cancer_survival.csv`

**Source:** The NCCTG (North Central Cancer Treatment Group) lung cancer
dataset, originally from Loprinzi et al. (1994), distributed with base R's
[`survival`](https://cran.r-project.org/package=survival) package as
`survival::lung`. This is a standard teaching dataset for survival analysis
methodology and appears throughout the `survival` and `survminer` package
documentation.

| Column | Type | Description |
|---|---|---|
| `inst` | numeric | Institution code |
| `time` | numeric | Survival time, in days |
| `status` | numeric | Censoring status: `1` = censored, `2` = dead (original `survival` package coding; recoded to a standard 0/1 `event` column in the analysis scripts) |
| `age` | numeric | Age in years |
| `sex` | factor | `Male` / `Female` |
| `ph.ecog` | numeric | ECOG performance status (0 = fully active, … 4 = completely disabled), as rated by the physician |
| `ph.karno` | numeric | Karnofsky performance score (0–100), physician-rated |
| `pat.karno` | numeric | Karnofsky performance score (0–100), patient-rated |
| `meal.cal` | numeric | Calories consumed at meals |
| `wt.loss` | numeric | Weight loss in the past 6 months (lbs) |

**Used in:** `scripts/04_survival_analysis/`, `scripts/05_hazard_ratios/`

---

## A note on dataset choice

Both datasets were chosen deliberately because they are:

1. **Public and freely redistributable** — both ship directly inside
   widely-used, open-source R packages, so there is no licensing ambiguity.
2. **Methodologically "canonical"** — both are the exact datasets used in
   the foundational papers and package documentation for the methods
   demonstrated, meaning the numeric results in this repository can be
   cross-checked against a large body of published reference output.
3. **Small enough to fully understand row-by-row** — important for a
   *learning* repository, where the goal is to demonstrate understanding of
   every number produced, not just to run a model on a black-box dataset.
