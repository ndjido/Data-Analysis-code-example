
require('ggplot2')
require('lme4')
require('MASS')
require('epicalc')
require('languageR')
require('lmerTest')

Lyon_FactorAnalysis_BUS <- read.table('Lyon_FactorAnalysis_BUS_Day.csv', sep=';', header=TRUE)

head(Lyon_FactorAnalysis_BUS)

#  [1] "date"                   "ligne"                  "nb_validations"         "NBR_VOY_BRT"            "NBR_VOY_COR"            "NB_CTL"                 "NB_TITRES_INCORRECTS"  
#  [8] "taux_de_non_validation" "Nombre_Perturbations"   "Nombre_Infractions"     "Nombre_alertes"         "dateTIME"               "JVScolaire"             "JFerie"                
# [15] "JGreve"                 "deux_prem_jour_mois"    "LIBELLE_MOIS"           "LIBELLE_JOUR"           "Temperature_moyenneC"   "Temperature_minimumC"   "Max_Humidite"          
# [22] "Mean_Humidite"          "Max_VisibiliteKm"       "Mean_VisibiliteKm"      "Min_VisibilitekM"       "Precipitationmm"        "CloudCover"             "Condition_Meteo"       
# [29] "moyenne_retard"


Lyon_FactorAnalysis_BUS[is.na(Lyon_FactorAnalysis_BUS$NBR_VOY_BRT),]$NBR_VOY_BRT = 0

Lyon_FactorAnalysis_BUS[is.na(Lyon_FactorAnalysis_BUS$NBR_VOY_COR),]$NBR_VOY_COR = 0

Lyon_FactorAnalysis_BUS[is.na(Lyon_FactorAnalysis_BUS$NB_CTL),]$NB_CTL = 0

Lyon_FactorAnalysis_BUS[is.na(Lyon_FactorAnalysis_BUS$Nombre_Perturbations),]$Nombre_Perturbations = 0

Lyon_FactorAnalysis_BUS[is.na(Lyon_FactorAnalysis_BUS$Nombre_Infractions),]$Nombre_Infractions = 0

Lyon_FactorAnalysis_BUS[is.na(Lyon_FactorAnalysis_BUS$Nombre_alertes),]$Nombre_alertes = 0

Lyon_FactorAnalysis_BUS[is.na(Lyon_FactorAnalysis_BUS$NB_TITRES_INCORRECTS),]$NB_TITRES_INCORRECTS = 0

Lyon_FactorAnalysis_BUS[Lyon_FactorAnalysis_BUS$Condition_Meteo == '',]$Condition_Meteo = 'Non_renseigne'

Lyon_FactorAnalysis_BUS$JVScolaire <- factor(Lyon_FactorAnalysis_BUS$JVScolaire)

Lyon_FactorAnalysis_BUS$JFerie <- factor(Lyon_FactorAnalysis_BUS$JFerie)

Lyon_FactorAnalysis_BUS$JGreve <- factor(Lyon_FactorAnalysis_BUS$JGreve)

Lyon_FactorAnalysis_BUS$deux_prem_jour_mois <- factor(Lyon_FactorAnalysis_BUS$deux_prem_jour_mois)

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Stats
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Lyon_FactorAnalysis_BUS$ligne <- factor(Lyon_FactorAnalysis_BUS$ligne)

summary(Lyon_FactorAnalysis_BUS[Lyon_FactorAnalysis_BUS$taux_de_non_validation>=0,]$taux_de_non_validation)

#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#   0.04682 0.37540 0.44670 0.44370 0.51580 0.93780     139 


Lyon_FactorAnalysis_BUS <- Lyon_FactorAnalysis_BUS[Lyon_FactorAnalysis_BUS$taux_de_non_validation>=0,]

png("Keolis_data/Lyon/DayAnalysis/Boxplot_Ligne.png", width=650)
plot(taux_de_non_validation ~ ligne ,data=Lyon_FactorAnalysis_BUS, notch=TRUE, ylab='Taux de non-validation', col='lightblue')
dev.off()


png("Keolis_data/Lyon/DayAnalysis/Boxplot_Jour.png", width=650)
plot(taux_de_non_validation ~ LIBELLE_MOIS ,data=Lyon_FactorAnalysis_BUS, notch=TRUE, ylab='Taux de non-validation', col='lightblue')
dev.off()


plot(taux_de_non_validation ~ deux_prem_jour_mois ,data=Lyon_FactorAnalysis_BUS, notch=TRUE, ylab='Taux de non-validation', col='lightblue')



#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Risk Factors Analysis  (lmer)
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Lyon_FactorAnalysis_BUS <- Lyon_FactorAnalysis_BUS[Lyon_FactorAnalysis_BUS$ligne != 'T1',]

Lyon_FactorAnalysis_BUS$controle = factor(Lyon_FactorAnalysis_BUS$NB_CTL>0)

tnv_mod_1 <- lmerTest::lmer(taux_de_non_validation ~ controle + Nombre_Perturbations + Nombre_Infractions + Nombre_alertes + JVScolaire + JGreve + JFerie
	                                   + deux_prem_jour_mois + moyenne_retard + Mean_VisibiliteKm 
	                                   + (1|ligne) + (1|LIBELLE_MOIS) + (1|LIBELLE_JOUR), 
	                                   data=Lyon_FactorAnalysis_BUS)


summary(tnv_mod_1)


#                           Estimate Std. Error         df t value Pr(>|t|)    
# (Intercept)              4.548e-01  3.938e-02  6.100e+00  11.549 2.18e-05 ***
# NB_CTL                   3.007e-06  2.738e-05  1.500e+03   0.110 0.912551    
# Nombre_Perturbations    -4.765e-05  6.315e-05  1.505e+03  -0.755 0.450656    
# Nombre_Infractions      -9.302e-05  4.233e-04  1.496e+03  -0.220 0.826113    
# Nombre_alertes          -3.523e-04  1.314e-03  1.501e+03  -0.268 0.788619    
# JVScolaire1              1.026e-02  4.379e-03  1.502e+03   2.343 0.019269 *  
# JGreve1                 -4.658e-03  1.492e-02  1.508e+03  -0.312 0.755006    
# JFerie1                  1.380e-02  1.146e-02  1.496e+03   1.204 0.228905    
# deux_prem_jour_moisTrue  2.840e-02  7.288e-03  1.501e+03   3.897 0.000101 ***
# moyenne_retard          -1.132e-05  9.481e-06  1.498e+03  -1.194 0.232673    
# Mean_VisibiliteKm       -2.289e-03  1.300e-03  1.502e+03  -1.760 0.078535 . 


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Risk Factors Analysis (RegLog)
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tnv_mod_2 <- glm(taux_de_non_validation ~ controle + Nombre_Perturbations + Nombre_Infractions + Nombre_alertes + JVScolaire + JGreve + JFerie
	                                   + deux_prem_jour_mois + moyenne_retard + Mean_VisibiliteKm 
	                                   + ligne + LIBELLE_MOIS + LIBELLE_JOUR, 
	                                   data=Lyon_FactorAnalysis_BUS)

summary(tnv_mod_2)

dropterm(tnv_mod_2, test='Chisq')
