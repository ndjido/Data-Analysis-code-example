
#libraries

require('lme4')
require('MASS')
require('epicalc')
require('languageR')
require('lmerTest')

#loading data

lyon_tram_rf <- read.table('Keolis_data//Lyon//factorAnalysis//Lyon_TRAM_RiskFactorsAnalysis_fillna_3.csv', sep=';', header=TRUE)

#features transformation

lyon_tram_rf$jferie <- factor(lyon_tram_rf$jferie)

lyon_tram_rf$jgreve <- factor(lyon_tram_rf$jgreve)

lyon_tram_rf$jvscolaire <- factor(lyon_tram_rf$jvscolaire)

lyon_tram_rf$arret <- factor(lyon_tram_rf$arret)

lyon_tram_rf$contrles_en_cours <- factor(lyon_tram_rf$contrles_en_cours)

lyon_tram_rf$libelle_jour <- relevel(lyon_tram_rf$libelle_jour, ref="Lundi")

lyon_tram_rf$libelle_mois <- relevel(lyon_tram_rf$libelle_mois, ref="Janvier")

lyon_tram_rf$deux_prem_jour_mois <- relevel(lyon_tram_rf$deux_prem_jour_mois, ref="Non")

lyon_tram_rf$conditions_meteo <- relevel(lyon_tram_rf$conditions_meteo, ref="Temps d\xe9gag\xe9")

lyon_tram_rf$periode <- relevel(lyon_tram_rf$periode, ref="08:30 - 08:59")

lyon_tram_rf$alerte <- factor(lyon_tram_rf$Nombre_alertes)

lyon_tram_rf[is.na(lyon_tram_rf$alerte),]$alerte = 0

lyon_tram_rf[is.na(lyon_tram_rf$Nombre_Infractions),]$Nombre_Infractions = 0

lyon_tram_rf$temperature_ressentie <- as.numeric(lyon_tram_rf$temperature_ressentie)

# model

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Contrôle Analysis
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

ctr_mod_1 <- glm(contrles_en_cours ~  periode + libelle_mois + libelle_jour + arret + Nombre_Infractions + alerte + 
	                                  jferie + jvscolaire + jgreve + deux_prem_jour_mois + conditions_meteo + temperature_ressentie,  
	                                  data=lyon_tram_rf, family='binomial')
 
summary(ctr_mod_1)

logistic.display(ctr_mod_1)

dropterm(ctr_mod_1, test="Chisq")

#  [1] "date"                         "periode"                     
#  [3] "ligne"                        "arret"                       
#  [5] "nombre_de_validations"        "nombre_d_entres"             
#  [7] "diffrence_entres_validations" "indice_de_validation"        
#  [9] "taux_de_non_validation"       "contrles_en_cours"           
# [11] "contrle"                      "nombre_de_personnes_contrles"
# [13] "nombre_de_titres_incorrects"  "nombre_total_de_pv"          
# [15] "nombre_perturbations"         "moy_nb_suites_infra"         
# [17] "nombre_infractions"           "Nombre_alertes"              
# [19] "nb_passages"                  "retard_entree_moy"           
# [21] "retard_entree_max"            "retard_entree_min"           
# [23] "retard_entree_sup_5mn_nb"     "retard_entree_2mn_5mn_nb"    
# [25] "avance_entree_sup_5mn_nb"     "avance_entree_2mn_5mn_nb"    
# [27] "duree_ouverture_portes_moy"   "duree_ouverture_portes_std"  
# [29] "annee"                        "libelle_mois"                
# [31] "libelle_jour"                 "jour_ferie"                  
# [33] "jour_ouvre"                   "jvscolaire"                  
# [35] "jferie"                       "jgreve"                      
# [37] "deux_prem_jour_mois"          "vitesse_du_vent"             
# [39] "vent"                         "temperatureC"                
# [41] "temperature_ressentie"        "conditions_de_temperature"   
# [43] "conditions_meteo"             "visites_fixe"                
# [45] "navigateurs_fixe"             "visites_mobiles"             
# [47] "navigateurs_mobiles"


Call:
glm(formula = contrles_en_cours ~ periode + libelle_mois + libelle_jour + 
    arret + Nombre_Infractions + alerte + jferie + jvscolaire + 
    jgreve + deux_prem_jour_mois + conditions_meteo + temperature_ressentie, 
    family = "binomial", data = lyon_tram_rf)

# Deviance Residuals: 
#     Min       1Q   Median       3Q      Max  
# -2.0108  -0.4858  -0.3312  -0.2025   3.3335  

