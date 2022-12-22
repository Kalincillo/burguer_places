library(ggmap)
library(mapproj)
library(googleway)
library(sp)
library(dplyr)

pass <- Sys.getenv("PASSWORD")
register_google(pass)

places <- google_places(search_string = 'ramen', 
                        location=c(20.687408505134194, -103.35158714983811), 
                        radius=5000, key=pass)

places$results$geometry$location


# coord_1 <- 
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

burguer_map <- qmap("guadalajara", zoom=12, maptype="hybrid")

burguer_map + geom_point(data = places_df, 
                         aes(x = places_df$geometry$location$lng, 
                             y = places_df$geometry$location$lat),
                         color="green", size=3, alpha=0.5)

