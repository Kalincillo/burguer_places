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

# radius of approximately 3 km, if it is longer it can go beyond the 
# limit of the zone
rad <- 3000

# register to the API
register_google(Sys.getenv("PASSWORD"))

# search for places for each zone from the center of the city with a
# 10km radius

# ---------------------------------------------------------------------------
# Guadalajara burger places 1, 2 and 3 token
gdl_burger <- google_places(search_string='burger',
                            location=gdl,
                            radius=rad,
                            key=Sys.getenv("PASSWORD"))

# gdl_burger_2 <- google_places(search_string='burger',
#                             location=gdl,
#                             radius=rad,
#                             key=Sys.getenv("PASSWORD"),
#                             page_token=gdl_burger$next_page_token)
# 
# gdl_burger_3 <- google_places(search_string='burger',
#                               location=gdl,
#                               radius=rad,
#                               key=Sys.getenv("PASSWORD"),
#                               page_token=gdl_burger_2$next_page_token)

# Zapopan burger places
zap_burger <- google_places(search_string='burger',
                            location=zap,
                            radius=rad,
                            key=Sys.getenv("PASSWORD"))

# zap_burger_2 <- google_places(search_string='burger',
#                             location=zap,
#                             radius=rad,
#                             key=Sys.getenv("PASSWORD"),
#                             page_token=zap_burger$next_page_token)
# 
# zap_burger_3 <- google_places(search_string='burger',
#                             location=zap,
#                             radius=rad,
#                             key=Sys.getenv("PASSWORD"),
#                             page_token=zap_burger_2$next_page_token)

# Tlaquepaque burger places
tlq_burger <- google_places(search_string='burger',
                            location=tlq,
                            radius=rad,
                            key=Sys.getenv("PASSWORD"))

# tlq_burger_2 <- google_places(search_string='burger',
#                             location=tlq,
#                             radius=rad,
#                             key=Sys.getenv("PASSWORD"),
#                             page_token=tlq_burger$next_page_token)
# 
# tlq_burger_3 <- google_places(search_string='burger',
#                               location=tlq,
#                               radius=rad,
#                               key=Sys.getenv("PASSWORD"),
#                               page_token=tlq_burger_2$next_page_token)
# Tonala burger places
ton_burger <- google_places(search_string='burger',
                            location=ton,
                            radius=rad,
                            key=Sys.getenv("PASSWORD"))

# ton_burger_2 <- google_places(search_string='burger',
#                             location=ton,
#                             radius=rad,
#                             key=Sys.getenv("PASSWORD"),
#                             page_token=ton_burger$next_page_token)
# 
# ton_burger_3 <- google_places(search_string='burger',
#                               location=ton,
#                               radius=rad,
#                               key=Sys.getenv("PASSWORD"),
#                               page_token=ton_burger_2$next_page_token)

# Tlajomulco burger places
tlj_burger <- google_places(search_string='burger',
                            location=tlj,
                            radius=rad,
                            key=Sys.getenv("PASSWORD"))

# tlj_burger_2 <- google_places(search_string='burger',
#                             location=tlj,
#                             radius=rad,
#                             key=Sys.getenv("PASSWORD"),
#                             page_token=tlj_burger$next_page_token)
# 
# tlj_burger_3 <- google_places(search_string='burger',
#                               location=tlj,
#                               radius=rad,
#                               key=Sys.getenv("PASSWORD"),
#                               page_token=tlj_burger_2$next_page_token)
# El salto burger places
sal_burger <- google_places(search_string='burger',
                     location=sal,
                     radius=rad,
                     key=Sys.getenv("PASSWORD"))

# sal_burger_2 <- google_places(search_string='burger',
#                      location=sal,
#                      radius=rad,
#                      key=Sys.getenv("PASSWORD"),
#                      page_token=sal$next_page_token)
# 
# sal_burger_3 <- google_places(search_string='burger',
#                        location=sal,
#                        radius=rad,
#                        key=Sys.getenv("PASSWORD"),
#                        page_token=sal_2$next_page_token)
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# get latitude and longitude of the first 20 places for each search

# first 20 searches
gdl_coords <- gdl_burger$results$geometry$location
zap_coords <- zap_burger$results$geometry$location
tlq_coords <- tlq_burger$results$geometry$location
ton_coords <- ton_burger$results$geometry$location
tlj_coords <- tlj_burger$results$geometry$location
sal_coords <- sal_burger$results$geometry$location

