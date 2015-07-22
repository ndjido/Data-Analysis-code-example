lyon_validation_t1_rf <- read.table('Lyon_validations_cal_meteo_t1.csv', sep=';', header=TRUE)


lyon_validation_t1_rf$JVScolaire <- factor(lyon_validation_t1_rf$JVScolaire)
lyon_validation_t1_rf$JFerie <- factor(lyon_validation_t1_rf$JFerie)
lyon_validation_t1_rf$JGreve <- factor(lyon_validation_t1_rf$JGreve)
lyon_validation_t1_rf$arret <- factor(lyon_validation_t1_rf$arret)
lyon_validation_t1_rf$SEMESTRE <- factor(lyon_validation_t1_rf$SEMESTRE)
lyon_validation_t1_rf$TRIMESTRE <- factor(lyon_validation_t1_rf$TRIMESTRE)
lyon_validation_t1_rf$controle <- factor(lyon_validation_t1_rf$nombre_de_controles>0)
lyon_validation_t1_rf$jour_num <- factor(substr(lyon_validation_t1_rf$date,1,2))

lyon_validation_t1_rf[lyon_validation_t1_rf$taux_de_nonvalidation<0,]$taux_de_nonvalidation= NA

lyon_validation_t1_rf <-lyon_validation_t1_rf[!is.na(lyon_validation_t1_rf$taux_de_nonvalidation),]

levels(lyon_validation_t1_rf$meteo) =  c("non_renseigne", "brouillard", "non_renseigne", "nuageux", "pluie", "pluie_legere", "temps_degrade")

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  RF 
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
require('randomForest')

N <- dim(lyon_validation_t1_rf)[1]

train_size <- ceiling(N*.7)

lyon_validation_t1_rf <- lyon_validation_t1_rf[sample(N), ]
df_train <- lyon_validation_t1_rf[1:train_size, ] 
df_test <- lyon_validation_t1_rf[(train_size+1):N, ]  

rf_mod1 <- randomForest(taux_de_nonvalidation ~ 1 + periode + arret + controle + SEMESTRE 
	      + TRIMESTRE + LIBELLE_MOIS + LIBELLE_JOUR + jour_num + JVScolaire + JFerie + JGreve + meteo, 
	      importance=TRUE, 
	      data=df_train, ntree=100)

# for filtering nights
night <- c("00:00 - 00:29", "00:30 - 00:59", "01:00 - 01:29", "01:30 - 01:59",
"02:00 - 02:29", "02:30 - 02:59", "03:00 - 03:29","03:30 - 03:59",
"04:00 - 04:29", "04:30 - 04:59")


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
