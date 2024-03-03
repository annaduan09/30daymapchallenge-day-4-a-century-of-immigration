#### setup ####
# libraries
library(sf)
library(tidyverse)
library(mapview)
library(conflicted)
library(tigris)
library(stringr)
library(gganimate)
library(viridis)
library(crsuggest)

# package/argument conflicts
conflicts_prefer(dplyr::filter)
conflicts_prefer(dplyr::select)
conflicts_prefer(dplyr::mutate)

#### Data Prep ####
# read data from NHGIS CSV files
dat1920 <- read.csv("data/dat1920.csv")
dat1930 <- read.csv("data/dat1930.csv")
dat1940 <- read.csv("data/dat1940.csv")
dat1950 <- read.csv("data/dat1950.csv")
dat1960 <- read.csv("data/dat1960.csv")
dat1970 <- read.csv("data/dat1970.csv")
dat1980 <- read.csv("data/dat1980.csv")
dat1990 <- read.csv("data/dat1990.csv")
dat2000 <- read.csv("data/dat2000.csv")
dat2010 <- read.csv("data/dat2010.csv")
dat2020 <- read.csv("data/dat2020.csv")

# read census tract boundaries from NHGIS shapefiles
nyc_bound <- counties(state = c("NY", "NJ", "PA")) %>%
  st_transform(6563) %>%
  st_crop(xmin= 2933258, ymin= 126870.5, xmax= 3096398, ymax= 303060.4) %>%
  erase_water()

sf_1920 <- st_read("shapefiles/1920/US_tract_1920.shp") %>%
  st_transform(6563) %>%
  st_crop(st_bbox(nyc_bound)) %>%
  dplyr::select(GISJOIN)

sf_1930 <- st_read("shapefiles/1930/US_tract_1930.shp") %>%
  st_transform(6563) %>%
  st_crop(st_bbox(nyc_bound)) %>%
  dplyr::select(GISJOIN)

sf_1940 <- st_read("shapefiles/1930/US_tract_1930.shp") %>%
  st_transform(6563) %>%
  st_crop(st_bbox(nyc_bound)) %>%
  dplyr::select(GISJOIN)

sf_1950 <- st_read("shapefiles/1950/US_tract_1950.shp") %>%
  st_transform(6563) %>%
  st_crop(st_bbox(nyc_bound)) %>%
  dplyr::select(GISJOIN)

sf_1960 <- st_read("shapefiles/1960/US_tract_1960.shp") %>%
  st_transform(6563) %>%
  st_crop(st_bbox(nyc_bound)) %>%
  dplyr::select(GISJOIN)

sf_1970 <- st_read("shapefiles/1970/US_tract_1970.shp") %>%
  st_transform(6563) %>%
  st_crop(st_bbox(nyc_bound)) %>%
  dplyr::select(GISJOIN)

sf_1980 <- st_read("shapefiles/1980/US_tract_1980.shp") %>%
  st_transform(6563) %>%
  st_crop(st_bbox(nyc_bound)) %>%
  dplyr::select(GISJOIN)

sf_1990 <- st_read("shapefiles/1990/US_tract_1990.shp") %>%
  st_transform(6563) %>%
  st_crop(st_bbox(nyc_bound)) %>%
  dplyr::select(GISJOIN)

sf_2000 <- st_read("shapefiles/2000/US_tract_2000.shp") %>%
  st_transform(6563) %>%
  st_crop(st_bbox(nyc_bound)) %>%
  dplyr::select(GISJOIN)

sf_2010 <- st_read("shapefiles/2010/US_tract_2010.shp") %>%
  st_transform(6563) %>%
  st_crop(st_bbox(nyc_bound)) %>%
  dplyr::select(GISJOIN)

sf_2020 <- st_read("shapefiles/2020/US_tract_2020.shp") %>%
  st_transform(6563) %>%  # Transform CRS after reading
  st_crop(nyc_bound) %>%  # Crop to the bounding box
  select(GISJOIN) 

