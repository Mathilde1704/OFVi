library(aRchi)
library(lidR)
library(data.table)
library(foreach)
library(doParallel)
library(readr)


site_plot_id = read.csv("data/raw_data/inventaires floristiques/inventaire_Gilles_Dauby/plot_id_identifiant.csv", sep = ";")
desnite_ref = read.csv("data/raw_data/inventaires floristiques/inventaire_Gilles_Dauby/plot_id_identifiant.csv", sep = ";")


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


### Création df mais pas obligatoire. 
# all_dt_list <- list()
# 
# for (site_name in names(sites_list)) {
#   res_site <- sites_list[[site_name]]  # liste d'aRchi pour ce site
#   
#   for (tree_name in names(res_site)) {
#     archi_obj <- res_site[[tree_name]]
#     
#     dt <- as.data.table(archi_obj@QSM)
#     
#     # S'assurer qu'on a un TreeID
#     if (!"TreeID" %in% names(dt)) {
#       dt[, TreeID := tree_name]
#     }
#     
#     # Ajouter le site
#     dt[, Site := site_name]
#     
#     all_dt_list[[paste(site_name, tree_name, sep = "_")]] <- dt
#   }
# }
# 
# dt_all <- rbindlist(all_dt_list, use.names = TRUE, fill = TRUE)
# 
# dt_all[]



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
    
    archi_obj <- sites_list[[site_name]][[tree_name]] 
    vol_tree <- TreeVolume(archi_obj, "Tree")
    biomass_tree <- TreeBiomass(archi_obj, WoodDensity = 550, "Tree")
    
    
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




