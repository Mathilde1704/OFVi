library(aRchi)
library(lidR)
library(data.table)
library(foreach)
library(doParallel)
library(readr)


site_plot_id = read.csv("data/raw_data/inventaires floristiques/inventaire_Gilles_Dauby/plot_id_identifiant.csv", sep = ";")
densite_ref = read.csv("data/raw_data/inventaires floristiques/inventaire_Gilles_Dauby/global_wood_density_database.csv", sep = ";")
densite_ref = aggregate(Wood.density..kg.m3. ~ Binomial, data = densite_ref, FUN = mean, na.rm = TRUE )
densite_ref$Wood.density..kg.m3. <- as.integer(densite_ref$Wood.density..kg.m3.)

site_plot_id$Wood_density <- densite_ref$Wood.density..kg.m3.[
  match(site_plot_id$species, densite_ref$Binomial)
]
#write.csv2(average_density, file = "average_density.csv")

mindourou = read_rds("données_lidar/QSM/list_archi/res_aRchi_list_mindourou.rds")
mikembo = read_rds("données_lidar/QSM/list_archi/res_aRchi_list_mikembo.rds")
ntui = read_rds("données_lidar/QSM/list_archi/res_aRchi_list_ntui.rds")
upemba = read_rds("données_lidar/QSM/list_archi/res_aRchi_list_upemba.rds")
rabi = read_rds("données_lidar/QSM/list_archi/res_aRchi_list_rabi.rds")

bouamirp3 = read_rds("données_lidar/QSM/list_archi/res_aRchi_list_bouamirp3.rds")
bouamirp16 = read_rds("données_lidar/QSM/list_archi/res_aRchi_list_bouamirp16.rds")
bouamir = c(bouamirp3, bouamirp16)


sites_list <- list(
  mindourou = mindourou,
  mikembo   = mikembo,
  ntui      = ntui,
  upemba    = upemba,
  bouamir = bouamir
)

sites_list <- lapply(sites_list, function(site) {
  lapply(site, function(tree) {
    if ("Volume" %in% names(tree@QSM) && !"volume" %in% names(tree@QSM)) {
      tree@QSM$volume <- tree@QSM$Volume
    }
    tree
  })
})


####################### Calculer des metriques #######################
#### TREE
df_tree <- data.frame(
  Site = character(),
  TreeID = character(),
  Tree_volume = numeric(),
  Tree_biomass = numeric(),
  Density_used = numeric(),
  Branch_Angle = numeric(),
  stringsAsFactors = FALSE
)

for (site_name in names(sites_list)) {
  for (tree_name in names(sites_list[[site_name]])) {
    
    archi_obj = sites_list[[site_name]][[tree_name]] 
    vol_tree = TreeVolume(archi_obj, "Tree")
    
    density <- site_plot_id$Wood_density[
      match(tree_name, site_plot_id$identifiant)
    ]
    density <- as.numeric(density)
    
    if (is.na(density)) {
      warning(paste("Identifiant", tree_name, 
                    "non trouvé ou densité manquante dans average_density"))
      density <- 550
    }
    
    tree_biomass <- TreeBiomass(archi_obj, WoodDensity = density, level = "Tree")
    
    ## Angle de branchement : seulement si Paths présents
    angle_seg <- NA_real_
    if (!is.null(archi_obj@Paths)) {
      angle_seg <- BranchAngle(
        archi_obj,
        method = "SegmentAngle",  # ou "King98"
        A0     = FALSE,
        level  = "Tree"
      )
    }
    
    df_tree <- rbind(df_tree, data.frame(
      Site = site_name,
      TreeID = tree_name,
      Tree_volume = vol_tree,
      Tree_biomass = tree_biomass,
      Density_used = density,
      Branch_Angle  = angle_seg,
      stringsAsFactors = FALSE
    ))
  }
}

hist(df_tree$Branch_Angle)
boxplot(Branch_Angle ~ Site, data = df_tree,
        main = "Variation des angles de branches par site",
        xlab = "Site", ylab = "Angle (°)")

#### branching order
df_branching_order <- data.frame(
  Site = character(),
  TreeID = character(),
  branching_order_volume = numeric(),
  branching_order_biomass = numeric(),
  Density_used = numeric(),
  Branch_Angle = numeric(),
  stringsAsFactors = FALSE
)

for (site_name in names(sites_list)) {
  for (tree_name in names(sites_list[[site_name]])) {
    
    archi_obj = sites_list[[site_name]][[tree_name]] 
    vol_branching_order = TreeVolume(archi_obj, "branching_order")
    
    density <- site_plot_id$Wood_density[
      match(tree_name, site_plot_id$identifiant)
    ]
    density <- as.numeric(density)
    
    if (is.na(density)) {
      warning(paste("Identifiant", tree_name, 
                    "non trouvé ou densité manquante dans average_density"))
      density <- 550
    }
    
    biomass_branching_order <- TreeBiomass(archi_obj, WoodDensity = density, level = "branching_order")
   
   
    
    df_branching_order <- rbind(df_branching_order, data.frame(
      Site = site_name,
      TreeID = tree_name,
      branching_order_volume = vol_branching_order,
      branching_order_biomass = biomass_branching_order,
      Density_used = density,
      Branch_Angle = angle_seg,
      stringsAsFactors = FALSE
    ))
  }
}


#### axis
df_axis <- data.frame(
  Site = character(),
  TreeID = character(),
  axis_volume = numeric(),
  axis_biomass = numeric(),
  
  stringsAsFactors = FALSE
)


for (site_name in names(sites_list)) {
  for (tree_name in names(sites_list[[site_name]])) {
    
    archi_obj = sites_list[[site_name]][[tree_name]] 
    vol_axis = TreeVolume(archi_obj, "Axis")
    
    density <- site_plot_id$Wood_density[
      match(tree_name, site_plot_id$identifiant)
    ]
    density <- as.numeric(density)
    
    if (is.na(density)) {
      warning(paste("Identifiant", tree_name, 
                    "non trouvé ou densité manquante dans average_density"))
      density <- 550
    }
    
    biomass_axis <- TreeBiomass(archi_obj, WoodDensity = density, level = "Axis")
    
    df_axis <- rbind(df_axis, data.frame(
      Site = site_name,
      TreeID = tree_name,
      axis_volume = vol_axis,
      axis_biomass = biomass_axis,
      stringsAsFactors = FALSE
    ))
  }
}





