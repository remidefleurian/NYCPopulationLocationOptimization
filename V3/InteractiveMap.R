library(tidyverse)
library(leaflet)
library(htmlwidgets)
library(mapview)

# Parse data
df <- read_csv("graphFiles/nyc_graph_3_unitsPerNode.csv") %>% 
  select(-X1) %>%   
  mutate(
    data = str_replace_all(data, "[\\(\\)\\{\\}\\']", ""),
    data = str_replace_all(data, "x: ", ""),
    data = str_replace_all(data, "y: ", ""),
    data = str_replace_all(data, "UnitsWithinQuarterMile: ", "")
  ) %>% 
  separate(data, into = c("id", "geom", "lng", "lat", "density"), sep = ",") %>% 
  select(-geom) %>% 
  mutate(id = str_replace(id, "n", "")) %>% 
  mutate_all(as.numeric) %>% 
  arrange(id) %>% 
  select(-id)

# Create palette
pal <- colorNumeric(palette = "Oranges", domain = df$density)

# Create static map
m <- df %>% 
  leaflet() %>% 
  addCircleMarkers(radius = 5, color = ~pal(density), stroke = FALSE) %>%
  addProviderTiles("CartoDB.Positron") %>% 
  setView(-74.01088, 40.71007, zoom = 15)

mapshot(m, file = "imageFiles/ManhattanIntersectionHeatmapLeaflet.png")

# Create interactive map
m <- df %>% 
  leaflet() %>% 
  addCircleMarkers(radius = 5, color = ~pal(density), stroke = FALSE) %>%
  addProviderTiles("CartoDB.Positron") %>% 
  setView(-74.01088, 40.71007, zoom = 14)

saveWidget(m, file = "imageFiles/ManhattanIntersectionHeatmapLeaflet.html")
