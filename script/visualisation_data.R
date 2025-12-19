library(ggplot2)
library(dplyr)
library(lme4)
library(lmerTest)
library(ggfortify)
library(FactoMineR)
library(factoextra)

#Regarder volume pour tree_height = X
df_tree =read.csv("F:/MathildeMillan_DD/OFVi/diversite_archi_afrique_centrale/BDD_Afrique_Centrale/BDD_Afrique_Centrale/R_output_file/df_tree.csv", header = T, sep = ";") 
df_tree[ abs(df_tree$Tree_height - 49.32197) < 1e-6 , ]

hist(df_tree$Tree_volume)
hist(df_tree$Tree_biomass)
hist(df_tree$Branch_Angle_segment)

hist(df_tree$DAI)
hist(df_tree$WoodSurface)
hist(df_tree$Tree_height)

hist(df_tree$ForkRate, breaks = seq(0, 200, by = 10),
     main  = "Histogramme du volume",
     xlab  = "Tree_volume",
     ylab  = "Fréquence")

##plot un arbre

tree_mindourou_2 <- sites_list[["mindourou"]][["mindourou_p1_ID_1"]]
plot(tree_mindourou_2)



##### Nombre d'espèces
especes_par_site <- df_tree %>% 
  filter(!is.na(species_final)) %>%          # ou espece
  group_by(Site) %>% 
  summarise(N_especes = n_distinct(species_final)) %>% 
  arrange(Site)

ggplot(especes_par_site, aes(x = Site, y = N_especes)) +
  geom_col() +
  labs(title = "Nombre d'espèces par site",
       x = "Site",
       y = "Nombre d'espèces") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

top_especes_site <- df_tree %>%
  filter(!is.na(species_final)) %>%
  group_by(Site, species_final) %>%
  summarise(N = n(), .groups = "drop") %>%
  group_by(Site) %>%
  arrange(desc(N)) %>%
  slice_head(n = 5)

ggplot(top_especes_site,
       aes(x = reorder(species_final, N), y = N, fill = species_final)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  facet_wrap(~ Site, scales = "free_y") +
  labs(title = "Top 5 espèces dominantes par site",
       x = "Espèce", y = "Nombre d'individus") +
  theme_bw()


comm <- df_tree %>%
  filter(!is.na(species_final)) %>%
  group_by(Site, species_final) %>%
  summarise(N = n(), .groups = "drop")

ggplot(comm,
       aes(x = Site, y = species_final, fill = N)) +
  geom_tile() +
  scale_fill_viridis_c() +
  labs(title = "Abondance des espèces par site",
       x = "Site", y = "Espèce") +
  theme_bw()



############################# Path fraction ############################# 
df_tree$SizeClass <- cut(df_tree$Tree_height,
                         breaks = 3,
                         labels = c("Petit", "Moyen", "Grand"))

#distribution des valeurs 
hist(df_tree$Path_fraction,
     main  = "Histogramme du Path_fraction",
     xlab  = "Tree_volume",
     ylab  = "Fréquence")

# PF~ taille
boxplot(Path_fraction ~ SizeClass,
        data = df_tree,
        col  = c("lightblue", "tan1", "lightgreen"),
        main = "Path Fraction selon la taille des arbres (hauteur)",
        xlab = "Classe de taille (hauteur)",
        ylab = "Path Fraction")

tapply(df_tree$Tree_height, df_tree$SizeClass, summary)


plot(df_tree$Tree_height, df_tree$Path_fraction,
     pch = 19, col = rgb(0,0,1,0.3),
     xlab = "Hauteur de l'arbre (m)",
     ylab = "Path Fraction",
     main = "Relation entre Path Fraction et hauteur")
abline(lm(Path_fraction ~ Tree_height, data = df_tree), col = "red", lwd = 2)

mod =lm(Path_fraction ~ Tree_height, data = df_tree)
table(df_tree$SizeClass)
s <- summary(mod)
r2   <- round(s$r.squared, 2)
pval <- s$coefficients["Tree_height", "Pr(>|t|)"]


### dif entre sites
par (mar= c(8,4,4,2))


ggplot(df_tree, aes(Site, Path_fraction)) +
  geom_boxplot() +
  theme_classic()

ggplot(df_tree, aes(Density_used, Path_fraction)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = TRUE) +
  theme_classic() +
  labs(x = "Wood density (proxy for growth strategy)",
       y = "Path fraction")

m1 <- lm(Path_fraction ~ Density_used, data = df_tree)
summary(m1)

ggplot(df_tree, aes(Site, Density_used)) +
  geom_boxplot() +
  theme_classic()


boxplot(Path_fraction ~ species_final,
        data = df_tree,
        las = 2,
        main = "Variabilité de Path Fraction selon les sites",
        xlab = "",
        ylab = "Path Fraction")

df_bouamir <- subset(df_tree,
                    Site == "mikembo" &
                      !is.na(Path_fraction) &
                      !is.na(species_final))

boxplot(Path_fraction ~ species_final,
        data = df_bouamir,
        las = 2,
        main = "Variabilité de Path Fraction selon les sites",
        xlab = "",
        ylab = "Path Fraction")


anova_mod <- aov(Path_fraction ~ Site, data = df_tree)
summary(anova_mod)
tukey_res <- TukeyHSD(anova_mod)


df_plot <- subset(df_tree, !is.na(Path_fraction) & !is.na(SizeClass))

ggplot(df_plot, aes(x = Site,
                    y = Path_fraction,
                    fill = SizeClass)) +
  geom_boxplot(position = position_dodge(width = 0.8)) +
  labs(title = "Path Fraction par taille d'arbre et par site",
       x = "Site",
       y = "Path Fraction",
       fill = "Classe de taille") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))