# list of decade dataframes
dat_all <- list(dat1920 = dat1920, dat1930 = dat1930, dat1940 = dat1940,
                dat1950 = dat1950, dat1960 = dat1960, dat1970 = dat1970,
             dat1980 = dat1980, dat1990 = dat1990, dat2000 = dat2000,
             dat2010 = dat2010, dat2020 = dat2020)

# list of NYC boroughs
nyc_counties <- c("Bronx", "Kings", "New", "Queens", "Richmond")

# filter for census tracts in NYC boroughs
dat_list <- map(dat_all, function(.x) {
  .x %>%
    filter(STATE == "New York" & word(COUNTY, 1) %in% nyc_counties)
})

# return dataframes to global environment
list2env(dat_list, envir = .GlobalEnv)

# rename population columns
dat1920 <- dat1920 %>%
  rename(pop_1910 = BBQ001,
         pop_1920 = BBQ002) %>%
  dplyr::select(pop_1910, pop_1920, GISJOIN)

dat1930 <- dat1930 %>%
  rename(pop_1930 = BOI001) %>%
  dplyr::select(pop_1930, GISJOIN)

dat1940 <- dat1940 %>%
  rename(pop_1940 = BZO001) %>%
  dplyr::select(pop_1940, GISJOIN)

dat1950 <- dat1950 %>%
  rename(pop_1950 = BZ8001) %>%
  dplyr::select(pop_1950, GISJOIN)

dat1960 <- dat1960 %>%
  rename(pop_1960 = CA4001) %>%
  dplyr::select(pop_1960, GISJOIN)

dat1970 <- dat1970 %>%
  rename(pop_1970 = CY7001) %>%
  dplyr::select(pop_1970, GISJOIN)

dat1980 <- dat1980 %>%
  rename(pop_1980 = C6W001) %>%
  dplyr::select(pop_1980, GISJOIN)

dat1990 <- dat1990 %>%
  rename(pop_1990 = ET1001) %>%
  dplyr::select(pop_1990, GISJOIN)

dat2000 <- dat2000 %>%
  rename(pop_2000 = FL5001) %>%
  dplyr::select(pop_2000, GISJOIN)

dat2010 <- dat2010 %>%
  rename(pop_2010 = H7V001) %>%
  dplyr::select(pop_2010, GISJOIN)

dat2020 <- dat2020 %>%
  rename(pop_2020 = U7H001) %>%
  dplyr::select(pop_2020, GISJOIN)
# 
# # gather back into list to select relevant columns (GISJOIN, population)
# dat_all_pop <- list(dat1930 = dat1930, dat1940 = dat1940, 
#                 dat1950 = dat1950, dat1960 = dat1960, dat1970 = dat1970, 
#                 dat1980 = dat1980, dat1990 = dat1990, dat2000 = dat2000, 
#                 dat2010 = dat2010, dat2020 = dat2020)
# 
# dat_all_pop <- map(dat_all_pop, function(.x) {
#   .x %>%
#     select(GISJOIN, last_col()) # select tract and population
# })
# 
# # for 1920 we have to manually choose the second to last and last columns because we have 1910 and 1920 populations together
# dat1920 <- dat1920 %>%
#   dplyr::select(GISJOIN, last_col(offset = 1), last_col())

# return dataframes to global environment
# list2env(dat_all_pop, envir = .GlobalEnv) 

# create lists of dataframes (population values) and sf objects (census tract boundaries) to join
list_sf <- list(sf_1920, sf_1930, sf_1940, sf_1950, sf_1960, sf_1970,
                sf_1980, sf_1990, sf_2000, sf_2010, sf_2020)
list_df <- list(dat1920, dat1930, dat1940, dat1950, dat1960, dat1970,
                dat1980, dat1990, dat2000, dat2010, dat2020)

# join the list of sf with the list of df
list_dat.sf <- map2(list_df, list_sf, ~inner_join(.x, .y, by = "GISJOIN") %>%
                      st_as_sf() %>%
                      mutate(area_mi = as.numeric(st_area(.)) / 27878400))