# Coefficients: (1 not defined because of singularities)
#                                        Estimate Std. Error z value Pr(>|z|)    
# (Intercept)                           -1.701065   0.300094  -5.668 1.44e-08 ***
# periode00:00 - 00:29                  -9.954213  58.596717  -0.170 0.865107    
# periode05:30 - 05:59                  -0.877423   0.747793  -1.173 0.240655    
# periode06:00 - 06:29                   0.089059   0.227368   0.392 0.695283    
# periode06:30 - 06:59                   0.428584   0.173839   2.465 0.013686 *  
# periode07:00 - 07:29                   0.444260   0.162359   2.736 0.006214 ** 
# periode07:30 - 07:59                   0.257529   0.160026   1.609 0.107553    
# periode08:00 - 08:29                   0.216860   0.154257   1.406 0.159774    
# periode09:00 - 09:29                   0.164348   0.164608   0.998 0.318077    
# periode09:30 - 09:59                   0.142952   0.144237   0.991 0.321642    
# periode10:00 - 10:29                   0.466495   0.142787   3.267 0.001087 ** 
# periode10:30 - 10:59                   0.358783   0.141980   2.527 0.011504 *  
# periode11:00 - 11:29                   0.389440   0.140405   2.774 0.005543 ** 
# periode11:30 - 11:59                   0.432936   0.141694   3.055 0.002247 ** 
# periode12:00 - 12:29                   0.316053   0.139707   2.262 0.023681 *  
# periode12:30 - 12:59                   0.487640   0.136230   3.580 0.000344 ***
# periode13:00 - 13:29                   0.589126   0.136259   4.324 1.54e-05 ***
# periode13:30 - 13:59                   0.142774   0.144572   0.988 0.323365    
# periode14:00 - 14:29                   0.341940   0.137645   2.484 0.012984 *  
# periode14:30 - 14:59                   0.503217   0.134448   3.743 0.000182 ***
# periode15:00 - 15:29                   0.438917   0.133429   3.290 0.001004 ** 
# periode15:30 - 15:59                   0.620036   0.134438   4.612 3.99e-06 ***
# periode16:00 - 16:29                   0.287782   0.141081   2.040 0.041366 *  
# periode16:30 - 16:59                   0.458079   0.142403   3.217 0.001296 ** 
# periode17:00 - 17:29                   0.594728   0.142851   4.163 3.14e-05 ***
# periode17:30 - 17:59                   0.141640   0.149411   0.948 0.343135    
# periode18:00 - 18:29                   0.678166   0.138309   4.903 9.43e-07 ***
# periode18:30 - 18:59                   0.647165   0.138077   4.687 2.77e-06 ***
# periode19:00 - 19:29                   0.611665   0.140745   4.346 1.39e-05 ***
# periode19:30 - 19:59                   0.387460   0.150342   2.577 0.009961 ** 
# periode20:00 - 20:29                   0.145777   0.158374   0.920 0.357333    
# periode20:30 - 20:59                   0.009591   0.200468   0.048 0.961842    
# periode21:00 - 21:29                  -0.247580   0.425212  -0.582 0.560398    
# periode21:30 - 21:59                  -0.414003   0.452874  -0.914 0.360629    
# periode22:00 - 22:29                   0.419219   0.417961   1.003 0.315856    
# periode22:30 - 22:59                  -0.901014   1.052355  -0.856 0.391893    
# periode23:00 - 23:29                  -0.481901   0.427613  -1.127 0.259761    
# periode23:30 - 23:59                  -0.472947   0.381547  -1.240 0.215141    
# libelle_moisAo\xfbt                   -0.135413   0.119015  -1.138 0.255212    
# libelle_moisAvril                      0.123113   0.076463   1.610 0.107374    
# libelle_moisD\xe9cembre               -0.300430   0.113272  -2.652 0.007995 ** 
# libelle_moisF\xe9vrier                -0.074636   0.067160  -1.111 0.266433    
# libelle_moisJuillet                   -0.285575   0.097343  -2.934 0.003350 ** 
# libelle_moisJuin                      -0.126334   0.091950  -1.374 0.169462    
# libelle_moisMai                       -0.158109   0.084829  -1.864 0.062343 .  
# libelle_moisMars                       0.034787   0.070355   0.494 0.620991    
# libelle_moisNovembre                  -0.173402   0.068969  -2.514 0.011930 *  
# libelle_moisOctobre                   -0.104610   0.079900  -1.309 0.190444    
# libelle_moisSeptembre                 -0.019200   0.088356  -0.217 0.827967    
# libelle_jourDimanche                  -0.356725   0.114591  -3.113 0.001852 ** 
# libelle_jourJeudi                      0.077950   0.044198   1.764 0.077791 .  
# libelle_jourMardi                      0.065200   0.045720   1.426 0.153848    
# libelle_jourMercredi                   0.017876   0.045210   0.395 0.692542    
# libelle_jourSamedi                    -0.227654   0.070710  -3.220 0.001284 ** 
# libelle_jourVendredi                   0.098217   0.048119   2.041 0.041238 *  
# arret32103                             1.231958   0.091563  13.455  < 2e-16 ***
# arret32104                            -0.411325   0.111984  -3.673 0.000240 ***
# arret32105                            -1.647651   0.161231 -10.219  < 2e-16 ***
# arret32106                            -0.506836   0.113194  -4.478 7.55e-06 ***
# arret32107                            -1.492206   0.146507 -10.185  < 2e-16 ***
# arret32108                            -0.833652   0.122169  -6.824 8.87e-12 ***
# arret32109                            -1.994776   0.175229 -11.384  < 2e-16 ***
# arret32110                             0.350493   0.096866   3.618 0.000297 ***
# arret32111                            -0.969648   0.124091  -7.814 5.54e-15 ***
# arret32112                            -0.061790   0.103617  -0.596 0.550956    
# arret32113                            -1.321176   0.138991  -9.505  < 2e-16 ***
# arret32114                            -0.699054   0.118155  -5.916 3.29e-09 ***
# arret32115                            -1.609066   0.153567 -10.478  < 2e-16 ***
# arret32116                             0.124911   0.099762   1.252 0.210535    
# arret32117                            -1.224984   0.133424  -9.181  < 2e-16 ***
# arret32118                            -0.010316   0.102395  -0.101 0.919754    
# arret32119                            -1.335625   0.140951  -9.476  < 2e-16 ***
# arret32120                            -0.117837   0.103276  -1.141 0.253873    
# arret32121                             1.141927   0.091732  12.449  < 2e-16 ***
# arret32122                            -0.064702   0.102458  -0.631 0.527715    
# arret32123                            -1.276419   0.136640  -9.341  < 2e-16 ***
# arret32124                            -0.485166   0.112677  -4.306 1.66e-05 ***
# arret32125                            -1.617113   0.155571 -10.395  < 2e-16 ***
# arret32126                             1.359624   0.091810  14.809  < 2e-16 ***
# arret32127                             0.141587   0.099214   1.427 0.153554    
# arret32128                            -1.165975   0.132582  -8.794  < 2e-16 ***
# arret32129                            -2.907970   0.270283 -10.759  < 2e-16 ***
# arret32130                            -0.429714   0.111198  -3.864 0.000111 ***
# arret32131                            -2.127360   0.202558 -10.502  < 2e-16 ***
# arret32132                            -0.692819   0.122850  -5.640 1.70e-08 ***
# arret32133                            -2.333113   0.219443 -10.632  < 2e-16 ***
# arret32134                            -0.551099   0.112781  -4.886 1.03e-06 ***
# arret32135                            -2.005736   0.209201  -9.588  < 2e-16 ***
# arret32136                            -1.167817   0.138955  -8.404  < 2e-16 ***
# arret32137                            -3.384855   0.362687  -9.333  < 2e-16 ***
# arret32138                            -1.770833   0.394132  -4.493 7.02e-06 ***
# arret32139                            -2.626883   0.249094 -10.546  < 2e-16 ***
# arret34067                            -0.986376   0.356081  -2.770 0.005604 ** 
# arret34068                            -3.206459   0.326403  -9.824  < 2e-16 ***
# arret34834                            -0.837962   0.122154  -6.860 6.89e-12 ***
# arret34835                            -2.072163   0.178688 -11.597  < 2e-16 ***
# arret34836                            -1.072799   0.131853  -8.136 4.07e-16 ***
# arret34837                            -1.759197   0.157441 -11.174  < 2e-16 ***
# arret34874                            -0.931290   0.126571  -7.358 1.87e-13 ***
# arret34875                             0.069150   0.103210   0.670 0.502863    
# arret35094                            -0.829451   0.128689  -6.445 1.15e-10 ***
# arret46154                            -2.012729   0.194470 -10.350  < 2e-16 ***
# arret46155                            -1.423108   0.160812  -8.850  < 2e-16 ***
# arret46156                            -3.239112   0.326353  -9.925  < 2e-16 ***
# arret46157                            -2.253898   0.215803 -10.444  < 2e-16 ***
# arret46158                            -3.254878   0.326315  -9.975  < 2e-16 ***
# arret46159                            -0.627187   0.125806  -4.985 6.18e-07 ***
# arret46160                            -2.766234   0.716751  -3.859 0.000114 ***
# Nombre_Infractions                     0.064219   0.003746  17.141  < 2e-16 ***
# alerte1                               -0.317962   0.307540  -1.034 0.301188    
# jferie1                               -0.630636   0.196569  -3.208 0.001336 ** 
# jvscolaire1                           -0.020174   0.034238  -0.589 0.555708    
# jgreve1                               -0.013217   0.145406  -0.091 0.927573    
# deux_prem_jour_moisOui                 0.115508   0.062267   1.855 0.063592 .  
# conditions_meteoBrouillard            -0.118272   0.115975  -1.020 0.307821    
# conditions_meteoNon renseign\xe9      -0.413014   0.291334  -1.418 0.156289    
# conditions_meteoNuageux                0.052780   0.048087   1.098 0.272379    
# conditions_meteoPluie                 -0.041280   0.118051  -0.350 0.726579    
# conditions_meteoPluie l\xe9g\xe8re     0.060889   0.058672   1.038 0.299372    
# temperature_ressentie-2               -0.550370   0.685690  -0.803 0.422176    
# temperature_ressentie-5                0.570872   0.498310   1.146 0.251954    
# temperature_ressentie0                 0.198043   0.335031   0.591 0.554440    
# temperature_ressentie1                -0.658251   0.459026  -1.434 0.151567    
# temperature_ressentie10               -0.422976   0.257964  -1.640 0.101074    
# temperature_ressentie11               -0.673998   0.279294  -2.413 0.015812 *  
# temperature_ressentie13               -0.562777   0.267692  -2.102 0.035525 *  
# temperature_ressentie15               -0.446166   0.261782  -1.704 0.088317 .  
# temperature_ressentie16               -0.507706   0.268833  -1.889 0.058951 .  
# temperature_ressentie17               -0.536300   0.268313  -1.999 0.045631 *  
# temperature_ressentie18               -0.563725   0.268815  -2.097 0.035987 *  
# temperature_ressentie19               -0.500010   0.270656  -1.847 0.064689 .  
# temperature_ressentie2                -0.280005   0.256144  -1.093 0.274327    
# temperature_ressentie20               -0.414240   0.269352  -1.538 0.124070    
# temperature_ressentie21               -0.580382   0.272316  -2.131 0.033066 *  
# temperature_ressentie22               -0.554210   0.269603  -2.056 0.039816 *  
# temperature_ressentie23               -0.468268   0.272817  -1.716 0.086086 .  
# temperature_ressentie24               -0.603287   0.276097  -2.185 0.028885 *  
# temperature_ressentie25               -0.580530   0.282750  -2.053 0.040057 *  
# temperature_ressentie26               -0.620820   0.280766  -2.211 0.027024 *  
# temperature_ressentie27               -0.496646   0.283459  -1.752 0.079758 .  
# temperature_ressentie28               -0.636383   0.286538  -2.221 0.026355 *  
# temperature_ressentie29               -0.181205   0.294789  -0.615 0.538757    
# temperature_ressentie3                -0.529448   0.293470  -1.804 0.071216 .  
# temperature_ressentie30               -0.700444   0.309843  -2.261 0.023781 *  
# temperature_ressentie31               -0.325434   0.332701  -0.978 0.327995    
# temperature_ressentie32               -0.972323   0.547354  -1.776 0.075666 .  
# temperature_ressentie33               -0.536505   0.369370  -1.452 0.146367    
# temperature_ressentie34               -1.099875   0.469453  -2.343 0.019135 *  
# temperature_ressentie35                0.415159   0.570958   0.727 0.467148    
# temperature_ressentie5                -0.373252   0.262695  -1.421 0.155359    
# temperature_ressentie6                -0.542501   0.304320  -1.783 0.074641 .  
# temperature_ressentie7                -0.201525   0.291192  -0.692 0.488895    
# temperature_ressentie8                -0.369058   0.259604  -1.422 0.155137    
# temperature_ressentie9                -0.473881   0.272690  -1.738 0.082245 .  
# temperature_ressentieNon renseign\xe9        NA         NA      NA       NA    
# ---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 45374  on 67964  degrees of freedom
Residual deviance: 38419  on 67811  degrees of freedom
  (436297 observations deleted due to missingness)
