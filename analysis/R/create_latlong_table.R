## Created 12 / January / 2016
## Updated 06 / February / 2017
## Marina Costa Rillo
##
## Code to transform the raw Buckley dataset (which has species as rows and lat long as colums) 
## into a latlong_table where lat and long are rows and each species is one column
## 
## Reads "Coordinates_Buckley" (coord_table.R) and "BuckleyCollection_DataPortal.csv"
## Creates "LatLongTable.csv" ; "LatLongTable_modern.csv"
##
## OBS: LatLongTable does not have unique coordinates, samples could be collected in the same lat/long but in different sediment depths
##
## TO DO STILL 1: check if "top_core" and "no_info" comprise only modern species, and double check which ones I used for morphometrics
## TO DO STILL 2: check if "tow" comprises only modern species

rm(list=ls())
setwd("/Users/marinacostarillo/Google Drive/DOUTORADO/R_data")
# setwd("/Users/Marina/Google Drive/DOUTORADO/R_data")

coord_table = read.csv("Buckley_Collection/Coordinates_Buckley.csv", header = TRUE, stringsAsFactors=FALSE) # run marmap_sea_depth.R code to create this file
buckley_table = read.csv("Buckley_Collection/BuckleyCollection_DataPortal.csv", header = TRUE, stringsAsFactors=FALSE)

names(buckley_table)[names(buckley_table) == "Long.decimal"] = "long"
names(buckley_table)[names(buckley_table) == "Lat.decimal"] = "lat"
names(buckley_table)[names(buckley_table) == "No_of_individuals"] = "no_ind"


# sort(unique(buckley_table[,"Species"]))

species_names =  c("acostaensis","adamsi", "altispira", "anfracta", "bollii", "bulloides","calida","conglobatus",
	"conglomerata","crassaformis", "dehiscens", "decoraperta", "digitata", "dutertrei", "falconensis",
	"fohsi", "glomerosa", "glutinata", "hexagona", "hirsuta", "humerosa", "humilis", "inflata", "iota","insueta", 
	"mayeri", "menardii","minuta", "mitra", "multicamerata", "nepenthes","nitida", "obliquiloculata", "obliquus", 
	"pachyderma", "pelagica","praepumilio", "primalis", "pseudofoliata", "pumilio", "punctulata", "quinqueloba", 
	"ruber", "rubescens","sacculifera", "scitula", "seminulina", "siphonifera", "spectabilis", "subdehiscens", 
	"tenellus", "tosaensis", "trilobus", "truncatulinoides", "tumida", "universa", "uvula", "venezuelana", 
	"various")
# took out: "obliqua", "subcretacea"

# JUST MODERN SPECIES
modern_macro_ssp =  c("adamsi","bulloides","calida","conglobatus","conglomerata","crassaformis", "dehiscens", 
	"digitata","dutertrei","falconensis","hexagona","hirsuta","humilis","inflata","menardii","obliquiloculata", 
	"pachyderma","quinqueloba","ruber","rubescens","sacculifera","scitula","siphonifera","tenellus","trilobus",
	"truncatulinoides","tumida","universa")
microper_ssp = c("glutinata", "iota", "nitida", "pelagica", "uvula")
# species_names <- c(modern_macro_ssp , microper_ssp, "various")


any(duplicated(species_names))

# Creating new 'normalized' species columns
ssp = rep(0, length(buckley_table[,1]))
buckley_table[,"ssp"] = ssp
for (i in 1: length(species_names)){
	buckley_table[which(buckley_table[,"Species"] == species_names[i]),"ssp"] = species_names[i]
} 
buckley_table[which(buckley_table[,"ssp"] == 0),"ssp"] = "various"
# various = buckley_table[which(buckley_table[,"ssp"] == "various"),"Species"] 
# sort(unique(various)) # see the 'unclassified' species


### Creating new table: lat & long as rows, species as columns
latlong_table <- data.frame()
latlong_table <- coord_table[c("lat","long","Sample_depth_min_cm","Sample_depth_max_cm","sample_type","Sea_Depth_meters_NOAA","Ocean","OBD_IRN")] # selecting columns
# Adding one column for each species
string <- c(colnames(latlong_table), as.character(species_names))
latlong_table[,seq(length(colnames(latlong_table))+1, length(string)) ] <- 0 
names(latlong_table) <- string
head(latlong_table)


# Filling species columns with the number of individuals of each
for (i in 1 : length(latlong_table[,1])){
	# i = 78
	same_latlong = c()
	same_latlong = c(same_latlong, which(buckley_table[,"lat"] == latlong_table[i,"lat"] & buckley_table[,"long"] == latlong_table[i,"long"]) )
	# same_latlong is never null, because latlong_table is the unique buckley_table
	for (j in 1: length(same_latlong)){ # j=1
		latlong_table[i, as.character(buckley_table[same_latlong[j], "ssp"])] <- as.numeric(latlong_table[i, as.character(buckley_table[same_latlong[j], "ssp"])]) + as.numeric(buckley_table[same_latlong[j], "no_ind"])
	}	
}


# Calculating species richness, total number of individuals (with and without 'various'). 'Various' are non identified individuals)
for (i in 1 : length(latlong_table[,1])){
	latlong_table[ i,"ssp_richness"] = sum(latlong_table[ i, grep(c("various"), as.character(species_names), value=TRUE, invert=TRUE) ] != 0) # species richness (without various)
	latlong_table[ i,"total_idind"] =  sum(latlong_table[ i, grep(c("various"), as.character(species_names), value=TRUE, invert=TRUE) ] ) # abundance without various (only identified individuals)
	latlong_table[ i,"total_ind"] = sum(latlong_table[ i, as.character(species_names) ]) # abundance with various
} 


# Saving latlong_table
write.csv(latlong_table, file = "Buckley_Collection/LatLongTable.csv",row.names=FALSE)

# write.csv(latlong_table, file = "Buckley_Collection/LatLongTable_modern.csv",row.names=FALSE)






