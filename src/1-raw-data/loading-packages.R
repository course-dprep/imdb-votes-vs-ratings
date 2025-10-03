# List of required packages
print('start loading packages')
packages <- c(
  "readr",
  "tidyverse",
  "dplyr",
  "tidyr",
  "ggplot2",
  "here",
  "vroom",
  "broom",
  "ordinal"
)

# Install any missing packages
installed <- rownames(installed.packages())
for (pkg in packages) {
  if (!pkg %in% installed) {
    install.packages(pkg, dependencies = TRUE)
  }
}

# Load packages
lapply(packages, library, character.only = TRUE)

print('packages loaded')