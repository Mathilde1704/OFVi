library(aRchi)
library(lidR)
library(data.table)
library(foreach)
library(doParallel)
library(readr)

getwd()

site_plot_id = read.csv("data/raw_data/inventaires floristiques/inventaire_Gilles_Dauby/plot_id_identifiant.csv", sep = ";")
lien_qsm_inventaire = read.csv("data/raw_data/inventaires floristiques/fichier_lien_qsm_inventaire.csv", sep = ";")
densite_ref = read.csv("data/raw_data/inventaires floristiques/inventaire_Gilles_Dauby/global_wood_density_database.csv", sep = ";")
densite_ref = aggregate(Wood.density..kg.m3. ~ Binomial, data = densite_ref, FUN = mean, na.rm = TRUE )
densite_ref$Wood.density..kg.m3. <- as.integer(densite_ref$Wood.density..kg.m3.)

idx <- match(site_plot_id$identifiant, lien_qsm_inventaire$ID_commun)
site_plot_id$DBH_inventory <- lien_qsm_inventaire$DBH_inventory[idx]
site_plot_id$tax_sp_inventaire <- lien_qsm_inventaire$tax_sp_level[idx]
site_plot_id$phenology     <- lien_qsm_inventaire$phenology[idx]
site_plot_id$succession_guild <- lien_qsm_inventaire$succession_guild[idx]
site_plot_id$Wood_density_inventaire <- lien_qsm_inventaire$wood_density_mean[idx]
site_plot_id$Wood_density_inventaire <- site_plot_id$Wood_density_inventaire * 1000
site_plot_id$Wood_density_inventaire <- as.integer(site_plot_id$Wood_density_inventaire)

site_plot_id$Wood_density_article <- densite_ref$Wood.density..kg.m3.[
  match(site_plot_id$species, densite_ref$Binomial)
]

site_plot_id$Wood_density_inventaire[site_plot_id$Wood_density_inventaire == ""] <- NA
site_plot_id$Wood_density_article[site_plot_id$Wood_density_article == ""] <- NA

site_plot_id$wood_density_final <- ifelse(!is.na(site_plot_id$Wood_density_inventaire),
                                          site_plot_id$Wood_density_inventaire,
                                ifelse(!is.na(site_plot_id$Wood_density_article),
                                       site_plot_id$Wood_density_article,
                                       550))

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


get_tree_height_from_QSM <- function(QSM) {
  z_vals <- c(QSM$startZ, QSM$endZ)   # les deux colonnes
  height <- max(z_vals, na.rm = TRUE) - min(z_vals, na.rm = TRUE)
  return(height)
}

####################### Calculer des metriques #######################
#### TREE
df_tree <- data.frame(
  Site = character(),
  TreeID = character(),
  Tree_volume = numeric(),
  Tree_biomass = numeric(),
  Density_used = numeric(),
  Branch_Angle_segment = numeric(),
  Path_fraction = numeric(),
  DAI = numeric(),
  N_Fork = numeric(), #Nb de fourches dans l'arbre
  ForkRate = numeric(), #Nombre de fourches par mètre de hauteur 
  WoodSurface = numeric(),
  stringsAsFactors = FALSE
)

