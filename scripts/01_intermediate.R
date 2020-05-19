###########################################################################
## Advanced R - packages, navigating file systems & reading/writing data ##
###########################################################################

#-------------------------------

###############
## Packages! ##
###############

# R comes with base functions ("base R"), but can be expanded by installing
# "packages." 
#
# Packages are a set (i.e., a package) of related functions, help
# files, example datasets, and tools geared around a data analysis task. For
# example, the "raster" package provides functions and tools for analyzing 
# raster data in R.

## Install a new package

install.packages("tidyverse")

# To examine what packages are installed on your machine, run the following:

library()

# Packages are in constant development and there are many that may be useful
# for a particular scientist, analyst, or task at hand.

# Some packages that I commonly use are:

# tidyverse - general data science workflow
# raster - processing of raster data
# sp - old school package for processing of vector data
# sf - new package for processing of vector data in the "tidyverse"
# nlme & lme4 - mixed effects model functions
# ggplot - advanced plotting functions
# ggmap - advanced plotting functions for maps

# A recently released package that likely might be of interest is "rFIA", which
# provides an interface between FIA data and R.

# https://www.sciencedirect.com/science/article/abs/pii/S1364815219311089


##-------------------

#############################
## Navigating file systems ##
#############################

# Before we begin reading and writing data, we need to understand how to 
# navigate file systems within R.

# The "working directory" is the root directory that R thinks it is in.
# R will use this directory to search for all files and if it doesn't find
# them, it will throw an error.

# We can print the working directory by using the following command:

getwd()

# Note that everyone's directories will be different, so the working directory
# will be specific to your machine.

# We can set the working directory using the following command:

setwd("/home/jbukoski/Desktop/")
getwd()

# The working directory is now set to my Desktop

list.files()    # Prints the file names of everything on my Desktop - oof, messy.

# I don't want that, so I'm going to change it back to where I originally was.

setwd("/home/jbukoski/consulting/usfs/usfs_r_training")
getwd()

list.files()


# Typically I create a directory for each project I have and create two
# subdirectories within it - one for "scripts", and one for "data"

# my_WD 
#    |____ scripts
#             |______00_script1.R
#             |______01_script2.R
#    |_____data
#             |______rawData.csv
#             |______myRaster.tif

# This tends to be a cleaner structure and helps keep things organized.

# I can also use the list.files() command to view my subdirectories

list.files()
list.files("scripts")

# "File not found" errors can be commonly caused by working from the wrong 
# directory.

#-----------------------------

############################
## Reading & Writing Data ##
############################

# Once you open an R session and load a library you need, you will need to load
# in the data that you want to analyze. Typically, the function you need to
# load in data will depend on the data type. For example,

# read_csv() - read in CSV files
# st_read - read in shapefiles using the SF package
# read_excel() - read in excel files using the 'readxl' package

# We can also download data directly from the internet using wget()

data_link <- "https://scrippsco2.ucsd.edu/assets/data/atmospheric/stations/in_situ_co2/weekly/weekly_in_situ_co2_mlo.csv"

download.file(url = data_link, destfile = "./data/co2_data.csv", method = "wget")

# Now we have a csv in our "data" directory, which we downloaded directly from
# the internet.

list.files("data")

# We can load that data into R using the read.csv() function:

dat <- read.csv("./data/co2_data.csv", header = FALSE, skip = 44)

head(dat)

# Assign column names:

colnames(dat) <- c("date", "concentration")

head(dat)

# Now that we've cleaned up the data file a bit, we can write it out to a new file.

write.csv(dat, "./data/clean_co2_data.csv")

list.files("data")

#------------------------------------
# Exercises:

# 1.1. What is the structure of the data?

# 1.2. What are the classes of the data columns?

# 1.3. How many rows are in the dataset?

# 1.4. Create a new dataframe named dat_1970s with all data from rows 562-1082.

# 1.5. What was the mean value of the CO2 concentration in the 1970s?

# 1.6. Plot the full dataset (1958 - present) as concentration ~ date using the plot() function.



