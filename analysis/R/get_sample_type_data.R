
get_sample_type_data <- function(buckley_table){
  
  
  
}




###################
### SAMPLE_TYPE ###
###################

unique(latlong_table[,"sample_type"])

length(which(latlong_table[,"sample_type"]==c("tow"))) # 80
length(which(latlong_table[,"sample_type"]==c("top_core"))) # 47
length(which(latlong_table[,"sample_type"]==c("deep_core"))) # 77
length(which(latlong_table[,"sample_type"]==c("no_info"))) # 74
length(which(latlong_table[,"sample_type"]==c("land"))) # 2

# Number of samples:
length(which(latlong_table[,"sample_type"]==c("tow"))) + length(which(latlong_table[,"sample_type"]==c("top_core"))) + length(which(latlong_table[,"sample_type"]==c("deep_core"))) +length(which(latlong_table[,"sample_type"]==c("no_info"))) +length(which(latlong_table[,"sample_type"]==c("land")))
# Number of geographic coordinates:
length(unique(latlong_table[,c("lat","long")])[,1]) 

### Create "many_cores", for when one geosample was collected in multiple depths!
unique(latlong_table[,"sample_type"])


