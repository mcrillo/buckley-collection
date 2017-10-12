

species_names =  c("acostaensis","adamsi", "altispira", "anfracta", "bollii", "bulloides","calida","conglobatus",
                   "conglomerata","crassaformis", "dehiscens", "decoraperta", "digitata", "dutertrei", "falconensis",
                   "fohsi", "glomerosa", "glutinata", "hexagona", "hirsuta", "humerosa", "humilis", "inflata", "iota","insueta", 
                   "mayeri", "menardii","minuta", "mitra", "multicamerata", "nepenthes","nitida", "obliquiloculata", "obliquus", 
                   "pachyderma", "pelagica","praepumilio", "primalis", "pseudofoliata", "pumilio", "punctulata", "quinqueloba", 
                   "ruber", "rubescens","sacculifera", "scitula", "seminulina", "siphonifera", "spectabilis", "subdehiscens", 
                   "tenellus", "tosaensis", "trilobus", "truncatulinoides", "tumida", "universa", "uvula", "venezuelana")
# took out: "obliqua", "subcretacea"
# any(duplicated(species_names)) # double-checking

modern_macro_ssp <-  c("adamsi","bulloides","calida","conglobatus","conglomerata","crassaformis", "dehiscens", 
                       "digitata","dutertrei","falconensis","hexagona","hirsuta","humilis","inflata","menardii","obliquiloculata", 
                       "pachyderma","quinqueloba","ruber","rubescens","sacculifera","scitula","siphonifera","tenellus","trilobus",
                       "truncatulinoides","tumida","universa")

modern_microper_ssp <- c("glutinata", "iota", "nitida", "pelagica", "uvula")

modern_ssp <- c(modern_macro_ssp, modern_microper_ssp)
fossil_ssp <- setdiff(species_names, c(modern_macro_ssp, modern_microper_ssp))

# double checking the species names:
# all.equal(setdiff(species_names, c(modern_macro_ssp, modern_microper_ssp)), fossil_ssp)

species_names_list <- list(species_names = species_names, 
                           modern_macro_ssp = modern_macro_ssp, 
                           modern_microper_ssp = modern_microper_ssp,
                           modern_ssp = modern_ssp, 
                           fossil_ssp = fossil_ssp)

function_write_list(species_names_list, wb_name = c("data/species_names.xlsx")) 


