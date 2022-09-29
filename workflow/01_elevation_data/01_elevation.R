library(terra)
library(magrittr)

# 1. Download Data --------------------------------------------------------

# List of URLs for DEM and DTM data rom Canada’s Open Government Portal at 1m resolution
ville_vancouver_dtm_url <- c(
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_VANCOUVER/VILLE_VANCOUVER/utm10/dtm_1m_utm10_w_0_144.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_VANCOUVER/VILLE_VANCOUVER/utm10/dtm_1m_utm10_w_0_145.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_VANCOUVER/VILLE_VANCOUVER/utm10/dtm_1m_utm10_w_0_146.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_VANCOUVER/VILLE_VANCOUVER/utm10/dtm_1m_utm10_w_1_144.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_VANCOUVER/VILLE_VANCOUVER/utm10/dtm_1m_utm10_w_1_145.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_VANCOUVER/VILLE_VANCOUVER/utm10/dtm_1m_utm10_w_1_146.tif"
)

ville_vancouver_dsm_url <- c(
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_VANCOUVER/VILLE_VANCOUVER/utm10/dsm_1m_utm10_w_0_144.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_VANCOUVER/VILLE_VANCOUVER/utm10/dsm_1m_utm10_w_0_145.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_VANCOUVER/VILLE_VANCOUVER/utm10/dsm_1m_utm10_w_0_146.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_VANCOUVER/VILLE_VANCOUVER/utm10/dsm_1m_utm10_w_1_144.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_VANCOUVER/VILLE_VANCOUVER/utm10/dsm_1m_utm10_w_1_145.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_VANCOUVER/VILLE_VANCOUVER/utm10/dsm_1m_utm10_w_1_146.tif"
)

ville_burnaby_dtm_url <- c(
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_BURNABY/VILLE_BURNABY/utm10/dtm_1m_utm10_e_0_144.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_BURNABY/VILLE_BURNABY/utm10/dtm_1m_utm10_e_0_145.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_BURNABY/VILLE_BURNABY/utm10/dtm_1m_utm10_e_0_146.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_BURNABY/VILLE_BURNABY/utm10/dtm_1m_utm10_w_0_144.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_BURNABY/VILLE_BURNABY/utm10/dtm_1m_utm10_w_0_145.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_BURNABY/VILLE_BURNABY/utm10/dtm_1m_utm10_w_0_146.tif"
)

ville_burnaby_dsm_url <- c(
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_BURNABY/VILLE_BURNABY/utm10/dsm_1m_utm10_e_0_144.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_BURNABY/VILLE_BURNABY/utm10/dsm_1m_utm10_e_0_145.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_BURNABY/VILLE_BURNABY/utm10/dsm_1m_utm10_e_0_146.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_BURNABY/VILLE_BURNABY/utm10/dsm_1m_utm10_w_0_144.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_BURNABY/VILLE_BURNABY/utm10/dsm_1m_utm10_w_0_145.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_BURNABY/VILLE_BURNABY/utm10/dsm_1m_utm10_w_0_146.tif"
)

ville_surrey_dtm_url <- c(
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_SURREY/VILLE_SURREY/utm10/dtm_1m_utm10_e_0_143.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_SURREY/VILLE_SURREY/utm10/dtm_1m_utm10_e_0_144.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_SURREY/VILLE_SURREY/utm10/dtm_1m_utm10_e_0_145.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_SURREY/VILLE_SURREY/utm10/dtm_1m_utm10_e_1_142.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_SURREY/VILLE_SURREY/utm10/dtm_1m_utm10_e_1_143.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_SURREY/VILLE_SURREY/utm10/dtm_1m_utm10_e_1_144.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_SURREY/VILLE_SURREY/utm10/dtm_1m_utm10_e_1_145.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_SURREY/VILLE_SURREY/utm10/dtm_1m_utm10_e_2_142.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_SURREY/VILLE_SURREY/utm10/dtm_1m_utm10_e_2_143.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dtm_mnt/1m/VILLE_SURREY/VILLE_SURREY/utm10/dtm_1m_utm10_e_2_144.tif"
)

ville_surrey_dsm_url <- c(
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_SURREY/VILLE_SURREY/utm10/dsm_1m_utm10_e_0_143.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_SURREY/VILLE_SURREY/utm10/dsm_1m_utm10_e_0_144.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_SURREY/VILLE_SURREY/utm10/dsm_1m_utm10_e_0_145.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_SURREY/VILLE_SURREY/utm10/dsm_1m_utm10_e_1_142.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_SURREY/VILLE_SURREY/utm10/dsm_1m_utm10_e_1_143.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_SURREY/VILLE_SURREY/utm10/dsm_1m_utm10_e_1_144.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_SURREY/VILLE_SURREY/utm10/dsm_1m_utm10_e_1_145.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_SURREY/VILLE_SURREY/utm10/dsm_1m_utm10_e_2_142.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_SURREY/VILLE_SURREY/utm10/dsm_1m_utm10_e_2_143.tif",
  "https://ftp.maps.canada.ca/pub/elevation/dem_mne/highresolution_hauteresolution/dsm_mns/1m/VILLE_SURREY/VILLE_SURREY/utm10/dsm_1m_utm10_e_2_144.tif"
)

