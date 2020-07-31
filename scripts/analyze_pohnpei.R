##########################
## Analyze Pohnpei data ##
##########################


#---------------------
# Load packages

library(janitor)
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

plot(dat2plot$dbh_avg, dat2plot$n_trees, 
     main = "Stem Density vs. DBH",
     type = "p",
     col = as.factor(dat2plot$sites),
     #legend("topleft", unique(dat2plot$sites), fill = c("black", "blue", "yellow", "red", "orange", "purple", "green", "pink"))
     )
      
#----------------------------------
# Soil data section

soilDat <- read_excel(path = "data/PNI_mangrove SoilsData.xlsx") %>%
  set_colnames(tolower(colnames(.))) %>%
  set_colnames(gsub(" |/|-", "_", colnames(.))) %>%
  set_colnames(gsub("\\(|\\)", "", colnames(.))) %>%
  set_colnames(gsub("_%", "", colnames(.))) %>%
  drop_na(site) %>%
  select(site:total_depth_interval_cm, bulk_density_g_cm3, percent____c__content) %>%
  separate(depth_interval_cm, c("start", "end"), "-") %>%
  mutate(start = as.numeric(start),
         end = as.numeric(end),
         interval = ifelse(start <= 15, 1, 
                           ifelse(start > 15 & start <= 30, 2, 
                                  ifelse(start > 30 & start <= 50, 3,
                                         ifelse(start > 50 & start <= 100, 4, 5))))) %>%
  select(site:date, interval, start:percent____c__content) %>%
  group_by(site, plot, subplot, interval)

soc <- soilDat %>%
  select(site, plot, subplot, interval, percent____c__content) %>%
  rename(poc = percent____c__content) %>%
  drop_na()

soilDat2 <- soilDat %>%
  left_join(soc, by = c("site", "plot", "subplot", "interval")) %>%
  select(-percent____c__content) %>%
  mutate(sc_Mg_ha = total_depth_interval_cm * bulk_density_g_cm3 * poc) %>%
  group_by(site, plot, subplot, interval) %>%
  mutate(itrvl_sc_Mg_ha = sum(sc_Mg_ha)) %>%
  group_by(site, plot, subplot) %>%
  mutate(core_sc_Mg_ha = sum(sc_Mg_ha))


#-----------------------------------------
# Calculate down woody debris

DWDdat <- read_excel("./data/PNI_DWD.xlsx", skip = 8) %>%
  clean_names() %>%
  drop_na(site) %>%
  mutate(plot = ifelse(is.na(plot), "Riverine", plot),
         site = ifelse(site == "Enipoas River", "Enipoas", site),
         plot = ifelse(plot == "River", "Riverine", plot))

cols <- colnames(DWDdat[ , 7:22])

DWDdat2 <- DWDdat %>%
  rename(setNames(cols, paste0("large_", 1:16)))

#--------------------------
# Summarize large dwd

lrg_dwd <- DWDdat2 %>%
  pivot_longer(cols = paste0("large_", 1:16),
               names_to = "size_class",
               values_to = "l_dia") %>%
  select(site:date, size_class, l_dia) %>%
  group_by(site, plot, subplot, transect) %>%
  mutate(ldwd_transect = pi^2 * (sum(l_dia^2, na.rm = T) / (8 * 12)) * 0.69 * 0.5 ) %>%
  group_by(site, plot, subplot) %>%
  mutate(ldwd_subp = mean(ldwd_transect)) %>%
  group_by(site, plot) %>%
  mutate(ldwd_plot = mean(ldwd_subp))

#-------------------------
# Medium, small and fine DWD

msf_dwd <- DWDdat2 %>%
  mutate(mdwd = pi^2 * ((number_medium * 4.52^2) / (8 * 5) ) * 0.5 * 0.71,
         sdwd = pi^2 * ((number_small * 1.47^2) / (8 * 3) ) * 0.5 * 0.64,
         fdwd = pi^2 * ((number_fine * 0.43^2) / (8 * 2) ) * 0.5 * 0.48) %>%
  group_by(site, plot, subplot) %>%
  mutate(mdwd_subp = mean(mdwd, na.rm = TRUE),
         sdwd_subp = mean(sdwd, na.rm = TRUE),
         fdwd_subp = mean(fdwd, na.rm = TRUE)) %>%
  group_by(site, plot) %>%
  mutate(mdwd_plot = mean(mdwd_subp, na.rm = TRUE),
         sdwd_plot = mean(sdwd_subp, na.rm = TRUE),
         fdwd_plot = mean(fdwd_subp, na.rm = TRUE)) %>%
  select(site:heading, mdwd_subp, mdwd_plot, sdwd_subp, sdwd_plot, fdwd_subp, fdwd_plot) %>%
  arrange(site, plot, subplot)
  
#----------------------

ttl_dwd <- lrg_dwd %>%
  left_join(msf_dwd, by = c("site", "plot", "subplot", "transect", "heading")) %>%
  select(-transect, -heading, -size_class, -l_dia, -ldwd_transect) %>%
  distinct() %>%
  arrange(site, plot, subplot) %>%
  mutate(ttl_subp = ldwd_subp + mdwd_subp + sdwd_subp + fdwd_subp,
         ttl_plot = ldwd_plot + mdwd_plot + sdwd_plot + fdwd_plot)

ttl_dwd %>%
  select(site, plot, subplot, ttl_subp, ttl_plot) %>%
  View


    