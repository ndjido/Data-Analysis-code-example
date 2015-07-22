# libs
require('lme4')
require('MASS')
require('epicalc')
require('languageR')
require('lmerTest')

# data loading 
lyon_data_day_t1 <- read.table('Lyon_validation_ctr_pb_meteo_pv_pass_journee_TRAM.csv', sep=';', header=TRUE, encoding = 'latin1')


# type definition

lyon_data_day_t1$JVScolaire <- factor(ifelse(lyon_data_day_t1$JVScolaire==1, "OUI", "NON"))

lyon_data_day_t1$JFerie <- factor(ifelse(lyon_data_day_t1$JFerie==1, "OUI", "NON"))

lyon_data_day_t1$JGreve <- factor(ifelse(lyon_data_day_t1$JGreve==1, "OUI", "NON"))

lyon_data_day_t1$deux_prem_jour_mois <- factor(ifelse(lyon_data_day_t1$deux_prem_jour_mois=="True", "OUI", "NON"))

lyon_data_day_t1$RETARD_ENTREE_SUP_5mn <- factor(ifelse(lyon_data_day_t1$RETARD_ENTREE_SUP_5mn==1, "OUI", "NON"))

lyon_data_day_t1$AVANCE_ENTREE_SUP_5mn <- factor(ifelse(lyon_data_day_t1$AVANCE_ENTREE_SUP_5mn==1, "OUI", "NON"))

lyon_data_day_t1$arret <- factor(lyon_data_day_t1$arret)

levels(lyon_data_day_t1$Condition_Meteo) <- c("Indisponible", "Brouillard", "Brouillard-Pluie", "Brouillard-Pluie-Orage", "Orage", "Pluie", "Pluie-Orage")
lyon_data_day_t1[is.na(lyon_data_day_t1$Condition_Meteo),]$Condition_Meteo = "Indisponible"

# filtering valid TnV

lyon_data_day_t1 = lyon_data_day_t1[ lyon_data_day_t1$taux_de_nonvalidation!=Inf & !is.na(lyon_data_day_t1$taux_de_nonvalidation) & lyon_data_day_t1$taux_de_nonvalidation>=0,]

summary(lyon_data_day_t1$taux_de_nonvalidation)

#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#0.0000  0.1818  0.3333  0.3544  0.5000  0.9870 

ci(lyon_data_day_t1$taux_de_nonvalidation)

# n      mean       sd          se lower95ci upper95ci
# 12739 0.3543706 0.228291 0.002022652 0.3504059 0.3583353


t.test(taux_de_nonvalidation ~ deux_prem_jour_mois, data = lyon_data_day_t1)

Welch Two Sample t-test

data:  taux_de_nonvalidation by deux_prem_jour_mois
t = 4.2034, df = 1464.364, p-value = 2.788e-05
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 0.01487954 0.04091868
sample estimates:
mean in group NON mean in group OUI 
        0.3569549         0.3290558 

png("Boxplot_Taux_DPJM.png", width=650)
plot(taux_de_nonvalidation ~ deux_prem_jour_mois, notch=TRUE, col="lightblue", ylab="Taux de Non-Validations", xlab="Deux 1er jours du mois", data=lyon_data_day_t1)
dev.off()

#----------------------------------------------------------------

t.test(taux_de_nonvalidation ~ JGreve, data = lyon_data_day_t1)

Welch Two Sample t-test

data:  taux_de_nonvalidation by JGreve
t = 0.5962, df = 250.72, p-value = 0.5516
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.01909716  0.03567855
sample estimates:
mean in group NON mean in group OUI 
        0.3545275         0.3462368 

png("Boxplot_Taux_JGreve.png", width=650)
plot(taux_de_nonvalidation ~ JGreve, notch=TRUE, col="lightblue", ylab="Taux de Non-Validations", xlab="Jour de grève", data=lyon_data_day_t1)
dev.off()

#----------------------------------------------------------------

t.test(taux_de_nonvalidation ~ JFerie, data = lyon_data_day_t1)

	Welch Two Sample t-test

data:  taux_de_nonvalidation by JFerie
t = 1.3877, df = 526.533, p-value = 0.1658
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.005932404  0.034480834
sample estimates:
mean in group NON mean in group OUI 
        0.3549152         0.3406410 

png("Boxplot_Taux_JFerie.png", width=650)
plot(taux_de_nonvalidation ~ JFerie, notch=TRUE, col="lightblue", ylab="Taux de Non-Validations", xlab="Jour férié", data=lyon_data_day_t1)
dev.off()

#----------------------------------------------------------------

t.test(taux_de_nonvalidation ~ JVScolaire, data = lyon_data_day_t1)

	Welch Two Sample t-test

data:  taux_de_nonvalidation by JVScolaire
t = -2.2645, df = 9217.675, p-value = 0.02357
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.01785948 -0.00128619
sample estimates:
mean in group NON mean in group OUI 
        0.3510139         0.3605867 

png("Boxplot_Taux_JVScolaire.png", width=650)
plot(taux_de_nonvalidation ~ JVScolaire, notch=TRUE, col="lightblue", ylab="Taux de Non-Validations", xlab="Jour de vacance scolaire", data=lyon_data_day_t1)
dev.off()

#----------------------------------------------------------------

t.test(taux_de_nonvalidation ~ RETARD_ENTREE_SUP_5mn, data = lyon_data_day_t1)

	Welch Two Sample t-test

