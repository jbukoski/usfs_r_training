#######################
## Jacob J. Bukoski  ##
## Introduction to R ##
#######################

# The object of this document is to help you start to use the R environment 
# for statistical analysis and graphics. Once you have familiarity with the 
# general functioning of R and of R's objects you can use online manuals and 
# guides to learn more advanced R. There is extensive documentation available 
# at:

#     *     www.r-project.org.
#     *     http://www.statmethods.net/index.html
#     *     http://wiki.r-project.org/rwiki/doku.php
#     *     https://r4ds.had.co.nz/ (R for Data Science by Hadley Wickham)

# The best way to learn R is via experimentation. A common pattern of code
# development for new R users is:

# 1. Copy and paste code that appears to do what you want.
# 2. Run code and receive errors.
# 3. Resolve errors and adjust code to do what you actually want.
# 4. Run code and receive more errors.
# 5. Continue to debug and develop code.

# Given this common workflow, here are a few tips to help streamline your 
# workflow:

# 1. Keep trying! And experimenting. Try different ways of doing the same
#    thing. Also try to read and understand what other people's code is doing.
# 2. Read your error messages! Not all error messages are create equal, but
#    many will hint at the issue you need to resolve.
# 3. Use help functions e.g., help(), class(), head(), str() to understand
#    what your code is doing. As Richard Feynman said, "What I cannot create,
#    I do not understand."
# 4. Ask for help when you need it, and learn how to ask for help. R can be
#    frustrating, so knowing when to ask for help is important. Knowing what
#    you are trying to ask can also be challenging - this will come with time.

##------------------
## Getting help

# R gives help on function and commands. On-line help gives useful information 
# as well. Getting used to R help is a key to successful statistical modelling. 
# There are primarily two ways to search R help in relation to a function:

# ?mean : This will search for the help file associated with the mean() function
# This is helpful for advise on the use of a specific function.

?mean

# ??mean : This will search for the keyword "mean" within all help pages

??mean

# Additionally, we can run the following:

help(mean)


#-----------------------------------------------

######################
## Getting started! ##
######################

# So, let's get started!

# At it's most basic use, R can be used simply as a calculator. PEMDAS applies.

1 + 1

3 + (20 * 5)

sqrt(64) -3 * 5

18^3 - 29

# We can store outputs of calculation in "objects"
# <- is the "assignment" operator, used for assigning objects to object names

a <- 19 - 5

a
print(a)
class(a)

# Remember that R is case sensitive!

print(A) # Error in print(A) : object 'A' not found

print(a)

A <- a

print(a)
print(A)

# Variable names in R must begin with a letter, followed by alphanumeric 
# characters.

3e <- 10e3  # Error: unexpected input in "3e "
e3 <- 10e3

# You are allowed to use "." in names, but it is typically bad practice 
# because the period character has specific meaning within R. 
# (E.g., ./ means "from this directory").
# I tend to use either "camelCase" or underscores.

goodName <- sqrt(A)
also_a_good_name <- sqrt(a)

ok.but.not.great <- a^A

# Avoid single letter names such us: c, l, q, t, C, D, F, I, and T, which are 
# either built-in R functions or hard to tell apart.

# Once defined, variables you can also use variables in interactive calculations:

b = 2*2
a = 2*3

a*b

# And in formulas:

c = 60 / (a+b)
c

myDBH <- 15

biomass <- 0.235 * myDBH ^ 2.42

# If you forget a parentheses at the end of a formula, R will hang with a "+"
# on the next line, waiting for you to continue the formular or close the
# parentheses.

# lets_hang <- 9 * (3 + 2


# Be careful of PEMDAS!

C = ((a + 2 * sqrt(b)) / (a + 8 * sqrt(b)))/2
C

# is different from:

C = a + 2 * sqrt(b) / a + 8 * sqrt(b) / 2
C

##-----------------
## Logical values

# R can perform conditional tests and generate True or False values as results.
# The logical operators are <, <=, >, >=, == for exact equality and != for 
# inequality.

x <- 60

x > 100

x == 70

x > 3

x != 100

# Logical values can be stored as variables:

x <- 60

x > 3


apple <- x > 3
print(apple)

##-----------------
## Strings

# We can also assign character strings to objects using R.

string1 <- "hello"
string2 <- "world"

string1
class(string1)

# We can join the strings using the paste() and paste0() functions.

myPhrase <- paste(string1, string2)
myPhrase

# Similarly, we can use the function strsplit() to separate strings.

fullSpecies <- "Rhizophora apiculata"

splitSpecies <- strsplit("Rhizophora apiculata", split = " ")

class(splitSpecies)

genus <- splitSpecies[[1]][1]
species <- splitSpecies[[1]][2]

splitSpecies[[1]][1]

genus
species

##-------------------------------

################
##  R objects ##
################