for (site_name in names(sites_list)) {
  for (tree_name in names(sites_list[[site_name]])) {
    
    archi_obj = sites_list[[site_name]][[tree_name]] 
    vol_tree = TreeVolume(archi_obj, "Tree")
    
    idx <- match(tree_name, site_plot_id$identifiant)
    
    # Vérifier si l'identifiant existe ET si la densité n'est pas NA
    if (is.na(idx) || is.na(site_plot_id$wood_density_final[idx])) {
      warning(paste("Identifiant", tree_name, 
                    "non trouvé ou densité manquante dans site_plot_id"))
      density <- 550
    } else {
      density <- as.numeric(site_plot_id$wood_density_final[idx])
    }
    
    tree_biomass <- TreeBiomass(archi_obj, WoodDensity = density, level = "Tree")
    
    ## Est-ce qu'il y a des Paths ?
    has_paths <- !is.null(archi_obj@Paths)
    
    ## Initialiser les métriques dépendantes des Paths à NA
    angle_segment_Angle <- NA_real_
    path_fraction_val   <- NA_real_
    DAI_val             <- NA_real_
    N_Fork_val          <- NA_real_
    ForkRate_val        <- NA_real_
    
    if (has_paths) {
      angle_segment_Angle <- BranchAngle(
        archi_obj,
        method = "SegmentAngle",  
        A0     = FALSE,
        level  = "Tree"
      )
      
      path_fraction_val <- PathFraction(archi_obj)
      DAI_val       <- DAI(archi_obj)
      fork_res <- ForkRate(archi_obj)      
      
      N_Fork_val     <- fork_res["N_Fork"]
      ForkRate_val   <- fork_res["Forkrate"]
      
    } else {
      warning(paste("Pas de Paths pour", site_name, tree_name, 
                    ": Path_fraction et DAI mis à NA"))
    }
   
    WoodSurface_val  = WoodSurface(archi_obj, level = "Tree")
    
    df_tree <- rbind(df_tree, data.frame(
      Site = site_name,
      TreeID = tree_name,
      Tree_volume = vol_tree,
      Tree_biomass = tree_biomass,
      Density_used = density,
      Branch_Angle_segment  = angle_segment_Angle,
      Path_fraction = path_fraction_val,
      DAI = DAI_val,
      N_Fork = N_Fork_val,
      ForkRate = ForkRate_val, 
      WoodSurface = WoodSurface_val,
      stringsAsFactors = FALSE
    ))
  }
}


##Ajouter la hauteur de l'arbre
df_tree$Tree_height <- mapply(
  FUN = function(site_name, tree_name) {
    archi_obj <- sites_list[[site_name]][[tree_name]]
    QSM <- get_QSM(archi_obj)
    get_tree_height_from_QSM(QSM)
  },
  site_name = df_tree$Site,
  tree_name = df_tree$TreeID
)

#############
sp  <- trimws(as.character(site_plot_id$species))
tax <- trimws(as.character(site_plot_id$tax_sp_inventaire))

sp[sp == ""]   <- NA
tax[tax == ""] <- NA

site_plot_id$species_final <- sp
site_plot_id$species_final[is.na(site_plot_id$species_final)] <- tax[is.na(site_plot_id$species_final)]


df_tree$species_final <- site_plot_id$species_final[
  match(df_tree$TreeID, site_plot_id$identifiant)]


df_tree$DBh_inventory <- site_plot_id$DBH_inventory[
  match(df_tree$TreeID, site_plot_id$identifiant)]

df_tree$phenology <- site_plot_id$phenology[
  match(df_tree$TreeID, site_plot_id$identifiant)]

df_tree$succession_guild <- site_plot_id$succession_guild[
  match(df_tree$TreeID, site_plot_id$identifiant)]


########################################## Metrique calculé à partir du NDP 
# install.packages("devtools")
library(ITSMe)

# Lire le nuage de points de l'arbre
pc_tree <- read_tree_pc(
  path = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/BDD_Afrique_Centrale/données_lidar/NDP/bouamir/bouamir_p3_ID_1.txt"
)

# Calculer les métriques (en extrayant les valeurs des listes)
hauteur <- tree_height_pc(pc = pc_tree)$h

dbh_result <- dbh_pc(pc = pc_tree)
dbh <- dbh_result$dbh

surface_proj <- projected_area_pc(pc = pc_tree)$pa
volume_alpha <- alpha_volume_pc(pc = pc_tree)$av

position <- tree_position_pc(pc = pc_tree)  # vecteur c(x, y, z)

diametre_couronne <- 2 * sqrt(surface_proj / pi)
ratio_H_L <- hauteur / diametre_couronne

df_metriques <- data.frame(
  arbre_id = "bouamir_p3_ID_1",
  hauteur_m = hauteur,
  dbh_m = dbh,
  surface_projetee_m2 = surface_proj,
  volume_alpha_m3 = volume_alpha,
  diametre_couronne_m = diametre_couronne,
  ratio_hauteur_largeur = ratio_H_L,
  position_x = position[1],
  position_y = position[2],
  position_z = position[3]
)