AIC: 38727

Number of Fisher Scoring iterations: 11

> 
> logistic.display(ctr_mod_1)
 
#                                             OR    lower95ci    upper95ci     Pr(>|Z|)
# periode00:00 - 00:29               0.000047527 6.299770e-55 3.585552e+45 8.651072e-01
# periode05:30 - 05:59               0.415853005 9.603227e-02 1.800788e+00 2.406553e-01
# periode06:00 - 06:29               1.093145192 7.000712e-01 1.706921e+00 6.952826e-01
# periode06:30 - 06:59               1.535081631 1.091841e+00 2.158258e+00 1.368580e-02
# periode07:00 - 07:29               1.559335610 1.134329e+00 2.143582e+00 6.213931e-03
# periode07:30 - 07:59               1.293729067 9.454288e-01 1.770345e+00 1.075526e-01
# periode08:00 - 08:29               1.242169636 9.180729e-01 1.680678e+00 1.597735e-01
# periode09:00 - 09:29               1.178624439 8.536120e-01 1.627385e+00 3.180767e-01
# periode09:30 - 09:59               1.153673880 8.695778e-01 1.530586e+00 3.216421e-01
# periode10:00 - 10:29               1.594396075 1.205190e+00 2.109293e+00 1.086689e-03
# periode10:30 - 10:59               1.431586802 1.083837e+00 1.890912e+00 1.150424e-02
# periode11:00 - 11:29               1.476153365 1.121033e+00 1.943769e+00 5.542531e-03
# periode11:30 - 11:59               1.541777587 1.167916e+00 2.035316e+00 2.247365e-03
# periode12:00 - 12:29               1.371703032 1.043138e+00 1.803759e+00 2.368122e-02
# periode12:30 - 12:59               1.628468102 1.246866e+00 2.126860e+00 3.442241e-04
# periode13:00 - 13:29               1.802412491 1.379971e+00 2.354173e+00 1.535284e-05
# periode13:30 - 13:59               1.153469223 8.688532e-01 1.531319e+00 3.233650e-01
# periode14:00 - 14:29               1.407675248 1.074828e+00 1.843596e+00 1.298359e-02
# periode14:30 - 14:59               1.654033274 1.270873e+00 2.152714e+00 1.819488e-04
# periode15:00 - 15:29               1.551027011 1.194110e+00 2.014626e+00 1.003600e-03
# periode15:30 - 15:59               1.858995021 1.428382e+00 2.419425e+00 3.987088e-06
# periode16:00 - 16:29               1.333466946 1.011333e+00 1.758208e+00 4.136605e-02
# periode16:30 - 16:59               1.581034205 1.195991e+00 2.090041e+00 1.296352e-03
# periode17:00 - 17:29               1.812537137 1.369910e+00 2.398180e+00 3.137159e-05
# periode17:30 - 17:59               1.152162260 8.596754e-01 1.544162e+00 3.431346e-01
# periode18:00 - 18:29               1.970260635 1.502431e+00 2.583764e+00 9.426251e-07
# periode18:30 - 18:59               1.910117435 1.457232e+00 2.503754e+00 2.772681e-06
# periode19:00 - 19:29               1.843498157 1.399073e+00 2.429098e+00 1.386981e-05
# periode19:30 - 19:59               1.473233997 1.097237e+00 1.978076e+00 9.960612e-03
# periode20:00 - 20:29               1.156937949 8.482072e-01 1.578041e+00 3.573326e-01
# periode20:30 - 20:59               1.009636853 6.815956e-01 1.495559e+00 9.618424e-01
# periode21:00 - 21:29               0.780687654 3.392626e-01 1.796464e+00 5.603978e-01
# periode21:30 - 21:59               0.660999282 2.720907e-01 1.605788e+00 3.606293e-01
# periode22:00 - 22:29               1.520772977 6.703408e-01 3.450111e+00 3.158559e-01
# periode22:30 - 22:59               0.406157552 5.163314e-02 3.194924e+00 3.918935e-01
# periode23:00 - 23:29               0.617608342 2.671335e-01 1.427900e+00 2.597612e-01
# periode23:30 - 23:59               0.623162843 2.950043e-01 1.316360e+00 2.151407e-01
# libelle_moisAo\xfbt                0.873355273 6.916484e-01 1.102799e+00 2.552117e-01
# libelle_moisAvril                  1.131012278 9.736037e-01 1.313870e+00 1.073744e-01
# libelle_moisD\xe9cembre            0.740500061 5.930723e-01 9.245759e-01 7.995026e-03
# libelle_moisF\xe9vrier             0.928081435 8.136160e-01 1.058651e+00 2.664326e-01
# libelle_moisJuillet                0.751581663 6.210371e-01 9.095673e-01 3.349506e-03
# libelle_moisJuin                   0.881320580 7.359792e-01 1.055364e+00 1.694623e-01
# libelle_moisMai                    0.853756846 7.229818e-01 1.008187e+00 6.234308e-02
# libelle_moisMars                   1.035398783 9.020314e-01 1.188485e+00 6.209905e-01
# libelle_moisNovembre               0.840799314 7.344896e-01 9.624963e-01 1.193037e-02
# libelle_moisOctobre                0.900675338 7.701180e-01 1.053366e+00 1.904439e-01
# libelle_moisSeptembre              0.980982666 8.249982e-01 1.166460e+00 8.279672e-01
# libelle_jourDimanche               0.699964642 5.591594e-01 8.762268e-01 1.851841e-03
# libelle_jourJeudi                  1.081068214 9.913609e-01 1.178893e+00 7.779083e-02
# libelle_jourMardi                  1.067372348 9.758859e-01 1.167435e+00 1.538482e-01
# libelle_jourMercredi               1.018037160 9.317099e-01 1.112363e+00 6.925421e-01
# libelle_jourSamedi                 0.796399605 6.933338e-01 9.147864e-01 1.283983e-03
# libelle_jourVendredi               1.103202405 1.003913e+00 1.212311e+00 4.123787e-02
# arret32103                         3.427934165 2.864800e+00 4.101764e+00 2.884577e-41
# arret32104                         0.662771722 5.321605e-01 8.254395e-01 2.396698e-04
# arret32105                         0.192501579 1.403440e-01 2.640430e-01 1.627166e-24
# arret32106                         0.602398715 4.825402e-01 7.520289e-01 7.548551e-06
# arret32107                         0.224876089 1.687470e-01 2.996750e-01 2.308947e-24
# arret32108                         0.434459564 3.419471e-01 5.520010e-01 8.868745e-12
# arret32109                         0.136044120 9.649943e-02 1.917939e-01 5.033623e-30
# arret32110                         1.419766858 1.174261e+00 1.716601e+00 2.965119e-04
# arret32111                         0.379216335 2.973449e-01 4.836303e-01 5.539754e-15
# arret32112                         0.940080529 7.673018e-01 1.151765e+00 5.509556e-01
# arret32113                         0.266821290 2.031940e-01 3.503725e-01 1.991533e-21
# arret32114                         0.497055197 3.943040e-01 6.265822e-01 3.289965e-09
# arret32115                         0.200074309 1.480728e-01 2.703382e-01 1.090533e-25
# arret32116                         1.133047775 9.318176e-01 1.377734e+00 2.105351e-01
# arret32117                         0.293762539 2.261654e-01 3.815634e-01 4.264464e-20
# arret32118                         0.989737384 8.097695e-01 1.209702e+00 9.197538e-01
# arret32119                         0.262993808 1.995113e-01 3.466758e-01 2.647502e-21
# arret32120                         0.888841080 7.259649e-01 1.088260e+00 2.538732e-01
# arret32121                         3.132800481 2.617282e+00 3.749860e+00 1.424285e-35
# arret32122                         0.937346515 7.668095e-01 1.145811e+00 5.277148e-01
# arret32123                         0.279034747 2.134766e-01 3.647256e-01 9.498440e-21
# arret32124                         0.615595100 4.936109e-01 7.677248e-01 1.663613e-05
# arret32125                         0.198470875 1.463102e-01 2.692273e-01 2.621313e-25
# arret32126                         3.894730100 3.253336e+00 4.662575e+00 1.278013e-49
# arret32127                         1.152101000 9.485045e-01 1.399400e+00 1.535545e-01
# arret32128                         0.311618784 2.403085e-01 4.040900e-01 1.438996e-18
# arret32129                         0.054586426 3.213802e-02 9.271503e-02 5.376544e-27
# arret32130                         0.650694927 5.232692e-01 8.091512e-01 1.113658e-04
# arret32131                         0.119151402 8.010909e-02 1.772215e-01 8.412772e-26
# arret32132                         0.500164111 3.931357e-01 6.363302e-01 1.704876e-08
# arret32133                         0.096993343 6.308871e-02 1.491187e-01 2.115851e-26
# arret32134                         0.576316293 4.620207e-01 7.188866e-01 1.026738e-06
# arret32135                         0.134561210 8.929919e-02 2.027647e-01 9.016234e-22
# arret32136                         0.311045194 2.368889e-01 4.084156e-01 4.305032e-17
# arret32137                         0.033882559 1.664396e-02 6.897565e-02 1.031868e-20
# arret32138                         0.170191212 7.860526e-02 3.684874e-01 7.022761e-06
# arret32139                         0.072303455 4.437410e-02 1.178117e-01 5.315578e-26
# arret34067                         0.372925703 1.855776e-01 7.494093e-01 5.604107e-03
# arret34068                         0.040499789 2.136083e-02 7.678696e-02 8.908573e-23
# arret34834                         0.432591207 3.404865e-01 5.496111e-01 6.892196e-12
# arret34835                         0.125913160 8.870973e-02 1.787191e-01 4.292129e-31
# arret34836                         0.342049735 2.641532e-01 4.429173e-01 4.074300e-16
# arret34837                         0.172183069 1.264669e-01 2.344251e-01 5.483601e-29
# arret34874                         0.394045017 3.074737e-01 5.049910e-01 1.869379e-13
# arret34875                         1.071596793 8.753444e-01 1.311849e+00 5.028626e-01
# arret35094                         0.436288589 3.390262e-01 5.614543e-01 1.153119e-10
# arret46154                         0.133623473 9.127449e-02 1.956213e-01 4.193251e-25
# arret46155                         0.240963830 1.758202e-01 3.302439e-01 8.787786e-19
# arret46156                         0.039198705 2.067663e-02 7.431280e-02 3.234928e-23
# arret46157                         0.104989161 6.877851e-02 1.602641e-01 1.556829e-25
# arret46158                         0.038585522 2.035471e-02 7.314487e-02 1.967690e-23
# arret46159                         0.534092209 4.173784e-01 6.834433e-01 6.184992e-07
# arret46160                         0.062898410 1.543619e-02 2.562944e-01 1.136619e-04
# Nombre_Infractions                 1.066326396 1.058525e+00 1.074185e+00 7.308720e-66
# alerte1                            0.727630306 3.982287e-01 1.329502e+00 3.011877e-01
# jferie1                            0.532253131 3.620748e-01 7.824168e-01 1.335616e-03
# jvscolaire1                        0.980027865 9.164201e-01 1.048051e+00 5.557082e-01
# jgreve1                            0.986869647 7.421465e-01 1.312290e+00 9.275727e-01
# deux_prem_jour_moisOui             1.122443622 9.934875e-01 1.268138e+00 6.359162e-02
# conditions_meteoBrouillard         0.888454415 7.078106e-01 1.115201e+00 3.078206e-01
# conditions_meteoNon renseign\xe9   0.661652766 3.738057e-01 1.171155e+00 1.562887e-01
# conditions_meteoNuageux            1.054198093 9.593795e-01 1.158388e+00 2.723793e-01
# conditions_meteoPluie              0.959560404 7.613553e-01 1.209365e+00 7.265786e-01
# conditions_meteoPluie l\xe9g\xe8re 1.062780743 9.473314e-01 1.192300e+00 2.993716e-01
# temperature_ressentie-2            0.576736178 1.504239e-01 2.211248e+00 4.221759e-01
# temperature_ressentie-5            1.769810461 6.664448e-01 4.699908e+00 2.519540e-01
# temperature_ressentie0             1.219015353 6.321647e-01 2.350651e+00 5.544403e-01
# temperature_ressentie1             0.517755971 2.105725e-01 1.273059e+00 1.515670e-01
# temperature_ressentie10            0.655094090 3.951155e-01 1.086134e+00 1.010738e-01
# temperature_ressentie11            0.509666991 2.948157e-01 8.810942e-01 1.581245e-02
# temperature_ressentie13            0.569625068 3.370769e-01 9.626074e-01 3.552461e-02
# temperature_ressentie15            0.640077197 3.831804e-01 1.069206e+00 8.831671e-02
# temperature_ressentie16            0.601874621 3.553656e-01 1.019381e+00 5.895095e-02
# temperature_ressentie17            0.584908177 3.457000e-01 9.896371e-01 4.563129e-02
# temperature_ressentie18            0.569084985 3.360168e-01 9.638140e-01 3.598713e-02
# temperature_ressentie19            0.606524724 3.568338e-01 1.030934e+00 6.468889e-02
# temperature_ressentie2             0.755780186 4.574726e-01 1.248608e+00 2.743270e-01
# temperature_ressentie20            0.660842346 3.897851e-01 1.120393e+00 1.240695e-01
# temperature_ressentie21            0.559684574 3.282067e-01 9.544194e-01 3.306610e-02
# temperature_ressentie22            0.574526163 3.387061e-01 9.745333e-01 3.981650e-02
# temperature_ressentie23            0.626085965 3.667848e-01 1.068702e+00 8.608639e-02
# temperature_ressentie24            0.547010477 3.184061e-01 9.397448e-01 2.888482e-02
# temperature_ressentie25            0.559601881 3.215157e-01 9.739937e-01 4.005731e-02
# temperature_ressentie26            0.537503627 3.100224e-01 9.319009e-01 2.702438e-02
# temperature_ressentie27            0.608568497 3.491634e-01 1.060694e+00 7.975832e-02
# temperature_ressentie28            0.529203242 3.018012e-01 9.279489e-01 2.635524e-02
# temperature_ressentie29            0.834264609 4.681438e-01 1.486717e+00 5.387571e-01
# temperature_ressentie3             0.588930012 3.313309e-01 1.046804e+00 7.121593e-02
# temperature_ressentie30            0.496364743 2.704345e-01 9.110448e-01 2.378138e-02
# temperature_ressentie31            0.722213607 3.762447e-01 1.386312e+00 3.279953e-01
# temperature_ressentie32            0.378203387 1.293649e-01 1.105692e+00 7.566611e-02
# temperature_ressentie33            0.584788457 2.835242e-01 1.206167e+00 1.463667e-01
# temperature_ressentie34            0.332912844 1.326573e-01 8.354680e-01 1.913531e-02
# temperature_ressentie35            1.514611797 4.946533e-01 4.637690e+00 4.671480e-01
# temperature_ressentie5             0.688491483 4.114260e-01 1.152140e+00 1.553588e-01
# temperature_ressentie6             0.581292476 3.201524e-01 1.055438e+00 7.464083e-02
# temperature_ressentie7             0.817483465 4.619724e-01 1.446578e+00 4.888945e-01
# temperature_ressentie8             0.691385492 4.156667e-01 1.149993e+00 1.551366e-01
# temperature_ressentie9             0.622581086 3.648228e-01 1.062453e+00 8.224533e-02
# > 
# > 
# > 
> dropterm(ctr_mod_1, test="Chisq")
Single term deletions

