packages_needed <- c(
  "magrittr", "terra", "sf", "dplyr", "kableExtra", "knitr", "ggplot2",
  "classInt", "spatLac", "sfheaders", "GVI", "osmdata", "osrm", "pbmcapply",
  "DRIGLUCoSE", "bartMachine", "tidymodels", "mapview", "psych", "tidyverse",
  "ggpubr", "foreach", "Rcpp", "RcppProgress", "doParallel"
)

for(i in which(!packages_needed %in% installed.packages()[,1])){
  this_package <- packages_needed[i]
  
  if(!this_package %in% installed.packages()[,1]){
    if(this_package == "DRIGLUCoSE"){
      remotes::install_git("https://github.com/STBrinkmann/DRIGLUCoSE")
    } else if(this_package == "spatLac"){
      devtools::install_github("STBrinkmann/spatLac")
    } else if(this_package == "GVI"){
       remotes::install_git("https://github.com/STBrinkmann/GVI")
    } else {
      install.packages(this_package)
    }
  }  
}
