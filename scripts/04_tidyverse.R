# Introduction to the tidyverse

# Load the tidyverse library:


# Let's get some data. The iris dataset is a common (famous?) dataset often
# used to teach R:

data(iris)

head(iris)

# Key functions:

# %>% - the "pipe"... a very cool function!
# filter() - filter dataset based on selection criteria
# mutate() - alter or manipulate columns of data
# select() - select columns of data you want
# rename() - rename column names
# group_by() - group the data before applying functions
# summarise() - summarise data given the groups
# ungroup() - ungroup the data to apply standard functions


# Filter the iris dataset to select all "virginica" species:



# Now, let's do it using tidyverse functions:



# Create two new columns in the data for Sepal.Area and Petal.Area, which are 
# the products of sepal and petal length and widths:



# Now, let's do it using tidyverse functions:



# Create a new tibble (i.e., data frame) with only the Sepal.Area, Petal.Area, 
# and Species columns:



# Now, let's do it using tidyverse functions:



# Rename the columns of your new tibble to remove the "periods" from the column
# names and use lowercase letters



# Now, let's do it using tidyverse functions:



# Calculate the mean Sepal.Length, Sepal.Width, Petal.Length, and Petal.Width 
# for each of the three species types.



# Now let's do it using tidyverse functions:


