## Created 
## Marina Costa Rillo
## 


##  CHECK IF I STILL NEED THIS CODE (03.04.17)

rm(list=ls())
library(ggplot2)
library(latticeExtra)

# Matching names

df.buckley <- read.csv("Morphometrics/all_species_morpho.csv", header = TRUE, stringsAsFactors=FALSE)
df.relabund <- read.csv("Bias_analysis/data_assemblages/bias_relative_abundances_nearest.csv", header = TRUE, stringsAsFactors=FALSE)


ssp.abbrev.names <- c("G.bulloides","G.falconensis","G.rubescens","G.tenellus","G.menardii","G.tumida","G.inflata",
                      "G.crassaformis","G.truncatulinoides","G.hirsuta","G.scitula","G.ungulata","G.hexagonus","N.dutertrei",
                      "N.incompta","N.pachyderma","G.siphonifera","G.calida","G.ruber","G.conglobatus","G.sacculifer",
                      "O.universa","P.obliquiloculata","G.conglomerata","G.glutinata","C.nitida","B.digitata","T.quinqueloba",
                      "T.humilis","S.dehiscens","H.pelagica","B.pumilio","G.theyeri")       

resamples <- c(5,10,20,25,27,31,44,46,55,66)
df.buckley <- df.buckley[which(df.buckley$sample %in% resamples), ]

for(i in 1 : length(unique(df.buckley$species))){
  ssp_name <- df.relabund$species[grep(unique(df.buckley$species)[i],unique(df.relabund$species))]
  ssp_short <- ssp.abbrev.names[grep(unique(df.buckley$species)[i],ssp.abbrev.names)]
  df.buckley[grep(unique(df.buckley$species)[i],df.buckley$species),"species"] <- rep(ssp_name, length(grep(unique(df.buckley$species)[i],df.buckley$species)))
  df.buckley[grep(unique(df.buckley$species)[i],df.buckley$species),"ssp_abbrev"] <- rep(ssp_short, length(grep(unique(df.buckley$species)[i],df.buckley$species)))
}