Model:
contrles_en_cours ~ periode + libelle_mois + libelle_jour + arret + 
    Nombre_Infractions + alerte + jferie + jvscolaire + jgreve + 
    deux_prem_jour_mois + conditions_meteo + temperature_ressentie
                      Df Deviance   AIC    LRT   Pr(Chi)    
<none>                      38419 38727                     
periode               37    38598 38832  179.3 < 2.2e-16 ***
libelle_mois          11    38477 38763   58.9 1.489e-08 ***
libelle_jour           6    38457 38753   38.9 7.592e-07 ***
arret                 53    44674 44876 6255.1 < 2.2e-16 ***
Nombre_Infractions     1    38697 39003  278.0 < 2.2e-16 ***
alerte                 1    38420 38726    1.1 0.2841953    
jferie                 1    38431 38737   11.9 0.0005575 ***
jvscolaire             1    38419 38725    0.3 0.5554838    
jgreve                 1    38419 38725    0.0 0.9275006    
deux_prem_jour_mois    1    38422 38728    3.4 0.0656246 .  
conditions_meteo       4    38422 38722    3.4 0.4869450    
temperature_ressentie 35    38473 38711   54.6 0.0183240 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
> 

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Risk Factors Analysis
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tnv_mod_1 <- lmer(taux_de_non_validation ~  contrles_en_cours + periode + libelle_mois + libelle_jour + arret + alerte 
	                                  + Nombre_Infractions + jferie + jvscolaire + jgreve + deux_prem_jour_mois + conditions_meteo
	                                  + retard_entree_moy + retard_entree_sup_5mn_nb + retard_entree_2mn_5mn_nb
	                                  + duree_ouverture_portes_moy + avance_entree_sup_5mn_nb + avance_entree_2mn_5mn_nb + nb_passages
	                                  + (1|periode) + (1|libelle_mois) + (1|arret) + (1|libelle_jour), 
	                                  data=lyon_tram_rf)

