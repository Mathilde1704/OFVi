library("aRchi")
library(lidR)
library(data.table)

# read a QSM ----
p <- "//amap-data.cirad.fr/safe/lidar/TLS/BDD_TLS_AC/Processed_trees/Data_QSM/Bouamir/Plot_3/ID_43.txt"
myqsm <- suppressWarnings(
  read_QSM(p, model = "treeQSM")
)

# read a point cloud ----
my_pointcloud=fread("//amap-data.cirad.fr/safe/lidar/TLS/BDD_TLS_AC/Processed_trees/Data_ndp/Bouamir/Plot_3/ID_Complet/ID_43.txt")

# create a class aRchi file ----
myarchi=build_aRchi(QSM = myqsm)
myarchi=add_pointcloud(myarchi,my_pointcloud)

#myarchi= Make_Node(myarchi)
#myarchi = Make_Pathxxxxz(myarchi)

## remplacer volume par Volume
if ("volume" %in% names(myarchi@QSM) && !"Volume" %in% names(myarchi@QSM)) {
  setnames(myarchi@QSM, "volume", "Volume")
}

##calcul du volume pour arbre/branch/axe
TreeVolume(myarchi, "Tree")
TreeVolume(myarchi, "branching_order")
TreeVolume(myarchi, "Axis")

## verification du volume par un calcul
QSM <- as.data.table(myarchi@QSM)
sum_indep <- QSM[, sum(pi * (radius_cyl^2) * length, na.rm = TRUE)]
sum_indep

# Plot ----
plot(myarchi,skeleton=T,color="axis",show_point_cloud=T)




