# ============================================================================
# Script:   00_setup_install_packages.R
# Folder:   scripts/
# Purpose:  One-time setup script. Run this first if you are missing any
#           required package. Safe to re-run (skips already-installed
#           packages).
# ============================================================================

required_packages <- c(
  "metafor",     # meta-analysis (effect sizes, pooling, forest plots)
  "metadat",     # provides the BCG vaccine demo dataset used in this repo
  "survival",    # Kaplan-Meier, Cox proportional hazards
  "survminer",   # publication-style survival plots
  "ggplot2",     # plotting (used internally by survminer)
  "dplyr",       # data wrangling
  "gridExtra"    # combining multiple plots
)

new_packages <- required_packages[
  !(required_packages %in% installed.packages()[, "Package"])
]

if (length(new_packages) > 0) {
  cat("Installing missing packages:", paste(new_packages, collapse = ", "), "\n")
  install.packages(new_packages, repos = "https://cloud.r-project.org")
} else {
  cat("All required packages are already installed.\n")
}

# Quick verification
cat("\n--- Package check ---\n")
for (pkg in required_packages) {
  cat(sprintf("%-12s : %s\n", pkg,
              ifelse(requireNamespace(pkg, quietly = TRUE), "OK", "MISSING")))
}
