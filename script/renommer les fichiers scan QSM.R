############# RENOMMER QSM ##############
#### BOUAMIR 
###Bouamir P16
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Bouamir/Plot_16"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM bouamir"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.treeQSM$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("bouamir_p16_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)
###Bouamir P3
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Bouamir/Plot_3"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM bouamir"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("bouamir_p3_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)

###### MIKEMBO 
###Mikembo P2
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Mikembo/Plot_2"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM mikembo"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("mikembo_p2_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)
###Mikembo P17
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Mikembo/Plot_17"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM mikembo"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("mikembo_p17_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)
###Mikembo P18
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Mikembo/Plot_18"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM mikembo"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("mikembo_p18_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)
###Mikembo P19
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Mikembo/Plot_19"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM mikembo"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("mikembo_p19_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)
###Mikembo P20
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Mikembo/Plot_20"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM mikembo"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("mikembo_p20_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)

#### MINDOUROU
###Mindourou P1
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Mindourou/plot_1"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM mindourou"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("mindourou_p1_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)


#### NTUI
###Ntui P1
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Ntui/plot_1"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM ntui"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("ntui_p1_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)




#### RABI
###Rabi P1
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Rabi/plot_1"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM rabi"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("rabi_p1_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)

ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Rabi/plot_3"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM rabi"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("rabi_p3_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)

ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Rabi/plot_4"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM rabi"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("rabi_p4_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)



#### UPEMBA
###Upemba P1
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Upemba/plot_1"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM upemba"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("upemba_p1_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)

ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Upemba/plot_2"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM upemba"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("upemba_p2_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)

ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_QSM/Upemba/plot_3"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/QSM upemba"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("upemba_p3_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)



############# RENOMMER SCAN ##############


#### BOUAMIR 
###Bouamir P16
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Bouamir/Plot_16/ID_Complet"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/NDP/bouamir"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("bouamir_p16_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)
###Bouamir P3
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Bouamir/Plot_3/Id_Complet"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/NDP/bouamir"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("bouamir_p3_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)

###### MIKEMBO 
###Mikembo P2
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Mikembo/Plot_2/Id_Complet"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/NDP/mikembo"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("mikembo_p2_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)
###Mikembo P17
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Mikembo/Plot_17/Id_Complet"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/NDP/mikembo"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("mikembo_p17_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)
###Mikembo P18
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Mikembo/Plot_18/Id_Complet"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/NDP/mikembo"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("mikembo_p18_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)
###Mikembo P19
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Mikembo/Plot_19/Id_Complet"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/NDP/mikembo"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("mikembo_p19_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)
###Mikembo P20
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Mikembo/Plot_20/Id_Complet"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/NDP/mikembo"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("mikembo_p20_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)

#### MINDOUROU
###Mindourou P1
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Mindourou/plot_1/Id_Complet"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/NDP/mindourou"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("mindourou_p1_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)


#### NTUI
###Ntui P1
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Ntui/Savane_Ntui/Id_Complet"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/NDP/ntui"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("ntui_p1_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)




#### RABI
###Rabi P1
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Rabi/plot_1/Id_Complet"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/NDP/rabi"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("rabi_p1_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)

ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Rabi/plot_3/Id_Complet"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/NDP/rabi"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("rabi_p3_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)

ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Rabi/plot_4/Id_Complet"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/NDP/rabi"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("rabi_p4_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)



#### UPEMBA
###Upemba P1
ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Upemba/plot_1/Id_Complet"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/NDP/upemba"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("upemba_p1_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)

ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Upemba/plot_2/Id_Complet"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/NDP/upemba"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("upemba_p2_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)

ancien_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/TLS/Processed_trees/Data_ndp/Upemba/plot_3/Id_Complet"     # le dossier actuel
nouveau_dossier <- "F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/données_lidar/NDP/upemba"  # nouveau dossier
fichiers <- list.files(ancien_dossier, pattern = "\\.txt$", full.names = TRUE)
anciens_noms <- basename(fichiers)
nouveaux_noms <- paste0("upemba_p3_", anciens_noms)
nouveaux_chemins <- file.path(nouveau_dossier, nouveaux_noms)
file.copy(from = fichiers, to = nouveaux_chemins)

