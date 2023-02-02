library(sf)
library(tidyverse)

road <- read_sf("London_Road.shp")

road %>% 
  st_drop_geometry %>% 
  select(CLASSIFICA) %>% 
  unique()

road %>% 
  filter(CLASSIFICA %in% c("A Road", "A Road, Collapsed Dual Carriageway", "Primary Road, Collapsed Dual Carriageway", "Minor Road")) %>% 
  plot()


road %>% 
  filter(CLASSIFICA %in% c("A Road", "A Road, Collapsed Dual Carriageway", "Primary Road, Collapsed Dual Carriageway", "Minor Road")) -> london_road

#st_collection_extract(london_road, "LINESTRING") -> london_road2

st_write(london_road, "London_Road_Clean.shp", layer_options = "SHPT=ARCZ")
