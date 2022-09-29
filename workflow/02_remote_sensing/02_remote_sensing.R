library(terra)
library(magrittr)
library(sf)

# AOI mask
aoi_mask <- terra::vect(file.path("data", "AOI.gpkg"))
vancouver_mask <- aoi_mask[1,]
surrey_mask <- aoi_mask[2,]

water_mask <- terra::vect(file.path("data", "water.gpkg"))


# 1. NDVI -----------------------------------------------------------------

ndvi <- function(r, nir, red) {
  (r[[nir]] - r[[red]]) / (r[[nir]] + r[[red]])
}

s2 <- terra::rast(file.path("data", "02_RemoteSensing", "01_raw", "S2_2015.tif")) %>% 
  terra::crop(aoi_mask) %>% 
  terra::mask(aoi_mask) %>% 
  terra::mask(water_mask, inverse = TRUE)

s2_ndvi <- ndvi(r = s2, nir = 8, red = 4)
names(s2_ndvi) <- "NDVI"

# Vancouver
s2_ndvi %>% 
  terra::crop(vancouver_mask) %>%
  terra::mask(vancouver_mask) %>%
  terra::writeRaster(file.path("data", "02_RemoteSensing", "02_processed", "NDVI_Vancouver.tif"), overwrite = TRUE)

# Surrey
s2_ndvi %>% 
  terra::crop(surrey_mask) %>%
  terra::mask(surrey_mask) %>%
  terra::writeRaster(file.path("data", "02_RemoteSensing", "02_processed", "NDVI_Surrey.tif"), overwrite = TRUE)


# 2. LAI ------------------------------------------------------------------

lai <- terra::rast(file.path("data", "02_RemoteSensing", "01_raw", "LAI_2015.tif")) %>% 
  terra::crop(aoi_mask) %>% 
  terra::mask(aoi_mask) %>% 
  terra::mask(water_mask, inverse = TRUE)
names(lai) <- "LAI"

# Vancouver
lai %>% 
  terra::crop(vancouver_mask) %>%
  terra::mask(vancouver_mask) %>%
  terra::writeRaster(file.path("data", "02_RemoteSensing", "02_processed", "LAI_Vancouver.tif"), overwrite = TRUE)

# Surrey
lai %>% 
  terra::crop(surrey_mask) %>%
  terra::mask(surrey_mask) %>%
  terra::writeRaster(file.path("data", "02_RemoteSensing", "02_processed", "LAI_Surrey.tif"), overwrite = TRUE)

# 3. Land Use and Land Cover (LULC) ---------------------------------------
# Description of LULC classes: https://geobrinkmann.com/post/visible-greenness-exposure/#section-greenspace-mask

LULC <- terra::rast(file.path("data", "02_RemoteSensing", "01_raw", "LULC_2014.tif")) %>% 
  terra::crop(aoi_mask) %>% 
  terra::mask(aoi_mask)

names(LULC) <- "LULC"
LULC[is.nan(LULC)] <- NA

# Build binary Green- & Bluespace raster for Visibility Analysis
(LULC %in% c(6:10, 12)) %>% 
  terra::mask(aoi_mask) %>% 
  terra::writeRaster(file.path("data", "02_RemoteSensing", "02_processed", "LULC_green_and_water.tif"), overwrite = TRUE)


# Build binary Greenspace raster for Availability Analysis
LULC_10m <- terra::aggregate(LULC, 5) %>% 
  terra::crop(aoi_mask) %>% 
  terra::mask(aoi_mask) %>% 
  terra::mask(water_mask, inverse = TRUE)

rcl_mat <- matrix(c(1, 6, 0,    # no vegetation
                    6, 11, 1,   # vegetation
                    11, 14, 0), # no vegetation
                  ncol = 3, byrow = TRUE)

LULC_green <- terra::classify(LULC_10m, rcl = rcl_mat, include.lowest = TRUE, right = FALSE)
ext(LULC_green) <- ext(s2_ndvi)

# Vancouver
LULC_green %>% 
  terra::crop(vancouver_mask) %>%
  terra::mask(vancouver_mask) %>%
  terra::writeRaster(file.path("data", "02_RemoteSensing", "02_processed", "LULC_green_Vancouver.tif"), overwrite = TRUE)

# Surrey
LULC_green %>% 
  terra::crop(surrey_mask) %>%
  terra::mask(surrey_mask) %>%
  terra::writeRaster(file.path("data", "02_RemoteSensing", "02_processed", "LULC_green_Surrey.tif"), overwrite = TRUE)