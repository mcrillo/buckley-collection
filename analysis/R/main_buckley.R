rm(list=ls())

setwd("/Users/marinacostarillo/Google Drive/DOUTORADO/R_data")
setwd("./buckley-collection/analysis")

# General Functions
source("R/write_list.R")
source("R/read_list.R")


### Loading Data: file downloaded from http://dx.doi.org/10.5519/0035055
buckley_table <- read.csv("data/BuckleyCollection_DataPortal.csv", header = TRUE, stringsAsFactors=FALSE)

species_names_list <- function_read_list("data/species_names.xlsx")



### Summary data of the Buckely Collection

# Specimens data: creates  output/buckley_specimens_data.xlsx
source("R/get_specimens_data.R")
get_specimens_data(buckley_table, species_names_list)


####### stopped here

# Slides data: creates  output/buckley_slides_data.xlsx




# OLD:
# Re-naming buckley_table columns
names(buckley_table)[names(buckley_table) == "Long.decimal"] = "long"
names(buckley_table)[names(buckley_table) == "Lat.decimal"] = "lat"

latlong_table <- read.csv("data/LatLongTable.csv", header = TRUE)
coord_table <- read.csv("data/Coordinates_Buckley.csv", header = TRUE)





