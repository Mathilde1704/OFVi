library(aRchi)
library(lidR)
library(data.table)
library(foreach)
library(doParallel)
library(readr)

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

####### VOLUME ####### 

#### TreeVolume 
for (site_name in names(sites_list)) {
  for (tree_name in names(sites_list[[site_name]])) {
    
    archi_obj <- sites_list[[site_name]][[tree_name]] 
    vol_tree <- TreeVolume(archi_obj, "Tree")
    archi_obj@QSM$TreeVolume_total <- vol_tree
    
    archi_obj@QSM$TreeID <- tree_name
    archi_obj@QSM$Site   <- site_name
    # remettre l'objet modifié dans la liste
    sites_list[[site_name]][[tree_name]] <- archi_obj
  }
}

#### branching order
vol_bo_vec <- unlist(vol_branching_order, use.names = TRUE)
archi_obj@QSM$branching_order_Volume <-
  vol_bo_vec[ as.character(archi_obj@QSM$branching_order) ]


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


### re Renommmer colonne Volume en volume 

for (site_name in names(sites_list)) {
  for (id in names(sites_list[[site_name]])) {
    if ("Volume" %in% names(sites_list[[site_name]][[id]]@QSM)) {
      sites_list[[site_name]][[id]]@QSM$volume <- sites_list[[site_name]][[id]]@QSM$Volume
    }
  }
}
 
## REPRENDRE ici
###Biomasse pour 1 arbre
id_test <- names(res_final)[1]
TreeBiomass(res_final[[id_test]], WoodDensity = 550, level = "Tree")
###Biomasse pour tous les arbres
tb_all <- sapply(res_final, function(a) {
  TreeBiomass(a, WoodDensity = 550, level = "Tree")
})
tb_all


###df avec les métriques

df_archi <- data.frame(
  TreeID  = names(tv_all),
  Volume  = as.numeric(tv_all),
  Biomass = as.numeric(tb_all[names(tv_all)]),  # on aligne bien les noms
  row.names = NULL
)

df_archi




