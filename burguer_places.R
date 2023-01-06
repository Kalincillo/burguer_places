# This code will find the best reviewed burger places
# in ZMG (Guadalajara, Zapopan, Tlaquepaque, Tonala, Tlajomulco, El Salto)
# and the distance between them, i will use the rating system from
# Google maps and connect to the Google cloud API with R

library(ggmap)
library(mapproj)
library(googleway)
library(sp)
library(dplyr)

# increase number of prints
options(max.print = 2000)

# Coordinates for each zone
gdl_c <- c(20.687147541385254, -103.35064301216147)
zap_c <- c(20.72497886572655, -103.39110428359953)
# tlq <- c(20.639473311590486, -103.31204195796764)
# ton <- c(20.623958671818926, -103.24131114715028)
# tlj <- c(20.475015349386634, -103.44819685025686)
# sal <- c(20.519990183452695, -103.17931472569043)

# radius of approximately 3 km, if it is longer it can go beyond the 
# limit of the zone
rad <- 3000

# register to the API
register_google(Sys.getenv("PASSWORD"))

# -----------------------------------------------------------------------------
# *************************** GUADALAJARA *************************************

# Guadalajara burger places 1, 2 and 3 token
gdl_burger <- google_places(search_string='burger',
                            location=gdl_c,
                            radius=rad,
                            key=Sys.getenv("PASSWORD"))

token <- gdl_burger$next_page_token

gdl_burger_2 <- google_places(search_string='burger',
                            location=gdl_c,
                            radius=rad,
                            key=Sys.getenv("PASSWORD"),
                            page_token=token)

token <- gdl_burger_2$next_page_token

gdl_burger_3 <- google_places(search_string='burger',
                              location=gdl_c,
                              radius=rad,
                              key=Sys.getenv("PASSWORD"),
                              page_token=gdl_burger_2$token)
# append the 3 results
gdl <- rows_append(gdl_burger$results, gdl_burger_2$results) %>% 
  rows_append(gdl_burger_3$results)

# ************************** ZAPOPAN ******************************************
# Zapopan burger places 1, 2 and 3 token
zap_burger <- google_places(search_string='burger',
                             location=zap_c,
                             radius=rad,
                             key=Sys.getenv("PASSWORD"))

token <- zap_burger$next_page_token

zap_burger_2 <- google_places(search_string='burger',
                             location=zap_c,
                             radius=rad,
                             key=Sys.getenv("PASSWORD"),
                             page_token=zap_burger$token)

token <- zap_burger_2$next_page_token

zap_burger_3 <- google_places(search_string='burger',
                             location=zap_c,
                             radius=rad,
                             key=Sys.getenv("PASSWORD"),
                             page_token=zap_burger_2$token)

# append the 3 results
zap <- rows_append(zap_burger$results, zap_burger_2$results) %>% 
  rows_append(zap_burger_3$results)

# ***************************** TLAQUEPAQUE ***********************************

# Tlaquepaque burger places
# tlq_burger <- google_places(search_string='burger',
#                             location=tlq,
#                             radius=rad,
#                             key=Sys.getenv("PASSWORD"))

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
# ton_burger <- google_places(search_string='burger',
#                             location=ton,
#                             radius=rad,
#                             key=Sys.getenv("PASSWORD"))

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
# tlj_burger <- google_places(search_string='burger',
#                             location=tlj,
#                             radius=rad,
#                             key=Sys.getenv("PASSWORD"))

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
# sal_burger <- google_places(search_string='burger',
#                      location=sal,
#                      radius=rad,
#                      key=Sys.getenv("PASSWORD"))

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
# get latitude and longitude 
gdl_coords <- gdl$geometry$location
zap_coords <- zap$geometry$location
# first 20 searches
# tlq_coords <- tlq_burger$results$geometry$location
# ton_coords <- ton_burger$results$geometry$location
# tlj_coords <- tlj_burger$results$geometry$location
# sal_coords <- sal_burger$results$geometry$location

# # second 20 searches
# zap_coords_2 <- zap_burger_2$results$geometry$location
# tlq_coords_2 <- tlq_burger_2$results$geometry$location
# ton_coords_2 <- ton_burger_2$results$geometry$location
# tlj_coords_2 <- tlj_burger_2$results$geometry$location
# sal_coords_2 <- sal_burger_2$results$geometry$location
# 
# # third 20 searches
# zap_coords_3 <- zap_burger_3$results$geometry$location
# tlq_coords_3 <- tlq_burger_3$results$geometry$location
# ton_coords_3 <- ton_burger_3$results$geometry$location
# tlj_coords_3 <- tlj_burger_3$results$geometry$location
# sal_coords_3 <- sal_burger_3$results$geometry$location

# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# get name of places
gdl_places <- gdl$name
zap_places <- zap$name
# first 20 searches
# tlq_places <- tlq_burger$results$name
# ton_places <- ton_burger$results$name
# tlj__places <- tlj_burger$results$name
# sal_places <- sal_burger$results$name

# # second 20 searches
# tlq_places_2 <- tlq_burger_2$results$name
# ton_places_2 <- ton_burger_2$results$name
# tlj__places_2 <- tlj_burger_2$results$name
# sal_places_2 <- sal_burger_2$results$name
# 
# # third 20 searches
# tlq_places_3 <- tlq_burger_3$results$name
# ton_places_3 <- ton_burger_3$results$name
# tlj__places_3 <- tlj_burger_3$results$name
# sal_places_3 <- sal_burger_3$results$name

# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# ****************************** MAPS ****************************************

# GUADALAJARA
gdl_map <- qmap(rev(gdl_c), zoom=13, maptype="hybrid") +
  geom_point(data = gdl,
             aes(x = gdl_coords$lng,
                 y = gdl_coords$lat),
             color='red', size=3)

# ZAPOPAN
zap_map <- qmap(rev(zap_c), zoom=13, maptype="hybrid") +
  geom_point(data = zap,
             aes(x = zap_coords$lng,
                 y = zap_coords$lat),
             color='green', size=3)

# --------------------------------------------------------------------------