tnv_mod_1 <- lmer(taux_de_non_validation ~  contrles_en_cours + alerte 
	                                  + Nombre_Infractions + jferie + jvscolaire + jgreve + deux_prem_jour_mois + conditions_meteo
	                                  + retard_entree_moy 
	                                  + (1|periode) + (1|libelle_mois) + (1|arret) + (1|libelle_jour), 
	                                  data=lyon_tram_rf)

print(tnv_mod_1, corr = FALSE)


tnv_mod_2 <- lmerTest::lmer(taux_de_non_validation ~  contrles_en_cours + alerte 
	                                  + Nombre_Infractions + jferie + jvscolaire + jgreve + deux_prem_jour_mois + conditions_meteo
	                                  + retard_entree_moy + retard_entree_sup_5mn_nb + retard_entree_2mn_5mn_nb
	                                  + duree_ouverture_portes_moy + avance_entree_sup_5mn_nb + avance_entree_2mn_5mn_nb + nb_passages
	                                  + (1|periode) + (1|libelle_mois) + (1|arret) + (1|libelle_jour), 
	                                  data=lyon_tram_rf)

print(tnv_mod_2, corr = FALSE)
summary(tnv_mod_2)



tnv_mod_3 <- glm(taux_de_non_validation ~  contrles_en_cours + alerte 
	                                  + Nombre_Infractions + jferie + jvscolaire + jgreve + deux_prem_jour_mois + conditions_meteo
	                                  + retard_entree_moy + retard_entree_sup_5mn_nb + retard_entree_2mn_5mn_nb
	                                  + duree_ouverture_portes_moy + avance_entree_sup_5mn_nb + avance_entree_2mn_5mn_nb + nb_passages
	                                  + periode + libelle_mois + arret + libelle_jour, 
	                                  data=lyon_tram_rf)



