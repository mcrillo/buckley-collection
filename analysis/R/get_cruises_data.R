
get_cruises_data <- function(buckley_table){
  
  
  
}



###############
### CRUISES ###
###############
cruises <- data.frame(unique(buckley_table[,c("lat","long","Vessel","Collection_date")]))
cruises <- cruises[order(cruises[,"Vessel"]),]
cruises


