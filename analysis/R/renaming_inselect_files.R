
rm(list=ls())
library(stringr)

# setwd("/Volumes/PHD_BUCKLEY/AxioZoom V16/Giles_slides_images_Inselect/PF_slides_Inselect")
setwd("/Users/marinacostarillo/Desktop/Buckley Inselect Data Portal/PF_slides_Inselect_backup")
folder_names = dir(pattern=c("crops"))
folder_names

for (i in 1:length(folder_names)){
  
  setwd(paste("./",folder_names[i], sep=""))
  interval <- str_extract_all(string=folder_names[i],pattern='([0-9]|[0-9])+')

  if(length(interval[[1]]) == 2){
    
    from <- as.numeric(interval[[1]][1])
    to <- as.numeric(interval[[1]][2])
    if(from>to) print("FROM > TO!!")
    
    images_re_name <- seq(from, to , 1) 
    images_re_name = as.character(images_re_name)
    
    images_name <- list.files()
    
    for (j in 1:length(images_name)){
      file.rename(from=images_name[j], to=paste("PF",images_re_name[j],".jpg", sep=""))
    }
    
  }
  
  # setwd("/Volumes/PHD_BUCKLEY/AxioZoom V16/Giles_slides_images_Inselect/PF_slides_Inselect")
  setwd("/Users/marinacostarillo/Desktop/Buckley Inselect Data Portal/PF_slides_Inselect_backup")
  
  
}
  