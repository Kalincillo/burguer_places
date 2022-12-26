# This code will find the best reviewed burger places in my local town
# ZMG and the distance between them, i will use the rating system from
# Google maps and connect to the Google cloud API with R

library(ggmap)
library(mapproj)
library(googleway)
library(sp)
library(dplyr)

# register to the API
register_google(Sys.getenv("PASSWORD"))

places <- google_places(search_string = 'ramen', 
                        location=c(20.687408505134194, -103.35158714983811), 
                        radius=5000, key=Sys.getenv("PASSWORD"))

places$results$geometry$location


# coord_1 <- aa
lat_1 <- places$results$geometry$viewport
lat_1

lat_2 <- places$results$geometry$location
lat_2

# Convert burguer places into Spacial points
coords <- cbind(Longitude=as.numeric(as.character(lat_2$lng)),
                Latitude = as.numeric(as.character(lat_2$lat)))

coords
places_df <- data.frame(places$results)

burguer_points <- 
  SpatialPointsDataFrame(coords,
                         places_df[-3],
                         proj4string = CRS("+init=epsg:4326"))

plot(burguer_points, pch=".", col="darkred")

burguer_map <- qmap("guadalajara", zoom=13, maptype="hybrid")

burguer_map + geom_point(data = places_df, 
                         aes(x = places_df$geometry$location$lng, 
                             y = places_df$geometry$location$lat),
                         color="red", size=3, alpha=0.5)

