
## Created 12 / January / 2016
## Marina Rillo
##
##
## Creates Coordinates.csv", "Samples_depth_definition.csv" and "Buckley_table_27Oct.csv"
##
## TO DO STILL: check if "top_core" comprise modern species only.
##

rm(list=ls())
setwd("/Users/marinacostarillo/Google Drive/DOUTORADO/R_data")
# setwd("/Users/Marina/Google Drive/DOUTORADO/R_data")


buckley_table = read.csv("Buckley_total_JMicrop.csv", header = TRUE, stringsAsFactors=FALSE)
buckley_table = buckley_table[,1:which(colnames(buckley_table)=="Ocean.Sea")]

names(buckley_table)[names(buckley_table) == "Long.decimal"] = "long"
names(buckley_table)[names(buckley_table) == "Lat.decimal"] = "lat"
names(buckley_table)[names(buckley_table) == "No..of.individuals"] = "number"
names(buckley_table)[names(buckley_table) == "ZF.PF.no."] = "Foram_no"
names(buckley_table)[names(buckley_table) == "Sample.depth.MIN..cm."] = "sample_depth_min"
names(buckley_table)[names(buckley_table) == "Sample.depth.MAX..cm."] = "sample_depth_max"

# Filling empty tow cells with 0 => tow is now a binary vector (1 = tow, 0 = Non-tow)
buckley_table[,"tow"][which(is.na(buckley_table[,"tow"]))] = 0

str(buckley_table)

### Taxonomic update
buckley_table[which(buckley_table[,"Species"]=="eggeri"),"Species"] = "dutertrei"
buckley_table[which(buckley_table[,"Species"]=="aequilateralis/siphonifera"),"Species"] = "siphonifera"
buckley_table[which(buckley_table[,"Species"]=="aequilateralis"),"Species"] = "siphonifera"
buckley_table[which(buckley_table[,"Species"]=="aequilateralis "),"Species"] = "siphonifera"
buckley_table[which(buckley_table[,"Species"]=="incompta"),"Species"] = "pachyderma"
# sort(unique(buckley_table[,"Species"]))


### SAMPLE DEPTH DEFINITION: tow, top_core, deep_core, land
deep = 20 # sample_depths > 20cm == deep_core
buckley_table[which(buckley_table[,"tow"]==1),c("sample_type")] = "tow"
buckley_table[which(buckley_table[,"sample_depth_min"]==c("land")), c("sample_type")] = "land"
buckley_table[which(as.numeric(buckley_table[,"sample_depth_max"])<=deep),"sample_type"]="top_core"
buckley_table[which(as.numeric(buckley_table[,"sample_depth_max"])>deep),"sample_type"]="deep_core"
buckley_table[which(is.na(buckley_table[,"sample_type"])),"sample_type"]="no_info"
# buckley_table[,c("sample_depth_min","sample_depth_max", "sample_type", "Foram_no")]

head(buckley_table)



########################################################################################################################
library(marmap)


coord_table = unique(buckley_table[,c("lat","long", "sample_depth_min", "sample_depth_max", "sample_type", "Sea.Depth..fms.", "Sea.Depth.NOAA..m.", "Sea.Depth..m.")])
coord_table = coord_table[order(coord_table[,"lat"], coord_table[,"sample_depth_min"]),]



### Adding NOAA SEA DEPTH to coord_table 
## Code to get sea depth given coordinates (uses marmap and NOAA data)
## If marmap_buckley_NOAA_depth.csv files already exist, no need to run this out-commented part

# Getting NOAA database from the internet  - TAKES QUITE SOME TIME!!
# OBS: resolution = 5 minutes ; keep = TRUE will save data automatically as marmap_coord.csv)
# sea_depth = getNOAA.bathy(180, -180, 90, -90, resolution = 2, keep=TRUE, antimeridian=FALSE)
# sea_depth is already of class bathy

