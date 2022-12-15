library(ggmap)
library(mapproj)
library(googleway)


key <- Sys.getenv("pw")
register_google(key)

places <- google_places(search_string = 'ramen', 
                        location=c(20.687408505134194, -103.35158714983811), 
                        radius=5000, key=llave)

places$results$geometry$location

places_2 <- google_places(search_string = 'ramen', 
                        location=c(20.687408505134194, -103.35158714983811), 
                        radius=5000, key=llave, 
                        page_token=places$next_page_token )
places_2

qmap('Guadalajara', zoom = 12, maptype = "satellite")

getwd()
