Investigating associations between multiple greenspace exposures and
symptoms of depression
================
[Sebastian T. Brinkmann](https://orcid.org/0000-0001-9835-7347)
2022-10-13

This is the github repository for my bachelor thesis “Investigating
associations between multiple greenspace exposures and symptoms of
depression. Results from the Prospective Urban and Rural Epidemiology
(PURE) Study”. Here I provide reproducible workflows for the analyses.
Data supporting this publication is accessible via the following DOI
XXX.

## Installation

All code is written in R (v. 4.2) and packages used in this analysis can
be installed from the
[00_setup.R](https://github.com/STBrinkmann/Bachelorthesis/blob/main/workflow/00_setup.R)
file.

## Workflows

#### [1. Elevation Data](https://github.com/STBrinkmann/Bachelorthesis/tree/main/workflow/01_elevation_data)

The elevation data required downloading and pre-processing. In this
workflow I have provided R scripts that describe the complete process.
Processed input has also been uploaded on Zenodo for easy access.

#### [2. Remote Sensing Data](https://github.com/STBrinkmann/Bachelorthesis/tree/main/workflow/02_remote_sensing)

This study used three different greenspace metrics that are used in the
existing literature, (i) Normalised Difference Index (NDVI), (ii) Leaf
Area Index (LAI), and (iii) Land Use Cover (LULC). Processed data has
also been uploaded on Zenodo for easy access.

#### [3. Greenspace Availability Exposure Index (GAVI)](https://github.com/STBrinkmann/Bachelorthesis/tree/main/workflow/03_GAVI)

The Greenspace Availability Exposure Index (GAVI) measures the
availability of greenspace. The final GAVI has been uploaded in this
GitHub repository
([GAVI.tif](https://github.com/STBrinkmann/Bachelorthesis/blob/main/data/03_ExposureIndices/GAVI/GAVI.tif)).

#### [4. Greenspace Visibility Exposure Index (VGVI)](https://github.com/STBrinkmann/Bachelorthesis/tree/main/workflow/04_VGVI)

The Greenspace Visibility Exposure Index (VGVI) measures the visibility
of greenspace. The final VGVI has been uploaded in this GitHub
repository
([VGVI.tif](https://github.com/STBrinkmann/Bachelorthesis/blob/main/data/03_ExposureIndices/VGVI/VGVI.tif)).

#### [5. Greenspace Accessibility Exposure Index (GACI)](https://github.com/STBrinkmann/Bachelorthesis/tree/main/workflow/05_GACI)

The Greenspace Accessibility Exposure Index (GACI) measures the acces of
public greenspace such as parks. The final GACIhas been uploaded in this
GitHub repository
([GACI.tif](https://github.com/STBrinkmann/Bachelorthesis/blob/main/data/03_ExposureIndices/GACI/GACI.tif)).

#### [6. Statistical Modelling](https://github.com/STBrinkmann/Bachelorthesis/tree/main/workflow/06_modelling)

Due to reassons of confidentiality the original data from the PURE study
can not be made publicly available. In order to follow the statistical
modelling, I have generated synthetical data. This workflow covers (i)
data pre-processing, (ii) statistical modelling with GLMs, and (iii)
metric specific weight calculation using BART.
