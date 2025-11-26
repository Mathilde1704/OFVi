# Library ----
library(data.table)
library(dplyr)
library(tidyr)
library(here)
library(purrr)
library(tidyverse)

here()

# chemin raw_data ----

raw <- here( "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/BDD_Afrique_Centrale/raw_data")

# BDD_template ---- 
BDD  <- read.csv(file.path(raw,"Bouamir_BDD_template", "BDD.csv"),
                 header = TRUE, sep = ";") 
BDD$ID = as.character(BDD$ID)

#### recupration des ID des scans pour ajout dans BDD ---- 
## 1) Déclare une seule fois ta fonction d'extraction
make_path_df <- function(files) {
  parts <- strsplit(files, "[/\\\\]+")
  site  <- vapply(parts, \(p) if (length(p) >= 3) p[length(p)-2] else NA_character_, character(1))
  plot  <- vapply(parts, \(p) if (length(p) >= 2) p[length(p)-1] else NA_character_, character(1))
  idb   <- tools::file_path_sans_ext(basename(files))
  
  data.frame(
    file    = files,
    site    = tolower(site),
    plot    = tolower(plot),
    id_base = idb,
    stringsAsFactors = FALSE
  )
}
## 2) Liste les dossiers à ingérer (tous en une fois)
root_dirs <- c(
  "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Upemba/plot_1",
  "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Upemba/plot_2",
  "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Upemba/plot_3",
  "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Ntui/plot_1",
  "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Rabi/plot_1",
  "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Rabi/plot_3",
  "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Rabi/plot_4"
)
## 3) Récupère tous les fichiers puis construis les lignes à ajouter
new_rows <- root_dirs |>
  map(\(rd) list.files(rd, pattern = "(?i)^id_.*\\.txt$", full.names = TRUE, recursive = TRUE)) |>
  flatten_chr() |>
  make_path_df() |>
  transmute(
    ID   = sub("(?i)^id_+", "", as.character(id_base)),
    site = site,
    plot = toupper(sub("^plot_+", "P", as.character(plot)))
  )
#### Empile ID dans BDD ---- 

BDD <- bind_rows(
  BDD,
  new_rows %>%
    mutate(across(everything(), as.character)) %>%        # harmonise les types
    add_column(!!!setNames(rep(list(NA), length(setdiff(names(BDD), names(.)))), 
                           setdiff(names(BDD), names(.)))) %>%
    select(all_of(names(BDD)))
)
## Contrôles 
with(subset(BDD, site == "upemba"), table(plot, useNA = "ifany"))
with(subset(BDD, site == "ntui"),   table(plot, useNA = "ifany"))
with(subset(BDD, site == "rabi"),   table(plot, useNA = "ifany"))

# chargement données inventaire floristique ---- 
momo_inventaire_flo <- read.csv(file.path(raw, "inventaires floristiques",
                                          "inventaire_Stephane_Momo",
                                          "fusion_parcelles_momo.csv"),
                                header = TRUE, sep = ";")


dauby_dir <- file.path(raw, "inventaires floristiques", "inventaire_Gilles_Dauby")

#dauby_inventaire_flo_bouamir  <- read.csv(file.path(dauby_dir, "extract_bouamir_P16_P3.csv"), header=TRUE, sep=";")
#dauby_inventaire_flo_mbalmayo <- read.csv(file.path(dauby_dir, "extract_mbalmayo5_6_9.csv"), header=TRUE, sep=";")
#dauby_inventaire_flo_mikembo  <- read.csv(file.path(dauby_dir, "extract_mikembo.csv"), header=TRUE, sep=";")
#dauby_inventaire_flo_mikembo$tag = as.character(dauby_inventaire_flo_mikembo$tag)
dauby_inventaire_flo_upemba   <- read.csv(file.path(dauby_dir, "extract_upemba.csv"), header=TRUE, sep=";")
dauby_inventaire_flo_upemba$tag = as.character(dauby_inventaire_flo_upemba$tag)

#dauby_inventaire_flo = bind_rows(dauby_inventaire_flo_bouamir, dauby_inventaire_flo_upemba)


##Ajouter data momo inventaire floristique dans BDD ----

BDD$site_plot_ID = paste(BDD$site,BDD$plot, BDD$ID,sep="_")

 ## 0) Harmonise les types de la clé
  BDD$site_plot_ID <- as.character(BDD$site_plot_ID)
