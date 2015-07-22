# libs
require('lme4')
require('MASS')
require('epicalc')
require('languageR')
require('lmerTest')

# data loading 
lyon_data_day <- read.table('Lyon_validations_cpt_ctr_pb_meteo_pv_pass_BUS.csv', sep=';', header=TRUE, encoding = 'latin1')


# type definition

lyon_data_day$JVScolaire <- factor(ifelse(lyon_data_day$JVScolaire==1, "OUI", "NON"))

lyon_data_day$JFerie <- factor(ifelse(lyon_data_day$JFerie==1, "OUI", "NON"))

lyon_data_day$JGreve <- factor(ifelse(lyon_data_day$JGreve==1, "OUI", "NON"))

lyon_data_day$deux_prem_jour_mois <- factor(ifelse(lyon_data_day$deux_prem_jour_mois=="True", "OUI", "NON"))

# filtering valid TnV


lyon_data_day = lyon_data_day[lyon_data_day$taux_de_non_valitation_cor>=0,]

lyon_data_day$type_trans <- factor(ifelse(lyon_data_day$ligne=="T1", "TRAM", "BUS"))

summary(lyon_data_day$taux_de_non_valitation_cor)

 # Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
 # 0.0467  0.3750  0.4463  0.4432  0.5157  0.9378     180 

ci(lyon_data_day$taux_de_non_valitation_cor)

 #n      mean        sd         se lower95ci upper95ci
 #1661 0.4432162 0.1029122 0.00252512 0.4382635  0.448169

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Bivariate Analysis
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

png("Boxplot_Taux_LIGNE.png", width=650)
plot(taux_de_non_valitation_cor ~ ligne, notch=TRUE, col="lightblue", ylab="Taux de Non-Validations", xlab="Lignes", data=lyon_data_day)
dev.off()

png("Boxplot_Taux_TTRANS.png", width=650)
plot(taux_de_non_valitation_cor ~ type_trans, notch=TRUE, col="lightblue", ylab="Taux de Non-Validations", xlab="Lignes", data=lyon_data_day)
dev.off()

t.test(taux_de_non_valitation_cor ~ type_trans, data = lyon_data_day)

#data:  taux_de_non_valitation_cor by type_trans
#t = 1.4289, df = 8.027, p-value = 0.1908
#alternative hypothesis: true difference in means is not equal to 0
#95 percent confidence interval:
# -0.05337208  0.22754830
#sample estimates:
# mean in group BUS mean in group TRAM 
#         0.4436881          0.3566000 

jour_order <- c('Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche')
lyon_data_day$LIBELLE_JOUR <- ordered(lyon_data_day$LIBELLE_JOUR, levels=jour_order)

png("Boxplot_Taux_LIBELLE_JOUR.png", width=650)
plot(taux_de_non_valitation_cor ~ LIBELLE_JOUR, notch=TRUE, col="lightblue", ylab="Taux de Non-Validations", xlab="Jour de la semaine", data=lyon_data_day)
dev.off()

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Risk Factors Analysis
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
lyon_data_day_bus <- lyon_data_day[lyon_data_day$ligne!="T1",]

tnv_mod_1 <- lmerTest::lmer(taux_de_non_valitation_cor ~ Nombre_Infractions + Nombre_Perturbations + NB_CTL
	                        + deux_prem_jour_mois + JGreve + Nombre_alertes
                            + ligne + JFerie + JVScolaire + Condition_Meteo + moyenne_retard
	                        + (1|LIBELLE_MOIS) + (1|LIBELLE_JOUR), 
	                         data=lyon_data_day)

# summary(tnv_mod_1)

# Nombre_Infractions                     2.473e-05  3.243e-04  1.110e+03   0.076 0.939233    
# Nombre_Perturbations                  -1.047e-04  5.258e-05  1.116e+03  -1.991 0.046771 *  
# NB_CTL                                 2.905e-06  2.115e-05  1.114e+03   0.137 0.890748    
# deux_prem_jour_moisOUI                 2.348e-02  6.481e-03  1.114e+03   3.623 0.000304 ***
# JGreveOUI                              4.402e-03  1.278e-02  1.119e+03   0.345 0.730491    
# Nombre_alertes                         1.182e-04  1.059e-03  1.113e+03   0.112 0.911107    
# ligne52                                2.236e-01  1.396e-02  1.110e+03  16.016  < 2e-16 ***
# ligneC12                               1.226e-01  1.397e-02  1.113e+03   8.775  < 2e-16 ***
# ligneC17                               1.018e-01  1.368e-02  1.111e+03   7.438 2.04e-13 ***
# ligneC26                               5.220e-02  1.373e-02  1.112e+03   3.803 0.000151 ***
# JFerieOUI                              2.172e-02  1.075e-02  1.110e+03   2.020 0.043621 *  
# JVScolaireOUI                         -1.084e-03  3.873e-03  1.119e+03  -0.280 0.779574    
# Condition_MeteoBrouillard             -1.690e-02  7.744e-03  1.117e+03  -2.183 0.029269 *  
# Condition_MeteoBrouillard-Pluie       -1.212e-02  1.104e-02  1.118e+03  -1.098 0.272363    
# Condition_MeteoBrouillard-Pluie-Orage -1.497e-02  1.578e-02  1.113e+03  -0.949 0.343071    
# Condition_MeteoOrage                  -1.244e-02  1.133e-02  1.115e+03  -1.098 0.272447    
# Condition_MeteoPluie                  -3.941e-03  3.903e-03  1.121e+03  -1.010 0.312867    
# Condition_MeteoPluie-Orage            -6.952e-03  5.928e-03  1.116e+03  -1.173 0.241198    


