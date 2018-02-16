rm(list=ls())

setwd("/Users/marinacostarillo/Google Drive/PhD/projects")
setwd("./buckley-collection/analysis")

# Libraries
source("R/library.R")

# Auxiliary functions
sourceDirectory("./R/aux_functions", modifiedOnly=FALSE)

### Loading Data: file downloaded from http://dx.doi.org/10.5519/0035055
buckley_table <- read.csv("data/BuckleyCollection_DataPortal.csv", header = TRUE, stringsAsFactors=FALSE)

species_names_list <- function_read_list("data/species_names.xlsx")


### Finding ZFs for Allison & Celli
zf_modern_strict <- c()
zf_modern_all <- c()
modern_species <- c(species_names_list$modern_ssp[,1],"aequilateralis/siphonifera", "eggeri")
for (i in 1:length(modern_species)){ # i=26
  ssp <- modern_species[i]
  all <- grep(ssp, buckley_table[, "Species"])   # grep gets everything with ssp pattern
  strict <- which(buckley_table[, "Species"]==ssp) # this is only exactly equal to ssp
  all_wo_strict <- setdiff(all, strict) # difference between all and strict
  zf_modern_strict <- c(zf_modern_strict, buckley_table[strict, "ZF_PF_no." ] )
  zf_modern_all <- c(zf_modern_all, buckley_table[all_wo_strict, "ZF_PF_no." ] )
}
zf_modern_strict <- sort(unique(zf_modern_strict))
zf_modern_all <- sort(unique(zf_modern_all))

write.csv(zf_modern_strict, file = "output/buckley_modern_no.csv", row.names = FALSE)
### Summary data of the Buckely Collection

# Specimens data: creates  output/buckley_specimens_data.xlsx
get_specimens_data(buckley_table, species_names_list)

# Finding species' map
conglobatus <- buckley_table[grep("conglobatus", buckley_table[,"Species"]),c("Long.decimal", "Lat.decimal")]  
conglobatus <- unique(na.omit(conglobatus))
plot_map(conglobatus, coord2=NA, plot_name="conglobatus")






####### stopped here

# Slides data: creates  output/buckley_slides_data.xlsx




# OLD:
# Re-naming buckley_table columns
names(buckley_table)[names(buckley_table) == "Long.decimal"] = "long"
names(buckley_table)[names(buckley_table) == "Lat.decimal"] = "lat"

latlong_table <- read.csv("data/LatLongTable.csv", header = TRUE)
coord_table <- read.csv("data/Coordinates_Buckley.csv", header = TRUE)