momo_inventaire_flo$site_plot_ID <- as.character(momo_inventaire_flo$site_plot_ID)

## 1) Déduplique df2 sur la clé (pour éviter de dupliquer des lignes de BDD)
df2 <- momo_inventaire_flo[!duplicated(momo_inventaire_flo["site_plot_ID"]), ]

## 2) Left join (garde toutes les lignes de BDD)
out <- merge(BDD, df2, by = "site_plot_ID", all.x = TRUE, suffixes = c("", ".df2"), sort = FALSE)

## 3) Remplir seulement les NA des colonnes communes et supprimer les *.df2
common <- setdiff(intersect(names(BDD), names(df2)), "site_plot_ID")

for (nm in common) {
  aux <- paste0(nm, ".df2")
  if (aux %in% names(out)) {
    # si types différents, passe en character pour pouvoir combiner sans erreur
    if (!identical(class(out[[nm]]), class(out[[aux]]))) {
      out[[nm]]  <- as.character(out[[nm]])
      out[[aux]] <- as.character(out[[aux]])
    }
    nas <- is.na(out[[nm]]) & !is.na(out[[aux]])
    out[[nm]][nas] <- out[[aux]][nas]
    out[[aux]] <- NULL
  }
}

#gestion problème fusion colonne

id_col <- "site_plot_ID"   # <-- MET ICI LE NOM DE TA COLONNE IDENTIFIANT

# 1) Prépare la source (une ligne par ID, species.name propre)
src <- momo_inventaire_flo %>%
  mutate(
    species.name = str_squish(species.name),
    species.name = na_if(species.name, "")
  ) %>%
  arrange(.data[[id_col]]) %>%
  group_by(.data[[id_col]]) %>%
  summarise(species.name_src = dplyr::first(na.omit(species.name)), .groups = "drop")

# 2) Met à jour BDD uniquement si vide/NA
BDD <- BDD %>%
  left_join(src, by = setNames(id_col, id_col)) %>%
  mutate(
    species.name = if_else(
      is.na(species.name) | str_trim(species.name) == "",
      coalesce(species.name_src, species.name),
      species.name
    )
  ) %>%
  select(-species.name_src)

## 4) Résultat
BDD <- out
write.csv2(BDD, file = "BDD_verification2.csv", row.names = FALSE)

##Ajouter data Gilles Dauby inventaire floristique dans BDD ----

dauby_inventaire_flo_upemba$site_plot_ID = paste(dauby_inventaire_flo_upemba$site,dauby_inventaire_flo_upemba$plot, dauby_inventaire_flo_upemba$tag,sep="_")

dauby_inventaire_flo_upemba <- dauby_inventaire_flo_upemba %>%
  rename(DBH = stem_diameter,
          species.name= tax_sp_level)

by_keys <- "site_plot_ID"


common_cols <- intersect(names(BDD), names(dauby_inventaire_flo_upemba))
df2_keep <- dauby_inventaire_flo_upemba %>%
  select(all_of(common_cols)) %>%
  distinct(across(all_of(by_keys)), .keep_all = TRUE)

# 2) Considérer "" comme manquant dans df1 (et df2, optionnel) pour que rows_patch les remplisse
BDD$Commentaires.sup <- na_if(trimws(iconv(BDD$Commentaires.sup, from="", to="UTF-8", sub=NA)), "")
clean_chr <- function(x) na_if(trimws(enc2utf8(x)), "") 

df1_norm <- BDD %>%
  mutate(across(where(is.character), ~na_if(trimws(.), "")))

df2_norm <- df2_keep %>%
  mutate(across(where(is.character), ~na_if(trimws(.), "")))

# Ensure key types match
df1_norm <- df1_norm %>% mutate(across(all_of(by_keys), as.character))
df2_norm <- df2_norm %>% mutate(across(all_of(by_keys), as.character))

# Make DBH numeric on both (handles "12,3" -> 12.3 too)
to_num <- function(x) suppressWarnings(as.numeric(gsub(",", ".", as.character(x))))
df1_norm <- df1_norm %>% mutate(DBH = to_num(DBH))
df2_norm <- df2_norm %>% mutate(DBH = to_num(DBH))

# 3) Patch = ne remplit que là où df1 est NA (donc NA ou "" une fois normalisé)
res <- rows_patch(df1_norm, df2_norm, by = by_keys, unmatched = "ignore")