data:  taux_de_nonvalidation by RETARD_ENTREE_SUP_5mn
t = -0.3578, df = 19.051, p-value = 0.7244
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.14089253  0.09974411
sample estimates:
mean in group NON mean in group OUI 
        0.3538803         0.3744545 

png("Boxplot_Taux_RETARD_ENTREE_SUP_5mn.png", width=650)
plot(taux_de_nonvalidation ~ RETARD_ENTREE_SUP_5mn, notch=TRUE, col="lightblue", ylab="Taux de Non-Validations", xlab="Retard >5mn", data=lyon_data_day_t1)
dev.off()

#----------------------------------------------------------------

t.test(taux_de_nonvalidation ~ AVANCE_ENTREE_SUP_5mn, data = lyon_data_day_t1)

	Welch Two Sample t-test

data:  taux_de_nonvalidation by AVANCE_ENTREE_SUP_5mn
t = -0.5441, df = 1779.654, p-value = 0.5865
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.016364586  0.009257065
sample estimates:
mean in group NON mean in group OUI 
        0.3534982         0.3570520 

png("Boxplot_Taux_AVANCE_ENTREE_SUP_5mn.png", width=650)
plot(taux_de_nonvalidation ~ AVANCE_ENTREE_SUP_5mn, notch=TRUE, col="lightblue", ylab="Taux de Non-Validations", xlab="Avance >5mn", data=lyon_data_day_t1)
dev.off()

#----------------------------------------------------------------

png("Boxplot_Taux_Condition_Meteo.png", width=1024)
plot(taux_de_nonvalidation ~ Condition_Meteo, notch=TRUE, col="lightblue", ylab="Taux de Non-Validations", xlab="Condition Météo", data=lyon_data_day_t1)
dev.off()

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Risk Factors Analysis
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

### Mixed model
tnv_mod_t1_1 <- lmerTest::lmer(taux_de_nonvalidation ~ Nombre_Perturbations + Nombre_Infractions + NB_CTL
	                        + deux_prem_jour_mois + JGreve + Nombre_alertes
                            + JFerie + JVScolaire + Condition_Meteo
                            + RETARD_ENTREE_SUP_5mn + AVANCE_ENTREE_SUP_5mn
	                        + (1|arret) + (1|LIBELLE_MOIS) + (1|LIBELLE_JOUR), 
	                         data=lyon_data_day_t1)

summary(tnv_mod_t1_1)

# Nombre_Infractions                    -1.349e-04  9.824e-05  1.530e+03  -1.374  0.16979    
# NB_CTL                                 3.690e-05  3.201e-05  5.404e+03   1.153  0.24897    
# deux_prem_jour_moisOUI                -1.754e-02  1.085e-02  3.233e+03  -1.617  0.10606    
# JGreveOUI                             -4.511e-02  2.423e-02  3.624e+03  -1.861  0.06278 .  
# Nombre_alertes                        -8.343e-03  1.852e-02  2.631e+03  -0.450  0.65241    
# JFerieOUI                             -4.418e-02  2.551e-02  4.004e+03  -1.732  0.08335 .  
# JVScolaireOUI                          9.616e-03  6.973e-03  3.550e+02   1.379  0.16879    
# Condition_MeteoBrouillard              3.091e-02  1.385e-02  5.450e+02   2.233  0.02598 *  
# Condition_MeteoBrouillard-Pluie       -3.750e-02  1.843e-02  6.190e+02  -2.035  0.04230 *  
# Condition_MeteoBrouillard-Pluie-Orage -2.025e-02  2.364e-02  2.223e+03  -0.857  0.39173    
# Condition_MeteoOrage                   8.066e-02  2.658e-02  1.443e+03   3.035  0.00245 ** 
# Condition_MeteoPluie                   1.357e-02  7.146e-03  4.420e+02   1.899  0.05822 .  
# Condition_MeteoPluie-Orage            -1.301e-02  1.159e-02  2.740e+03  -1.122  0.26191    
# RETARD_ENTREE_SUP_5mnOUI               2.122e-02  6.816e-02  5.407e+03   0.311  0.75556    
# AVANCE_ENTREE_SUP_5mnOUI               8.950e-03  1.005e-02  5.401e+03   0.890  0.37344   

# [1] "date"                           "arret"                          "SEMESTRE"                      
#  [4] "TRIMESTRE"                      "LIBELLE_MOIS"                   "LIBELLE_JOUR"                  
#  [7] "nombre_validations"             "nombre_entrees"                 "difference_entrees_validations"
# [10] "JVScolaire"                     "JFerie"                         "JGreve"                        
# [13] "taux_de_nonvalidation"          "ligne"                          "NB_CTL"                        
# [16] "NB_TITRES_INCORRECTS"           "Nombre_Perturbations"           "Nombre_Infractions"            
# [19] "Nombre_alertes"                 "dateTIME"                       "deux_prem_jour_mois"           
# [22] "Temperature_moyenneC"           "Mean_Humidite"                  "Mean_VisibiliteKm"             
# [25] "Precipitationmm"                "Condition_Meteo"                "DUREE_OUVERTURE_PORTES"        
# [28] "RETARD_ENTREE"                  "RETARD_ENTREE_SUP_5mn"          "RETARD_ENTREE_2mn_5mn"         
# [31] "AVANCE_ENTREE_SUP_5mn"          "AVANCE_ENTREE_2mn_5mn"         