# The entities R operates on are technically known as objects. 
# Examples are vectors of numeric (real) or complex values, vectors of logical
# values and vectors of character strings. These are known as atomic structures
# since their components are all of the same type, or mode, namely numeric, 
# complex, logical, character and raw. R also operates on objects called lists,
# which are of mode list. These are ordered sequences of objects which 
# individually can be of any mode. Lists are known as recursive rather than 
# atomic structures since their components can be lists themselves.
# 
# The other recursive structures are those of mode function and expression. 
# Functions are the objects that form part of the R system along with similar 
# user written functions, which we discuss in some detail later. Expressions as
# objects form an advanced part of R which will not be discussed in this guide.
# 
# By the mode of an object we mean the basic type of its fundamental 
# constituents. This is a special case of a property of an object. Another 
# property of every object is its length. The functions mode(object) and 
# length(object) can be used to find out the mode and length of any defined 
# structure.
# 
# Further properties of an object are usually provided by attributes(object). 
# Because of this, mode and length are also called intrinsic attributes of an
# object.

#------------
### Vectors

# Vectors are combinations of scalars in a string structure. 
# Vectors must have their values all of the same mode. Thus any given vector 
# must be unambiguously either logical, numeric, complex, character or raw. 
# (The only apparent exception to this rule is the special value listed as NA
# for quantities not available, but in fact there are several types of NA). 
# Note that a vector can be empty and still have a mode. For example the empty
# character string vector is listed as character(0) and the empty numeric 
# vector as numeric(0).
# 
# c() is the generic function to combine arguments (think "combine") with
# the default forming a vector.
#
# Let's look at the help file for c().

?c

# As an example we can create a simple vector of seven values typing:

myVctr <- c(2, 3, 4, 5, 10, 5, 8)

myVctr

# We can generate a sequence using the shorthand syntax:

myVctr <- 1:10

# We can generate the same sequence of 1:10 command using the seq() function.
# The syntax will be :

seq(1, 10)

# The seq() function seq(from = number, to = number, by = number) creates a 
# vector starting from a value to another by a defined increment:

seq(from = 1, to = 10, by = 0.25)

seq(1, 10, 0.25)   # Using positions

seq(by = 0.25, to = 10, from = 1) # mixing positions, but naming arguments
 
# The replicate function rep() replicates a vector several times in a more 
# complex vector. Calculations can be included to form vectors as well and 
# functions can be combined in the same command:

one2three <- 1:3 

rep(one2three, 10)

c(10 * 0:10)

10 * c(0:10)

# Getting a bit crazy:

rep( c(5*40:1, 5*1:40, 5, 6, 7, 8, 3, 2001:2014), 2)

rep(seq(1, 3, 0.5), 3)

myVctr <- c("a", "b", "c")

1:10

c(myVctr, 1:10)

#---------------------
## Missing Values

# In some cases the components of a vector or of an R object more in general,
# may not be completely known. When an element or value is not available or a
# missing value in the statistical sense, a place within a vector may be 
# reserved for it by assigning it the special value NA.
#
# Any operation on an NA becomes an NA.
# 
# The function is.na(x) gives a logical vector of the same size as x with value
# TRUE if and only if the corresponding element in x is NA.

z <- c(1:3, NA)
ind <- is.na(z)
ind

# A stumper - why are the following different?

is.na(NA)
is.na("NA")


# There is a second kind of missing values which are produced by numerical 
# computation, the so-called Not a Number, NaN, values. Examples are 0/0 or 
# Inf - Inf which both give NaN since the result cannot be defined sensibly.

Inf-Inf

0/0

# In summary, is.na(xx) is TRUE both for NA and NaN values. To differentiate 
# these, is.nan(xx) is only TRUE for NaNs. Missing values are sometimes 
# printed as <NA> when character vectors are printed without quotes.

z <- c(1:3, NaN) 

is.not.available <- is.na(z) # This can catch both NA and NaN
is.not.a.number <- is.nan(z) # This can ONLY catch NaN, not NA

is.not.available 
is.not.a.number



#--------------------------
#######################
## Matrices & Arrays ##
#######################

# Matrices, or more generally arrays, are multi-dimensional generalizations of 
# vectors. In fact, they are vectors that can be indexed by two or more indices
# and will be printed in special ways.

#   *   factors provide compact ways to handle categorical data.
#   *   lists are a general form of vector in which the various elements need 
#       not be of the same type, and are often themselves vectors or lists. 
#       Lists provide a convenient way to return the results of a statistical 
#       computation.

# matrix() function creates a matrix from the given set of values. We use the 
# matrix(x, nrow =, ncol =) function to set the matrix cells values, the number
# of raws and the number of columns. We can use the colnames() and rawnames()
# functions to set the column and raw names of the matrix-like object.

matrix(data = NA, nrow = 2, ncol = 3)

example_matrix <- matrix(0, 2, 3)
example_matrix

example_matrix[1, ]
example_matrix[ , 2]

example_matrix[1, ] <- 1:3
example_matrix[2, ] <- c(5, 10, 4)
example_matrix

matrix_head <- c("col a", "col b", "column c")
matrix_side <- c("first row", "second row")
str(matrix_side)

