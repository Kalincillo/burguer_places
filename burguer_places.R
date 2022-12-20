library(ggmap)
library(mapproj)
library(googleway)
library(sp)


pass <- Sys.getenv("PASSWORD")
register_google(pass)

places <- google_places(search_string = 'ramen', 
                        location=c(20.687408505134194, -103.35158714983811), 
                        radius=5000, key=pass)

places$results$geometry$location

places_2 <- google_places(search_string = 'burguer', 
                        location=c(20.687408505134194, -103.35158714983811), 
                        radius=5000, key=pass, 
                        page_token=places$next_page_token )
places_2

qmap('Guadalajara', zoom = 12, maptype = "satellite")

qmap('Eutimio Pinzón 927', zoom=19, maptype = "satellite")

# coord_1 <- 
lat_1 <- places$results$geometry$viewport
lat_1

lat_2 <- places$results$geometry$location
lat_2

# Convert burguer places into Spacial points
coords <- cbind(Longitude=as.numeric(as.character(lat_2$lng)),
                Latitude = as.numeric(as.character(lat_2$lat)))

burguer_points <- SpatialPointsDataFrame(coords)
