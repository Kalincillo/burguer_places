
# Read the 6 csv files
gdl_csv <- read.csv("gdl.csv")
zap_csv <- read.csv("zap.csv")
tlq_csv <- read.csv("tlq.csv")
sal_csv <- read.csv("sal.csv")
tlj_csv <- read.csv("tlj.csv")
ton_csv <- read.csv("ton.csv")

# Join all the results
zmg_csv <- bind_rows(gdl_csv, zap_csv,
                     tlq_csv, sal_csv,
                     tlj_csv, ton_csv)

# Sort by rating
zmg_csv <- arrange(zmg_csv, desc(rating))

# drop id column and reorder columns
zmg_csv <- subset(zmg_csv, select = c(keeps, 'lat', 'lng'))
zmg_csv <- zmg_csv[, c(2, 3, 1, 4, 5, 6)]

# Save csv file
write.csv(zmg_csv, file=file.path(wd, "/zmg.csv"))

# *****************************************************************************
# ***************************** MAPPING ***************************************

mp <- google_map(
  key = Sys.getenv("PASSWORD"),
  data = zmg_csv,
  location = gdl_c,
  zoom = 14) %>% 
  add_markers(lat='lat', lon='lng', mouse_over = 'name' )


# *****************************************************************************
# *****************************************************************************




