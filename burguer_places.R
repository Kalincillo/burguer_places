# This code will find the best reviewed burger places
# in ZMG (Guadalajara, Zapopan, Tlaquepaque, Tonala, Tlajomulco, El Salto)
# and the distance between them, i will use the rating system from
# Google maps and connect to the Google cloud API with R

# -------------------------- LIBRARIES ----------------------------------------
library(ggmap)
library(mapproj)
library(googleway)
library(sp)
library(dplyr)
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# increase number of prints
options(max.print = 2000)

# Coordinates for each zone
gdl_c <- c(20.687147541385254, -103.35064301216147)
zap_c <- c(20.72497886572655, -103.39110428359953)
tlq_c <- c(20.639473311590486, -103.31204195796764)
ton_c <- c(20.623958671818926, -103.24131114715028)
tlj_c <- c(20.475015349386634, -103.44819685025686)
sal_c <- c(20.519990183452695, -103.17931472569043)

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

# Delay to prevent the API to generate the token
Sys.sleep(5)

gdl_burger_2 <- google_places(search_string='burger',
                            location=gdl_c,
                            radius=rad,
                            key=Sys.getenv("PASSWORD"),
                            page_token=token)

token <- gdl_burger_2$next_page_token

# Delay to prevent the API to generate the token
Sys.sleep(5)

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

# Delay to prevent the API to generate the token
Sys.sleep(5)

zap_burger_2 <- google_places(search_string='burger',
                             location=zap_c,
                             radius=rad,
                             key=Sys.getenv("PASSWORD"),
                             page_token=zap_burger$token)

token <- zap_burger_2$next_page_token

# Delay to prevent the API to generate the token
Sys.sleep(5)

zap_burger_3 <- google_places(search_string='burger',
                             location=zap_c,
                             radius=rad,
                             key=Sys.getenv("PASSWORD"),
                             page_token=zap_burger_2$token)

# append the 3 results
zap <- rows_append(zap_burger$results, zap_burger_2$results) %>% 
  rows_append(zap_burger_3$results)

# ***************************** TLAQUEPAQUE ***********************************
# Tlaquepaque burger places 1, 2 and 3 token
tlq_burger <- google_places(search_string='burger',
                             location=tlq_c,
                             radius=rad,
                             key=Sys.getenv("PASSWORD"))

token <- tlq_burger$next_page_token

# Delay to prevent the API to generate the token
Sys.sleep(5)

tlq_burger_2 <- google_places(search_string='burger',
                             location=tlq_c,
                             radius=rad,
                             key=Sys.getenv("PASSWORD"),
                             page_token=token)

token <- tlq_burger_2$next_page_token

# Delay to prevent the API to generate the token
Sys.sleep(5)
 
tlq_burger_3 <- google_places(search_string='burger',
                               location=tlq_c,
                               radius=rad,
                               key=Sys.getenv("PASSWORD"),
                               page_token=tlq_burger_2$next_page_token)

# append the 3 results
tlq <- rows_append(tlq_burger$results, tlq_burger_2$results) %>% 
  rows_append(tlq_burger_3$results)

# ***************************** TONALA ****************************************
# Tonala burger places 1, 2 and 3 token
ton_burger <- google_places(search_string='burger',
                             location=ton_c,
                             radius=rad,
                             key=Sys.getenv("PASSWORD"))

token <- ton_burger$next_page_token

# Delay to prevent the API to generate the token
Sys.sleep(5)

ton_burger_2 <- google_places(search_string='burger',
                             location=ton_c,
                             radius=rad,
                             key=Sys.getenv("PASSWORD"),
                             page_token=token)

token <- ton_burger_2$next_page_token

# Delay to prevent the API to generate the token
Sys.sleep(5)
 
ton_burger_3 <- google_places(search_string='burger',
                               location=ton_c,
                               radius=rad,
                               key=Sys.getenv("PASSWORD"),
                               page_token=token)

