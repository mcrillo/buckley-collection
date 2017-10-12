## Created 06 / February / 2017
## Marina Costa Rillo
##
## Code to find NOAA sea depth for Buckley Collection coordinates
## 
## Uses "BuckleyCollection_DataPortal.csv" & "marmap_coord_-180;-90;180;90_res_5.csv"
##
## Updates "BuckleyCollection_DataPortal.csv"
##

rm(list=ls())
library(marmap)

setwd("/Users/marinacostarillo/Google Drive/DOUTORADO/R_data")
buckley_table <- read.csv("Buckley_Collection/BuckleyCollection_DataPortal.csv", header = TRUE, stringsAsFactors=FALSE)

### Adding NOAA SEA DEPTH to coord_table 
## Code to get sea depth given coordinates (uses marmap and NOAA data)
## If marmap_buckley_NOAA_depth.csv files already exist, no need to run this out-commented part

# Getting NOAA database from the internet  - TAKES QUITE SOME TIME!!
# OBS: resolution = 5 minutes ; keep = TRUE will save data automatically as marmap_coord.csv)
# sea_depth = getNOAA.bathy(180, -180, 90, -90, resolution = 2, keep=TRUE, antimeridian=FALSE)
# sea_depth is already of class bathy

# Getting sea depths from already saved table marmap_coord_-180;-90;180;90_res_5.csv (in folder Ocean_Environment)
sea_depth <- read.csv("/Users/marinacostarillo/Google Drive/DOUTORADO/R_data/Ocean_Environment/marmap_coord_-180;-90;180;90_res_5.csv")
sea_depth <- as.bathy(sea_depth)
is.bathy(sea_depth)
NOAA_coord = unique(na.omit(buckley_table[,c("Lat.decimal","Long.decimal")]))
NOAA_depth_table = get.depth(sea_depth, x=NOAA_coord[,"Long.decimal"], y=NOAA_coord[,"Lat.decimal"], locator=FALSE, distance=FALSE)
write.csv(NOAA_depth_table, file = "Buckley_Collection/marmap_buckley_depths.csv",row.names=FALSE)


NOAA_depth_table = read.csv("Buckley_Collection/marmap_buckley_depths.csv", header = TRUE)

for (i in 1 : length(buckley_table[,1])){
  same_latlong = c()
  same_latlong = c(same_latlong, which(buckley_table[i,"Lat.decimal"] == NOAA_depth_table[,"lat"] & 
                                         buckley_table[i,"Long.decimal"] == NOAA_depth_table[,"lon"]) ) 
  if (length(same_latlong) > 0){
    buckley_table[i, "Sea.Depth..m....modern.methods"] = unique(NOAA_depth_table[same_latlong,"depth"])
  }
}


# Fixing the "land" and depth > 0
unique(buckley_table[which(buckley_table[,"Sample.depth.MIN..cm."]==c("land") | buckley_table[,"Sea.Depth..m....modern.methods"]>0 ),
                    c("Lat.decimal","Long.decimal","Sample.depth.MIN..cm.","Sea.Depth..m....modern.methods")])
# 2 Samples are wrong
# 1st Sample
buckley_table[which(buckley_table[,"Lat.decimal"]== 18.23300 & buckley_table[,"Long.decimal"] == -76.60000),]
print(buckley_table[which(buckley_table[,"Lat.decimal"]== 18.23300 & buckley_table[,"Long.decimal"] == -76.60000),"Collection.info"])
# "1/2 mile E of Buff Bay, Jamaica" ~ Lat 18.250622  Long  -76.544666 (I looked on a map)
get.depth(sea_depth, x=-76.544666, y=18.250622, locator=FALSE, distance=FALSE)
buckley_table[which(buckley_table[,"Lat.decimal"]== 18.23300 & buckley_table[,"Long.decimal"] == -76.60000),"Sea.Depth..m....modern.methods"] <- -606
# 2nd Sample
buckley_table[which(buckley_table[,"Lat.decimal"]== 15.21700 & buckley_table[,"Long.decimal"] == 145.76700),]
#  Saipan Island ~ Lat 18.250622  Long  145.744684 (I looked on a map)
get.depth(sea_depth, x=15.191158, y=15.191158, locator=FALSE, distance=FALSE)
buckley_table[which(buckley_table[,"Lat.decimal"]== 15.21700 & buckley_table[,"Long.decimal"] == 145.76700),"Sea.Depth..m....modern.methods"] <- c(23,23)


# Checking NAs - the NAs are all from samples without Lat and Long info
buckley_table[which(is.na(buckley_table[,"Sea.Depth..m....modern.methods"])),
              c("Lat.decimal","Long.decimal","Sample.depth.MIN..cm.","Sea.Depth..m....modern.methods")]


# Saving buckley_table 
write.csv(buckley_table, file = "Buckley_Collection/BuckleyCollection_DataPortal.csv",row.names=FALSE)



