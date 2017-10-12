## Created 12 / January / 2016
## Updates 14 / February / 2017
## Marina Costa Rillo
##
## Code to assess number of specimens counted (abundance) of each species within each sample_type (tow, top_core, ...)
## As well as number of samples and unique coordinates that each species was found in the Buckley Collection
##
## Reads "LatLongTable.csv" (latlong_table.R)
## Creates "Ssp_Abundances_Sites.csv"
##
## TO DO STILL: missing one last check (see below) ***

rm(list=ls())
setwd("/Users/marinacostarillo/Google Drive/DOUTORADO/R_data")

latlong_table = read.csv("Buckley_Collection/LatLongTable.csv", header = TRUE)

latlong_table = latlong_table[order(latlong_table[,"lat"],latlong_table[,"Sample_depth_min_cm"]),]

modern_macro_ssp =  c("adamsi","bulloides","calida","conglobatus","conglomerata","crassaformis", "dehiscens", 
                      "digitata","dutertrei","falconensis","hexagona","hirsuta","humilis","inflata","menardii","obliquiloculata", 
                      "pachyderma","quinqueloba","ruber","rubescens","sacculifera","scitula","siphonifera","tenellus","trilobus",
                      "truncatulinoides","tumida","universa")

# Creating shortcut for rows numbers
tow <- which(latlong_table[,"sample_type"]==c("tow"))
top_core <- which(latlong_table[,"sample_type"]==c("top_core"))
deep_core <- c( which(latlong_table[,"sample_type"]==c("deep_core")) ) #, which(latlong_table[,"sample_type"]==c("many_cores")) ) 
no_info <- which(latlong_table[,"sample_type"]==c("no_info"))
land <- which(latlong_table[,"sample_type"]==c("land"))



### Abundances of each species in each type of sample (tow, top_core or deep_core) and in total
ssp_abund_tow <- data.frame(colSums( latlong_table[tow, pmatch(as.character(modern_macro_ssp), colnames(latlong_table)) ] ) )
ssp_abund_top_core <- data.frame(colSums(latlong_table[top_core, pmatch(as.character(modern_macro_ssp), colnames(latlong_table))]) )
ssp_abund_deep_core <- data.frame(colSums( latlong_table[deep_core, pmatch(as.character(modern_macro_ssp), colnames(latlong_table)) ] ) )
ssp_abund_no_info <- data.frame(colSums( latlong_table[no_info, pmatch(as.character(modern_macro_ssp), colnames(latlong_table)) ] ) )
ssp_abund_land <- data.frame(colSums( latlong_table[land, pmatch(as.character(modern_macro_ssp), colnames(latlong_table)) ] ) )
ssp_abund_total <- data.frame(colSums(latlong_table[, pmatch(as.character(modern_macro_ssp), colnames(latlong_table))]) )


### Number of samples where each species was found (OBS: might include repeated coordinates, when there's more than one sample depth)
ssp_samples_tow <- data.frame(colSums(latlong_table[tow, pmatch(as.character(modern_macro_ssp), colnames(latlong_table)) ] !=0 ) )
ssp_samples_top_core <- data.frame(colSums(latlong_table[top_core, pmatch(as.character(modern_macro_ssp), colnames(latlong_table)) ] !=0 ) )
ssp_samples_deep_core <- data.frame(colSums(latlong_table[deep_core, pmatch(as.character(modern_macro_ssp), colnames(latlong_table)) ] !=0 ) )
ssp_samples_no_info <- data.frame(colSums(latlong_table[no_info, pmatch(as.character(modern_macro_ssp), colnames(latlong_table)) ] !=0  ) )
ssp_samples_land <- data.frame(colSums(latlong_table[land, pmatch(as.character(modern_macro_ssp), colnames(latlong_table)) ] !=0 ) )
ssp_samples_total <- data.frame(colSums(latlong_table[, pmatch(as.character(modern_macro_ssp), colnames(latlong_table))] !=0 ) )