# append the 3 results
ton <- rows_append(ton_burger$results, ton_burger_2$results) %>% 
  rows_append(ton_burger_3$results)


# ***************************** TLAJOMULCO ************************************
# Tlajomulco burger places 1, 2 and 3 token
tlj_burger <- google_places(search_string='burger',
                             location=tlj_c,
                             radius=rad,
                             key=Sys.getenv("PASSWORD"))

token <- tlj_burger$next_page_token

# Delay to prevent the API to generate the token
Sys.sleep(5)

tlj_burger_2 <- google_places(search_string='burger',
                             location=tlj_c,
                             radius=rad,
                             key=Sys.getenv("PASSWORD"),
                             page_token=token)

token <- tlj_burger_2$next_page_token

# Delay to prevent the API to generate the token
Sys.sleep(5)
 
tlj_burger_3 <- google_places(search_string='burger',
                               location=tlj_c,
                               radius=rad,
                               key=Sys.getenv("PASSWORD"),
                               page_token=token)

# append the 3 results
tlj <- rows_append(tlj_burger$results, tlj_burger_2$results) %>% 
  rows_append(tlj_burger_3$results)

# ****************************** EL SALTO *************************************
# El salto burger places
sal_burger <- google_places(search_string='burger',
                      location=sal_c,
                      radius=rad,
                      key=Sys.getenv("PASSWORD"))

token <- sal_burger$next_page_token

# Delay to prevent the API to generate the token
Sys.sleep(5)

sal_burger_2 <- google_places(search_string='burger',
                      location=sal_c,
                      radius=rad,
                      key=Sys.getenv("PASSWORD"),
                      page_token=token)

token <- sal_burger_2$next_page_token

# Delay to prevent the API to generate the token
Sys.sleep(5)
 
sal_burger_3 <- google_places(search_string='burger',
                        location=sal_c,
                        radius=rad,
                        key=Sys.getenv("PASSWORD"),
                        page_token=token)

# append the 3 results
tlj <- rows_append(tlj_burger$results, tlj_burger_2$results) %>% 
  rows_append(tlj_burger_3$results)

# ****************************************************************************
# -----------------------------------------------------------------------------

# -------------------------- COORDINATES --------------------------------------
# get latitude and longitude 
gdl_coords <- gdl$geometry$location
zap_coords <- zap$geometry$location
tlq_coords <- tlq$geometry$location
ton_coords <- ton$geometry$location
tlj_coords <- tlj$geometry$location
sal_coords <- sal$geometry$location

# -----------------------------------------------------------------------------


# ------------------------------ BURGER PLACES --------------------------------
# get name of places
gdl_places <- gdl$name
zap_places <- zap$name
tlq_places <- tlq$name
ton_places <- ton$name
tlj_places <- tlj$name
sal_places <- sal$name
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

# TLAQUEPAQUE
tlq_map <- qmap(rev(tlq_c), zoom=13, maptype="hybrid") +
  geom_point(data = tlq,
             aes(x = tlq_coords$lng,
                 y = tlq_coords$lat),
             color='violetred1', size=3)

# TONALA
ton_map <- qmap(rev(ton_c), zoom=13, maptype="hybrid") +
  geom_point(data = ton,
             aes(x = ton_coords$lng,
                 y = ton_coords$lat),
             color='orangered', size=3)

# TLAJOMULCO
tlj_map <- qmap(rev(tlj_c), zoom=13, maptype="hybrid") +
  geom_point(data = tlj,
             aes(x = tlj_coords$lng,
                 y = tlj_coords$lat),
             color='darkgreen', size=3)

# EL SALTO
ton_map <- qmap(rev(sal_c), zoom=13, maptype="hybrid") +
  geom_point(data = sal,
             aes(x = sal_coords$lng,
                 y = sal_coords$lat),
             color='slateblue4', size=3)

# --------------------------------------------------------------------------

