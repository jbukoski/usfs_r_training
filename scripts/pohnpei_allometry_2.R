########################
## Mangrove allometry ##
########################

## A helper script that generates functions to apply allometric equations
## to diameter measurements. A library of species-specific allometric 
## equations is given at the bottom of this script.

## The Sections of this script include:
##   Section 1: Specify a library of mangrove allometric equations
##   Section 2: Generate a look up table for allometric equations


##-----------------------------------------------------------------------------------
## Section 1 - Mangrove allometry library

# Allometric equation functions, labelled by <species_code>_<aboveground/belowground>_<authoryear>

# Example: total aboveground biomass equation for Rhizophora apiculata by Ong et al., 2004:
#   - rhap_ag_ong2004

# General functions, Komiyama et al., 2005, function of diameter at breast height and wood density

general_ag_komiyama2005 <- function(dbh, dens) { 0.251 * dens * (dbh ^ 2.46) }
general_bg_komiyama2005 <- function(dbh, dens) { 0.199 * (dens ^ 0.899) * (dbh ^ 2.22) }

#Bruguiera gymnorrhiza

brgy_ag_cole1999 <- function(dbh, dens) {dens * 0.0754 * dbh ^ 2.50512 }
brgy_leaf_CandS1989 <- function(dbh, dens) {0.0679 * dbh ^ 1.4914}

brgy_leaf_CandS1989(10, 0.710)

#Lumnitzera littorea

luli_ag_cole1999 <- function(dbh, dens) {(0.0001032 * dbh ^ 2.40281) * dens} 		# Cole et al. 1999
luli_leaf_KandD2012 <- function(dbh, dens) {luli_ag_cole1999(dbh, dens) * 0.025 }		#	Kauffman and Donato 2012

#Rhizophora apiculata

rhap_ag_cole1999 <- function(dbh, dens) {0.0787 * dbh ^ 2.63297 * dens}
rhap_leaf_CandS1989 <- function(dbh, dens) {0.0139 * dbh ^ 2.1072}
rhap_roots_CandS1989 <- function(dbh, dens) {0.0068 * dbh ^ 3.1353}

rhap_bg_ong2004 <- function(dbh, dens) { 0.00698 * dbh^2.61 }

#Rhizophora mucronata

rhmu_ag_cole1999 <- function(dbh, dens) {0.1274 * dbh^2.35838 * dens}
rhmu_leaf_CandS1989 <- function(dbh, dens) {0.0139 * dbh^2.1072}
rhmu_roots_CandS1989 <- function(dbh, dens) {0.0068 * dbh^3.1353 }

rhmu_bg_comley2005 <- function(dbh, dens) { 10^(-0.583 + 1.860 * log10(dbh)) }

#Rhizophora stylosa

# Uses rhmu equations

#Sonneratia alba

soal_ag_cole1999 <- function(dbh, dens) {0.3841 * dbh^2.10060 * dens}
soal_leaf_CandS1989 <- function(dbh, dens) {1.45 * dbh^-0.3179}

# Xylocarpus granatum

xygr_ag_cole1999 <- function(dbh, dens) {0.0001862 * dbh ^ 2.25405 * dens}
xygr_leaf_cole1999 <- function(dbh, dens) {0.005 * dbh ^ 2.3966}
xygr_bg_poungparn2002 <- function(dbh, dens) { 0.145 * dbh ^ 2.55 }

# Null, remove biomass component

null_function <- function(dbh, dens) { dbh * 0}


##-----------------------------------------------------------
## Section 2 - Generate a look up table for the allometric equations

library(tidyverse)

allom_lookup <- tibble(genus = character(), 
                       species = character(), 
                       sps_code = character(),
                       density = double(),
                       ag_form = list(),
                       leaf_form = list(),
                       root_form = list(),
                       bg_form = list() )  %>%
  add_row(genus = "bruguiera", species = "gymnorrhiza", sps_code = "brgy", density = 0.710,
          ag_form = c(brgy_ag_cole1999), 
          leaf_form = c(brgy_leaf_CandS1989),
          root_form = c(null_function),
          bg_form = c(general_bg_komiyama2005)) %>%
  add_row(genus = "lumnitzera", species = "littorea", sps_code = "luli", density = 0.670,
          ag_form = c(luli_ag_cole1999), 
          leaf_form = c(luli_leaf_KandD2012),
          root_form = c(null_function),
          bg_form = c(general_bg_komiyama2005)) %>%
  add_row(genus = "rhizophora", species = "apiculata", sps_code = "rhap", density = 0.850,
          ag_form = c(rhap_ag_cole1999), 
          leaf_form = c(rhap_leaf_CandS1989),
          root_form = c(rhap_roots_CandS1989),
          bg_form = c(rhap_bg_ong2004)) %>%
  add_row(genus = "rhizophora", species = "mucronata", sps_code = "rhmu", density = 0.820,
          ag_form = c(rhmu_ag_cole1999), 
          leaf_form = c(rhmu_leaf_CandS1989),
          root_form = c(rhmu_roots_CandS1989),
          bg_form = c(rhmu_bg_comley2005)) %>%
  add_row(genus = "rhizophora", species = "stylosa", sps_code = "rhst", density = 0.840,
          ag_form = c(rhmu_ag_cole1999), 
          leaf_form = c(rhmu_leaf_CandS1989),
          root_form = c(rhmu_roots_CandS1989),
          bg_form = c(rhmu_bg_comley2005)) %>%
  add_row(genus = "sonneratia", species = "alba", sps_code = "soal", density = 0.509,
          ag_form = c(soal_ag_cole1999), 
          leaf_form = c(soal_leaf_CandS1989),
          root_form = c(null_function),
          bg_form = c(general_bg_komiyama2005)) %>%
  add_row(genus = "xylocarpus", species = "granatum", sps_code = "xygr", density = 0.567,
          ag_form = c(xygr_ag_cole1999), 
          leaf_form = c(xygr_leaf_cole1999),
          root_form = c(null_function),
          bg_form = c(xygr_bg_poungparn2002)) 



