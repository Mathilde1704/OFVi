library(aRchi)
library(lidR)
library(data.table)
library(foreach)
library(doParallel)
library(readr)


#### Mettre à jour aRchi via github car par sur CRAN
#install.packages("remotes")
#remotes::install_github('umr-amap/aRchi')

qsm_dir <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/BDD_Afrique_Centrale/données_lidar/QSM/QSM ntui"
qsm_files <- list.files(qsm_dir, pattern = "\\.txt$", full.names = TRUE)
length(qsm_files)

# Parallélisation
n_cores <- min(6, detectCores() - 1)
cat("Utilisation de", n_cores, "cœurs\n")
cl <- makeCluster(n_cores)
registerDoParallel(cl)

# Boucle sur tt ma liste
res <- foreach(p = qsm_files, .packages = c("aRchi", "lidR", "data.table")) %dopar% {
  id <- sub("\\.txt$", "", basename(p))
  
  tryCatch({
    # Lecture du QSM
    myqsm <- suppressWarnings(read_QSM(p, model = "treeQSM"))
    # Stratégie : essayer d'abord avec keep_original = TRUE Si ça échoue, refaire avec keep_original = FALSE
    build_result <- tryCatch({
      myarchi <- build_aRchi(QSM = myqsm, keep_original = TRUE)
      myarchi <- Make_Node(myarchi)
      myarchi <- Make_Path(myarchi)
      list(archi = myarchi, reconstructed = FALSE, error = NA)
      
    }, error = function(e) {
      # Si échec, reconstruction avec topologie interne
      myarchi <- build_aRchi(QSM = myqsm, keep_original = FALSE)
      myarchi <- Make_Node(myarchi)
      
      # Tentative Make_Path
      path_result <- tryCatch({
        myarchi <- Make_Path(myarchi)
        list(archi = myarchi, reconstructed = TRUE, error = NA)
      }, error = function(e2) {
        # Même avec reconstruction, Make_Path échoue
        list(archi = myarchi, reconstructed = TRUE, error = conditionMessage(e2))
      })
      
      return(path_result)
    })
    
    build_result$archi@QSM$TreeID <- id
    if ("volume" %in% names(build_result$archi@QSM) &&
        !"Volume" %in% names(build_result$archi@QSM)) {
      setnames(build_result$archi@QSM, "volume", "Volume")
    }
    
    list(
      id = id,
      archi = build_result$archi,
      qsm_path = p,
      ok = TRUE,
      path_ok = is.na(build_result$error),
      path_erreur = build_result$error,
      reconstructed = build_result$reconstructed
    )
    
  }, error = function(e) {
    # Échec complet (lecture QSM ou autre problème majeur)
    list(
      id = id,
      archi = NULL,
      qsm_path = p,
      ok = FALSE,
      path_ok = FALSE,
      path_erreur = conditionMessage(e),
      reconstructed = NA
    )
  })
}

stopCluster(cl)

# Extraction des résultats
res_final <- list()
erreurs <- data.frame(
  id = character(),
  qsm_path = character(),
  erreur = character(),
  stringsAsFactors = FALSE
)
avertissements_path <- data.frame(
  id = character(),
  qsm_path = character(),
  probleme = character(),
  reconstructed = logical(),
  stringsAsFactors = FALSE
)

for (item in res) {
  # Garder tous les arbres chargés
  if (item$ok) {
    res_final[[item$id]] <- item$archi
  }
  
  # Tableau d'erreurs pour les échecs complets
  if (!item$ok) {
    erreurs <- rbind(erreurs, data.frame(
      id = item$id,
      qsm_path = item$qsm_path,
      erreur = item$path_erreur,
      stringsAsFactors = FALSE
    ))
    cat("❌", item$id, ":", item$path_erreur, "\n")
    
  } else if (!item$path_ok) {
    # Arbres chargés MAIS sans Make_Path
    avertissements_path <- rbind(avertissements_path, data.frame(
      id = item$id,
      qsm_path = item$qsm_path,
      probleme = item$path_erreur,
      reconstructed = item$reconstructed,
      stringsAsFactors = FALSE
    ))
    
    recon_msg <- ifelse(item$reconstructed, " (topologie reconstruite)", "")
    cat("⚠️ ", item$id, ": Make_Path échoué", recon_msg, " -", item$path_erreur, "\n")
  } else if (item$reconstructed) {
    # Arbres OK mais avec reconstruction (info seulement)
    cat("ℹ️ ", item$id, ": topologie reconstruite (OK)\n")
  }
}

# Résumé
cat("✅ Arbres chargés:", length(res_final), "/", length(qsm_files), "\n")
cat("❌ Échecs complets:", nrow(erreurs), "\n")
cat("⚠️  Arbres sans Make_Path:", nrow(avertissements_path), "\n")

if (nrow(avertissements_path) > 0) {
  n_reconstructed <- sum(avertissements_path$reconstructed, na.rm = TRUE)
  cat("   - dont topologie reconstruite:", n_reconstructed, "\n")
  cat("   - dont topologie originale:", nrow(avertissements_path) - n_reconstructed, "\n")
}

# combien d'arbres reconstruits avec succès
n_reconstructed_ok <- sum(sapply(res, function(x) x$ok && x$path_ok && x$reconstructed))
cat("ℹ️  Arbres avec topologie reconstruite (OK):", n_reconstructed_ok, "\n")

###sauvegarde
saveRDS(res_final, "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/BDD_Afrique_Centrale/données_lidar/QSM/list_archi/res_aRchi_list_ntui.rds")