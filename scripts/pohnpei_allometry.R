########################
## Mangrove allometry ##
########################

## A helper script that generates functions to apply allometric equations
## to diameter measurements. A library of species-specific allometric 
## equations is given at the bottom of this script.

## The Sections of this script include:
##   Section 1: Specify a library of mangrove allometric equations
##   Section 2: Generate a look up table for allometric equations

library(tidyverse)

##-----------------------------------------------------------------------------------
## Section 1 - Mangrove allometry library

# Allometric equation functions, labelled by <species_code>_<aboveground/belowground>_<authoryear>

# Example: total aboveground biomass equation for Rhizophora apiculata by Ong et al., 2004:
#   - rhap_ag_ong2004

# General functions, Komiyama et al., 2005, function of diameter at breast height and wood density

general_ag_komiyama2005 <- function(dbh, dens) { 0.251 * dens * (dbh ^ 2.46) }
general_bg_komiyama2005 <- function(dbh, dens) { 0.199 * (dens ^ 0.899) * (dbh ^ 2.22) }

# Bruguiera gymnorrhiza 

brgy_ag_cole1999 <- function(dbh, dens) { 
  
  # returns biomass in kg, multiply by 1000 to account for units
  
  1000 * dens * 0.0000754 * dbh ^ 2.50512 
  
  }  

brgy_ag_cole1999(20, 0.7)

# Lumnitzera literia

# Rhizophora apiculata

# Rhizophora gymnorrhiza ?

# Rhizophora mucronata

# Rhizophora stylosa

# Sonneratia alba

# Xylocarpus granatum


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
                       bg_form = list(), 
                       ag_ref = character(),
                       bg_ref = character()
)

allom_lookup <- allom_lookup %>%
  add_row(genus = "bruguieria", species = "gymnorrhiza", sps_code = "brgy", density = 0.66,
          ag_form = c(brgy_ag_cole1999), 
          bg_form = c(NA), 
          ag_ref = "cole et al. 1999", bg_ref = NA)
