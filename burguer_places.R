# This code will find the best reviewed burger places
# in ZMG (Guadalajara, Zapopan, Tlaquepaque, Tonala, Tlajomulco, El Salto)
# and the distance between them, i will use the rating system from
# Google maps and connect to the Google cloud API with R

# LIBRARIES -------

library(ggmap)
library(mapproj)
library(googleway)
library(sp)
library(dplyr)

# ------------------

# ----------------------------- SET-UP ----------------------------------------
# increase number of prints and save working directory
wd <- getwd()
options(max.print = 2000)

# columns of interest
keeps <- c("formatted_address", "name", 
           "rating", "user_ratings_total")

# Coordinates for each zone
gdl_c <- c(20.687147541385254, -103.35064301216147)
zap_c <- c(20.738511340844003, -103.40372375191114)
tlq_c <- c(20.639473311590486, -103.31204195796764)
ton_c <- c(20.623958671818926, -103.24131114715028)
tlj_c <- c(20.475015349386634, -103.44819685025686)
sal_c <- c(20.519990183452695, -103.17931472569043)

# radius of approximately 3 km, if it is longer it can go beyond the 
# limit of the zone
rad <- 2800

# register to the API
register_google(Sys.getenv("PASSWORD"))

# ----------------------------------------------------------------------------

# *****************************************************************************
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
                              page_token=token)

# append the 3 results and filter restaurants with more than 100 reviews
gdl <- rows_append(gdl_burger$results, gdl_burger_2$results) %>%
  rows_append(gdl_burger_3$results) %>%
  filter(user_ratings_total > 100) %>%
  data.frame()

# Filter top 10 burger places
gdl <- arrange(gdl, desc(rating)) %>% head(10)

# Add the subset of locations
locations_gdl <- gdl$geometry$location

# Clean unused columns
gdl <- subset(gdl, select = keeps)

# append the locations and reordering
gdl <- cbind(gdl, locations_gdl)
gdl <- gdl[, c(2, 1, 3, 4, 5, 6)]

# Check manually if they are in fact in Guadalajara  and save the files
# in a csv file
write.csv(gdl, file=file.path(wd, "/gdl.csv"))

# *************************** GUADALAJARA *************************************
# *****************************************************************************


# **************************************************************************
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
                             page_token=token)

token <- zap_burger_2$next_page_token

# Delay to prevent the API to generate the token
Sys.sleep(5)

zap_burger_3 <- google_places(search_string='burger',
                             location=zap_c,
                             radius=rad,
                             key=Sys.getenv("PASSWORD"),
                             page_token=token)

# append the 3 results
zap <- rows_append(zap_burger$results, zap_burger_2$results) %>%
  rows_append(zap_burger_3$results[1:16])

# Clean data from other region in this case Guadalajara and filter
# restaurants with more than 50 reviews
addr <- zap$formatted_address
zap <- filter(zap, !grepl("Guadalajara", addr) & user_ratings_total > 50) %>%
  data.frame()

# Filter top 10 burger places
zap <- arrange(zap, desc(rating)) %>% head(10)

# Add the subset of locations
locations_zap <- zap$geometry$location

# Clean unused columns
zap <- subset(zap, select = keeps)

# append the locations and reordering
zap <- cbind(zap, locations_zap)
zap <- zap[, c(2, 1, 3, 4, 5, 6)]

# Check manually if they are in fact in Zapopan  and save the files
# in a csv file
write.csv(zap, file=file.path(wd, "/zap.csv"))

# ***************************** ZAPOPAN ***************************************
# *****************************************************************************


# **************************************************************************
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
                               page_token=token)

# append the 3 results
tlq <- rows_append(tlq_burger$results, tlq_burger_2$results) %>% 
  rows_append(tlq_burger_3$results)

# Clean data from other region in this case Guadalajara and filter 
# restaurants with more than 50 reviews
addr <- tlq$formatted_address
tlq <- filter(tlq,!grepl("Guadalajara", addr) & user_ratings_total > 50) %>% 
  data.frame()

# Keep all places (Total 5)
tlq <- arrange(tlq, desc(rating))

# Add the subset of locations
locations_tlq <- tlq$geometry$location

# Clean unused columns
tlq <- subset(tlq, select = keeps)

