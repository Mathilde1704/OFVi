library(aRchi)
library(lidR)
library(data.table)
library(foreach)
library(doParallel)
library(readr)


site_plot_id = read.csv("data/raw_data/inventaires floristiques/inventaire_Gilles_Dauby/plot_id_identifiant.csv", sep = ";")
densite_ref = read.csv("data/raw_data/inventaires floristiques/inventaire_Gilles_Dauby/global_wood_density_database.csv", sep = ";")
average_density = aggregate(Wood.density..kg.m3.~ Binomial, data = densite_ref, FUN = mean, na.rm = TRUE)
average_density$identifiant <- site_plot_id$identifiant[match(average_density$Binomial,site_plot_id$species)]

#write.csv2(average_density, file = "average_density.csv")

mindourou = read_rds("données_lidar/QSM/res_aRchi_list_mindourou.rds")
mikembo = read_rds("données_lidar/QSM/res_aRchi_list_mikembo.rds")
ntui = read_rds("données_lidar/QSM/res_aRchi_list_ntui.rds")
upemba = read_rds("données_lidar/QSM/res_aRchi_list_upemba.rds")

sites_list <- list(
  mindourou = mindourou,
  mikembo   = mikembo,
  ntui      = ntui,
  upemba    = upemba
)

####################### Calculer des metriques #######################

############# VOLUME ############# 

#### TreeVolume 
df_tree <- data.frame(
  Site = character(),
  TreeID = character(),
  TreeVolume_total = numeric(),
  Treebiomass = numeric(),
  stringsAsFactors = FALSE
)

for (site_name in names(sites_list)) {
  for (tree_name in names(sites_list[[site_name]])) {
    
    archi_obj = sites_list[[site_name]][[tree_name]] 
    vol_tree = TreeVolume(archi_obj, "Tree")
    
    density = average_density$Wood.density..kg.m3.[average_density$identifiant == tree_name]
    
    # Si l'identifiant n'est pas trouvé, utiliser une valeur par défaut
    if(length(density) == 0) {
      warning(paste("Identifiant", tree_name, "non trouvé dans average_density"))
      density <- 550 # valeur par défaut
    } else {
      # IMPORTANT : prendre seulement la première valeur si plusieurs matches
      density <- density[1]
    }
    
    # Calculer la biomasse avec  densité spécifique à l'espèce
    biomass_tree <- TreeBiomass(archi_obj, WoodDensity = density, level = "Tree")
    
    df_tree <- rbind(df_tree, data.frame(
      Site = site_name,
      TreeID = tree_name,
      TreeVolume_total = vol_tree,
      Treebiomass = biomass_tree,
      stringsAsFactors = FALSE
    ))
  }
}
    
df_tree

# Test avec upemba_p2_ID_33
test_id <- "upemba_p2_ID_33"
test_density <- average_density$Wood.density..kg.m3.[average_density$identifiant == test_id]

print(paste("TreeID:", test_id))
print(paste("Densité trouvée:", test_density))
print(paste("Classe densité:", class(test_density)))

# Vérifier que l'arbre existe
if(test_id %in% names(sites_list$upemba)) {
  
  test_tree <- sites_list$upemba[[test_id]]
  
  # Calculer volume
  test_vol <- TreeVolume(test_tree, "Tree")
  print(paste("Volume:", test_vol))
  
  # Calculer biomasse
  test_biomass <- TreeBiomass(test_tree, WoodDensity = test_density, level = "Tree")
  print(paste("Biomasse TreeBiomass:", test_biomass))
  
  # Calcul manuel
  biomass_manuelle <- test_vol * test_density
  print(paste("Biomasse manuelle (volume * densité):", biomass_manuelle))
  
  # Vérifier le QSM
  print(paste("Nombre de cylindres:", nrow(test_tree@QSM)))
  print(paste("NA dans Volume?:", sum(is.na(test_tree@QSM$Volume))))
  
} else {
  print("ERREUR: upemba_p2_ID_33 n'existe pas dans sites_list$upemba")
  print("Arbres disponibles:")
  print(names(sites_list$upemba))
}

#### branching order
df_branching_order <- data.frame(
  Site = character(),
  TreeID = character(),
  branching_order_volume = numeric(),
  branching_order_biomass = numeric(),
  stringsAsFactors = FALSE
)


for (site_name in names(sites_list)) {
  for (tree_name in names(sites_list[[site_name]])) {
    
    archi_obj <- sites_list[[site_name]][[tree_name]] 
    vol_branching_order <- TreeVolume(archi_obj, "branching_order")
    biomass_branching_order <- TreeBiomass(archi_obj, WoodDensity = 550, "branching_order")
    
    
    df_branching_order <- rbind(df_branching_order, data.frame(
      Site = site_name,
      TreeID = tree_name,
      branching_order_volume = vol_branching_order,
      branching_order_biomass = biomass_branching_order,
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
    
    archi_obj <- sites_list[[site_name]][[tree_name]] 
    vol_axis <- TreeVolume(archi_obj, "Axis")
   biomass_axis <- TreeBiomass(archi_obj, WoodDensity = 550, "Axis")
    
    df_axis <- rbind(df_axis, data.frame(
      Site = site_name,
      TreeID = tree_name,
      axis_volume = vol_axis,
      axis_biomass = biomass_axis,
      stringsAsFactors = FALSE
    ))
  }
}


#### Volume pour un arbre

# indice du site et de l'arbre
i_site  <- 2
i_tree  <- 3
# nom du site et de l'arbre
site_name <- names(sites_list)[i_site]
tree_name <- names(sites_list[[i_site]])[i_tree]
# objet aRchi correspondant
archi_obj <- sites_list[[i_site]][[i_tree]]
tv_ex <- TreeVolume(archi_obj, "Tree")
names(tv_ex) <- paste(site_name, tree_name, sep = "_")
tv_ex

############# BIOMASSE ############# 

### re Renommmer colonne Volume en volume 

for (site_name in names(sites_list)) {
  for (id in names(sites_list[[site_name]])) {
    if ("Volume" %in% names(sites_list[[site_name]][[id]]@QSM)) {
      sites_list[[site_name]][[id]]@QSM$volume <- sites_list[[site_name]][[id]]@QSM$Volume
    }
  }
}

###Biomasse pour tous les arbres
#### TreeBiomass 
df_tree_biomass <- data.frame(
  Site = character(),
  TreeID = character(),
  TreeVolume_total = numeric(),
  stringsAsFactors = FALSE
)


for (site_name in names(sites_list)) {
  for (tree_name in names(sites_list[[site_name]])) {
    
    archi_obj <- sites_list[[site_name]][[tree_name]] 
    vol_tree <- TreeVolume(archi_obj, "Tree")
    
    
    df_tree_volume <- rbind(df_tree_volume, data.frame(
      Site = site_name,
      TreeID = tree_name,
      TreeVolume_total = vol_tree,
      stringsAsFactors = FALSE
    ))
  }
}
df_tree_volume


###df avec les métriques

df_archi <- data.frame(
  TreeID  = names(tv_all),
  Volume  = as.numeric(tv_all),
  Biomass = as.numeric(tb_all[names(tv_all)]),  # on aligne bien les noms
  row.names = NULL
)

df_archi




