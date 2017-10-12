

get_slides_data <- function(buckley_table){
  
  
  
}

##############
### SLIDES ###
##############


length(unique(buckley_table[,"ZF_PF_no."])) 
# TOTAL number of slides = 1713

slide_modern_macro = na.omit(buckley_table[which(buckley_table[,"Species"] %in% modern_macro_ssp),"ZF_PF_no."])
length(unique(slide_modern_macro)) # TOTAL 1085

slide_microper = na.omit(buckley_table[which(buckley_table[,"Species"] %in% microper_ssp),"ZF_PF_no."])
length(unique(slide_microper)) # TOTAL 104

slide_fossil = na.omit(buckley_table[which(buckley_table[,"Species"] %in% fossil_ssp),"ZF_PF_no."])
length(unique(slide_fossil)) # TOTAL 89

slide_nonid = 	na.omit(buckley_table[which(buckley_table[,"Species"] %in% non_id[,"species"]),"ZF_PF_no."])
length(unique(slide_nonid)) # TOTAL 441

# check: FALSE!
length(unique(buckley_table[,"ZF_PF_no."])) == length(unique(slide_modern_macro)) + length(unique(slide_microper)) + length(unique(slide_fossil)) + length(unique(slide_nonid))
length(unique(buckley_table[,"ZF_PF_no."])) - (length(unique(slide_modern_macro)) + length(unique(slide_microper)) + length(unique(slide_fossil)) + length(unique(slide_nonid)) )
# Reason: some slides contain more than one type (iid species and non-iid or modern and fossil)
print("Slides counted more than one time:")
length(unique(slide_nonid)) + length(unique(slide_modern_macro)) + length(unique(slide_microper)) + length(unique(slide_fossil)) - length(unique(buckley_table[,"ZF_PF_no."])) 
print("Slides ZF numbers:")
double_counts_slides <- c(intersect(slide_modern_macro,slide_fossil),intersect(slide_modern_macro,slide_nonid),intersect(slide_microper,slide_nonid))
double_counts_slides
buckley_table[which(buckley_table[,"ZF_PF_no."] %in% double_counts_slides),]



