## Created 12 / January / 2016
## Updates 06 / February / 2017
## Marina Costa Rillo
##
## Code that uses the raw CSV file of the Buckley Collection downloaded from the NHM Data Portal
##
## Reads "BuckleyCollection_DataPortal.csv"
## Creates "Coordinates_Buckley.csv" (with sample_type column)
##

rm(list=ls())

setwd("/Users/marinacostarillo/Google Drive/DOUTORADO/R_data")

buckley_table <- read.csv("Buckley_Collection/BuckleyCollection_DataPortal.csv", header = TRUE, stringsAsFactors=FALSE)
# buckley_table = read.csv("Buckley_total_JMicrop.csv", header = TRUE, stringsAsFactors=FALSE)
# buckley_table = buckley_table[,1:which(colnames(buckley_table)=="Ocean.Sea")] # in case csv file includes empty columns

names(buckley_table)[names(buckley_table) == "Long.decimal"] = "long"
names(buckley_table)[names(buckley_table) == "Lat.decimal"] = "lat"
names(buckley_table)[names(buckley_table) == "No_of_individuals"] = "no_ind"
names(buckley_table)[names(buckley_table) == "ZF_PF_no."] = "Foram_no"

### Taxonomic update
buckley_table[which(buckley_table[,"Species"]=="eggeri"),"Species"] = "dutertrei"
buckley_table[which(buckley_table[,"Species"]=="aequilateralis/siphonifera"),"Species"] = "siphonifera"
buckley_table[which(buckley_table[,"Species"]=="aequilateralis"),"Species"] = "siphonifera"
buckley_table[which(buckley_table[,"Species"]=="aequilateralis "),"Species"] = "siphonifera"
buckley_table[which(buckley_table[,"Species"]=="incompta"),"Species"] = "pachyderma"
# sort(unique(buckley_table[,"Species"]))

names(buckley_table)
coord_table = unique(buckley_table[,c("lat","long","Sample_depth_min_cm", "Sample_depth_max_cm",
                                      "Sea_Depth_meters_NOAA", "Sea_Depth_meters")])

### Removing samples that do not have coordinates info
coord_table <- coord_table[order(coord_table[,"lat"]),]
length(coord_table[,1])
nas <- which(is.na(coord_table[,"lat"]))
length(nas)
coord_table <- coord_table[-nas,]
length(coord_table[,1])

# Adding "sample_type" column: tow, top_core, deep_core, land, no_info
deep = 15 
coord_table[,"sample_type"] <- NA
names(coord_table)
coord_table[which(as.numeric(coord_table[,"Sample_depth_max_cm"])<=deep),"sample_type"]="top_core" # NA introduced because some sample depth are empty
coord_table[which(as.numeric(coord_table[,"Sample_depth_max_cm"])>deep),"sample_type"]="deep_core" # NA introduced because some sample depth are empty
coord_table[which(is.na(coord_table[,"sample_type"])),"sample_type"]="no_info"
coord_table[which(coord_table[,"Sample_depth_min_cm"]==c("tow")),c("sample_type")] = "tow"
coord_table[which(coord_table[,"Sample_depth_min_cm"]==c("land")), c("sample_type")] = "land"


# Number of unique coordinates
length(unique(coord_table[,c("lat","long", "Sample_depth_min_cm")])[,1])
length(unique(coord_table[,c("lat","long")])[,1])
sum(duplicated(coord_table[,c("lat","long")])) == length(unique(coord_table[,c("lat","long","Sample_depth_min_cm","Sample_depth_max_cm","sample_type","Sea_Depth_meters_NOAA")])[,1]) - length(unique(coord_table[,c("lat","long")])[,1])
# check <- data.frame(duplicated(coord_table[,c("lat","long")]), coord_table[,c("lat", "long","Sample_depth_min_cm","Sample_depth_max_cm", "sample_type")])
# names(check) <- c("check","lat","long","Sample_depth_min_cm","Sample_depth_max_cm","sample_type")
# write.csv(check, file = "Buckley_Collection/check_coord.csv",row.names=FALSE)

### Fixing coordinates that have more than one top_core (e.g. 0-3.5cm, 4-5.5cm, 12-13cm)
lat_fix <- c(-19.475, 7.193, 36.543) # doing it by hand, based on "check" right above
rows_fix <- which(round(coord_table[,"lat"],3) %in% lat_fix & coord_table[,"sample_type"] == c("top_core"))
coord_table[rows_fix,"sample_type"] = rep("deep_core", length(rows_fix))
coord_table[which(coord_table[,"Sample_depth_min_cm"]==0),"sample_type"] = rep("top_core", length(which(coord_table[,"Sample_depth_min_cm"]==0)))
coord_table[rows_fix,]


### Adding difference between BUCKLEY SEA DEPTH and NOAA SEA DEPTH 
coord_table[,"Diff_Buckley_NOAA"] = NA
sea_floor_sample = c("top_core","no_info","deep_core")
diff_rows = which(coord_table[,"sample_type"] %in% sea_floor_sample)
coord_table[diff_rows,"Diff_Buckley_NOAA"] = as.numeric(coord_table[diff_rows,"Sea_Depth_meters"]) + coord_table[diff_rows ,"Sea_Depth_meters_NOAA"]


### Adding Ocean and OBD IRN information
coord_table[,"Ocean"] = 0
coord_table[,"OBD_IRN"] = 0
for (i in 1 : length(coord_table[,1])){
	same_latlong = c()
	same_latlong = c(same_latlong, which(coord_table[i,"lat"] == buckley_table[,"lat"] & 
		coord_table[i,"long"] == buckley_table[,"long"]) )
	coord_table[i, "Ocean"] = unique(buckley_table[same_latlong,"Ocean_Sea"])[1]
	coord_table[i, "OBD_IRN"] = unique(buckley_table[same_latlong,"IRN_Residue_OBD"])[1]
}


### Adding EXTRA OBD IRN information
OBD_table = read.csv("Buckley_Collection/OBD.csv", header = TRUE, stringsAsFactors=FALSE)
head(OBD_table)
OBD_table[,"info"] <- paste(OBD_table[,3],OBD_table[,4], sep = "|")
coord_table[,"OBD_IRN_extra_info"] = 0
for (i in 1 : length(coord_table[,1])){
	same_IRN = c()
	same_IRN = c(same_IRN, which(coord_table[i,"OBD_IRN"] == OBD_table[,"IRN"]))
	coord_table[i,"OBD_IRN_extra_info"] = unique(OBD_table[same_IRN,"info"])[1]
}


### Ordering and saving coord_table
coord_table = coord_table[order(coord_table[,"sample_type"],coord_table[,"lat"]),]
write.csv(coord_table, file = "Buckley_Collection/Coordinates_Buckley.csv",row.names=FALSE)

