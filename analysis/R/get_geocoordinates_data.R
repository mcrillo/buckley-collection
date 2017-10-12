


get_geocoordinates_data <- function(buckley_table){
  
  
  
}


#################
### GEOGRAPHY ### STILL CHECK, maybe do it through sample_type instead of species names
#################

# Number of geographic coordinates:
length(unique(na.omit(buckley_table[,c("lat","long")]))[,1]) # NA.OMIT necessary!
length(unique(coord_table[,c("lat","long")])[,1]) 

# Geographic sites of modern samples (tow, top_core, and assuming no_info is also topcore...)
length(unique(latlong_table[which(latlong_table[,"sample_type"] %in% c("no_info","top_core","tow")), c("lat","long")])[,1])
# Geographic sites of tow (modern)
length(unique(latlong_table[which(latlong_table[,"sample_type"] %in% c("tow")), c("lat","long")])[,1])
# Geographic sites of top-core (modern) - sediment depth < 15cm
length(unique(latlong_table[which(latlong_table[,"sample_type"] %in% c("top_core")), c("lat","long")])[,1]) 
# Geographic sites of deep-core (fossil) - sediment depth > 15cm
length(unique(latlong_table[which(latlong_table[,"sample_type"] %in% c("deep_core")), c("lat","long")])[,1])
# Geographic sites of land (fossil) 
length(unique(latlong_table[which(latlong_table[,"sample_type"] %in% c("land")), c("lat","long")])[,1])

