# This code will find the best reviewed burger places
# in ZMG (Guadalajara, Zapopan, Tlaquepaque, Tonala, Tlajomulco, El Salto)
# and the distance between them, i will use the rating system from
# Google maps and connect to the Google cloud API with R

library(ggmap)
library(mapproj)
library(googleway)
library(sp)
library(dplyr)

# register to the API
register_google(Sys.getenv("PASSWORD"))

# search for places including burger from the center of the city with a
# 10km radius
places <- google_places(search_string = 'burger', 
                        location=c(20.677214679298075, -103.34695181349188), 
                        radius=10000, key=Sys.getenv("PASSWORD"))

# get latitude and longitude of the first 20 places
lat_lon <- places$results$geometry$location

# Convert burger places into Spacial points
coords <- cbind(Longitude=as.numeric(as.character(lat_lon$lng)),
                Latitude = as.numeric(as.character(lat_lon$lat)))

places_df <- data.frame(places$results)

burguer_points <- 
  SpatialPointsDataFrame(coords,
                         places_df[-3],
                         proj4string = CRS("+init=epsg:4326"))

plot(burguer_points, pch=".", col="darkblue")

burguer_map <- qmap("guadalajara", zoom=13, maptype="hybrid")

burger_gmap <- burguer_map + geom_point(data = places_df, 
                         aes(x = places_df$geometry$location$lng, 
                             y = places_df$geometry$location$lat),
                         color="red", size=3, alpha=0.5)