df_metriques
df_metriques$epaisseur_moy = df_metriques$volume_alpha_m3 / df_metriques$surface_projetee_m2
df_metriques$espace_occupe = df_metriques$volume_alpha_m3 / ((df_metriques$surface_projetee_m2)*(df_metriques$hauteur_m))

dir_ndp <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/BDD_Afrique_Centrale/données_lidar/NDP/NDP_sites"
files <- list.files(dir_ndp, pattern = "\\.txt$", full.names = TRUE, recursive = TRUE)

# Petite fonction pour extraire une valeur depuis un retour ITSMe (liste ou numérique)
get_val <- function(x, name) {
  if (is.list(x) && !is.null(x[[name]])) return(x[[name]])
  if (is.numeric(x) && length(x) == 1) return(x)
  return(NA_real_)
}

# Fonction qui calcule les métriques pour 1 fichier
calc_metrics_one <- function(path) {
  arbre_id <- tools::file_path_sans_ext(basename(path))
 
  pc_tree <- read_tree_pc(path = path)
  hauteur_out <- tree_height_pc(pc = pc_tree)
  hauteur <- get_val(hauteur_out, "h")
  dbh_out <- dbh_pc(pc = pc_tree)
  dbh <- get_val(dbh_out, "dbh")
  pa_out <- projected_area_pc(pc = pc_tree)
  surface_proj <- get_val(pa_out, "pa")

  av_out <- alpha_volume_pc(pc = pc_tree)
  volume_alpha <- get_val(av_out, "av")
  
  position <- tree_position_pc(pc = pc_tree)
  px <- ifelse(length(position) >= 1, position[1], NA_real_)
  py <- ifelse(length(position) >= 2, position[2], NA_real_)
  pz <- ifelse(length(position) >= 3, position[3], NA_real_)
  
  # Diamètre équivalent + ratio H/L
  diametre_couronne <- ifelse(!is.na(surface_proj) && surface_proj > 0,
                              2 * sqrt(surface_proj / pi),
                              NA_real_)
  ratio_H_L <- ifelse(!is.na(hauteur) && !is.na(diametre_couronne) && diametre_couronne > 0,
                      hauteur / diametre_couronne,
                      NA_real_)
  
  data.frame(
    arbre_id = arbre_id,
    fichier = path,
    hauteur_m = hauteur,
    dbh_m = dbh,
    surface_projetee_m2 = surface_proj,
    volume_alpha_m3 = volume_alpha,
    diametre_couronne_m = diametre_couronne,
    ratio_hauteur_largeur = ratio_H_L,
    position_x = px,
    position_y = py,
    position_z = pz,
    stringsAsFactors = FALSE
  )
}

# Boucle sur tous les fichiers avec gestion d'erreurs (très important en TLS)
res_list <- lapply(files, function(f) {
  tryCatch(
    calc_metrics_one(f),
    error = function(e) {
      data.frame(
        arbre_id = tools::file_path_sans_ext(basename(f)),
        fichier = f,
        hauteur_m = NA_real_,
        dbh_m = NA_real_,
        surface_projetee_m2 = NA_real_,
        volume_alpha_m3 = NA_real_,
        diametre_couronne_m = NA_real_,
        ratio_hauteur_largeur = NA_real_,
        position_x = NA_real_,
        position_y = NA_real_,
        position_z = NA_real_,
        error = conditionMessage(e),
        stringsAsFactors = FALSE
      )
    }
  )
})

df_metriques <- do.call(rbind, res_list)


# Sauvegarder
write.csv(df_metriques, file = file.path(dir_ndp, "metriques_TLS_ITSMe.csv"), row.names = FALSE)

f <- files[1]  # ou choisis un fichier réputé "gros"
pc <- read_tree_pc(f)

system.time(tree_height_pc(pc))
system.time(dbh_pc(pc))
system.time(projected_area_pc(pc))
system.time(alpha_volume_pc(pc))
