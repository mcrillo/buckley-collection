
rm(list=ls())
library(stringr)

drawer = c("Buckley_pachyderma_40X_selected") #### ZF!!!
directory = c("/Volumes/Buckley/AXIO_ZOOM_V16/MRillo_ExternalDrive")
setwd(paste(directory,drawer,sep="/"))
folder_names = list.dirs(recursive=FALSE)
# folder_names = dir(pattern=c("ZF"))
folder_names

for (i in 1:length(folder_names)){

	setwd(folder_names[i])

	if ( length(list.files(pattern=c("_s"))) != 0 ){

		tiff_files = list.files(pattern=c("_s"))
		# str_extract(tiff_files,'([0-9]|[0-9])+')
		first_tiff_no = unique(str_extract(tiff_files,'([0-9]|[0-9])+'))
		first_tiff_no = as.numeric(first_tiff_no)
		final_tiff_no = first_tiff_no + (length(tiff_files)-1)
		tiff_names = seq(first_tiff_no, final_tiff_no , 1) 
		tiff_names = as.character(tiff_names)

		for (j in 1:length(tiff_files)){

			file.rename(from=list.files(pattern=paste("_s",j,sep="")), to=paste("ZF",tiff_names[j],".tif", sep=""))
		}

	}
	

	setwd(paste(directory, drawer, sep="/"))
}