tnv_mod_4 <- lmerTest::lmer(taux_de_non_validation ~  contrles_en_cours + alerte 
	                                  + Nombre_Infractions + jferie + jvscolaire + jgreve + deux_prem_jour_mois + conditions_meteo
	                                  + retard_entree_moy + retard_entree_sup_5mn_nb + retard_entree_2mn_5mn_nb + 
	                                  + duree_ouverture_portes_moy + avance_entree_sup_5mn_nb + avance_entree_2mn_5mn_nb + nb_passages
	                                  + (1|periode) + (1|libelle_mois) + (1|arret) + (1|libelle_jour), 
	                                  data=lyon_tram_rf)


tnv_mod_6 <- lmerTest::lmer(indice_de_validation ~  contrles_en_cours + alerte 
	                                  + Nombre_Infractions + jferie + jvscolaire + jgreve + deux_prem_jour_mois + conditions_meteo
	                                  + retard_entree_moy + retard_entree_sup_5mn_nb + retard_entree_2mn_5mn_nb + 
	                                  + duree_ouverture_portes_moy + avance_entree_sup_5mn_nb + avance_entree_2mn_5mn_nb + nb_passages
	                                  + (1|periode) + (1|libelle_mois) + (1|arret) + (1|libelle_jour), 
	                                  data=lyon_tram_rf)