# Define names for the joined dataframes
names_list <- c("sf_1920", "sf_1930", "sf_1940", "sf_1950", "sf_1960",
                "sf_1970", "sf_1980", "sf_1990", "sf_2000", "sf_2010", "sf_2020")

# Assign names to the list
names(list_dat.sf) <- names_list

# Return dataframes to the global environment
list2env(list_dat.sf, envir = .GlobalEnv)
# 
# #### Consolidate all data into one dataframe for gganimate####
# # create sf object to use
# tracts.sf <- sf_2020 %>%
#   select(geometry, GISJOIN) %>%
#   rename(tract2020 = GISJOIN)
# 
# # intersect each decade's sf object with tracts.sf
# tract_1920 <- sf_1920 %>%
#   st_centroid() %>%
#   st_intersection(tracts.sf) %>%
#   filter(duplicated(tract2020) == FALSE) %>%
#   select(tract2020, pop_1910, pop_1920, area_mi) %>%
#   st_drop_geometry()
# 
# tract_1930 <- sf_1930 %>%
#   st_centroid() %>%
#   st_intersection(tracts.sf) %>%
#   filter(duplicated(tract2020) == FALSE) %>%
#   select(tract2020, pop_1930) %>%
#   st_drop_geometry()
# 
# tract_1940 <- sf_1940 %>%
#   st_centroid() %>%
#   st_intersection(tracts.sf) %>%
#   filter(duplicated(tract2020) == FALSE) %>%
#   select(tract2020, pop_1940) %>%
#   st_drop_geometry()
# 
# tract_1950 <- sf_1950 %>%
#   st_centroid() %>%
#   st_intersection(tracts.sf) %>%
#   filter(duplicated(tract2020) == FALSE) %>%
#   select(tract2020, pop_1950) %>%
#   st_drop_geometry()
# 
# tract_1960 <- sf_1960 %>%
#   st_centroid() %>%
#   st_intersection(tracts.sf) %>%
#   filter(duplicated(tract2020) == FALSE) %>%
#   select(tract2020, pop_1960) %>%
#   st_drop_geometry()
# 
# tract_1970 <- sf_1970 %>%
#   st_centroid() %>%
#   st_intersection(tracts.sf) %>%
#   filter(duplicated(tract2020) == FALSE) %>%
#   select(tract2020, pop_1970) %>%
#   st_drop_geometry()
# 
# tract_1980 <- sf_1980 %>%
#   st_centroid() %>%
#   st_intersection(tracts.sf) %>%
#   filter(duplicated(tract2020) == FALSE) %>%
#   select(tract2020, pop_1980) %>%
#   st_drop_geometry()
# 
# tract_1990 <- sf_1990 %>%
#   st_centroid() %>%
#   st_intersection(tracts.sf) %>%
#   filter(duplicated(tract2020) == FALSE) %>%
#   select(tract2020, pop_1990) %>%
#   st_drop_geometry()
# 
# tract_2000 <- sf_2000 %>%
#   st_centroid() %>%
#   st_intersection(tracts.sf) %>%
#   filter(duplicated(tract2020) == FALSE) %>%
#   select(tract2020, pop_2000) %>%
#   st_drop_geometry()
# 
# tract_2010 <- sf_2010 %>%
#   st_centroid() %>%
#   st_intersection(tracts.sf) %>%
#   filter(duplicated(tract2020) == FALSE) %>%
#   select(tract2020, pop_2010) %>%
#   st_drop_geometry()
# 
# tract_2020 <- sf_2020 %>%
#   rename(tract2020 = GISJOIN) %>%
#   select(tract2020, pop_2020) %>%
#   filter(duplicated(tract2020) == FALSE)
# 
# # combine into one df
# tracts_all <- tract_2020 %>%
#   left_join(tract_1930, by = "tract2020") %>%
#   left_join(tract_1940, by = "tract2020") %>%
#   left_join(tract_1950, by = "tract2020") %>%
#   left_join(tract_1960, by = "tract2020") %>%
#   left_join(tract_1970, by = "tract2020") %>%
#   left_join(tract_1980, by = "tract2020") %>%
#   left_join(tract_1990, by = "tract2020") %>%
#   left_join(tract_2000, by = "tract2020") %>%
#   left_join(tract_2010, by = "tract2020") %>%
#   left_join(tract_1920, by = "tract2020") %>%
#   st_as_sf() 
#   
#### Make maps #### 
# mapping function
generate_map_jpg <- function(dat.sf, pop_col, title_decade) {
  
  # Create the plot
  plot <- ggplot() +
    geom_rect(data = bbox_df, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), 
              color = "transparent", fill = "lightblue2") +
    geom_sf(data = nyc_bound, fill = "floralwhite", color = "gray90") +
    geom_sf(data = dat.sf, aes(fill = round(pop_col/(area_mi * 1000000), 1)), color = "transparent", alpha = 0.8, size = 0.1) +
    scale_fill_viridis_c(direction = -1, option = "B", name = "People per\nsqmi (millions)") +
    labs(title = title_decade, subtitle = paste("Total population:", round(sum(pop_col)/1000000, 2), "million"), sep = "") +
    guides(fill = guide_colourbar(title.position = "top", label.position = "bottom")) +
    theme_void() + 
    theme(legend.position = c(0.8, 0.12),
          legend.title.align = 0.5,
          legend.text = element_text(color = "brown"),
          legend.title = element_text(vjust = 1, color = "brown", face = "bold"),
          plot.title = element_text(vjust = -35, hjust = 0.5, face = "bold", color = "coral3", size = 80),
          plot.subtitle = element_text(hjust = 0.5, vjust = -175, face = "bold", color = "coral4", size = 16),
          legend.direction = "horizontal")
  
  # Save the plot as a JPEG
  ggsave(filename = paste0(title_decade, ".png"), plot = plot, dpi = 320, width = 9, height = 10.85)
}