numeric_vector <- c(rep(c (5*10:1, 5, 6), 2))
character_vector <- as.character(numeric_vector)

str(character_vector)

colnames(example_matrix) = matrix_head
rownames(example_matrix) = matrix_side

example_matrix
  
str(example_matrix)


##  Array

# An array can be considered as a multiply subscripted collection of data
# entries, for example numeric. R allows simple facilities for creating and
# handling arrays, and in particular the special case of matrices.
# 
# As well as giving a vector structure a dim (dimension) attribute, arrays can
# be constructed from vectors by the array function, which has the form
# array(data_vector, dim_vector)

Z <- array(data = 1:24, dim = c(3, 4, 2))
Z

#-------------------------------------

#################
## Data Frames ##
#################

## Data Frames

# Data frames are matrix-like structures, in which the columns can be of 
# different types. Think of data frames as data matrices with one row per 
# observational unit but with (possibly) both numerical and categorical 
# variables. Many experiments are best described by data frames: the treatments
# are categorical but the response is numeric.
#
# As a result R dataframes are tightly coupled collections of variables that 
# share many of the properties of matrices and of lists. Data frames are used
# as the fundamental data structure by most of R's modeling software.
# A data frame is a list with class "data frame". There are restrictions on 
# lists that may be made into data frames, namely :

#   *   The components must be vectors (numeric, character, or logical), 
#       factors, numeric matrices, lists, or other data frames.
#   *   Matrices, lists, and data frames provide as many variables to the new
#       data frame as they have columns, elements, or variables, respectively.
#   *   Numeric vectors, logicals and factors are included as is, and character
#       vectors are coerced to be factors, whose levels are the unique values 
#       appearing in the vector.
#   *   Vector structures appearing as variables of the data frame must all 
#       have the same length, and matrix structures must all have the same 
#       row size.

# Let's look at the help file

?data.frame

# Constructing a dataframe

my_df = data.frame(v = 1:4, 
                   ch = c("a","b","c","d"), 
                   n = 10)
my_df

class(my_df)
class(my_df$v)
class(my_df$ch)

# or

my_df = data.frame(vector = 1:4, 
                   character = c("a", "b", "c", "d"), 
                   const.vector = NA, 
                   row.names = c("data1", "data2", "data3", "data4"))
my_df

# Data selection and manipulation
# 
# You can extract data from dataframes using the start and $ sign:

my_df[["character"]]

my_df[[2]]    # my_df[ , 2]

my_df[[2]][3]

my_df$vector

my_df$character[2:3]

# You can add single arguments to a data frame, query informations, select
# and manipulate arguments or single values from a dataframe.

my_df$new
#   NULL

my_df$new <- c(10, 11, 20, 40)
my_df

str(my_df)

# length(object.name) number of elements in an object:

length(my_df$new)

# We can begin to apply functions to subsets of the data frame.
# max(object.name) - return the value of the greatest element

max(my_df$new)

# sort(object.name) - sort from small to big

sort(my_df$new) 

# rev(object.name) - from big to small

rev(sort(my_df$new)) # 


# subset(object.name, subset = "some logical expression") subset returns a 
# selection of an object with respect to criteria (typically comparisons: 
# x$V1 < 10); if the object is a data frame, the option select gives the 
# variables to be kept or dropped using a minus sign

subset(my_df, my_df$new == 20)

sample(my_df$new, 3)

sample(my_df$new, 3)

sample(my_df$new, 3)

# Exercise

my_new_df <- data.frame(a = 1:5, 
                        b = c("no", "no", "no", "get me", "no"), 
                        c = c(3, 6, 9, 10, 2), 
                        d = as.factor(runif(5, max = 20)))

my_new_df

# Extract the "get me" character string from the data frame and assign it to
# an object called "myObject". What is the class of that object?

#-----------------------------------------------------

################
## Functions! ##
################

##  Functions

# Functions are themselves objects in R which can be stored in the project's 
# workspace. This provides a simple and convenient way to extend R.
#
# Usage: in writing your own function you provide one or more argument or names
# for the function, an expression (or body of the function) and a value is 
# produced equal to the output function result.

# Example
# A function named "myfunction"
# The argument functions are "x", which the user defines when calling it.

myfunction <- function(x) {
  
  answer <- x^5
  
  return(answer)
  
}

myfunction(3)

# A more complex and more relevant example:

rhapAllomEq <- function(dbh) {
  
  biomass <- 0.235 * dbh ^ 2.42
  
  return(biomass)
  
}

rhapAllomEq(15.2)

myData <- data.frame(plot = c(1, 1, 1, 1),
                     subplot = c(1, 1, 2, 2),
                     species = c("rhap", "rhap", "rhap", "soob"),
                     dbh = c(6.2, 19.4, 10.2, 7.1))

rhapData <- myData[myData$species == "rhap", ] 
rhapBiomass <- rhapAllomEq(myData[myData$species == "rhap", ]$dbh)

rhapData$biomass <- rhapBiomass

rhapData
         