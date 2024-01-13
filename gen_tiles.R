# https://docs.ropensci.org/tiler/
# https://cran.r-project.org/web/packages/tiler/vignettes/tiler-intro.html

library(leaflet)

map <- raster('path/to/raster/file/map.tif')
tile(map, tile_dir, "0-3")


tiles <- "https://leonawicz.github.io/tiles/st2/tiles/{z}/{x}/{y}.png"
leaflet(
  options = leafletOptions(
    crs = leafletCRS("L.CRS.Simple"), minZoom = 0, maxZoom = 7, attributionControl = FALSE), width = "100%") %>%
  addTiles(tiles) %>% setView(71, -60, 3)
