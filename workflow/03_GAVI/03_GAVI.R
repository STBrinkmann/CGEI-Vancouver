library(dplyr)
library(ggplot2)
library(terra)
library(spatLac)
library(classInt)

source("Scripts/theme_publication.R")

# Load data
vancouver <- list(
  terra::rast(file.path("data", "02_RemoteSensing", "02_processed", "NDVI_Vancouver.tif")),
  terra::rast(file.path("data", "02_RemoteSensing", "02_processed", "LAI_Vancouver.tif")),
  terra::rast(file.path("data", "02_RemoteSensing", "02_processed", "LULC_green_Vancouver.tif"))
)

surrey <- list(
  terra::rast(file.path("data", "02_RemoteSensing", "02_processed", "NDVI_Surrey.tif")),
  terra::rast(file.path("data", "02_RemoteSensing", "02_processed", "LAI_Surrey.tif")),
  terra::rast(file.path("data", "02_RemoteSensing", "02_processed", "LULC_green_Surrey.tif"))
)

# 1. Lacunarity -----------------------------------------------------------

# Compute Lacunarity
if (!file.exists(file.path("Data", "03_ExposureIndices", "GAVI", "Lacunarity", "Vancouver", "Vancouver_lacunarity.csv"))) {
  lac_vancouver <- spatLac::lacunarity(x = vancouver,
                                       r_vec = c(3, 5, 7, 9, 11, 13, 15, 17, 21, 25, 29,
                                                 31, 35, 39, 41, 45, 51, 59, 65, 75, 85,
                                                 95, 111, 129, 151, 171, 191, 211, 231,
                                                 257, 301, 351, 401, 513, 601, 701, 751,
                                                 851, 951, 1051, 1151, 1251, 1351, 1451),
                                       progress = TRUE, ncores = 22, plot = FALSE)
  
  lac_surrey    <- spatLac::lacunarity(x = surrey,
                                       r_vec = c(3, 5, 7, 9, 11, 13, 15, 17, 21, 25, 29,
                                                 31, 35, 39, 41, 45, 51, 59, 65, 75, 85,
                                                 95, 111, 129, 151, 171, 191, 211, 231,
                                                 257, 301, 351, 401, 513, 601, 701, 751,
                                                 851, 951, 1051, 1151, 1251, 1351, 1451),
                                       progress = TRUE, ncores = 22, plot = FALSE)
  
  
  readr::write_csv(lac_vancouver,
                   file.path("data", "03_ExposureIndices", "GAVI", "Lacunarity", "Vancouver", "Vancouver_lacunarity.csv"))
  
  readr::write_csv(lac_surrey,
                   file.path("data", "03_ExposureIndices", "GAVI", "Lacunarity", "Surrey", "Surrey_lacunarity.csv"))
} else {
  lac_vancouver <- readr::read_csv(file.path("data", "03_ExposureIndices", "GAVI", "Lacunarity", "Vancouver", "Vancouver_lacunarity.csv"))
  lac_surrey    <- readr::read_csv(file.path("data", "03_ExposureIndices", "GAVI", "Lacunarity", "Surrey", "Surrey_lacunarity.csv"))
}




# Plot
lac_vancouver$region <- "Vancouver"
lac_surrey$region <- "Surrey"
lac_combined <- rbind(lac_vancouver, lac_surrey) 

x_names <- as.character(lac_combined$name)
max_x <- ceiling(max(lac_combined$`ln(r)`, na.rm = TRUE))
max_y <- round(max(lac_combined$`ln(Lac)`, na.rm = TRUE), 1)+0.1


lac_combined %>% 
  dplyr::mutate(region = factor(region, levels = c("Vancouver", "Surrey"))) %>% 
  ggplot2::ggplot(mapping = ggplot2::aes(x = `ln(r)`,
                                         y = `ln(Lac)`,
                                         colour = x_names)) +
  ggplot2::geom_line(lwd = 0.8) + 
  ggplot2::labs(x = "ln(r)",
                y = "ln(lacunarity)",
                colour = "Legend") +
  ggplot2::scale_x_continuous(breaks = seq(0, max_x, 1),
                              limits = c(1, max_x)) +
  ggplot2::scale_y_continuous(breaks = seq(0, max_y, 0.1),
                              limits = c(0, max_y)) +
  ggplot2::facet_wrap(~region) +
  scale_colour_Publication() +
  theme_Publication() +
  ggplot2::theme(axis.title = ggplot2::element_text(size = 14),
                 axis.text = ggplot2::element_text(size = 12),
                 legend.text = ggplot2::element_text(size = 12),
                 legend.title = ggplot2::element_text(size = 14),
                 strip.text = ggplot2::element_text(size=16))