# Vector of all URLs and Filenames
urls <- c(
  ville_vancouver_dtm_url, ville_vancouver_dsm_url,
  ville_burnaby_dtm_url, ville_burnaby_dsm_url,
  ville_surrey_dtm_url, ville_surrey_dsm_url
)

file_names <- file.path("data", "01_Elevation", "01_raw", paste0(c(
  paste("ville_vancouver_dtm", 1:6, sep = "_"), paste("ville_vancouver_dsm", 1:6, sep = "_"),
  paste("ville_burnaby_dtm", 1:6, sep = "_"), paste("ville_burnaby_dsm", 1:6, sep = "_"),
  paste("ville_surrey_dtm", 1:10, sep = "_"), paste("ville_surrey_dsm", 1:10, sep = "_")), ".tif", sep = ""))

# Download data
Map(function(u, d) download.file(u, d, mode="wb"), urls, file_names)


# 2. Raster Manipulation --------------------------------------------------

# DTM
ville_vancouver_dtm <- list.files(file.path("data", "01_Elevation", "01_raw"), pattern = "ville_vancouver_dtm", full.names = TRUE) %>% 
  lapply(terra::rast) %>% 
  do.call(terra::merge, .)

ville_burnaby_dtm <- list.files(file.path("data", "01_Elevation", "01_raw"), pattern = "ville_burnaby_dtm", full.names = TRUE) %>% 
  lapply(terra::rast) %>% 
  do.call(terra::merge, .)

ville_surrey_dtm <- list.files(file.path("data", "01_Elevation", "01_raw"), pattern = "ville_surrey_dtm", full.names = TRUE) %>% 
  lapply(terra::rast) %>% 
  do.call(terra::merge, .)

dtm_list <- list(ville_vancouver_dtm, ville_burnaby_dtm, ville_surrey_dtm) 
dtm_list$filename <- file.path("data", "01_Elevation", "02_processed", "DTM.tif")
dtm_list$overwrite <- TRUE

dtm <- do.call(terra::merge, dtm_list)
names(dtm) <- "DTM"
rm(dtm_list, ville_vancouver_dtm, ville_burnaby_dtm, ville_surrey_dtm); invisible(gc())

# DSM
ville_vancouver_dsm <- list.files(file.path("data", "01_Elevation", "01_raw"), pattern = "ville_vancouver_dsm", full.names = TRUE) %>% 
  lapply(terra::rast) %>% 
  do.call(terra::merge, .) %>% 
  terra::focal(9, fun = median, na.rm = TRUE)

ville_burnaby_dsm <- list.files(file.path("data", "01_Elevation", "01_raw"), pattern = "ville_burnaby_dsm", full.names = TRUE) %>% 
  lapply(terra::rast) %>% 
  do.call(terra::merge, .) %>% 
  terra::focal(9, fun = median, na.rm = TRUE)

ville_surrey_dsm <- list.files(file.path("data", "01_Elevation", "01_raw"), pattern = "ville_surrey_dsm", full.names = TRUE)[1:5] %>% 
  lapply(terra::rast) %>% 
  do.call(terra::merge, .) %>% 
  terra::focal(9, fun = median, na.rm = TRUE)

ville_surrey_dsm2 <- list.files(file.path("data", "01_Elevation", "01_raw"), pattern = "ville_surrey_dsm", full.names = TRUE)[6:10] %>% 
  lapply(terra::rast) %>% 
  do.call(terra::merge, .) %>% 
  terra::focal(9, fun = median, na.rm = TRUE)

dsm_list <- list(ville_vancouver_dsm, ville_burnaby_dsm, ville_surrey_dsm, ville_surrey_dsm2) 
dsm_list$filename <- file.path("data", "01_Elevation", "02_processed", "DSM.tif")
dsm_list$overwrite <- TRUE

dsm <- do.call(terra::merge, dsm_list)
names(dsm) <- "DSM"
rm(dsm_list, ville_vancouver_dsm, ville_burnaby_dsm, ville_surrey_dsm, ville_surrey_dsm2); invisible(gc())


# 3. Reproject and mask to AOI --------------------------------------------

aoi_mask <- terra::vect(file.path("data", "AOI.gpkg"))

dtm %>% 
  terra::project(terra::crs(aoi_mask)) %>% 
  crop(aoi_mask) %>% 
  mask(aoi_mask) %>% 
  terra::writeRaster(file.path("data", "01_Elevation", "02_processed/DTM.tif"), overwrite = TRUE)

dsm %>% 
  terra::project(terra::crs(aoi_mask)) %>% 
  crop(aoi_mask) %>% 
  mask(aoi_mask) %>% 
  terra::writeRaster(file.path("data", "01_Elevation", "02_processed/DSM.tif"), overwrite = TRUE)