### Number of unique coordinates where each species was found (OBS: might include more than one sample depth)
ssp_coord_tow <-data.frame(colSums(unique(latlong_table[tow, c("lat","long", modern_macro_ssp)])[, pmatch(as.character(c(modern_macro_ssp)), colnames(unique(latlong_table[tow,c("lat","long", modern_macro_ssp)])))]!=0))
ssp_coord_top_core <-data.frame(colSums(unique(latlong_table[top_core, c("lat","long", modern_macro_ssp)])[, pmatch(as.character(c(modern_macro_ssp)), colnames(unique(latlong_table[top_core,c("lat","long", modern_macro_ssp)])))]!=0))
ssp_coord_deep_core <-data.frame(colSums(unique(latlong_table[deep_core, c("lat","long", modern_macro_ssp)])[, pmatch(as.character(c(modern_macro_ssp)), colnames(unique(latlong_table[deep_core,c("lat","long", modern_macro_ssp)])))]!=0))
ssp_coord_no_info <-data.frame(colSums(unique(latlong_table[no_info, c("lat","long", modern_macro_ssp)])[, pmatch(as.character(c(modern_macro_ssp)), colnames(unique(latlong_table[no_info,c("lat","long", modern_macro_ssp)])))]!=0))
ssp_coord_land <-data.frame(colSums(unique(latlong_table[land, c("lat","long", modern_macro_ssp)])[, pmatch(as.character(c(modern_macro_ssp)), colnames(unique(latlong_table[land,c("lat","long", modern_macro_ssp)])))]!=0))
ssp_coord_total <-data.frame(colSums(unique(latlong_table[, c("lat","long", modern_macro_ssp)])[, pmatch(as.character(c(modern_macro_ssp)), colnames(unique(latlong_table[,c("lat","long", modern_macro_ssp)])))]!=0))


ssp_abund_sites <- rownames(ssp_abund_total)
ssp_abund_sites <- data.frame(ssp_abund_sites, 
                              sapply(ssp_abund_tow, as.numeric), sapply(ssp_samples_tow, as.numeric), sapply(ssp_coord_tow, as.numeric),
                              sapply(ssp_abund_top_core, as.numeric), sapply(ssp_samples_top_core, as.numeric), sapply(ssp_coord_top_core, as.numeric),
                              sapply(ssp_abund_deep_core, as.numeric), sapply(ssp_samples_deep_core, as.numeric), sapply(ssp_coord_deep_core, as.numeric),
                              sapply(ssp_abund_no_info, as.numeric), sapply(ssp_samples_no_info, as.numeric), sapply(ssp_coord_no_info, as.numeric),
                              sapply(ssp_abund_land, as.numeric), sapply(ssp_samples_land, as.numeric), sapply(ssp_coord_land, as.numeric),
                              sapply(ssp_abund_total, as.numeric), sapply(ssp_samples_total, as.numeric), sapply(ssp_coord_total, as.numeric)
)

names(ssp_abund_sites) = c("species", "abund_tow", "sample_tow", "coord_tow",
                               "abund_top_core", "sample_top_core", "coord_top_core",
                               "abund_deep_core", "sample_deep_core", "coord_deep_core",
                               "abund_no_info", "sample_no_info", "coord_no_info",
                               "abund_land", "sample_land", "coord_land",
                               "abund_total", "sample_total", "coord_total")


### Checking if it makes sense:
# abundance counts
all(ssp_abund_sites[,"abund_tow"] + ssp_abund_sites[,"abund_top_core"] + ssp_abund_sites[,"abund_deep_core"] + ssp_abund_sites[,"abund_no_info"] + ssp_abund_sites[,"abund_land"] == ssp_abund_sites[,"abund_total"])
# sample counts
all(ssp_abund_sites[,"sample_tow"] + ssp_abund_sites[,"sample_top_core"] + ssp_abund_sites[,"sample_deep_core"] + ssp_abund_sites[,"sample_no_info"] + ssp_abund_sites[,"sample_land"] == ssp_abund_sites[,"sample_total"])
# unique coordinates counts
for (i in 1: length(modern_macro_ssp)){
  print(modern_macro_ssp[i])
  print(ssp_abund_sites[which(ssp_abund_sites[,"species"] == modern_macro_ssp[i]),"coord_total"]==length(unique(latlong_table[(latlong_table[,pmatch(as.character(modern_macro_ssp[i]), colnames(latlong_table))]!=0),c("lat","long")])[,1]))
} 
# STILL MISSING TO CHECK UNIQUE COORDINATES COUNTS FOR EACH SAMPLE_TYPE... ***



### Saving data
write.csv(ssp_abund_sites, file = "Buckley_Collection/Ssp_Abundances_Sites.csv",row.names = FALSE)

