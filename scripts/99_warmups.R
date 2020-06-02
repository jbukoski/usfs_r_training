# 99_warmups.R

#----------------------------------
# May 26, 2020

# Create three vectors of different types (any data type is fine) and of length 6. Save them as separate objects.

hexysexy <- c(1, 2, 3, 4, 5, 6)
mangle <- c("rhap", "rhap", "avma", "soal", "xygr", "brgy")
status <- factor(c("live", "dead", "live", "dead", "live", "dead"))

# Combine the three vectors into a data frame named my_df

my_df <- data.frame(hexysexy, mangle, status)

# Save the value from the 3rd row, 2nd column to a new object named my_object.

my_object <- my_df[3, 2]

my_df$mangle[3]

# Create another vector of length 6 (any data type is fine), and add it to your data frame. 

myDead <- c(0, 1, 0, 2, 0, 1)

my_new_df <- cbind(my_df, myDead)


#--------------------------------------
# June 2, 2020

# Create a dataframe with 4 columns and 5 rows. Two of the columns should be numeric

DBH <- c(12.5, 13, 105, 15, 16)
height <- c(18, 20, 15, 35, 21)
species <- c("RHAP", "BRGY", "XYGR", "SOAL", "AVMA")
status <- c("0", "0", "2", "1", "3")

mangroovy <- data.frame(species = species, DBH = DBH, status = status, height = height)
  
# Add a fifth column (named "total") to the dataframe that is the sum of the 
# two numeric columns

total <- DBH + height

mangroovy2 <- cbind(mangroovy, total)

mangroovy

# Challenge - run a linear regression with the "total" predicted as a function
# of one of the numeric columns. Save the linear model to an object named "lm1".

lm1 <- lm(total ~ DBH + status)

summary(lm1)

# View the model results using summary(lm1).

