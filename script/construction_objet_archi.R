library(aRchi)
library(lidR)
library(data.table)
library(foreach)
library(doParallel)
library(readr)
# test
# start parallélisation
n_cores=min(5, detectCores() - 1)
cat("Utilisation de", n_cores, "cœurs\n")
cl=makeCluster(n_cores)
registerDoParallel(cl)

## chargement fichiers
qsm_dir <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM/QSM bouamir P3"
qsm_files <- list.files(qsm_dir, pattern = "\\.txt$", full.names = TRUE)

# Traiter tous les fichiers en parallèle
res <- foreach(p = qsm_files, .packages = c("aRchi", "lidR", "data.table")) %dopar% {
  id <- sub("\\.txt$", "", basename(p))
  
  # Tout dans un seul try-catch
  result <- tryCatch({
    # Lire et construire
    myqsm <- suppressWarnings(read_QSM(p, model = "treeQSM"))
    myarchi <- build_aRchi(QSM = myqsm)
    myarchi@QSM$TreeID <- id
    if ("volume" %in% names(myarchi@QSM) && !"Volume" %in% names(myarchi@QSM)) {
      setnames(myarchi@QSM, "volume", "Volume")
    }
    myarchi <- Make_Node(myarchi)
    myarchi <- Make_Path(myarchi)
    
    list(id = id, archi = myarchi, ok = TRUE)
    
  }, error = function(e) {
    list(id = id, archi = NULL, ok = FALSE, erreur = e$message)
  })
  
  return(result)
}

# stop parallélisation
stopCluster(cl)

# Extraire les résultats 
res_final <- list()
erreurs <- list()

for (item in res) {
  if (item$ok) {
    res_final[[item$id]] <- item$archi
  } else {
    erreurs[[item$id]] <- item$erreur
    cat("❌", item$id, ":", item$erreur, "\n")
  }
}
# Résumé
cat("\n✅ Succès:", length(res_final), "/", length(qsm_files), "\n")
cat("❌ Erreurs:", length(erreurs), "\n")
# résultat final 
res <- res_final


###sauvegarde 
saveRDS(res, "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM/res_aRchi_list_upemba.rds")


#### Prb ####

### trouver prb dans caclul biomasse

id <- "mindourou_p1_ID_12"

summary(res_final[[id]]@QSM$radius_cyl)
summary(res_final[[id]]@QSM$volume)
summary(res_final[[id]]@QSM$length)

q <- res_final[[id]]@QSM
head(q[order(-q$volume), ], 10)

ratio <- tb_all / (tv_all * 550)
summary(ratio)

### Visualisation QSM
plot(res_final$mindourou_p1_ID_1)
plot(res_final$mindourou_p1_ID_100)
plot(res_final$mindourou_p1_ID_99)

############################### Visu de qq variable sur site ###############################

### volume par arbre 
id_tree <- names(res_final)[2]
tv_ex <- TreeVolume(res_final[[2]], "Tree")
names(tv_ex) <- id_tree
tv_ex


###Volume pour tous les arbres
tv_all <- sapply(res_final, function(a) TreeVolume(a, "Tree"))
tv_all
df_vol <- data.frame(
  TreeID = names(tv_all),
  Volume = as.numeric(tv_all),
  row.names = NULL
)


## re Renommmer colonne Volume en volume 

for (id in names(res_final)) {
  res_final[[id]]@QSM$volume <- res_final[[id]]@QSM$Volume
}
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
