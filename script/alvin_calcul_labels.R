library("aRchi")
library(lidR)
library(data.table)
library(dplyr)
library(purrr)

# read a QSM ----
p <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/BDD_Afrique_Centrale/raw_data/Alvin/labeled/QSM/ID_16.treeQSM"
myqsm <- suppressWarnings(
  read_QSM(p, model = "treeQSM")
)

# read a point cloud ----
my_pointcloud=fread("F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/BDD_Afrique_Centrale/raw_data/Alvin/labeled/ndp/ID_16.txt")

# create a class aRchi file ----
myarchi=build_aRchi(QSM = myqsm)
myarchi=add_pointcloud(myarchi,my_pointcloud)

myarchi= Make_Node(myarchi)
myarchi = Make_Path(myarchi)

## remplacer volume par Volume
if ("volume" %in% names(myarchi@QSM) && !"Volume" %in% names(myarchi@QSM)) {
  setnames(myarchi@QSM, "volume", "Volume")
}

##calcul du volume pour arbre/branch/axe
myarchi[["TreeVolume"]] <- TreeVolume(myarchi, "Tree")

tree <- data.frame(TreeVolume = TreeVolume(myarchi, "Tree"))

branching = data.frame(TreeVolume = TreeVolume(myarchi, "branching_order"))

Axis = data.frame(TreeVolume = TreeVolume(myarchi, "Axis"))

#récuperation de l'ID
id_str <- sub("\\..*$", "", basename(p))   # -> "ID_45"
tree$ID <- id_str   
branching$ID <- id_str 
Axis$ID <- id_str

## verification du volume par un calcul
QSM <- as.data.table(myarchi@QSM)
sum_indep <- QSM[, sum(pi * (radius_cyl^2) * length, na.rm = TRUE)]
sum_indep


###Calcul autre labels

TreeBiomass(myarchi,WoodDensity = NULL,"Tree")
DAI(myarchi)
BranchAngle(myarchi,level="branching_order",method="SegmentAngle",A0=TRUE)

# Plot ----
plot(myarchi,skeleton=T,color="branching_order",show_point_cloud=T)
plot(myarchi,skeleton=T,color="subtree",show_point_cloud=T)


### Calc par dossier :
# Dossiers
base    <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/BDD_Afrique_Centrale/raw_data/Alvin/labeled"
qsm_dir <- file.path(base, "QSM")
ndp_dir <- file.path(base, "ndp")

# Tous les QSM
files <- list.files(qsm_dir, pattern = "\\.treeQSM$", full.names = TRUE)

process_one <- function(p) {
  id_str <- sub("\\..*$", "", basename(p))           # "ID_45"
  id_num <- as.integer(sub(".*ID_(\\d+).*", "\\1", id_str))
  
  # lecture QSM + point cloud
  myqsm <- suppressWarnings(read_QSM(p, model = "treeQSM"))
  pc_path <- file.path(ndp_dir, paste0(id_str, ".txt"))
  my_pointcloud <- if (file.exists(pc_path)) fread(pc_path) else NULL
  
  # build aRchi (pour récupérer QSM proprement)
  myarchi <- build_aRchi(QSM = myqsm)
  if (!is.null(my_pointcloud)) myarchi <- add_pointcloud(myarchi, my_pointcloud)
  
  # ---- QSM table
  qsm <- as.data.table(myarchi@QSM)
  if ("volume" %in% names(qsm) && !"Volume" %in% names(qsm)) setnames(qsm, "volume", "Volume")
  qsm[, Volume := as.numeric(Volume)]
   
  # Volume total arbre
  vol_tree <- sum(qsm$Volume, na.rm = TRUE)
  
  # --- BRANCHING ORDER (depuis QSM)
  ax_col <- grep("branch.*order|(^|_)order($|_)+|^bo$", names(qsm), ignore.case = TRUE, value = TRUE)[1]
  branching <- if (!is.na(ax_col)) {
    out <- qsm[, .(order_volume = sum(Volume, na.rm = TRUE)), by = ax_col]
    setnames(out, ax_col, "branching_order")
    out[, `:=`(ID = id_num, tree_volume = vol_tree)]
    out[, .(ID, branching_order = as.integer(branching_order),
            order_volume = as.numeric(order_volume), tree_volume)]
  } else data.table(ID = integer(), branching_order = integer(),
                    order_volume = numeric(), tree_volume = numeric())
  
  # --- AXIS (depuis QSM)
  ax_hits <- grep("^axis(_?id)?$|axis.?id|^axisid$", names(qsm), ignore.case = TRUE, value = TRUE)
  if (length(ax_hits)) {
    ax_col <- ax_hits[1]
    out <- qsm[, .(axis_volume = sum(Volume, na.rm = TRUE)), by = c(ax_col)]  # ← ICI : c(ax_col), pas ..ax_col
    data.table::setnames(out, ax_col, "axis_id")
    out[, `:=`(ID = id_num, tree_volume = vol_tree)]
    axis <- out[, .(ID, axis_id = as.integer(axis_id),
                    axis_volume = as.numeric(axis_volume), tree_volume)]
  } else {
    axis <- data.table::data.table(ID = integer(), axis_id = integer(),
                                   axis_volume = numeric(), tree_volume = numeric())
  }
  
  # --- TREE (1 ligne par fichier)
  tree <- data.table(ID = id_num, tree_volume = vol_tree)
  
  list(tree = tree, branching = branching, axis = axis)
}

parts <- lapply(files, process_one)

# 3 data.frames finaux
tree_df      <- rbindlist(lapply(parts, `[[`, "tree"),      use.names = TRUE, fill = TRUE)
branching_df <- rbindlist(lapply(parts, `[[`, "branching"), use.names = TRUE, fill = TRUE)
axis_df      <- rbindlist(lapply(parts, `[[`, "axis"),      use.names = TRUE, fill = TRUE)

# (optionnel) en data.frame
tree_df      <- as.data.frame(tree_df)
branching_df <- as.data.frame(branching_df)
axis_df      <- as.data.frame(axis_df)


write.csv2(tree_df, file = "tree_volume.csv", row.names = FALSE)  
write.csv2(branching_df, file = "branching_volume.csv", row.names = FALSE)  
write.csv2(axis_df, file = "axis_volume.csv", row.names = FALSE)  



qsm <- data.table::as.data.table(myarchi@QSM)
range(qsm$Z, na.rm=TRUE)           # hauteur approx en unités des données
summary(qsm[, .(radius_cyl, length)])  # doivent être << 1 si en mètres
