# This code will find the best reviewed burger places
# in ZMG (Guadalajara, Zapopan, Tlaquepaque, Tonala, Tlajomulco, El Salto)
# and the distance between them, i will use the rating system from
# Google maps and connect to the Google cloud API with R

library(ggmap)
library(mapproj)
library(googleway)
library(sp)
library(dplyr)

# Coordinates for each zone
gdl <- c(20.687147541385254, -103.35064301216147)
zap <- c(20.72497886572655, -103.39110428359953)
tlq <- c(20.639473311590486, -103.31204195796764)
ton <- c(20.623958671818926, -103.24131114715028)
tlj <- c(20.475015349386634, -103.44819685025686)
sal <- c(20.519990183452695, -103.17931472569043)

# radius
rad <- 5000

# register to the API
register_google(Sys.getenv("PASSWORD"))

# search for places for each zone from the center of the city with a
# 10km radius

# ---------------------------------------------------------------------------
# Guadalajara burger places
gdl_burger <- google_places(search_string='burger',
                            location=gdl,
                            radius=rad,
                            key=Sys.getenv("PASSWORD"))
# Zapopan burger places
zap_burger <- google_places(search_string='burger',
                            location=zap,
                            radius=rad,
                            key=Sys.getenv("PASSWORD"))
# Tlaquepaque burger places
tlq_burger <- google_places(search_string='burger',
                            location=tlq,
                            radius=rad,
                            key=Sys.getenv("PASSWORD"))
# Tonala burger places
ton_burger <- google_places(search_string='burger',
                            location=ton,
                            radius=rad,
                            key=Sys.getenv("PASSWORD"))
# Tlajomulco burger places
tlj_burger <- google_places(search_string='burger',
                            location=tlj,
                            radius=rad,
                            key=Sys.getenv("PASSWORD"))
# El salto burger places
sal <- google_places(search_string='burger',
                     location=sal,
                     radius=rad,
                     key=Sys.getenv("PASSWORD"))
# ---------------------------------------------------------------------------

# get latitude and longitude of the first 20 places
gdl_coords <- gdl_burger$results$geometry$location
zap_coords <- zap_burger$results$geometry$location
tlq_coords <- tlq_burger$results$geometry$location
ton_coords <- ton_burger$results$geometry$location
tlj_coords <- tlj_burger$results$geometry$location
sal_coords <- sal_burger$results$geometry$location


# Convert burger places into Spacial points
sp_gdl <- cbind(Longitude=as.numeric(as.character(gdl_coords$lng)),
                Latitude = as.numeric(as.character(gdl_coords$lat)))

sp_zap <- cbind(Longitude=as.numeric(as.character(zap_coords$lng)),
                Latitude = as.numeric(as.character(zap_coords$lat)))

sp_tlq <- cbind(Longitude=as.numeric(as.character(tlq_coords$lng)),
                Latitude = as.numeric(as.character(tlq_coords$lat)))

sp_ton <- cbind(Longitude=as.numeric(as.character(ton_coords$lng)),
                Latitude = as.numeric(as.character(ton_coords$lat)))

sp_tlj <- cbind(Longitude=as.numeric(as.character(tlj_coords$lng)),
                Latitude = as.numeric(as.character(tlj_coords$lat)))

sp_sal <- cbind(Longitude=as.numeric(as.character(sal_coords$lng)),
                Latitude = as.numeric(as.character(sal_coords$lat)))

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