# 2. GAVI -----------------------------------------------------------------

# Compute Lacunarity only at 50, 100, 200, 300, and 400 m
lac_small_vancouver <- spatLac::lacunarity(x = vancouver,
                                           r_vec = c(50, 100, 200, 300, 400)/10 * 2 + 1,
                                           progress = TRUE, ncores = 22)

lac_small_surrey    <- spatLac::lacunarity(x = surrey,
                                           r_vec = c(50, 100, 200, 300, 400)/10 * 2 + 1,
                                           progress = TRUE, ncores = 22)

# For each Greenspace layer compute Greenspace Availability Exposure Index (GAVI) based on
# Labib et al. 2020: https://doi.org/10.1016/j.compenvurbsys.2020.101501
GAVI <- function(r_list, lac) {
  # Output list
  out <- list()
  
  pb = txtProgressBar(min = 0, max = length(r_list), initial = 0, style = 3) 
  for (i in seq_along(r_list)) {
    this_r <- r_list[[i]]
    
    # Get Lacunarity values
    this_lac <- lac[lac$name == names(this_r), ]
    w_vec <- this_lac$r
    lac_vec <- this_lac$`ln(Lac)`
    
    # Compute scale-weighted layers
    weighted_list <- list()
    for (j in seq_along(w_vec)) {
      weighted_list[[j]] <- (terra::focal(this_r, w = w_vec[j], fun = "mean", na.rm = TRUE) * lac_vec[j]) %>% 
        terra::crop(this_r) %>% 
        terra::mask(this_r)
    }
    
    # Compute combined GreenSpace exposure
    combined_GS <- (do.call("sum", weighted_list) / sum(lac_vec)) %>% 
      terra::crop(this_r) %>% 
      terra::mask(this_r)
    
    # Using Jenks algorithm to reclassified raster with 9 classes
    this_jenks <- classInt::classIntervals(var = combined_GS %>% 
                                             terra::values(mat = FALSE) %>% 
                                             na.omit() %>%
                                             sample(100000),
                                           n = 9, style = "fisher", warnLargeN = FALSE)
    this_jenks$brks[c(1, 10)] <- c(combined_GS@ptr$range_min, combined_GS@ptr$range_max)
    
    rcl_mat <- matrix(c(this_jenks$brks[1:9],
                        this_jenks$brks[2:10],
                        1:9),
                      ncol = 3, byrow = F)
    out[[i]] <- classify(combined_GS, rcl_mat, include.lowest=TRUE)
    setTxtProgressBar(pb,i)
  }
  
  # Produce composite multiscale, multi-metric, greenspace ‘exposure index’ map
  composite_GS <- out %>% 
    terra::sprc() %>% 
    terra::mosaic(fun = "sum")
  
  rcl_mat <- matrix(c(1,3,1,
                      3,6,2,
                      6,9,3,
                      9,12,4,
                      12,15,5,
                      15,18,6,
                      18,21,7,
                      21,24,8,
                      24,27,9),
                    ncol = 3, byrow = TRUE)
  return(terra::classify(composite_GS, rcl = rcl_mat, include.lowest = TRUE))
}

GAVI_vancouver <- GAVI(vancouver, lac_small_vancouver)
GAVI_surrey <- GAVI(surrey, lac_small_surrey)



# AOI mask
aoi_mask <- terra::vect(file.path("data", "AOI.gpkg"))
water_mask <- terra::vect(file.path("data", "water.gpkg"))

GAVI_merged <- terra::merge(GAVI_vancouver, GAVI_surrey)

rcl_mat <- matrix(c(1,2,1,
                    2,3,2,
                    3,4,3,
                    4,5,4,
                    5,6,5,
                    6,7,6,
                    7,8,7,
                    8,9,8,
                    9,10,9),
                  ncol = 3, byrow = TRUE)
gavi_rast <- terra::classify(GAVI_merged, rcl = rcl_mat, include.lowest = TRUE, right= FALSE) %>% 
  terra::crop(aoi_mask) %>% 
  terra::mask(water_mask, inverse = TRUE)

terra::writeRaster(gavi_rast, file.path("data", "03_ExposureIndices", "GAVI", "GAVI.tif"), overwrite = TRUE)









