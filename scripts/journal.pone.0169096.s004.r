###################################################################
###################################################################
##                                                               ##
##   The following R script provides the multiple linear mixed   ##
##   effects models described in the associated PLoS One         ##
##   manuscript, Bukoski et al., 2016.                           ##
##                                                               ##
##   The intention of the provided R script is to show the       ##
##   model structure and allow for recreation of model           ##
##   diagnostics and the publication figures. The necessary      ##

##   code for the importing and pre-processing of the dataset    ##
##   (i.e., subsetting the data to only include relevant         ##
##   observations) is not included here. Some adjustment of      ##
##   dataframe names, column names, and other parameters will    ##
##   need to be adjusted to rerun the script. However, if the    ##
##   dataframe is constructed to match the parameter names we    ##
##   use, the script can be run more efficiently. We have also   ##
##   provided the code to reproduce the figures of the study     ##
##   as well.                                                    ##
##                                                               ##
###################################################################
###################################################################

#------------------------------------------------------------------
# Load the necessary packages. If the packages are not installed on
# your local machine, you can install them via install.packages()

package_list = c("cowplot", "ggplot2", "hydroGOF", "MuMIn", "nlme")
new_packages = package_list[!(package_list %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

# Load the necessary packages

lapply(package_list, require, character.only = TRUE)

#--------------#####################################--------------#
               ##                                 ##
               ##     Mangrove biomass model      ##
               ##                                 ##
#--------------#####################################--------------#

# Fit the biomass model

lme.biomass <- lme(Biomass ~ Basal.area*Latitude - Latitude, random = ~1|Site,
            weights=varIdent(form = ~Latitude|Site), data=param.bas, control=ctrl)

# Look at model diagnostics

summary(lme.biomass)
lme.C.density$apVar
r.squaredGLMM(lme.biomass)
intervals(lme.biomass)

# Adjust data for plotting

results = as.data.frame(lme.full$fitted)
results = cbind(round(results,1), param.bas$Biomass, param.bas$Cntry)
colnames(results) = c("Fixed", "Mixed", "Observed", "Location")
results = as.data.frame(results)

# Plot Observed vs. Predicted for fixed effects only

biomass.plot.fe = ggplot(results, aes(Fixed, Observed)) + 
  geom_point() + 
  scale_shape_manual(values=c(1:25,33:63)) + 
  theme_bw() + geom_abline(col="red") + 
  xlab("Predicted Biomass Carbon (Mg C/ha)") +
  ylab("Observed Biomass (Mg C/ha)") +
  theme(axis.text=element_text(size=14))

# Plot Observed vs. Predicted for fixed + random effects

biomass.plot.re = ggplot(results, aes(Mixed, Observed)) + 
  geom_point() + 
  scale_shape_manual(values=c(1:25,33:63)) + 
  theme_bw() + geom_abline(col="red") + 
  xlab("Predicted Biomass C (Mg C/ha)") +
  ylab("Observed Biomass C (Mg C/ha)") + 
  theme(axis.text=element_text(size=14))

# Grid the plots

plot_grid(biomass.plot.fe, biomass.plot.re, ncol=2)


#--------------#####################################--------------#
               ##                                 ##
               ##    Soil organic carbon model    ##
               ##                                 ##
#--------------#####################################--------------#

# Fit the soil organic C model

lme.C.density <- lme((C.density) ~ log(Latitude) + log(Basal.area), random=~1|Site,
                     weights = varPower(form=~log(Latitude)),
                     method = "REML", data=model.c.dens, 
                     control = ctrl, na.action = "na.omit")

# Look at model diagnostics

summary(lme.C.density)
lme.C.density$apVar
r.squaredGLMM(lme.C.density)
intervals(lme.C.density)

# Adjust data for plotting

results.soil = as.data.frame(lme.C.density$fitted)
results.soil = cbind(round(results.soil,1), model.c.dens$C.density, model.c.dens$Site)
colnames(results.soil) = c("Fixed", "Mixed", "Observed", "Site")
results = as.data.frame(results.soil)

# Plot Observed vs. Predicted for fixed effects only

final.soil.plot.fe = ggplot(results.soil, aes(Fixed, Observed)) + 
  geom_point() + 
  scale_shape_manual(values=c(1:25,64)) +
  theme_bw() + geom_abline(col="red") +
  ylab(expression(paste('Observed SOC (mg C/cm'^3, ")", sep=""))) +
  xlab(expression(paste('Predicted SOC (mg C/cm'^3, ")", sep=""))) +
  theme(axis.text=element_text(size=14))

# Plot Observed vs. Predicted for fixed + random effects

final.soil.plot.re = ggplot(results.soil, aes(Mixed, Observed)) + 
  geom_point() + 
  scale_shape_manual(values=c(1:25,64)) +
  theme_bw() + geom_abline(col="red") + 
  ylab(expression(paste('Observed SOC (mg C/cm'^3, ")", sep=""))) +
  xlab(expression(paste('Predicted SOC (mg C/cm'^3, ")", sep=""))) +
  theme(axis.text=element_text(size=14))

# Grid the plots

plot_grid(soil.plot.fe, soil.plot.re, ncol=2)

