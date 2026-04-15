

library(lidR)
library(arbor)

params <- default_arbor_parameters

params$global$cut_above_ground = 0.25

filter <- "-keep_random_fraction 0.25"

las <- readTLS("E:/MathildeMillan_DD/arbor/quadrat_taille_buffer/quadrat_1_buf5m.laz", select = "xyz", filter = filter)
las <- hybrid_homogeneization(las)
las <- segment_ground(las)
las <- wood_likelihood(las, params)
las <- segment_semantic(las, params)
see <- find_seeds(las,params =  params)

# arbor_studio_seeds(las =las , see )
las <- segment_instance(las,seeds=see,params)
las <- remove_small_trees(las, max_height = 2)
# las <- clip_buffer(las, -10)
# my_qsf=qsf(las)
# plot(my_qsf)

# Combine les les inventaire par quadra
library(data.table)
ls_inventaire <- list.files("F:/TLS_04_25_Mbalmayo/Mbal_09/bdquadrats/","Quadra*",full.names = T)

tab_inv=NULL
for (i in ls_inventaire){

  inv_i=fread(i)
  names(inv_i)=c("DBH" ,"Hauteur","IDplot", "IDtree","Species","Moved" , "CenterX"  ,"CenterY", "Rayonducercle")
  tab_inv=rbind(tab_inv,inv_i)
}

# Tranche laz  entre 1 et 1.5
las_130=las
las_130@data=las_130@data[hag<1.50&hag>1]
plot_instance(las_130)
# Inventaire laz : Table avec Moyenne des X, Y , Z et nombre de point pour chaque cluster de la sortie de arbor
XY_inv_las_130=las_130@data[,.(X_mean=mean(X),Y_mean=mean(Y),Z_mean=mean(Z),.N),by=treeID]

# Match de l’inventaire terrain avec l'inventaire laz
library(RANN)

tab_nn=nn2(XY_inv_las_130[,c("X_mean","Y_mean")],tab_inv[,c("CenterX","CenterY")],1,radius=1)

# on recupére le match <1m
tab_inv_Quadra1=tab_inv[which(tab_nn$nn.dists<1),]

# on attribue le Z mean de l'oinventaire laz à l'inventiare terrain le plus proche
tab_inv_Quadra1$Z=XY_inv_las_130[tab_nn$nn.idx[which(tab_nn$nn.dists<1)],]$Z_mean
tab_inv_Quadra1$treeID_laz=XY_inv_las_130[tab_nn$nn.idx[which(tab_nn$nn.dists<1)],]$treeID

# ON ne garde que les colonnes d'interet pour CC
tab_inv_Quadra1_4_CC=tab_inv_Quadra1[,c("CenterX","CenterY","Z","IDtree","DBH")]

for (i in 1:nrow(tab_inv_Quadra1)){
  # tree <- lidR::filter_poi(las, treeID == i)
  tree_laz_id=tab_inv_Quadra1[i,]$treeID_laz
  context_i <- extract_tree_context(las, tree_laz_id, exclude_tree = F)
  tree_inv_id =tab_inv_Quadra1[i,]$IDtree
  writeLAS(context_i,paste0("E:/MathildeMillan_DD/arbor/sortie_arbor/Tree_context/",tree_inv_id,".laz"))
}
nn_tab_test=nn2(tree@data[,1:3],las@data[,1:3])

fwrite(tab_inv_Quadra1_4_CC,"E:/MathildeMillan_DD/arbor/Inventaire_Terrrain_Quadra_Z/Quadra1.txt")

las@data$treeID[which(is.na(las@data$treeID))]=0
writeLAS(las,"E:/MathildeMillan_DD/arbor/sortie_arbor/sortie_arbor_Quadra/quadra1_0buff.laz")
