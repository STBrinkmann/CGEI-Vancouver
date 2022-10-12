library(magrittr)
library(terra)
library(sf)
library(sfheaders)
library(GVI)
options(show.error.messages = T)

# Set your cores here!
cores <- 22

# 1. XY rom LULC ----------------------------------------------------------

# Land Use raster and output raster with 5m resolution
aoi_mask <- terra::vect(file.path("data", "AOI.gpkg"))

lulc <- terra::rast(file.path("data", "02_RemoteSensing", "01_raw", "LULC_2014.tif"))
output <- terra::rast(resolution = 5, crs = terra::crs(lulc), extent = terra::ext(lulc), vals = 1) %>% 
  terra::mask(aoi_mask)

# Buildings and waters
lulc_build_water <- (lulc %in% c(1, 12)) %>% 
  terra::mask(lulc)

# XY coordinates from Land Use
lulc_build_water_xy <- terra::xyFromCell(lulc_build_water, which(lulc_build_water[] == 1))

# Corresponding cell values in output raster
output_build_water_cells <- unique(na.omit(terra::cellFromXY(output, lulc_build_water_xy)))

output[output_build_water_cells] <- NA

# Convert to POINTS and save
output_xy <- terra::xyFromCell(output, which(output[] == 1))
observer <- sf::st_sf(sfheaders::sf_point(output_xy), 
                      crs = sf::st_crs(as.numeric(terra::crs(output, describe = T)$code)))

rm(lulc, lulc_build_water, lulc_build_water_xy,output, output_build_water_cells, output_xy)
invisible(gc())


# 2. VGVI -----------------------------------------------------------------

# Load raster data
dtm <- terra::rast(file.path("data", "01_Elevation", "02_processed", "DTM.tif"))
dsm <- terra::rast(file.path("data", "01_Elevation", "02_processed", "DSM.tif"))
greenspace <- terra::rast(file.path("data", "02_RemoteSensing", "02_processed", "LULC_green.tif"))

# Compute VGVI
vancouver_vgvi <- GVI::vgvi_from_sf(observer = observer,
                                    dsm_rast = dsm,
                                    dtm_rast = dtm,
                                    greenspace_rast = greenspace,
                                    max_distance = 300, observer_height = 1.8,
                                    raster_res = 1,
                                    m = 1, b = 3, mode = "exponential",
                                    cores = cores,
                                    progress = TRUE)


# 3. IDW ------------------------------------------------------------------

vgvi_idw <- GVI::sf_to_rast(observer = vancouver_vgvi, v = "VGVI", aoi = st_as_sf(aoi_mask),
                            max_distance = 400, n = 10, raster_res = 10, beta = 2,
                            cores = 22, progress = TRUE)
# Remove last NA values
vgvi_idw <- vgvi_idw %>% 
  terra::focal(21, fun = median, na.rm = TRUE, na.policy = "only")

rm(vancouver_vgvi); invisible(gc())

# Cleaning
water_mask <- terra::vect(file.path("data", "water.gpkg"))

vgvi_idw_clean <- vgvi_idw %>%
  terra::focal(3, fun = median, na.rm = TRUE) %>%
  terra::crop(aoi_mask) %>% 
  terra::mask(aoi_mask) %>%
  terra::mask(water_mask, inverse = TRUE)


# 4. Jenks ----------------------------------------------------------------
set.seed(1234)
this_jenks <- classInt::classIntervals(var = vgvi_idw_clean %>% 
                                         terra::values(mat = FALSE) %>% 
                                         na.omit() %>%
                                         sample(100000),
                                       n = 9, style = "fisher", warnLargeN = FALSE)
this_jenks$brks[c(1, 10)] <- c(vgvi_idw_clean@ptr$range_min, vgvi_idw_clean@ptr$range_max)

rcl_mat <- matrix(c(this_jenks$brks[1:9],
                    this_jenks$brks[2:10],
                    1:9),
                  ncol = 3, byrow = F)
vgvi_idw_clean_jenks <- classify(vgvi_idw_clean, rcl_mat, include.lowest=TRUE)

terra::writeRaster(vgvi_idw_clean_jenks, file.path("data", "03_ExposureIndices", "VGVI", "VGVI.tif"), overwrite = TRUE)
