library(ggmap)
library(mapproj)
library(googleway)
llave <- ""

register_google(llave)
# map <- get_map(location="mexico", zoom=3, maptype="terrain")

google_places(search_string = 'burguer', location=c(20.687408505134194, -103.35158714983811), radius=3218, key=llave)
