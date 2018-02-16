### Description
# plot coordinates on a map

### Usage
# plot_map(coord1, coord2, plot_name)

### Arguments
# coord1: data.frame with coordinates of points to be plot on map (in blue). First column: Longitude (x), second column: Latitude (y).
# coord2: NA or data.frame with a 2nd set of coordinates to be plot on map (in red). First column: Longitude (x), second column: Latitude (y).
# plot_name: string cointaining name of the pdf plot

plot_map <- function(coord1, coord2, plot_name){
  
  if (!file.exists("output/plots_map")){
    dir.create("output/plots_map/")
  }
  
  if (!file.exists(paste("output/plots_map/map_", plot_name, ".pdf", sep=""))){
    # Maptools dataset
    data(wrld_simpl)
    world <- fortify(wrld_simpl)
    
    # plotting map
    mapplot <- ggplot(world, mapping = aes(x = long, y = lat, group = group)) +
      geom_polygon(fill = "black", colour = "black") +
      theme(axis.text=element_text(size=22, colour = "black"), axis.title=element_blank())
    # + coord_cartesian(xlim = c(-125, -30), ylim = c(-60, 35))
    
    # adding points and labels
    
    if(all(is.na(coord2))){
      mappoints <- mapplot + geom_point(data=coord1, aes(x=coord1[,1], y=coord1[,2], group = row.names(coord1)),
                                        shape = 21, colour = "navyblue", fill = "blue", size = 3, stroke = 1)
      # to lable the points:
      # geom_text(data=resamples_df, aes(x=Long, y=Lat,group=sample,label=sample),hjust=-0.3, vjust=0,color="red")
    }else{
      mappoints <- mapplot + 
        geom_point(data=coord1, aes(x=coord1[,1], y=coord1[,2], group = row.names(coord1)),
                   shape = 21, colour = "navyblue", fill = "blue", size = 3, stroke = 1) +
        geom_point(data=coord2, aes(x=coord2[,1], y=coord2[,2], group = row.names(coord2)),
                   shape = 21, colour = "darkred", fill = "red", size = 3, stroke = 1)
    }
    
    # saving
    pdf(file = paste("output/plots_map/map_", plot_name, ".pdf", sep=""), paper = "a4r", width = 14, height = 7)
    print(mappoints)
    dev.off()
  } # if
  
}


# OLD
# map('world', interior= FALSE, col = "grey55")
# with(data, points(Long, Lat, 	type = "p", pch = 21, bg ="white", col="black",	cex = 1.2, lwd = 1) )
# with(data, text(Long, Lat, labels = sample, adj = NULL, pos = 4, offset = 0.5, vfont = NULL,cex = 1, col = "black", font = NULL))

