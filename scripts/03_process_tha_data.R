###########################
## 03_process_tha_data.R ##
###########################

# Imports plotwise field data for three sites from Thailand:
#
#  - the Krabi River Estuary,
#  - the Palian River Estuary, and
#  - the Pak Panang Mangrove 
# 
# This script generates site wide estimates of carbon stocks and
# soil parameters for each of the three sites.

# Inputs:
#  1. Excel file containing field data  

# Outputs
#  2. CSV files of processed data

print("02_site_analysis.R running...")

#--------------------------------------
# Load libraries and begin script

suppressMessages(library("magrittr"))
suppressMessages(library("tidyverse"))
suppressMessages(library("raster"))
suppressMessages(library("readxl"))
suppressMessages(library("sp"))
suppressMessages(library("plotrix"))

#----------------------
# Load in helper functions & allometry functions

source("./scripts/allometry.R")

#----------------------
# Specify in/out directories

in_dir <- "./data/raw/"
out_dir <- "./data/processed/"

#---------------------------------------
## Load in data

sps_codes <- read_csv(paste0(in_dir, "species_codes.csv"), 
                      col_types = list(col_character(), col_character())) 

excel_dat <- "~/Desktop/swamp_database/Thailand_2020-04-24.xlsx"

meta <- read_excel(excel_dat, sheet="Subplot", col_names = T) %>%
  set_colnames(tolower(colnames(.))) %>%
  mutate(type = "forest",
         site = ifelse(site_name == "Krabi River Estuary", "Krabi",
                       ifelse(site_name == "Pak Panang Mangrove", "Nakorn", "Trang"))) %>%
  dplyr::select(site, type, plot, subplot = subp, latitude, longitude, geomorp, eco_cond, topo, subp_description)

raw_trees <- read_excel(excel_dat, sheet = "Tree", col_names = T,
                        col_types = c(rep("numeric", 2), "text", "numeric", "text", "numeric", "text", rep("numeric", 2),
                                       "text", rep("numeric", 3), "text", rep("numeric", 5), "text")) %>%
  set_colnames(tolower(colnames(.))) %>%
  mutate(type = "forest",
         height_m = ifelse(!is.na(deadbreak_hgt), deadbreak_hgt, hgt),
         statid = ifelse(statid == 1, NA, statid - 1),
         site = ifelse(site_name == "Krabi River Estuary", "Krabi",
                       ifelse(site_name == "Pak Panang Mangrove", "Nakorn", "Trang"))) %>%
  left_join(sps_codes, by = c("spp" = "species")) %>%
  dplyr::select(site, type, plot, subplot = subp, full_species, species = spp,
                dbh_cm = dbh, height_m, base_cm = dbase, status = statid)

raw_saps <- read_excel(excel_dat, sheet = "Sapling", col_names = T) %>%
  set_colnames(tolower(colnames(.))) %>%
  mutate(type = "forest",
         subp = as.character(subp),
         statid = ifelse(statid == 1, NA, statid - 1),
         site = ifelse(site_name == "Krabi River Estuary", "Krabi",
                       ifelse(site_name == "Pak Panang Mangrove", "Nakorn", "Trang"))) %>%
  left_join(sps_codes, by = c("spp" = "species")) %>%
  dplyr::select(site, type, plot, subplot = subp, full_species, species = spp, 
                dbh_cm = dbh, height_m = hgt, base_cm = dbase, status = statid)

soil_depth <- read_excel(excel_dat, sheet = "SoilDepth") %>%
  set_colnames(tolower(colnames(.))) %>%
  group_by(site_name, plot, subp) %>%
  summarize(avg_depth = round(mean(depth, na.rm = T))) %>%
  ungroup()

raw_soil <- read_excel(excel_dat, sheet = "Soil") %>%
  set_colnames(tolower(colnames(.))) %>%
  left_join(soil_depth, by = c("site_name", "plot", "subp")) %>%
  mutate(type = "forest",
         subp = as.character(subp),
         avg_depth = round(avg_depth),
         site = ifelse(site_name == "Krabi River Estuary", "Krabi",
                       ifelse(site_name == "Pak Panang Mangrove", "Nakorn", "Trang"))) %>%
  dplyr::select(site, type, plot, subplot = subp, interval = samp,
                int_a = mind, int_b = maxd, avg_depth, bd, poc = c)


#-------------------------
# Drop incomplete plots from Trang