# Getting sea depths from already saved table marmap_coord_-180;-90;180;90_res_5.csv
# sea_depth = read.csv("/Users/marinacostarillo/Google Drive/DOUTORADO/R_data/marmap_coord_-180;-90;180;90_res_5.csv")
# is.bathy(sea_depth)
# NOAA_coord = unique(na.omit(coord_table[,c("lat","long")]))
# NOAA_depth_table = get.depth(sea_depth, x=NOAA_coord[,"long"], y=NOAA_coord[,"lat"], locator=FALSE, distance=FALSE)
# write.csv(NOAA_depth_table, file = "marmap_buckley_NOAA_depth.csv",row.names=FALSE)

NOAA_depth_table = read.csv("marmap_buckley_NOAA_depth.csv", header = TRUE)
for (i in 1 : length(coord_table[,1])){
	same_latlong = c()
	same_latlong = c(same_latlong, which(coord_table[i,"lat"] == NOAA_depth_table[,"lat"] & 
		coord_table[i,"long"] == NOAA_depth_table[,"lon"]) ) 
	if (length(same_latlong) > 0){
		coord_table[i, "Sea.Depth.NOAA..m."] = unique(NOAA_depth_table[same_latlong,"depth"])
	}
}


# Fixing the "land" and depth > 0 using the coordinates:
coord_table[which(coord_table[,"sample_type"]==c("land") | coord_table[,"Sea.Depth.NOAA..m."]>0),]
which(coord_table[,"Sea.Depth.NOAA..m."]>0)
coord_table[212,] # this coordinates in the map are very close to the shore, but still in the sea!
coord_table[212,"Sea.Depth.NOAA..m."] = -5 # I picked this random number
which(coord_table[,"sample_type"]==c("land") & coord_table[,"Sea.Depth.NOAA..m."]<0 ) # sea depth < 0 but coordinate in the middle of Saipan island!
coord_table[201,"Sea.Depth.NOAA..m."] = 5 # I picked this random number


### Adding difference between BUCKLEY SEA DEPTH and NOAA SEA DEPTH 
coord_table[,"Diff_Buckley_NOAA"] = NA
diff_rows = which(coord_table[,"sample_type"]!=c("tow")  & coord_table[,"Sea.Depth..m."]!="")
coord_table[diff_rows,"Diff_Buckley_NOAA"] = as.numeric(coord_table[diff_rows,"Sea.Depth..m."]) + coord_table[diff_rows ,"Sea.Depth.NOAA..m."]


### Adding Ocean and OBD IRN information
coord_table[,"Ocean"] = 0
coord_table[,"OBD_IRN"] = 0
for (i in 1 : length(coord_table[,1])){
	same_latlong = c()
	same_latlong = c(same_latlong, which(coord_table[i,"lat"] == buckley_table[,"lat"] & 
		coord_table[i,"long"] == buckley_table[,"long"]) )
	coord_table[i, "Ocean"] = unique(buckley_table[same_latlong,"Ocean.Sea"])[1]
	coord_table[i, "OBD_IRN"] = unique(buckley_table[same_latlong,"Residue.OBD.IRN"])[1]
}



### Adding EXTRA OBD IRN information
OBD_table = read.csv("OBD.csv", header = TRUE, stringsAsFactors=FALSE)
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
# coord_table
write.csv(coord_table, file = "Coordinates_JMicropal.csv",row.names=FALSE)


########################################################################################################################


### Adding NOAA SEA DEPTH to buckley_table 
buckley_table[, "Sea.Depth.NOAA..m."]=0
NOAA_depth_table = read.csv("marmap_buckley_NOAA_depth.csv", header = TRUE)
for (i in 1 : length(buckley_table[,1])){
	same_latlong = c()
	same_latlong = c(same_latlong, which(buckley_table[i,"lat"] == NOAA_depth_table[,"lat"] & 
		buckley_table[i,"long"] == NOAA_depth_table[,"lon"]) )
	if (length(same_latlong) > 0){
		buckley_table[i, "Sea.Depth.NOAA..m."] = unique(NOAA_depth_table[same_latlong,"depth"])
	}
}

write.csv(buckley_table, file = "Buckley_table_JMicropal_R.csv",row.names=FALSE)