############################# DAI ############################# 
hist(df_tree$DAI,
     main  = "Histogramme du Path_fraction",
     xlab  = "Tree_volume",
     ylab  = "Fréquence")


df_dai <- subset(df_tree, !is.na(DAI))

ggplot(df_dai, aes(x = Site, y = DAI)) +
  geom_boxplot() +
  labs(title = "DAI selon les sites",
       x = "Site",
       y = "DAI (dominance de l'axe principal)") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


m <- lmer(DAI ~ Tree_height + Site + (1|species_final), data = df_tree)
anova(m)

ggplot(df_dai, aes(x = SizeClass , y = DAI)) +
  geom_boxplot() +
  labs(title = "DAI selon les sites",
       x = "Site",
       y = "DAI (dominance de l'axe principal)") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#############################  Branch angle ############################# 

hist(df_tree$Branch_Angle_segment, breaks = seq(0, 150, by = 10),
     main  = "Histogramme Branch angle",
     xlab  = "branch angle ",
     ylab  = "Fréquence")

ggplot(df_tree, aes(x = Site, y = Branch_Angle_segment)) +
  geom_boxplot() +
  labs(
       x = "Site",
       y = "Branch angle") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(df_tree, aes(x = Tree_height, y = Branch_Angle_segment, color = Site)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  theme_minimal() +
  labs(x = "Hauteur (m)", y = "Angle moyen des branches (°)")

ggplot(df_tree, aes(x = DAI, y = Branch_Angle_segment, color = Site)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  theme_minimal() +
  labs(x = "DAI (dominance axe principal)", y = "Angle moyen des branches (°)")


# Je fais des classes d'angle 

df_tree2 = df_tree %>%
  mutate(AngleClass = case_when(
    Branch_Angle_segment < 30 ~ "Dressée (0–30)",
    Branch_Angle_segment < 60 ~ "Oblique (30–60)",
    Branch_Angle_segment <= 90 ~ "Horizontale (60–90)",
    Branch_Angle_segment > 90 ~ "Retombante (>90)",
    TRUE ~ NA_character_
  ))

 
 site_prop <- df_tree2 %>%
   filter(!is.na(AngleClass)) %>%
   count(Site, AngleClass) %>%
   group_by(Site) %>%
   mutate(prop = n / sum(n)) %>%
   ungroup()
 
 ggplot(site_prop, aes(x = Site, y = prop, fill = AngleClass)) +
   geom_col(position = "fill") +
   scale_y_continuous(labels = scales::percent) +
   theme_minimal() +
   labs(y = "% d’arbres", fill = "Orientation")

 
 ggplot(df_tree, aes(x = Site, y = Branch_Angle_segment)) +
   geom_violin(trim = TRUE) +
   geom_boxplot(width = 0.12, outlier.alpha = 0.2) +
   theme_minimal() +
   labs(y = "Angle moyen des branches (°)")

 
 df_BA <- subset(df_tree, !is.na(Branch_Angle_segment) & !is.na(SizeClass))
 
 ggplot(df_BA, aes(x = Site,
                     y = Branch_Angle_segment,
                     fill = SizeClass)) +
   geom_boxplot(position = position_dodge(width = 0.8)) +
   labs(
        x = "Site",
        y = "Branch_Angle_segment",
        fill = "Classe de taille") +
   theme_bw() +
   theme(axis.text.x = element_text(angle = 45, hjust = 1))
 
 ggplot(df_tree, aes(x = SizeClass, y = Branch_Angle_segment, fill = SizeClass)) +
   geom_boxplot() +
   theme_minimal() +
   labs(x="Classe de taille", y="Angle moyen des branches (°)")
 
### ACP 

 
 vars <- df_tree %>%
   select(Tree_height, DAI, ForkRate) %>%
   na.omit()
 
 pca <- prcomp(vars, scale. = TRUE)
 fviz_pca_var(pca, repel = TRUE)
 
 
 
 #############################  Tree biomass  ############################# 
 # faire log pour eviter cette variance énorme   pour réduire l'influence des valeurs extrêmes meilleure visibilité des relations
 
 hist(log10(df_tree$Tree_biomass),
      main = "Histogramme log10(biomasse)",
      xlab = "log10(biomasse)")
 
 df_tree$log_biomass <- log10(df_tree$Tree_biomass + 1)
 ggplot(df_tree, aes(x = Site, y = log_biomass, fill = Site)) +
   geom_boxplot(alpha = 0.7) +
   theme_minimal() +
   labs(
     y = "log10(biomasse)",
     x = "Site"
   ) +
   theme(legend.position = "none")
 
 anova(lm(log10(Tree_biomass) ~ Site, data = df_tree))
 
 ggplot(df_tree, aes(x = log10(Tree_volume), y = log10(Tree_biomass))) +
   geom_point(alpha = 0.3) +
   geom_smooth(method = "lm", se = TRUE) +
   theme_classic() +
   labs(
     x = "log10(Tree volume)",
     y = "log10(Tree biomass)",
     title = paste0("log10(Biomass) ~ log10(Volume)  |  R² = ", round(r2, 3))
   )
 
 m = lm(log10(Tree_biomass) ~ log10(Tree_volume), data = df_tree)
 r2 <- summary(m)$r.squared
 
 ggplot(df_tree, aes(x = Site, y = log_biomass)) +
   geom_violin(fill = "grey80") +
   geom_boxplot(width = 0.1, outlier.shape = NA) +
   theme_minimal()
 
 
 ###est ce que traits archi impact le volume ?
 m_vol_archi <- lm(
   log10(Tree_volume) ~ Path_fraction + ForkRate + DAI,
   data = df_tree
 )
 
 summary(m_vol_archi)
 
 m_archi <- lm(
   log10(Tree_biomass) ~ log10(Tree_volume) +
     Path_fraction + ForkRate + DAI,
   data = df_tree
 )
 
 summary(m_archi)
 
 ## effet archi sur biomasse
 m_archi <- lm(
   log10(Tree_biomass) ~ log10(Tree_volume) +
     Path_fraction + ForkRate + DAI,
   data = df_tree
 )
 summary(m_archi)
 

 ## biomasse vs  DAI 
 ggplot(df_tree, aes(x = DAI, y = log_biomass, color = Site)) +
   geom_point(alpha = 0.6) +
   geom_smooth(method = "lm", se = FALSE) +
   theme_minimal() +
   labs(x = "DAI", y = "log10(biomasse)") 
 
 ######################### FORKRATE  ######################### 

 hist(df_tree$ForkRate, breaks = seq(0, 30, by = 1),
      main  = "Histogramme Branch angle",
      xlab  = "branch angle ",
      ylab  = "Fréquence")
 
  ggplot(df_tree, aes(Site, ForkRate)) +
   geom_boxplot() +
   geom_jitter(width = 0.2, alpha = 0.3) +
   theme_classic() +
   labs(y = "Fork rate (forks per meter)")
 
 
 anova(lm(ForkRate ~ Site, data = df_tree))
 
 
 ggplot(df_tree, aes(ForkRate)) +
   geom_histogram(bins = 40) +
   facet_wrap(~Site, scales = "free_y") +
   theme_classic()
 
 library(lme4)
 
 m_fork <- lmer(ForkRate ~ 1 + (1|Site), data = df_tree)
 summary(m_fork)
 VarCorr(m_fork)
 
 ICC <- 1.155 / (1.155 + 2.313)
 ICC
 
 m_fork2 <- lmer(ForkRate ~ Density_used + (1|Site), data = df_tree)
 summary(m_fork2)
 VarCorr(m_fork2)
 
 ggplot(df_tree, aes(Density_used, ForkRate)) +
   geom_point(alpha = 0.4) +
   geom_smooth(method = "lm", se = TRUE) +
   theme_classic() +
   labs(x = "Wood density (proxy for growth strategy)",
        y = "Path fraction")
 
 m1 <- lm(ForkRate ~ Density_used, data = df_tree)
 summary(m1)$r.squared
 summary(m1)
 anova_mod <- aov(ForkRate ~ Density_used, data = df_tree)
 summary(anova_mod)
 tukey_res <- TukeyHSD(anova_mod)
 
 
 
 ggplot(df_tree, aes(Path_fraction, ForkRate)) +
   geom_point(alpha = 0.8) +
   geom_smooth(method = "lm", se = TRUE) +
   theme_classic() +
   labs(x = "Wood density (proxy for growth strategy)",
        y = "Path fraction")
 
 
 ggplot(df_tree, aes(DBh_inventory, ForkRate)) +
   geom_point(alpha = 0.4) +
   geom_smooth(method = "lm", se = TRUE) +
   theme_classic() +
   labs(x = "Wood density (proxy for growth strategy)",
        y = "Path fraction")
 
 
 ### form factor
 ggplot(df_tree, aes(Site, form_factor)) +
   geom_boxplot(outlier.shape = NA) +
   geom_jitter(width = 0.2, alpha = 0.2) +
   scale_y_log10() +
   theme_classic() +
   labs(y = "Total form factor (log scale)")

 ggplot(df_tree, aes(x = species_final, y = form_factor)) +
   geom_boxplot(outlier.alpha = 0.3) +
   facet_wrap(~ Site, scales = "free_y") +
   theme_classic() +
   theme(
     axis.text.x = element_text(angle = 45, hjust = 1)
   ) +
   labs(
     x = "Species",
     y = "Total form factor"
   )
 
 df_tree %>%
   group_by(Site) %>%
   summarise(
     n = n(),
     mean_F = mean(form_factor, na.rm = TRUE),
     sd_F   = sd(form_factor, na.rm = TRUE),
     CV_F   = sd_F / mean_F
   )
 
 
 ggplot(df_tree, aes(Site, form_factor)) +
   geom_violin(fill = "grey80") +
   geom_boxplot(width = 0.15, outlier.shape = NA) +
   theme_classic() +
   labs(y = "Total form factor")
 