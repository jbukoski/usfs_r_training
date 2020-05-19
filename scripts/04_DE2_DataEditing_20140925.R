
###################
### Finding NAs
###################
# set the working directory to where ever you put the sample data
# establecer el directorio de trabajo a "Rworkshop"
getwd()
setwd("C:/Rworkshop") # for Tracey and Paul #para Tracey y Paul
getwd()

tree <- read.csv("PlotData/tree.csv",
header=TRUE, sep = ",", dec = ".", skip = 0, row.names = NULL,
stringsAsFactors=FALSE);

plot <- read.csv("PlotData/plt.csv",
header=TRUE, sep = ",", dec = ".", skip = 0, row.names = NULL,
stringsAsFactors=FALSE);

cond <- read.csv("PlotData/cond.csv",
header=TRUE, sep = ",", dec = ".", skip = 0, row.names = NULL,
stringsAsFactors=FALSE);


#Exercise 4
# Input the above three files
# En la carpeta PlotData que les dimos, introduzca los tres archivos anteriores

# Let's look at what variables are in data frame.
# Echemos un vistazo a lo que las variables están en trama de datos.
head(tree)
head(plot)
head(cond)

dim(tree)
sum(rowSums(is.na(tree))>0)
sum(colSums(is.na(tree))>0)
# Since there is only 25 colSums, let's look at them
# Ya que está a sólo 25 colSums, echemos un vistazo a los
colSums(is.na(tree))>0

# A bit confusing, so let's print only the column names for the columns with NAs
# Un poco confuso, así que vamos a imprimir sólo los nombres de columna de las columnas con NA
names(tree[,colSums(is.na(tree))>0])
# or
names(tree)[colSums(is.na(tree))>0]

# Exercise 5
# How do we get the column sums only for those columns with NAs?
# ¿Cómo obtenemos la columna resume sólo aquellas columnas con NA?

# Let's look at STATUS CODES for the rows where are NA's. 
# There is a handout "Handout_B4_DataEditing_20130522" on the website that describes the variables.
# Echemos un vistazo a los códigos de estado de las filas en las que son de NA.
# Hay un "Handout_B4_DataEditing_20130522" folleto en la página web que describe las variables. 
unique(tree$STATUSCD[rowSums(is.na(tree))>0])

# Exercise 6
# What are the values of STATUSCD when both DIA and CR are NA?
# What are the values of STATUSCD when DIA has numeric value and CR is NA?
# Do your answers make sense? 
# ¿Cuáles son los valores de STATUSCD cuando ambos DIA y CR son NA?
# ¿Cuáles son los valores de STATUSCD cuando DIA tiene un valor numérico y CR es NA?
# ¿Sus respuestas tienen sentido? 

#########################
### Data Exploration ####
#########################

# Let's look at the data to find irregulaties
# Echemos un vistazo a los datos para encontrar irregulaties
summary(tree)

# Looking at a specific variable
# En cuanto a una variable específica
summary(tree$HT)
hist(tree$HT)

# Exercise 7
# Find the summary() and hist() for the variable TREEAGE
# Encontrar el summary() y hist() para la variable de TREEAGE

# there is also individual functions: min, max, mean, median, quantile
# también hay mínimo (min), máximo (max), media (mean), mediana (median), cuantil (quantile)
# Let's look a little closer at the quantiles of TREEAGE
# Vamos a ver un poco más de cerca a los cuantiles de
quantile(tree$TREEAGE,seq(0.1,0.9,0.1), rm.na=TRUE)

# There are no NAs, so it must be that trees that were not measured for age were assigned the
# value zero.
# No hay nuevos inmigrantes, por lo que debe ser que los árboles que no fueron medidos por 
# edad se les asigna el valor cero.

# Exercise 8
# How many zeros are there for the variable "TREEAGE"? 
# Does this agree with the previous "quantile" results?
# What are the 0.1,0.2,...,0.8,0.9 quantiles of the nonzero values?
# ¿Cuántos ceros están ahí para el "TreeAge" variable?
# ¿Esta de acuerdo con los últimos resultados "cuantiles"?
# ¿Cuáles son los 0.1,0.2, ..., 0.8,0.9 cuantiles de los valores distintos de cero?

# We can use scatter plots to see outliers.  Let's look at Height versus Diameter.
# Podemos usar gráficos de dispersión para ver outliers. Veamos Altura Diámetro frente.
plot(tree$DIA,tree$HT)

# I don't like the axis lables
# No me gustan los lables eje
plot(tree$DIA,tree$HT,
xlab="Diameter",ylab="Height",
  main = "All trees")

