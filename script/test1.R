library("aRchi")
library(lidR)
library(data.table)
library(dplyr)
library(purrr)
#test_12_2_
# ============================================
# CONFIGURATION : Liste de tes sites
# ============================================
sites <- list(
  list(
    name = "Bouamir",
    parcelles = list(
      list(name = "Plot3",
           qsm = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Bouamir/Plot_3",
           ndp = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Bouamir/Plot_3/ID_Complet"),
      list(name = "P16",
           qsm = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Bouamir/Plot_16",
           ndp = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Bouamir/Plot_16/ID_Complet")
    )
  ),
  
  list(
    name = "Mikembo",
    parcelles = list(
      list(name = "Plot2",
           qsm = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Mikembo/Plot_2",
           ndp = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Mikembo/Plot_2/ID_Complet"),
      list(name = "P16",
           qsm = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Mikembo/Plot_17",
           ndp = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Mikembo/Plot_17/ID_Complet"),
      list(name = "P16",
           qsm = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Mikembo/Plot_18",
           ndp = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Mikembo/Plot_18/ID_Complet"),
      list(name = "P16",
           qsm = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Mikembo/Plot_19",
           ndp = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Mikembo/Plot_19/ID_Complet"),
      list(name = "P16",
           qsm = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Mikembo/Plot_20",
           ndp = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Mikembo/Plot_20/ID_Complet")
    )
  ),
  
  list(
    name = "Mindourou",
    parcelles = list(
      list(name = "Plot2",
           qsm = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Mindourou/Plot_1",
           ndp = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Mindourou/Plot_1/ID_Complet")
    )
  ),
  
  list(
    name = "Rabi",
    parcelles = list(
      list(name = "Plot2",
           qsm = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Rabi/Plot_1",
           ndp = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Rabi/Plot_1/ID_Complet"),
      list(name = "P16",
           qsm = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Rabi/Plot_3",
           ndp = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Rabi/Plot_3/ID_Complet"),
      list(name = "P16",
           qsm = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Rabi/Plot_4",
           ndp = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Rabi/Plot_4/ID_Complet"))
  ),
  
  
  list(
    name = "Upemba",
    parcelles = list(
      list(name = "Plot2",
           qsm = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Upemba/Plot_1",
           ndp = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Upemba/Plot_1/ID_Complet"),
      list(name = "P16",
           qsm = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Upemba/Plot_2",
           ndp = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Upemba/Plot_2/ID_Complet"),
      list(name = "P16",
           qsm = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Upemba/Plot_3",
           ndp = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Upemba/Plot_3/ID_Complet"))
  ),
  
  list(
    name = "Ntui",
    parcelles = list(
      list(name = "Plot2",
           qsm = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Ntui/Savane_Ntui",
           ndp = "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Ntui/Savane_Ntui/ID_Complet"))
  )
  )
  

# ============================================
# FONCTION DE TRAITEMENT (modifiée)
# ============================================
process_one <- function(p, site_name) {
  id_str <- sub("\\..*$", "", basename(p))  # "ID_45"
  id_num <- as.integer(sub(".*ID_(\\d+).*", "\\1", id_str))
  
  # Création de l'ID unique : site + ID local
  unique_id <- paste0(site_name, "_", id_num)
  
  # Lecture QSM + point cloud
  myqsm <- suppressWarnings(read_QSM(p, model = "treeQSM"))
  
  # Cherche le fichier ndp dans le bon dossier
  ndp_dir <- sites[[which(sapply(sites, function(s) s$name == site_name))]]$ndp
  pc_path <- file.path(ndp_dir, paste0(id_str, ".txt"))
  my_pointcloud <- if (file.exists(pc_path)) fread(pc_path) else NULL
  
  # Build aRchi
  myarchi <- build_aRchi(QSM = myqsm)
  if (!is.null(my_pointcloud)) myarchi <- add_pointcloud(myarchi, my_pointcloud)
  
  # ---- QSM table
  qsm <- as.data.table(myarchi@QSM)
  if ("volume" %in% names(qsm) && !"Volume" %in% names(qsm)) 
    setnames(qsm, "volume", "Volume")
  qsm[, Volume := as.numeric(Volume)]
  
  # Volume total arbre
  vol_tree <- sum(qsm$Volume, na.rm = TRUE)
  
  # --- BRANCHING ORDER
  ax_col <- grep("branch.*order|(^|_)order($|_)+|^bo$", 
                 names(qsm), ignore.case = TRUE, value = TRUE)[1]
  
  branching <- if (!is.na(ax_col)) {
    out <- qsm[, .(order_volume = sum(Volume, na.rm = TRUE)), by = ax_col]
    setnames(out, ax_col, "branching_order")
    out[, `:=`(site = site_name, 
               local_ID = id_num,
               unique_ID = unique_id,
               tree_volume = vol_tree)]
    out[, .(site, local_ID, unique_ID, branching_order = as.integer(branching_order), 
            order_volume = as.numeric(order_volume), tree_volume)]
  } else {
    data.table(site = character(), local_ID = integer(), unique_ID = character(),
               branching_order = integer(), order_volume = numeric(), tree_volume = numeric())
  }
  
  # --- AXIS
  ax_hits <- grep("^axis(_?id)?$|axis.?id|^axisid$", 
                  names(qsm), ignore.case = TRUE, value = TRUE)
  
  if (length(ax_hits)) {
    ax_col <- ax_hits[1]
    out <- qsm[, .(axis_volume = sum(Volume, na.rm = TRUE)), by = c(ax_col)]
    setnames(out, ax_col, "axis_id")
    out[, `:=`(site = site_name, 
               local_ID = id_num,
               unique_ID = unique_id,
               tree_volume = vol_tree)]
    axis <- out[, .(site, local_ID, unique_ID, axis_id = as.integer(axis_id), 
                    axis_volume = as.numeric(axis_volume), tree_volume)]
  } else {
    axis <- data.table(site = character(), local_ID = integer(), unique_ID = character(),
                       axis_id = integer(), axis_volume = numeric(), tree_volume = numeric())
  }
  
  # --- TREE (1 ligne par fichier)
  tree <- data.table(site = site_name, 
                     local_ID = id_num,
                     unique_ID = unique_id,
                     tree_volume = vol_tree)
  
  list(tree = tree, branching = branching, axis = axis)
}

# ============================================
# BOUCLE SUR TOUS LES SITES
# ============================================
all_parts <- list()

for (site in sites) {
  cat("\n=== Traitement du site:", site$name, "===\n")
  
  # Liste tous les fichiers QSM du site
  files <- list.files(site$qsm, pattern = "\\.treeQSM$", full.names = TRUE)
  
  if (length(files) == 0) {
    cat("Aucun fichier QSM trouvé dans", site$qsm, "\n")
    next
  }
  
  cat("Nombre de fichiers:", length(files), "\n")
  
  # Traite chaque fichier
  site_parts <- lapply(files, function(f) process_one(f, site$name))
  all_parts <- c(all_parts, site_parts)
}

# ============================================
# CONSOLIDATION DES RÉSULTATS
# ============================================
tree_df <- rbindlist(lapply(all_parts, `[[`, "tree"), 
                     use.names = TRUE, fill = TRUE)
branching_df <- rbindlist(lapply(all_parts, `[[`, "branching"), 
                          use.names = TRUE, fill = TRUE)
axis_df <- rbindlist(lapply(all_parts, `[[`, "axis"), 
                     use.names = TRUE, fill = TRUE)

# Conversion en data.frame
tree_df <- as.data.frame(tree_df)
branching_df <- as.data.frame(branching_df)
axis_df <- as.data.frame(axis_df)

# Affichage des résultats
cat("\n=== RÉSUMÉ ===\n")
cat("Nombre d'arbres total:", nrow(tree_df), "\n")
cat("Arbres par site:\n")
print(table(tree_df$site))

# ============================================
# EXPORT (optionnel)
# ============================================
# write.csv(tree_df, "resultats_tree_multisite.csv", row.names = FALSE)
# write.csv(branching_df, "resultats_branching_multisite.csv", row.names = FALSE)
# write.csv(axis_df, "resultats_axis_multisite.csv", row.names = FALS