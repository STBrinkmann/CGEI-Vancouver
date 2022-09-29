packages_needed <- c(
  "magrittr", "terra", "sf", "dplyr", "kableExtra", "knitr"
)

packages_needed %in% installed.packages()[,1]