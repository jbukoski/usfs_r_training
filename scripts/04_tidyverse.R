# Introduction to the Tidyverse

# Load the tidyverse library:

library(tidyverse)

# Let's get some data. The iris dataset is a common (famous?) dataset often
# used to teach R:
  
data(iris)

head(iris)

# Key tidyverse functions:

# %>% - the "pipe"... a very cool function!
# filter() - filter dataset based on selection criteria
# mutate() - alter or manipulate columns of data
# select() - select columns of data you want
# rename() - rename column names
# group_by() - group the data before applying functions
# summarise() - summarise data given the groups
# ungroup() - ungroup the data to apply standard functions


# Filter the iris dataset to select all "virginica" species:

iris[iris$Species == "virginica", ]

# Now, let's do it using tidyverse functions:

myVirginicaData <- myRawData %>%
  filter(Species == "virginica")


# Create two new columns in the data for Sepal.Area and Petal.Area, which are 
# the products of sepal and petal length and widths:

Sepal.Area <- iris$Sepal.Length * iris$Sepal.Width
Petal.Area <- iris$Petal.Length * iris$Petal.Width

iris2 <- cbind(iris, Sepal.Area, Petal.Area)

head(iris2)


# Now, let's do it using tidyverse functions:

iris2 <- iris %>%
  mutate(Sepal.Area = Sepal.Length * Sepal.Width,
         Petal.Area = Petal.Length * Petal.Width)


# Create a new tibble (i.e., data frame) with only the Sepal.Area, Petal.Area, 
# and Species columns:

iris2[ , c("Sepal.Area", "Petal.Area", "Species")]
iris2[ , c(6, 7, 5)]

# Now, let's do it using tidyverse functions:

iris2 %>%
  select(Sepal.Area, Petal.Area, Species)

# Rename the columns of your new tibble to remove the "periods" from the column
# names and use lowercase letters

colnames(iris2) <- c("sepal_length", ...)

# Now, let's do it using tidyverse functions:

test <- iris2 %>%
  set_colnames(tolower(colnames(.)))

# Calculate the mean Sepal.Length, Sepal.Width, Petal.Length, and Petal.Width 
# for each of the three species types.

aggregate(Sepal.Length ~ Species, data = iris, FUN = "mean")

setosa_df <- iris[iris$Species == "setosa", ]

mean(setosa_df$Sepal.Length)

# Now let's do it using tidyverse functions:

iris2 %>%
  group_by(Species) %>%
  summarise(mean_SL = mean(Sepal.Length),
            mean_SW = mean(Sepal.Width),
            mean_PL = mean(Petal.Length),
            mean_PW = mean(Petal.Width))

