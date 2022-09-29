packages_needed <- c(
  "magrittr", "terra"
)

packages_needed %in% installed.packages()[,1]
library(terra)
library(magrittr)