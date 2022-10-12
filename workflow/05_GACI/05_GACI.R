library(sf)
library(dplyr)
library(osmdata)
library(osrm)
library(terra)
library(pbmcapply)

# Load observer
observer <- terra::rast(file.path("data", "03_ExposureIndices", "GAVI", "GAVI.tif")) %>% 
  terra::xyFromCell(which(!is.na(.[]))) %>% 
  sfheaders::sf_point() %>% 
  sf::st_sf(crs = sf::st_crs(26910)) %>% 
  dplyr::mutate(id = 1:dplyr::n())

# Load AOI
aoi <- sf::read_sf(file.path("data", "AOI.gpkg"))

# Water mask
water_mask <- terra::vect(file.path("data", "water.gpkg"))

# A. Calculate/load Parks and Access Points  ------------------------------
if(!file.exists(file.path("data", "03_ExposureIndices", "GACI", "01_raw", "park_accesspoints.gpkg"))){
  
  # Helper function
  st_multipoint_to_point <- function(x) {
    x.points <- x[which(sf::st_geometry_type(x) == "POINT"), ]
    x.multipoints <- x[which(sf::st_geometry_type(x) == "MULTIPOINT"), ]
    
    for (i in 1:nrow(x.multipoints)) {
      x.points <- x.points %>% 
        dplyr::add_row(sf::st_cast(x.multipoints[i, ], "POINT"))
    }
    
    return(x.points)
  }
  
  # 1. Parks
  # Download parks from OSM
  aoi_bbox <- aoi %>% 
    sf::st_buffer(1000) %>% 
    sf::st_transform(4326) %>% 
    sf::st_bbox()
  
  osm_parks_raw <- osmdata::opq(aoi_bbox) %>% 
    osmdata::add_osm_feature(key = "leisure", value = "park") %>% 
    osmdata::osmdata_sf()
  
  park_poly <- osm_parks_raw$osm_polygons %>% 
    dplyr::select(name) %>% 
    sf::st_cast("MULTIPOLYGON")
  park_multipoly <- osm_parks_raw$osm_multipolygons %>% select(name)
  
  osm_parks <- rbind(park_poly, park_multipoly) %>% 
    sf::st_transform(st_crs(aoi)) 
  
  # Intersects parks with AOI
  osm_parks <- osm_parks[sf::st_buffer(aoi, 1000),]
  cat(glue::glue("Number of parks before cleaning: {nrow(osm_parks)}")); cat("\n")
  
  # Remove small parks (< 1 ha) and those without "park" in their name (e.g. greenbelts)
  osm_parks <- osm_parks %>% 
    dplyr::filter(name != "Boundary Bay Regional Park") %>% 
    mutate(name = tolower(name)) %>% 
    filter(stringr::str_detect(name, "park")) %>% 
    mutate(size_ha = st_area(geometry) %>% 
             units::set_units(value = ha) %>% 
             as.numeric()) %>% 
    filter(size_ha > 1) %>% 
    mutate(size_log = log(size_ha))
  
  cat(glue::glue("Number of parks after cleaning: {nrow(osm_parks)}\n")); cat("\n")
  write_sf(osm_parks, file.path("data", "03_ExposureIndices", "GACI", "01_raw", "parks_osm.gpkg"))
  
  
  # 2. OSM road network
  # Download street network from OSM
  osm_roads_raw <- osmdata::opq(bbox = aoi_bbox) %>%
    osmdata::add_osm_feature(key = "highway") %>%
    osmdata::osmdata_sf(quiet = FALSE) %>%
    osmdata::osm_poly2line()
  
  # Remove features that are not made for walking (e.g. motorway, ...)
  osm_roads <- osm_roads_raw$osm_lines %>%
    dplyr::select(highway) %>%
    dplyr::filter(!highway %in% c("motorway", "motorway_link", "trunk", "trunk_link", "raceway")) %>% 
    sf::st_transform(st_crs(aoi)) %>% 
    sf::st_intersection(sf::st_buffer(rmapshaper::ms_simplify(aoi) , 1000))
  
  # Break lines in segments to increase accuracy
  cores <- 12
  # ---- WINDWOS ----
  if (Sys.info()[["sysname"]] == "Windows") {
    cl <- parallel::makeCluster(cores)
    osm_roads <- suppressWarnings(split(osm_roads, seq(from = 1, to = nrow(osm_roads), by = 200)))
    osm_roads <- parallel::parLapply(cl, osm_roads, fun = function(x){
      nngeo::st_segments(sf::st_cast(x, "LINESTRING"), progress = FALSE)
    })
    parallel::stopCluster(cl)
  } else { # ---- Linux and macOS ----
    osm_roads <- suppressWarnings(split(osm_roads, seq(from = 1, to = nrow(osm_roads), by = 200))) %>%
      parallel::mclapply(function(x){
        nngeo::st_segments(sf::st_cast(x, "LINESTRING"), progress = FALSE)
      },
      mc.cores = cores, mc.preschedule = TRUE)
  }
  
  osm_roads <- st_as_sf(dplyr::as_tibble(data.table::rbindlist(osm_roads)))
  osm_roads <- sf::st_set_geometry(osm_roads, "geom")
  
  # Round coordinates to 0 digits.
  st_geometry(osm_roads) <- st_geometry(osm_roads) %>%
    lapply(function(x) round(x, 0)) %>%
    st_sfc(crs = st_crs(osm_roads))
  
  # 3. Park access points (park centroids + streets that lead into park)
  osm_park_centroids <- osm_parks %>% 
    sf::st_centroid() %>% 
    dplyr::select(name, size_ha, size_log)
  
  osm_park_road_interesect <- osm_parks %>% 
    sf::st_boundary() %>% 
    sf::st_intersection(osm_roads) %>% 
    dplyr::select(name, size_ha, size_log) %>% 
    st_multipoint_to_point()
  
  park_accesspoints <- rbind(osm_park_centroids, osm_park_road_interesect)
  
  write_sf(park_accesspoints, file.path("data", "03_ExposureIndices", "GACI", "01_raw", "park_accesspoints.gpkg"))
} else {
  osm_parks <- read_sf(file.path("data", "03_ExposureIndices", "GACI", "01_raw", "parks_osm.gpkg"))
  park_accesspoints <- read_sf(file.path("data", "03_ExposureIndices", "GACI", "01_raw", "park_accesspoints.gpkg"))
}

