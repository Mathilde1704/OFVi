library("aRchi")
library(lidR)
library(data.table)

# read a QSM ----
p <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Rabi/plot_4/id_240099.txt"
myqsm <- suppressWarnings(
  read_QSM(p, model = "treeQSM")
)


# create a class aRchi file ----
myarchi=build_aRchi(QSM = myqsm, keep_original = F)
#myarchi=add_pointcloud(myarchi,my_pointcloud)

myarchi= Make_Node(myarchi)
myarchi = Make_Path(myarchi)

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
plot(myarchi,skeleton=T)




