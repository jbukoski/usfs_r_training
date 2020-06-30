##########################
## Analyze Pohnpei data ##
##########################


#---------------------
# Load packages

library(magrittr)
library(readxl)
library(tidyverse)

#----------------------
# Import the data

dat <- read_excel(path = "data/revisedPNI_mangrove_TreesFile.xlsx") %>%
  set_colnames(tolower(colnames(.))) %>%
  set_colnames(gsub(" ", "_", colnames(.))) %>%
  rename(plt_radius = "plot_radius_(m)",
         dbh = "dbh_(cm)",
         hgt = "height_(m)",
         vol_dead = "volume_of_dead_trees_(cm^3)",
         dens = "wood_density_(ρ,_g/cm3)_(*a)") %>%
  mutate(sps_code = tolower(species)) %>%
  separate(hgt, into = c("hgt1", "hgt2"), sep = "/") %>%
  mutate(hgt1 = as.numeric(hgt1),
         hgt2 = as.numeric(hgt2),
         hgt = rowMeans(cbind(hgt1, hgt2), na.rm = T)) %>%
  select(-hgt1, -hgt2)

source("./scripts/pohnpei_allometry_2.R")

#------------------------------------
# Convert DBH to volume, and then biomass

biomassData <- dat %>%
  select(-dens, -species) %>%
  left_join(allom_lookup, by = c("sps_code" = "sps_code")) %>%
  mutate(params = map2(dbh, density, list)) %>%
  mutate(agb = invoke_map_dbl(ag_form, params),
         leaf = invoke_map_dbl(leaf_form, params),
         roots = invoke_map_dbl(root_form, params),
         bgb = invoke_map_dbl(bg_form, params))



biomassData <- biomassData %>%
  mutate(plot = ifelse(plot == "River", "Riverine", plot),
         plt_area = pi * plt_radius^2) %>%
  rowwise() %>%
  mutate(ttl_biomass = sum(agb, leaf, roots, bgb),
         ttl_biom_Mg_ha = 10 * ttl_biomass / plt_area,
         dens_ha = 10000 * n() / plt_area) %>%
  ungroup() %>%
  group_by(sites, plot, subplot, sps_code) %>%
  mutate(site_biomass = sum(ttl_biom_Mg_ha),
         n_trees = sum(dens_ha),
         dbh_avg = mean(dbh)) %>%
  ungroup()


dat2plot <- biomassData %>%
  select(sites, plot, subplot, sps_code, site_biomass, n_trees, dbh_avg) %>%
  distinct()

plot(dat2plot$dbh_avg, dat2plot$n_trees, col = as.factor(dat2plot$sps_code))

View(biomassData)



unique(biomassData$sites)
unique(biomassData$plot)
unique(biomassData$subplot)

biomassData %>%
  group_by(sites, plot, subplot) %>%
  summarize(n = n()) %>% 
  View()
       
       
    