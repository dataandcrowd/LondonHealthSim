library(tidyverse)
library(terra)
library(raster)
x <- raster("London_lc.tif")
lc <- x$London_lc
lc[is.na(lc[])] <- -9999

res(lc)

#aggregate from 40x40 resolution to 120x120 (factor = 3)
lc_agg <- aggregate(lc, fact=40)
res(lc_agg)

#writeRaster(lc_agg, "London_LC.asc", format="ascii", overwrite=TRUE)

raster::shapefile(lc_agg, "London_LC.shp")