# call mapping function for each decade
generate_map_jpg(sf_1920, sf_1920$pop_1910, "1910")
generate_map_jpg(sf_1920, sf_1920$pop_1920, "1920")
generate_map_jpg(sf_1930, sf_1930$pop_1930, "1930")
generate_map_jpg(sf_1940, sf_1940$pop_1940, "1940")
generate_map_jpg(sf_1950, sf_1950$pop_1950, "1950")
generate_map_jpg(sf_1960, sf_1960$pop_1960, "1960")
generate_map_jpg(sf_1970, sf_1970$pop_1970, "1970")
generate_map_jpg(sf_1980, sf_1980$pop_1980, "1980")
generate_map_jpg(sf_1990, sf_1990$pop_1990, "1990")
generate_map_jpg(sf_2000, sf_2000$pop_2000, "2000")
generate_map_jpg(sf_2010, sf_2010$pop_2010, "2010")
generate_map_jpg(sf_2020, sf_2020$pop_2020, "2020")

# line plot
pop.df <- data.frame(pop = c(sum(sf_1920$pop_1910), sum(sf_1920$pop_1920),
                             sum(sf_1930$pop_1930), sum(sf_1940$pop_1940),
                             sum(sf_1950$pop_1950), sum(sf_1960$pop_1960),
                             sum(sf_1970$pop_1970), sum(sf_1980$pop_1980), 
                             sum(sf_1990$pop_1990), sum(sf_2000$pop_2000),
                             sum(sf_2010$pop_2010), sum(sf_2020$pop_2020)),
                     decade = c(1910, 1920, 1930, 1940, 1950, 1960,
                                1970, 1980, 1990, 2000, 2010, 2020))

ggplot(pop.df, aes(x = decade, y = pop)) +
  geom_path(color = "gray80", size = 6, alpha = 0.2) +
  geom_point(color = "gray70", size = 6) +
  labs(x = "year", y = "total pop") +
  theme_void()