drop_ids <- raw_trees[is.na(raw_trees$full_species) | is.na(raw_trees$dbh_cm), ] %>%
  dplyr::select(plot) %>%
  distinct %>%
  pull(plot)

#-----------------------------------------
# Specify necessary parameters

plot_size <- (7^2)*pi
subplot_size <- (2^2)*pi
transect_size <- 5 * plot_size

t_val <- qt(0.975, 7-1)

# Specify site areas

site_areas <- tibble(site = c("Krabi", "Nakorn", "Trang"),
                     type = c("forest", "forest", "forest"),
                     area = c(76110000, 110510000, 70650000))

#------------------------------------------------------------------------------
# Processing raw data

# Create species code and calculate basal area

trees <- raw_trees %>%
  separate(full_species, into = c("genus", "species"), sep = " ", remove = FALSE) %>%
  mutate(sps_code = paste0(tolower(substr(genus, 1, 2)), tolower(substr(species, 1, 2))),
         basal_area = pi * (dbh_cm/100/2)^2) %>%
  dplyr::select(-genus, -species)

# Calculate above-ground biomass using species-specific allometric equations. 
# Where species-specific equations are not available, used Komiyama et al 2005 
# general equation with species specific wood densities

trees <- trees[!is.na(trees$full_species),]
trees <- trees[!is.na(trees$dbh_cm),]
trees <- trees %>% filter(!(site == "Trang" & plot %in% drop_ids))
trees <- trees %>% filter(!sps_code %in% c("unun", "aceb"))

trees <- trees %>%
  left_join(allom_lookup, by = c("sps_code" = "sps_code")) %>%
  mutate(params = map2(dbh_cm, density, list)) %>%
  mutate(agb = invoke_map_dbl(ag_form, params)) %>%
  mutate(bgb = invoke_map_dbl(bg_form, params))

# Adjust AGB variable based on 'status' variable
# Calculate cone if base_cm measurement exists, otherwise assume a cylinder

trees <- trees %>%
  mutate(top_diam = ifelse(status == 3 & !is.na(base_cm) & height_m < 1.37, dbh_cm,
                           base_cm - (100 * height_m * ((base_cm - dbh_cm) / 137)))) %>%
  mutate(stump.vol = ifelse(status == 3 & !is.na(base_cm) & height_m < 1.37, 
                            ((100 * height_m) / 3) * (pi*(base_cm/2)^2 + sqrt((pi*(base_cm/2)^2)*(pi*(dbh_cm/2)^2)) + pi*(dbh_cm/2)^2),
                            ifelse(status == 3 & !is.na(base_cm) & height_m >= 1.37, 
                                   ((100 * height_m) / 3) * (pi*(base_cm/2)^2 + sqrt((pi*(base_cm/2)^2)*(pi*(top_diam/2)^2)) + pi*(top_diam/2)^2), 
                                   NA))) %>%
  mutate(adj_agb = ifelse(is.na(status), agb,
                          ifelse(status == 1, 0.95 * agb, 
                                 ifelse(status == 2, 0.8 * agb, 
                                        ifelse(status == 3 & !is.na(base_cm), 
                                               density * stump.vol / 1000, 
                                               density * pi * (dbh_cm/2)^2 * height_m * 100 / 1000)))))

trees <- trees %>%
  mutate(agb = adj_agb,
         biomass = adj_agb + bgb) %>%
  dplyr::select(-ag_form, -bg_form, -ag_ref, -bg_ref, 
                -params, -top_diam, -stump.vol, - adj_agb)

#-------------------------------------------------------------------------------
# Processing for saplings
# Follows same steps as for trees

saps <- raw_saps %>% 
  separate(full_species, into = c("genus", "species"), sep = " ", remove = FALSE) %>%
  mutate(sps_code = paste0(tolower(substr(genus, 1, 2)), tolower(substr(species, 1, 2)))) %>%
  dplyr::select(-genus, -species)

saps <- saps[!is.na(saps$full_species), ]
saps <- saps[!is.na(saps$dbh_cm), ]
saps <- saps %>% filter(!(site == "Trang" & plot %in% drop_ids))
saps <- saps %>% filter(!(sps_code %in% c("mytu", "unun")))

saps <- saps %>%
  left_join(allom_lookup, by = c("sps_code" = "sps_code")) %>%
  mutate(params = map2(dbh_cm, density, list)) %>%
  mutate(agb = invoke_map_dbl(ag_form, params)) %>%
  mutate(bgb = invoke_map_dbl(bg_form, params))

