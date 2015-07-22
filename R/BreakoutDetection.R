library(AnomalyDetection)

#data loading

validations_alsace <- read.table('DATASET_data/Lyon/Validations_Lyon_ALSACE_FULL.csv', sep=',', header=TRUE)

# Alsace 52
validations_alsace_52 <- validations_alsace[which(validations_alsace$DATASET.agg_validations_indices.agg_validations_divers_val_arret_code==52 & validations_alsace$DATASET.agg_validations_indices.annee==2014),] # & validations_alsace$DATASET.agg_validations_indices.libelle_jour=='Dimanche'),]

count <- validations_alsace_52$DATASET.agg_validations_indices.agg_validations_divers_nb_validations
timestamp <- validations_alsace_52$date_tranche_hor

Alsace_52 <- data.frame(substr(timestamp,1,19), count)#(count-mean(count))/sqrt(var(count)))

res_52 = AnomalyDetectionTs(Alsace_52, max_anoms=10.0, direction='both', plot=TRUE, alpha=.05, ylabel ="Nombre de Validations")
res_52


res_52_bis = AnomalyDetectionVec(Alsace_52$count, max_anoms=0.1, direction='both', plot=TRUE, period=48)
res_52_bis$plot

# Alsace 53
validations_alsace_53 <- validations_alsace[which(validations_alsace$DATASET.agg_validations_indices.agg_validations_divers_val_arret_code==53 & validations_alsace$DATASET.agg_validations_indices.annee==2014),]

count2 <- validations_alsace_53$DATASET.agg_validations_indices.agg_validations_divers_nb_validations
timestamp2 <- validations_alsace_53$date_tranche_hor

Alsace_53 <- data.frame(substr(timestamp2,1,19), count2) #(count2-mean(count2))/sqrt(var(count2)))

res_53 = AnomalyDetectionTs(Alsace_53, max_anoms=0.3, direction='both', plot=TRUE, alpha=.025, ylabel ="Nombre de Validations")
res_53


#=======================================
validations_alsace_52 <- validations_alsace[which(validations_alsace$DATASET.agg_validations_indices.agg_validations_divers_val_arret_code==52 & validations_alsace$DATASET.agg_validations_indices.annee==2014),] #& validations_alsace$DATASET.agg_validations_indices.libelle_jour=='Dimanche'),]

count <- validations_alsace_52$DATASET.agg_validations_indices.agg_validations_divers_nb_validations
count_2 <- diff(log(count))
timestamp_2 <- validations_alsace_52$date_tranche_hor[-1]

Alsace_52_ <- data.frame(substr(timestamp_2,1,19), count_2)#(count-mean(count))/sqrt(var(count)))

res_52_ = AnomalyDetectionTs(Alsace_52_, max_anoms=0.3, direction='both', plot=TRUE, alpha=.025, longterm=TRUE, ylabel ="Nombre de Validations")
res_52_


which( Alsace_52_$substr.timestamp_2..1..19. %in% substr(res_52_$anoms$timestamp,1,19))

#=======================================================
x <- as.vector(time(count))

model_52_dimance <- lm( count ~
						   sin(2*pi*x/20) + cos(2*pi*x/20) 
						 + sin(2*2*pi*x/39) + cos(2*2*pi*x/39) 
		               )

plot(count ~ x, type='l')

lines(predict(model_52_dimance)~x, col='red')

plot(count[1:200] ~ x[1:200], type='l')

pred <- predict(model_52_dimance, interval="predict", level = 0.9)

lines(pred[,1]~x, col='red')

lines(pred[,2]~x, col='red', lty=3)

lines(pred[,3]~x, col='red', lty=3)


fit <- auto.arima(count[1:ceiling(length(count)/2)])
plot(forecast(fit, h=30))


#=============================================================================================================

library(BreakoutDetection)

res2_52 = breakout(count, min.size=6, method='multi', beta=.001, degree=1, plot=TRUE)
res2_52v

res = breakout(serie_alsace_52, min.size=24, method='multi', beta=.001, degree=1, plot=TRUE)

#=============================================================================================================

count <- serie_alsace_52
mx <- mean(count)
stdx <- sqrt(var(count))
count <- (count - mx)/stdx

CUMSUM <- function(count) {
     res <- numeric(length(count))
     for (i in seq_along(count) + 1) {
         res[i] <- max(0, res[i-1] + count[i-1] - mx)
     }
     res
 }

U <- mx + stdx
L <- mx - stdx

plot(CUMSUM(count), type='b', ylim=c(U+sqrt(mx), L-sqrt(mx)))
abline(h=U, col=2)
abline(h=L, col=2)


library(qcc)

MyCUSUM <- cusum(count, sizes=1, center=mx, std.dev=stdx, decision.interval = U, se.shift =.3)

summary(MyCUSUM)


#=============================================================================================================
# [1] "date"               "tranche_hor"       
# [3] "ligne"              "nb_validations"    
# [5] "avg_nb_validations" "std_nb_validations"
# [7] "size_gp"

validations_Lyon_lignes <- read.table('DATASET_data/Lyon/Validations_Lyon_Lignes.csv', sep=',', header=TRUE)

validations_Lyon_ligne_C3 <- validations_Lyon_lignes[which(validations_Lyon_lignes$ligne=='C3' & substr(validations_Lyon_ligne_C3$date,7,10)=='2014'),]
count_ligne_C3 <- validations_Lyon_ligne_C3$nb_validations

Year <- substr(validations_Lyon_ligne_C3$date, 7, 10)
Month <- substr(validations_Lyon_ligne_C3$date, 4, 5)
Day <- substr(validations_Lyon_ligne_C3$date, 1, 2)

timestamp_ligne_C3 <- paste( Year,'-', Month, '-', Day, ' ', substr(validations_Lyon_ligne_C3$tranche_hor, 1, 5), ':00', sep='')

Ligne_C3 <- data.frame(timestamp_ligne_C3, count_ligne_C3)

res_ligne_C3 = AnomalyDetectionTs(Ligne_C3, max_anoms=0.1, direction='both', plot=TRUE, alpha=.025, ylabel ="Nombre de Validations")
res_ligne_C3