# # second 20 searches
# gdl_coords_2 <- gdl_burger_2$results$geometry$location
# zap_coords_2 <- zap_burger_2$results$geometry$location
# tlq_coords_2 <- tlq_burger_2$results$geometry$location
# ton_coords_2 <- ton_burger_2$results$geometry$location
# tlj_coords_2 <- tlj_burger_2$results$geometry$location
# sal_coords_2 <- sal_burger_2$results$geometry$location
# 
# # third 20 searches
# gdl_coords_3 <- gdl_burger_3$results$geometry$location
# zap_coords_3 <- zap_burger_3$results$geometry$location
# tlq_coords_3 <- tlq_burger_3$results$geometry$location
# ton_coords_3 <- ton_burger_3$results$geometry$location
# tlj_coords_3 <- tlj_burger_3$results$geometry$location
# sal_coords_3 <- sal_burger_3$results$geometry$location

# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# get name of places of the first 20 places for each search

# first 20 searches
gdl_places <- gdl_burger$results$name
zap_places <- zap_burger$results$name
tlq_places <- tlq_burger$results$name
ton_places <- ton_burger$results$name
tlj__places <- tlj_burger$results$name
sal_places <- sal_burger$results$name

# # second 20 searches
# gdl_places_2 <- gdl_burger_2$results$name
# zap_places_2 <- zap_burger_2$results$name
# tlq_places_2 <- tlq_burger_2$results$name
# ton_places_2 <- ton_burger_2$results$name
# tlj__places_2 <- tlj_burger_2$results$name
# sal_places_2 <- sal_burger_2$results$name
# 
# # third 20 searches
# gdl_places_3 <- gdl_burger_3$results$name
# zap_places_3 <- zap_burger_3$results$name
# tlq_places_3 <- tlq_burger_3$results$name
# ton_places_3 <- ton_burger_3$results$name
# tlj__places_3 <- tlj_burger_3$results$name
# sal_places_3 <- sal_burger_3$results$name

# -----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# *************** Convert burger places into Spacial points *******************

# first 20 searches
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

# # second 20 searches
# sp_gdl_2 <- cbind(Longitude=as.numeric(as.character(gdl_coords_2$lng)),
#                 Latitude = as.numeric(as.character(gdl_coords_2$lat)))
# 
# sp_zap_2 <- cbind(Longitude=as.numeric(as.character(zap_coords_2$lng)),
#                 Latitude = as.numeric(as.character(zap_coords_2$lat)))
# 
# sp_tlq_2 <- cbind(Longitude=as.numeric(as.character(tlq_coords_2$lng)),
#                 Latitude = as.numeric(as.character(tlq_coords_2$lat)))
# 
# sp_to_2 <- cbind(Longitude=as.numeric(as.character(ton_coords_2$lng)),
#                 Latitude = as.numeric(as.character(ton_coords_2$lat)))
# 
# sp_tlj_2 <- cbind(Longitude=as.numeric(as.character(tlj_coords_2$lng)),
#                 Latitude = as.numeric(as.character(tlj_coords_2$lat)))
# 
# sp_sal_2 <- cbind(Longitude=as.numeric(as.character(sal_coords_2$lng)),
#                 Latitude = as.numeric(as.character(sal_coords_2$lat)))
# 
# # third 20 searches
# sp_gdl_3 <- cbind(Longitude=as.numeric(as.character(gdl_coords_3$lng)),
#                   Latitude = as.numeric(as.character(gdl_coords_3$lat)))
# 
# sp_zap_3 <- cbind(Longitude=as.numeric(as.character(zap_coords_3$lng)),
#                   Latitude = as.numeric(as.character(zap_coords_3$lat)))
# 
# sp_tlq_3 <- cbind(Longitude=as.numeric(as.character(tlq_coords_3$lng)),
#                   Latitude = as.numeric(as.character(tlq_coords_3$lat)))
# 
# sp_to_3 <- cbind(Longitude=as.numeric(as.character(ton_coords_3$lng)),
#                  Latitude = as.numeric(as.character(ton_coords_3$lat)))
# 
# sp_tlj_3 <- cbind(Longitude=as.numeric(as.character(tlj_coords_3$lng)),
#                   Latitude = as.numeric(as.character(tlj_coords_3$lat)))
# 
# sp_sal_3 <- cbind(Longitude=as.numeric(as.character(sal_coords_2$lng)),
#                   Latitude = as.numeric(as.character(sal_coords_2$lat)))
# -----------------------------------------------------------------------------

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