lmerTest::summary(tnv_mod_6)



tnv_mod_6 <- lmerTest::lmer(taux_de_non_validation ~  
	                                  + jferie + jvscolaire + jgreve + deux_prem_jour_mois + conditions_meteo +
	                                  (1 + Nombre_Infractions|periode) + (1 + contrles_en_cours|libelle_mois) + (1 + alerte|arret) + (1 + alerte|libelle_jour) +
	                                  (1 + retard_entree_moy|periode) + (1 + retard_entree_sup_5mn_nb|libelle_mois) + (1 + retard_entree_2mn_5mn_nb|arret) + (1 + alerte|libelle_jour) +
	                                  (1 + duree_ouverture_portes_moy|periode) + (1 + avance_entree_sup_5mn_nb|libelle_mois) + (1 + avance_entree_2mn_5mn_nb|arret) + (1 + alerte|libelle_jour) +
	                                  + (1|periode) + (1|libelle_mois) + (1|arret) + (1|libelle_jour), 
	                                  data=lyon_tram_rf)


mcmc_sample_tnv_mod_1 <- mcmcsamp(priming.lmer2, n = 50000)
densityplot(mcmc_sample_tnv_mod_1, plot.points = FALSE)

mcmc_tnv_mod_1 <- pvals.fnc(tnv_mod_1, nsim = 10000)
mcmc_tnv_mod_1$fixed
mcmc_tnv_mod_1$random


