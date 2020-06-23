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

#------------------------------------
# Convert dbh to volume, and then biomass

test_df <- dat %>%
  select(-dens, -species) %>%
  left_join(allom_lookup, by = c("sps_code" = "sps_code")) %>%
  mutate(params = map2(dbh, density, list)) %>%
  mutate(agb = invoke_map_dbl(ag_form, params),
         leaf = invoke_map_dbl(leaf_form, params),
         roots = invoke_map_dbl(root_form, params),
         bgb = invoke_map_dbl(bg_form, params)) %>%
  select(sps_code, dbh, density, agb, leaf, roots, bgb)

test_df %>%
  group_by(sps_code) %>%
  summarise(ttl_agb = sum(agb))


head(dat)

head(allom_lookup)
    