require('MASS')

validations_data <- read.table('agg_validations_indexes_sorted.csv', sep=';', header=TRUE)

names(validations_data)

validations_data['JNV'] = ifelse(validations_data$JOUR_FERIE==1 | validations_data$JVScolaire==1 , 'yes', 'no')

modelNB <- glm.nb(AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS ~ AGG_VALIDATIONS_DIVERS_PERIODE + factor(AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE) 
+ LIBELLE_JOUR + factor(JOUR_FERIE) + LIBELLE_MOIS + JNV + AGG_VALIDATIONS_DIVERS_TYPE_TRANSPORT , data = validations_data)

summary(modelNB)


"GROUP"                                 
 [4] "AGG_VALIDATIONS_DIVERS_DATE_VALIDATION"
 [5] "AGG_VALIDATIONS_DIVERS_PERIODE"        
 [6] "AGG_VALIDATIONS_DIVERS_LIG_CODE"       
 [7] "AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE" 
 [8] "LISTE_ARRETS_NOM_LIE"                  
 [9] "LISTE_ARRETS_COO_X"                    
[10] "LISTE_ARRETS_COO_Y"                    
[11] "LISTE_ARRETS_COO_Z"                    
[12] "AGG_VALIDATIONS_DIVERS_TYPE_TRANSPORT" 
[13] "AGG_VALIDATIONS_DIVERS_NB_VALIDATIONS" 
[14] "ANNEE"                                 
[15] "LIBELLE_MOIS"                          
[16] "LIBELLE_JOUR"                          
[17] "JOUR_FERIE"                            
[18] "JOUR_OUVRE"                            
[19] "JVScolaire"                            
[20] "JFerie"                                
[21] "JGreve"                                
[22] "sum"                                   
[23] "mean"                                  
[24] "std"                                   
[25] "INDICES_1"                             
[26] "INDICES_2"                             
[27] "DATETIME"                              
[28] "MOVING_SUM"                            
[29] "MOVING_AVG" 

summary(modelNB)



                                      Df     AIC   LRT   P-value(Chi)    
                                                                    
AGG_VALIDATIONS_DIVERS_PERIODE        47 9105595 83637 < 2.2e-16 
AGG_VALIDATIONS_DIVERS_VAL_ARRET_CODE  1 9026754  4703 < 2.2e-16 
LIBELLE_JOUR                           6 9040452 18412 < 2.2e-16 
JOUR_FERIE                             1 9025064  3013 < 2.2e-16 
LIBELLE_MOIS                          11 9033451 11420 < 2.2e-16 