tnv_mod_1 <- lmer(taux_de_non_validation ~  contrles_en_cours + periode + libelle_mois + libelle_jour + arret + alerte  
	                                  + Nombre_Infractions + jour_ferie + jvscolaire + jgreve + deux_prem_jour_mois + conditions_meteo
	                                  + retard_entree_moy + retard_entree_moy + retard_entree_sup_5mn_nb + retard_entree_2mn_5mn_nb
	                                  + duree_ouverture_portes_moy + avance_entree_sup_5mn_nb + avance_entree_2mn_5mn_nb # fix effects
	                                  + (nb_passages|arret) + (1|periode) + (1|libelle_mois) + (1|arret) + (1|libelle_jour), # random effects
	                                  data=lyon_tram_rf)


iv_mod_1 <- lmer(indice_de_validation ~  contrles_en_cours + periode + libelle_mois + libelle_jour + arret + alerte + Nombre_alertes 
	                                  + Nombre_Infractions + jour_ferie + jvscolaire + jgreve + deux_prem_jour_mois + conditions_meteo
	                                  + retard_entree_moy + retard_entree_moy + retard_entree_sup_5mn_nb + retard_entree_2mn_5mn_nb
	                                  + duree_ouverture_portes_moy + avance_entree_sup_5mn_nb + avance_entree_2mn_5mn_nb
	                                  + visites_mobiles + visites_fixe # fix effects
	                                  + (nb_passages|arret) + (1|periode) + (1|libelle_mois) + (1|arret) + (1|libelle_jour), # random effects
	                                  data=lyon_tram_rf_2)



tnv_mod_7 <- lmerTest::lmer(taux_de_non_validation ~  (1 + contrles_en_cours|arret) + (1 + contrles_en_cours|periode), # random effects
	                                  data=lyon_tram_rf)