saps <- saps %>%
  mutate(adj_agb = ifelse(is.na(status), agb,
                          ifelse(status == 1, 0.95 * agb, 0.8 * agb)))

saps <- saps %>%
  mutate(agb = adj_agb,
         biomass = agb + bgb) %>%
  dplyr::select(-ag_form, -bg_form, -ag_ref, -bg_ref, -params, - adj_agb)

#-------------------------------------------------------------
# Biomass: Join trees and saplings

biomass <- bind_rows(mutate(trees, stage = "tree"), mutate(saps, stage = "sapling"))

#------------------------------------------------------
# Processing for soil

soil_drop <- raw_soil %>%
  filter(is.na(avg_depth)) %>%
  dplyr::select(plot) %>%
  unique

filt_soil <- raw_soil[!is.na(raw_soil$avg_depth), ]
filt_soil <- filt_soil %>% 
  filter(!(site == "Trang" & plot %in% drop_ids))

soil <- filt_soil %>%
  mutate(c_dens = bd * (poc/100),
         int_volume = ifelse(interval == 5, 
                             ((avg_depth/100) - (int_a/100)) * 10000, 
                             ((int_b/100) - (int_a/100)) * 10000),
         soc_per_ha = int_volume * c_dens)

write_csv(soil, paste0(out_dir, "th_soil_params.csv"))

#-------------------------------------------------------------------------------
#----------------------------#
# Carbon & biomass estimates #
#----------------------------#

# Obtain estimate of biomass per hectare based on all plots
# Outputs estimates of biomass in Mg/ha at the subplot, plot, and site aggregation
# Any of the trees, saplings, or biomass tibbles can be run through
# Calculation of mean and variance follows Gregoire and Valentine 20XX?

# Print summary table of total biomass & aboveground vs belowground carbon
# Note different units (biomass vs C) of reported values.

biomass_subplot <- biomass %>%
  dplyr::select(site, type, plot, subplot, biomass, agb, bgb) %>%
  left_join(site_areas, by = c("site", "type")) %>%
  group_by(site, type, plot, subplot) %>%
  summarise(agb_tau = mean(area) * ( sum(agb) / plot_size),
            bgb_tau = mean(area)* ( sum(bgb) / plot_size)) %>%
  group_by(site, type, plot, subplot) %>%
  left_join(site_areas, by = c("site", "type")) %>%
  mutate(avg_plot_agb = mean(agb_tau),
         avg_plot_bgb = mean(bgb_tau),
         agb_ha = 10 * avg_plot_agb / area,
         bgb_ha = 10 * avg_plot_bgb / area) %>%
  mutate(agc_ha = agb_ha * 0.47,
         bgc_ha = bgb_ha * 0.39) %>%
  dplyr::select(site, type, plot, subplot, 
                agb_ha, bgb_ha, agc_ha, bgc_ha) %>%
  distinct

#------------------------------------------------------------------------------
#-----------------------------#
# Analysis of soil properties #
#-----------------------------#

soc_subplot <- soil %>%
  group_by(site, type, plot, subplot) %>%
  mutate(subplot_c = sum(soc_per_ha)) %>%
  dplyr::select(site, type, plot, subplot, subplot_c) %>%
  distinct()

#-----------------------------------------------------------------------------

#-----------------------#
# Join all carbon pools #
#-----------------------#

c_summary_subplot <- biomass_subplot %>% 
  left_join(soc_subplot, by = c("site", "type", "plot", "subplot")) %>%
  mutate(agb_ha = ifelse(is.na(agb_ha) && type == "aquaculture", 0, agb_ha),
         bgb_ha = ifelse(is.na(bgb_ha) && type == "aquaculture", 0, bgb_ha),
         agc_ha = ifelse(is.na(agc_ha) && type == "aquaculture", 0, agc_ha),
         bgc_ha = ifelse(is.na(bgc_ha) && type == "aquaculture", 0, bgc_ha),
         cwd_biom = NA,
         cwd_carb = NA) %>%
  rename(soc = subplot_c) %>%
  arrange(desc(type), site, plot, subplot)

write_csv(c_summary_subplot, paste0(out_dir, "th_carbon.csv"))
write_csv(meta, paste0(out_dir, "th_meta.csv"))

#----------------------------
# Clear environment and collect garbage to clear RAM

rm(list = ls())
gc()

##--------------------------

print("Finished processing Thailand field data. Output files in `./data/processed/` directory.")