# append the locations and reordering
tlq <- cbind(tlq, locations_tlq)
tlq <- tlq[, c(2, 1, 3, 4, 5, 6)]
# Check manually if they are in fact in Guadalajara  and save the files 
# in a csv file 
write.csv(tlq, file=file.path(wd, "/tlq.csv"))

# ******************************* TLAQUEPAQUE *********************************
# *****************************************************************************


# *****************************************************************************
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

# reorder permanently_closed column
ton_burger_3$results <- ton_burger_3$results[, c(1:15, 17, 16)]

# append the 3 results
ton <- rows_append(ton_burger$results, ton_burger_2$results) %>% 
  rows_append(ton_burger_3$results[1:16])

# Clean data from other region in this case Guadalajara and Tlaquepaque 
addr <- ton$formatted_address
ton <- filter(ton, 
              !grepl("Guadalajara", addr) & !grepl("Tlaquepaque", addr)) %>% 
  data.frame()

# Filter results with more than 10 user ratings 
ton <- filter(ton, user_ratings_total > 10)

# Filter top 10 and sort by rating
ton <- arrange(ton, desc(rating)) %>% head(10)

# Add the subset of locations
locations_ton <- ton$geometry$location

# Clean unused columns
ton <- subset(ton, select = keeps)

# append the locations and reordering
ton <- cbind(ton, locations_ton)
ton <- ton[, c(2, 1, 3, 4, 5, 6)]
# Check manually if they are in fact in Guadalajara  and save the files 
# in a csv file 
write.csv(ton, file=file.path(wd, "/ton.csv"))

# ***************************** TONALA ****************************************
# *****************************************************************************

# *****************************************************************************
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

# reorder columns to be able to append them after
tlj_burger_2$results <- tlj_burger_2$results[, c(1:11, 13:16, 12)]

# append the 3 results
tlj <- rows_append(tlj_burger$results, tlj_burger_2$results) %>% 
  rows_append(tlj_burger_3$results[1:16])

# Clean data from other region in this case Guadalajara and Tlaquepaque,
# Zapopan and other regions.
addr <- tlj$formatted_address
tlj <- filter(tlj, 
              !grepl("Guadalajara", addr)
              & !grepl("Tlaquepaque", addr)
              & !grepl("Anita", addr)
              & !grepl("Geovillas", addr)
              & !grepl("Zapopan", addr)) %>% 
  data.frame()

# Filter results with more than 10 user ratings 
tlj <- filter(tlj, user_ratings_total > 10)

# Filter top 10 and sort by rating
tlj <- arrange(tlj, desc(rating)) %>% head(10)

# Add the subset of locations
locations_tlj <- tlj$geometry$location

# Clean unused columns
tlj <- subset(tlj, select = keeps)

# append the locations and reordering
tlj <- cbind(tlj, locations_tlj)
tlj <- tlj[, c(2, 1, 3, 4, 5, 6)]

# Check manually if they are in fact in Guadalajara  and save the files 
# in a csv file 
write.csv(tlj, file=file.path(wd, "/tlj.csv"))


# *****************************************************************************
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
sal <- rows_append(sal_burger$results, sal_burger_2$results) %>% 
  rows_append(sal_burger_3$results)

# Clean data from other region in this case Guadalajara and Tlaquepaque,
# Zapopan and other regions.
addr <- sal$formatted_address
sal <- filter(sal, 
              !grepl("Guadalajara", addr)
              & !grepl("Tlaquepaque", addr)
              & !grepl("Anita", addr)
              & !grepl("Geovillas", addr)
              & !grepl("Zapopan", addr)
              & !grepl("45875", addr)
              & !grepl("Tonalá", addr)
              & !grepl("Zapotlanejo", addr)
              & !grepl("45887", addr)
              & !grepl("Tlajomulco", addr)
              & !grepl("45675", addr)) %>% 
  data.frame()

# Filter results with more than 10 user ratings 
sal <- filter(sal, user_ratings_total > 10)

# Sort results by rating
sal <- arrange(sal, desc(rating))

# Add the subset of locations
locations_sal <- sal$geometry$location

# Clean unused columns
sal <- subset(sal, select = keeps)

# append the locations and reordering
sal <- cbind(sal, locations_sal)
sal <- sal[, c(2, 1, 3, 4, 5, 6)]

# Check manually if they are in fact in Guadalajara  and save the files 
# in a csv file 
write.csv(sal, file=file.path(wd, "/sal.csv"))


# *****************************************************************************
# *****************************************************************************