# It will be more informative if we do a separate graph for each species
# Será más informativo si hacemos un gráfico separado para cada especie
species <- unique(tree$SPCD)
length(species)
species
species <- sort(species)
species

#Exercise 9
# How many trees are there with SPCD = 19? How many have NAs for DIA and HT? How many NAs for DIA?
# ¿Cuántos árboles están allí con SPCD = 19? ¿Cuántos tienen AN para DIA y HT? 
# ¿Cuántas agencias nacionales para la DIA?

sp19 <- tree[( tree$SPCD==19 & !is.na(tree$DIA) ),]
dim(sp19)

# Start off with a scatter plot 
# Comience con un gráfico de dispersión
plot(sp19$DIA,sp19$HT,
  xlab="Diameter",ylab="Height",
  main = "Species Subalpine Fir")

# Let's produce a scatter plot for DIA,HT for all the species
# Vamos a producir un gráfico de dispersión para DIA, TreeAge para todas las especies
par(mfrow=c(5,3))
for (i in 1:length(species)) {
  sp <- tree[( tree$SPCD==species[i] & !is.na(tree$DIA)  ),]
  plot(sp$DIA,sp$HT,
  xlab="DIA",ylab="HT",
  main=paste("sp ",species[i]))
} # End for loop
par(mfrow=c(1,1))

# reduce number of graphs and add the ASK option
# Reducir número de gráficos y agregar la opción ASK
par(ask=TRUE)
par(mfrow=c(2,2))
for (i in 1:length(species)) {
  sp <- tree[( tree$SPCD==species[i] & !is.na(tree$DIA)  ),]
  plot(sp$DIA,sp$HT,
  xlab="DIA",ylab="HT",
  main=paste("sp ",species[i]))
} # End for loop
par(mfrow=c(1,1))
par(ask=FALSE)

# Next we will use regression to flag trees that based on thier diameter have a height that is suspect.
# A continuación vamos a utilizar la regresión de los árboles del pabellón que con base en el diámetro 
# emabrgo tiene una altura que es sospechoso.

# Build a regression model of height regressed on diameter; show the output from the model. The theory
# of regression will be discussed in a later model. Right now we just accept that we can build a 
# regression model and use it to locate outliers.
# Construir un modelo de regresión de la altura de una regresión en el diámetro; mostrar la salida 
# del modelo. La teoría de la regresión se discutirá en un modelo posterior. En este momento sólo 
# aceptamos que podemos construir un modelo de regresión y lo utilizan para localizar los valores atípicos. 
r.mod <- lm(HT~DIA,data=sp19)

# let's add the regression line to the scatter plot
# vamos a añadir la línea de regresión a la gráfica
plot(sp19$DIA,sp19$HT,
  xlab="Diameter",ylab="Height",
  main = "Species Subalpine Fir")
abline(r.mod)

# there is a problem; the distance of a point to the line increases as the diameter increases
# hay un problema; la distancia de un punto a la línea aumenta a medida que el diámetro aumenta
# Lets break the trees into diameter classes where the distance to the line doesn't appear to
# increase
# Vamos a romper los árboles en clases de diámetro con una distancia hasta la línea no parece 
# aumentar

mins=c(0,5,10)
maxs=c(5,10,40)
par(mfrow=c(2,2))
for (i in 1:3) {
 dia.class <- sp19[sp19$DIA > mins[i] & sp19$DIA <= maxs[i],]
 plot(dia.class$DIA,dia.class$HT,
   xlab="Diameter",ylab="Height",
   main = "Species Subalpine Fir")
 r.mod <- lm(HT~DIA,data=dia.class)
 abline(r.mod)
}
par(mfrow=c(1,1))

# Looks pretty good. Now we will use the distance from the regression line to flag trees we want to look at.
# Se ve muy bien. Ahora vamos a utilizar la distancia de la línea de regresión a los árboles 
# bandera que queremos ver.

dia.class <- sp19[sp19$DIA > mins[1] & sp19$DIA <= maxs[1],]
r.mod <- lm(HT~DIA,data=dia.class)
names(r.mod)

# The height the model predicts for the diameter values is in object "fitted"
# La altura el modelo predice los valores de diámetro está en el objeto "fitted"
r.mod$fitted[1:3]
# The DIA and HT values are in the object "model"
# Los valores de DIA y HT están en el objeto "model"
r.mod$model[1:3,]
# The "residual" should be the "fitted" minus "HT".
# El "residual" debe ser "fitted" menos "HT".
r.mod$residuals[1:3]

