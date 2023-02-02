library(sf)
library(tidyverse)
library(magrittr)

ldn <- read_sf("London_Borough_Excluding_MHW.shp")

plot(ldn)

ldn %<>% 
  select(NAME, GSS_CODE, HECTARES, NONLD_AREA, ONS_INNER)


ldn %>% 
  mutate(index = 1:length(NAME)) %>% 
  select(index, everything()) -> london


plot(london)

st_write(london, "London_Boundary_cleaned.shp")

