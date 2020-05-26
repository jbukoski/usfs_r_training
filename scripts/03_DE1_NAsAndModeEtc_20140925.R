## NAs and More on Mode, etc.
## NAs y m?s en el modo, etc

# Taken from: https://www.fs.fed.us/rm/ogden/research/Rworkshop/DataEditing.shtml

###################
# More on input data into data frames and effect on mode
# A m?s de los datos de entrada en tramas de datos y el efecto en el mode de
# (Modo Pablo cambi? al mode)
##################

dat <- data.frame(rbind(c(1,1,"CANELO",1,12.7,20),
			c(1,2,"LECHERO",1,20.1,25),
			c(1,3,"LECHERO",1,30.5,30),
			c(1,4,"LECHERO",2,15.0,15),
			c(1,5,"CANELO",1,NA,40),
			c(2,1,"CANELO",1,25.2,25),
			c(2,2,"COCO",2,14.4,28),
			c(2,3,"CANELO",1,35.1,NA),
			c(2,4,"COCO",2,17.0,22)),
                  stringsAsFactors=FALSE)

names(dat) <- c("parcela", "codigo", "nombre_comun", "estado_arbol", "dap", "altura")

#Let's check the mode
# Vamos a ver el mode de
mode(dat$parcela)
mode(dat$altura)

# Why a problem
# ?Por qu? esto es un problema.
mean(dat$altura)

# A couple solutions
# Un par de soluciones
mean(as.numeric(dat$altura))

# (We will talk about this NA in a couple minutes)
# (Vamos a hablar de esto NA en un par de minutos)

dat$altura<-as.numeric(dat$altura)
mode(dat$altura)

#An easy way to declare the mode of all variables in the data frame.
# Una manera f?cil de declarar el mode de todas las variables en el cuadro de datos.

colcls6<-c("numeric","numeric","character","numeric","numeric","numeric")
for (i in 1:6) {
  mode(dat[,i]) <- colcls6[i]
} # end for loop

# If the data.frame is being create using a read.csv, etc... you can set the mode
# when the data set is being created, using colClasses = colcls6.
# Si el data.frame se crean utilizando un read.csv, etc .. se puede establecer el mode de
#?cuando se cre? el conjunto de datos, utilizando colClasses = colcls6.
help(read.csv)

# Exercise 1
# Test the mode of the third and sixth column
# Pruebe el mode de la tercera y la sexta columna

#Let's add a row of NAs in the middle
# Vamos a a?adir una fila de AN en el medio
dat <- rbind(dat[1:5,], rep(NA,6), dat[6:9,])

# Let's simulate what occationally happens when reading from an excel file and rows of NAs are 
# added to the bottom of the data frame.  
# Vamos a simular lo occationally sucede cuando la lectura de un archivo de Excel y filas de 
# los NAs se a?ade al final de la trama de datos.
for (i in 1:3) {
  dat <- rbind(dat,rep(NA,dim(dat)[2]))
} # End for loop

#Exercise 2
# Add a new live Canelo tree, which is on parcela 1; the tree has dap of 13.2, but no height.
# A?adir un nuevo ?rbol vivo Canelo, que est? en parcela 1, el ?rbol tiene dap de 13.2, 
# pero no la altura.

#Let's check the mode
#Vamos a ver el modo de
mode(dat$altura)

# we need to rerun the loop above.
#tenemos que volver a ejecutar el bucle anterior
#Let's check the mode
#Vamos a ver el modo de
mode(dat$altura)


# Let's run the code creating the data frame dat, but leave out the stringsAsFactors=FALSE, 
# we will denote the data frame by dat.test and check the mode of columns.
# Vamos a ejecutar el c?digo de creaci?n de datos marco dat, pero sin las stringsAsFactors = FALSO,
# denotaremos la trama de datos por dat.test y comprobar el modo de columnas.

dat.test <- data.frame(rbind(c(1,1,"CANELO",1,12.7,20),
                             c(1,2,"LECHERO",1,20.1,25),
                             c(1,3,"LECHERO",1,30.5,30),
                             c(1,4,"LECHERO",2,15.0,15),
                             c(1,5,"CANELO",1,NA,40),
                             c(2,1,"CANELO",1,25.2,25),
                             c(2,2,"COCO",2,14.4,28),
                             c(2,3,"CANELO",1,35.1,NA),
                             c(2,4,"COCO",2,17.0,22))
                  )
names(dat.test) <- c("parcela", "codigo", "nombre_comun", "estado_arbol", "dap", "altura")

for (i in 1:length( names(dat.test) )){
   print( mode(dat.test[,i]) )
} #end for loop

for (i in 1:length( names(dat.test) )){
   print( typeof(dat.test[,i]) )
} #end for loop

for (i in 1:length( names(dat.test) )){
   print( class(dat.test[,i]) )
} #end for loop

# interesting!
# interesante! 

str(dat.test)

###########################################
## Dealing with NA values
###########################################

# Prints the rows which contain a NA value
# Imprime las filas que contienen un valor NA
dat[!complete.cases(dat),]

# logical (TRUE/FALSE) matrix with TRUE if values are NA
# l?gico (TRUE/FALSE) matriz con TRUE si los valores son NA
is.na(dat)

# the number of NAs per row
# El n?mero de nuevos inmigrantes por fila			
rowSums(is.na(dat))		

# TRUE for all rows which have at least one data value
# TRUE para todas las filas que tienen al menos un valor de datos
rowSums(is.na(dat))<ncol(dat)	

# Remove the rows in which all columns have value NA	
# Elimina filas en las que todas las columnas tienen valor NA 
a<- dat[rowSums(is.na(dat)) < ncol(dat),]	
a 

# Remove the rows with any NA values
# Eliminar las filas con los valores de NA
b <- na.omit(dat)
b

###
# changing NA values
# cambiar los valores de NA
####

# To change all NAs to 0
# Para cambiar todas las agencias nacionales a 0
a
a[is.na(a)] <- 0
a

# only change NA values in a column to 0 values
# s?lo cambian los valores de NA en una columna de valores 0
a.0<- dat[rowSums(is.na(dat)) < ncol(dat),]
a.0
a.0[is.na(a.0[,"altura"]), "altura"] <- 0
a.0

# for numeric variables I sometimes prefer to use a number that sticks out; lets use -9999
# para las variables num?ricas veces prefiero usar un n?mero que sobresale, permite el uso -9999
a.neg <- dat[rowSums(is.na(dat)) < ncol(dat),]
a.neg[is.na(a.neg[,"altura"]), "altura"] <- -9999
a.neg

#Let's look at the mean.
mean(a.0$altura)
mean(a.neg$altura)

mean(a.0$altura[a.0$altura>0])
mean(a.neg$altura[a.neg$altura>0])

# Exercise 3
# In the data frame a.neg replace any NA in the column "dap" with a suitable number and find the
# mean of the non-NA rows.  
# En el marco de datos a.neg reemplazar cualquier NA en la columna  "dap" con un n?mero adecuado 
# y encontrar la media de las filas no NA.

# start totally fresh and free up memory
# comenzar memoria hasta totalmente fresco y libre de
gc()
rm(list=ls())

gc()
ls()

