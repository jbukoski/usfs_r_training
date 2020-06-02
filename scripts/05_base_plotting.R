# Plotting in R {base}

data(iris)

#----------------------
# Histograms

hist(iris$Sepal.Length)

hist(iris$Sepal.Length, breaks = 20)

hist(iris$Sepal.Length, breaks = 20, xlim = c(5, 7))

# Challenge - change the title and x axis label to be more legible


#----------------------
# Boxplots

boxplot(iris$Sepal.Length)

# Add a Title and y-axis label

# Challenge 1 - create one figure with three box & whiskers for Sepal.Length by Species (Sepal.Length ~ Species)


# Challenge 2 - Are the differences in mean Sepal.Lengths statistically significant? Check with the ANOVA function, aov().


#------------------------
# Scatter plots

# Plotting 

plot(iris$Sepal.Length, iris$Petal.Length)

# Color each dot by its species


# Add a title and change the x and y axis labels


# Regress Sepal.Length on Petal.Length, and add the model fit to your plot.
# **hint - you will need lm() and abline() 