# We want all trees where the residuals are less than the 0.02 quantile of the residuals or greater 
# than the 0.98 quantile of the residuals
# Queremos que todos los árboles, donde los residuos son menores que el 0,02 cuantil de los residuos 
# o mayor que el 0,98 cuantil de los residuos

q <-quantile(r.mod$residuals,c(0.02,0.98), rm.na=TRUE)
q
boxplot(r.mod$residuals)
dia.class[(r.mod$residuals < q[1] | r.mod$residuals > q[2]),]

# Let's now do this for all diameter classes and store the results, so an "expert" can look at them,
# that is we did all the hard work of writing the code and now it is time to pass the results off to
# someone else.
# Ahora vamos a hacer esto para todas las clases de diámetro y almacenar los resultados, por lo que 
# un "experto" puede mirar en ellos, es decir, hemos hecho todo el trabajo duro de escribir el código 
# y ahora es el momento de pasar los resultados a otra persona.

outliers <- data.frame()
for (i in 1:3) {
 dia.class <- sp19[sp19$DIA > mins[i] & sp19$DIA <= maxs[i],]
 r.mod <- lm(HT~DIA,data=dia.class)
 q <-quantile(r.mod$residuals,c(0.02,0.98), rm.na=TRUE)
 outliers <- rbind(outliers,dia.class[(r.mod$residuals < q[1] | r.mod$residuals > q[2]),])
}

dim(outliers)
outliers[,1:10]

# Exercise 10
# For Species = 19, use regression to create a file of trees that based on thier height that have a diamter
# that is suspect. Label the file outliers2.
# Is the data set you found the same as the one we found using HT on DIA? 
# Para las especies = 19, utilizar la regresión para crear un archivo de árboles que basan en emabrgo altura 
# que tiene un diamter que es sospechoso. Etiquetar el outliers2 archivo.
# ¿Los datos establecen que encontró el mismo que el que encontramos en el uso de HT DIA?


# Lots more on regression in a later presentation
# Muchos más en regresión en una presentación posterior

# Cross tabulation between variables is useful for finding errors.
# For example, are there species of trees which are in forest types which they very 
# unlikely to be in? So we need to merge the data frames.
# In the data frames plots and trees the unique identifier is the plot number
# We will merge the two data frames using plot number
# Tabulación cruzada entre las variables es útil para encontrar errores.
# Por ejemplo, ¿hay especies de árboles que se encuentran en los tipos de bosque que ellos 
# mismos poco probable que se pulg Por lo tanto tenemos que combinar las tramas de datos.
# En los marcos de las parcelas y los árboles de datos del identificador único es el 
# número de la parcela
# Vamos a fusionar las dos tramas de datos utilizando el número de parcela
tree <- tree[order(tree$PLT_CN,tree$SUBP,tree$TREE),]
plot <- plot[order(plot$CN),]
extend.tree <- merge(tree,plot,by.x="PLT_CN",by.y="CN")

cond <- cond[order(cond$PLT_CN,cond$CONDID),]
extend.tree <- merge(extend.tree,cond,by=c("PLT_CN","CONDID"))

# The data set we are working with has already been cleaned (i.e., checked for errors)
# I will give a couple of examples of functions can be used to find errors
# El conjunto de datos que estamos trabajando ya se ha limpiado (es decir, comprobar si 
# hay errores)
# Daré un par de ejemplos de funciones se puede utilizar para encontrar errores

# table of Forest Type
# tabla de tipo de bosque
table(extend.tree$FORTYPCD,useNA="no")

# table of Species
# Tabla de Especies
table(extend.tree$SPCD,useNA="no")

# Cross tabulation of Forest Type and Species
# Tabulación cruzada de tipo y especie forestal
table(extend.tree$FORTYPCD,extend.tree$SPCD,useNA="no")

# "tapply" is the same as a "by" statement, with the output a matrix for "tapply" and a list for "by"
# "tapply" es la misma que una declaración "por", con la salida de una matriz para "tapply" y 
# una lista de "por"

by(extend.tree$ELEVM,as.factor(extend.tree$SPCD),range)

tapply(extend.tree$TREEAGE,as.factor(extend.tree$FORTYPCD),range)

# Exercise 11 
# The species with code = 66 usually doesn't grow over 2600 meters. Print to the 
# screen a list of trees which are growing at over 2600 meters. 
# Only print out the following variables PLT_CN,SUBP,TREE,SPCD,FORTYPCD,ELEVM.
# Las especies con código = 66 por lo general no crecen más de 2.600 metros. 
# Imprimir en la pantalla una lista de Árboles que crecen a más de 2.600 metros. 
# Sólo imprima las siguientes variables PLT_CN, SUBP, TREE, SPCD, FORTYPCD, ELEVM.