# Remove observer locations inside parks
observer <- observer[-(observer[osm_parks, ]$id), ]

# Make sure that Docker is installed (https://docs.docker.com/engine/install/ubuntu/)
if(file.exists(file.path("data", "03_ExposureIndices", "GACI", "01_raw", "Docker", "british-columbia-latest.osm.pbf"))){
  # Change timeout
  default_timeout <- getOption("timeout")
  options(timeout = max(600, default_timeout))
  download.file(url = "http://download.geofabrik.de/north-america/canada/british-columbia-latest.osm.pbf",
                destfile = file.path("data", "03_ExposureIndices", "GACI", "01_raw", "Docker", "british-columbia-latest.osm.pbf"), mode="wb")
  options(timeout = default_timeout)
  
  
  # Once the download is complete, open Bash and navigate to the
  # "Data/03_ExposureIndices/GACI/Docker/" folder.
  file.path(getwd(), file.path("data", "03_ExposureIndices", "GACI", "01_raw", "Docker"))
  # Run these lines to start a local Docker OSRM instance:
  
  # docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-extract -p /opt/foot.lua /data/british-columbia-latest.osm.pbf
  # docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-partition /data/british-columbia-latest.osrm
  # docker run -t -v "${PWD}:/data" osrm/osrm-backend osrm-customize /data/british-columbia-latest.osrm
  # docker run -t -i -p 5000:5000 -v "${PWD}:/data" osrm/osrm-backend osrm-routed --algorithm mld /data/british-columbia-latest.osrm
}

# Function that calculates the walking distance to the big parks for a distinct observer 
observer_park_duration <- function(j){
  # Get knn with k = sqrt of number of park accesspoints
  suppressMessages({
    knn_access <- nngeo::st_nn(observer[j,], park_accesspoints,
                               k = round(sqrt(nrow(park_accesspoints))),
                               progress = FALSE) %>% 
      unlist()
  })
  
  # Calculate duration using local docker instance
  duration_table <- osrmTable(src = observer[j,],
                              dst = park_accesspoints[knn_access,],
                              osrm.server = "http://0.0.0.0:5000/", osrm.profile = "foot")
  
  # Get the smallest distance of each unique park
  out <- tibble(
    id = observer[j,]$id,
    dist = as.numeric(duration_table$durations),
    size_ha = park_accesspoints[knn_access,]$size_ha,
    size_log = park_accesspoints[knn_access,]$size_log,
    name = park_accesspoints[knn_access,]$name
  ) %>% 
    group_by(name) %>% 
    filter(dist == min(dist)) %>% 
    distinct() %>% 
    ungroup() %>% 
    arrange(dist)
  
  #invisible(gc())
  return(out)
}

# Split observer in list of 5000 ids
obs_seq <- split(1:nrow(observer), ceiling(seq_along(1:nrow(observer))/10000))

# Output table that will be loaded with data
tibble(
  id = as.numeric(),
  dist = as.numeric(),
  size_ha = as.numeric(),
  size_log = as.numeric(),
  name = as.character()
) %>% 
  readr::write_csv("Data/03_ExposureIndices/GACI/access_table.csv", col_names = TRUE)

# Parallel calculate distance to nearest big park
pb = pbmcapply::progressBar(min = 0, max = length(obs_seq)); stepi = 1
for(this_seq in obs_seq){
  # Get distance to closest parks
  dist_table <- parallel::mclapply(this_seq, observer_park_duration,
                                   mc.cores = 12) %>%
    do.call(rbind, .)
  
  # Append to table
  readr::write_csv(dist_table, "Data/03_ExposureIndices/GACI/access_table.csv",
                   append = TRUE)
  
  setTxtProgressBar(pb, stepi); stepi = stepi + 1
}
close(pb)

# Load all distance data
dist_table <- readr::read_csv("Data/03_ExposureIndices/GACI/access_table.csv")

# Helper function to normalise data [0-1]
range01 <- function(x){(x-min(x))/(max(x)-min(x))}


# Calculate weighted distance with respect to the size and distance of park.
# While distance has the greatest influence (weight = 1.91) the size of the park
# is important, too (weight = 0.85).
# https://doi.org/10.1016/j.amepre.2004.10.018  (page 172 "Statistical Analysis")
dist_per_id <- dist_table %>% 
  #filter(id == unique(dist_table$id)[1]) %>% 
  group_by(id) %>% 
  mutate(dist__0_1 = 1 - range01(log(dist)),
         size__0_1 = range01(size_log)) %>% 
  mutate(w1 = (1.91/0.85*dist__0_1 + size__0_1) / 2) %>% 
  arrange(desc(w1)) %>% 
  filter(w1 == max(w1)) %>% 
  ungroup() %>% 
  arrange((dist__0_1))

dist_table %>% 
  filter(id == 734689) %>% 
  mutate(dist__0_1 = 1 - range01(log(dist)),
         size__0_1 = range01(size_log)) %>% 
  mutate(w1 = (1.91/0.85*dist__0_1 + size__0_1) / 2) %>% 
  arrange(desc(w1))

# Merge with observer locations
dist_sf <- inner_join(observer, dist_per_id)

# Convert to reaster using IDW
dist_rast <- GVI::sf_to_rast(observer = dist_sf, v = "dist", aoi = aoi,
                             max_distance = 40, raster_res = 10, 
                             cores = 22, progress = TRUE) %>% 
  focal(3, mean)

# Align extent with GAVI raster
gavi <- rast("Data/03_ExposureIndices/GAVI/GAVI.tif")
dist_rast <- project(dist_rast, gavi)
ext(dist_rast) == ext(gavi)

# Parks need to be set at min value
dist_rast <- dist_rast %>% 
  mask(osm_parks, inverse = TRUE)

dist_rast[which(is.na(dist_rast[]))] <- min(dist_rast[], na.rm = TRUE)
dist_rast <- dist_rast %>% 
  crop(aoi) %>% 
  mask(water_mask, inverse = TRUE) %>% 
  mask(aoi)


# Deal with extreme values
q_9 <- quantile(dist_rast[], 0.9, na.rm = TRUE, names = FALSE)
dist_rast[which(dist_rast[] > q_9)] <- q_9

# Compute Jenks
jenks <- classInt::classIntervals(var = dist_rast %>% 
                                    terra::values(mat = FALSE) %>% 
                                    na.omit() %>%
                                    sample(100000),
                                  n = 9, style = "fisher", warnLargeN = FALSE)
jenks$brks[c(1, 10)] <- c(dist_rast@ptr$range_min, dist_rast@ptr$range_max)

rcl_mat <- matrix(c(jenks$brks[1:9],
                    jenks$brks[2:10],
                    9:1),
                  ncol = 3, byrow = F)
gaci <- classify(dist_rast, rcl_mat, include.lowest=TRUE)

writeRaster(gaci, "Data/03_ExposureIndices/GACI/GACI.tif", overwrite = TRUE)










