

get_specimens_data <- function(buckley_table, species_names_list){
  
  species_names <- species_names_list$species_names$x
  modern_macro_ssp <- species_names_list$modern_macro_ssp$x
  modern_microper_ssp <- species_names_list$modern_microper_ssp$x
  modern_ssp <- species_names_list$modern_ssp$x
  fossil_ssp <- species_names_list$fossil_ssp$x
  
    ### Summing total number of individuals
      all_specimens_df <- aggregate(buckley_table[,"No_of_individuals"] ~ buckley_table[,"Species"], 
                                    data=buckley_table[,c("Species","No_of_individuals")], FUN=sum)
      names(all_specimens_df) <- c("species","counts")
      
      total <- data.frame(species =  c("TOTAL"), counts = sum(all_specimens_df[,"counts"]), stringsAsFactors = F)
      
      idd_specimens_df <- all_specimens_df[which(all_specimens_df[,"species"] %in% species_names),]
      total_id <- data.frame(species =  c("Total_ID"), counts = sum(idd_specimens_df[, "counts"]), stringsAsFactors = F)
      
      non_idd_specimens_df <- all_specimens_df[which(!(all_specimens_df[,"species"] %in% species_names)), ] 
      total_non_id <- data.frame(species =  c("Total_NON_ID"), counts = sum(non_idd_specimens_df[, "counts"]), stringsAsFactors = F)
      
      # check:
      # sum(total_id$counts, total_non_id$counts) == total$counts
      
      
    ### Subsets of the identified (modern(macroperforate, microperforate), fossil):
      modern_macro_df = idd_specimens_df[which(idd_specimens_df[,"species"] %in% modern_macro_ssp),]
      total_macro = data.frame(species =  c("Total_Macro"), counts = sum(modern_macro_df[, "counts"]) )# TOTAL 13,661
    
      modern_micro_df = idd_specimens_df[which(idd_specimens_df[,"species"] %in% modern_microper_ssp),]
      total_micro = data.frame(species =  c("Total_Micro"), counts = sum(modern_micro_df[, "counts"]) )# TOTAL 1001
      
      fossil_df = idd_specimens_df[which(idd_specimens_df[,"species"] %in% fossil_ssp),]
      total_fossil = data.frame(species =  c("Total_Fossil"), counts = sum(fossil_df[, "counts"]) )# TOTAL 923
      
      # check:
      # total_macro$counts + total_micro$counts + total_fossil$counts == total_id$counts

      
    ### Putting all together
      all_specimens_df <- rbind(all_specimens_df,total)
      idd_specimens_df <- rbind(idd_specimens_df,total_id)
      non_idd_specimens_df <- rbind(non_idd_specimens_df,total_non_id)
      modern_macro_df <- rbind(modern_macro_df, total_macro)
      modern_micro_df <- rbind(modern_micro_df, total_micro)
      fossil_df <- rbind(fossil_df, total_fossil)
      
      specimens_list <- list(all_speci = all_specimens_df, 
                             idd_speci = idd_specimens_df, 
                             non_idd_speci = non_idd_specimens_df,
                             modern_macro_idd = modern_macro_df, 
                             modern_micro_idd = modern_micro_df, 
                             fossil_idd = fossil_df)
      
      function_write_list(specimens_list, wb_name = paste("output/buckley_specimens_data.xlsx", sep="")) 
      
}
