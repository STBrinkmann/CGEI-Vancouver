packages_needed <- c(
  "magrittr", "terra", "sf", "dplyr", "kableExtra", "knitr", "ggplot2",
  "classInt", "spatLac"
)

packages_needed %in% installed.packages()[,1]