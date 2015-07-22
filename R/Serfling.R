lyon_validation_t1 <- read.table('Lyon_Validations_comptages_T1_Lignes_vide_v2.csv', sep=',', skip = 1)

data_header <- c('date','periode','ligne','arret','nombre_validations','nombre_entrees','difference_entrees_validations','indice_de_validation','taux_de_nonvalidation','nombre_de_controles','nombre_de_titres_incorrects')

colnames(lyon_validation_t1) <- data_header

lyon_validation_t1$date_deb <- as.numeric(strptime(paste(as.character(lyon_validation_t1$date), ' ' , substr(lyon_validation_t1$periode,1,5), ':00', sep=''), '%d/%m/%Y %H:%M:%S'))

lyon_validation_t1$date_fin <- as.numeric(strptime(paste(as.character(lyon_validation_t1$date), ' ', substr(lyon_validation_t1$periode,9,13), ':00', sep=''), '%d/%m/%Y %H:%M:%S'))

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Serfling method implementation
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# for filtering nights

night <- c("00:00 - 00:29", "00:30 - 00:59", "01:00 - 01:29", "01:30 - 01:59",
"02:00 - 02:29", "02:30 - 02:59", "03:00 - 03:29","03:30 - 03:59",
"04:00 - 04:29", "04:30 - 04:59")


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Arrêt :   Code arrêt = 32121 (Gare  Part-Dieu)
#______________________________________________________________

# Extracting data

# Arret 32121
lyon_validation_t1_32121 <- lyon_validation_t1[which(lyon_validation_t1$arret==32121),]

lyon_validation_t1_32121 <- lyon_validation_t1_32121[order(lyon_validation_t1_32121$date_deb),]

# get rid of negative values
lyon_validation_t1_32121[lyon_validation_t1_32121$taux_de_nonvalidation<0,]$taux_de_nonvalidation = 0

# filtering nights
lyon_validation_t1_32121 <- lyon_validation_t1_32121[!lyon_validation_t1_32121$periode %in% night,]

lyon_validation_t1_32121_diff_day <- aggregate(difference_entrees_validations ~ date, lyon_validation_t1_32121, sum )

lyon_validation_t1_32121_entree_day <- aggregate(nombre_entrees ~ date, lyon_validation_t1_32121, sum )

lyon_validation_t1_32121_diff_day$taux_de_nonvalidation <- lyon_validation_t1_32121_diff_day$difference_entrees_validations/lyon_validation_t1_32121_entree_day$nombre_entrees

lyon_validation_t1_32121_diff_day[is.na(lyon_validation_t1_32121_diff_day$taux_de_nonvalidation),]$taux_de_nonvalidation = 0

x <- as.vector(time(lyon_validation_t1_32121_diff_day$taux_de_nonvalidation))

plot(taux_de_nonvalidation ~ x, type='l', data=lyon_validation_t1_32121_diff_day)

f3 <- rep(1/3, 3)

m <- filter(lyon_validation_t1_32121_diff_day$taux_de_nonvalidation, f3, sides=1)
lines(m, col="blue")

acf(lyon_validation_t1_32121_diff_day$taux_de_nonvalidation)

spectrum(lyon_validation_t1_32121_diff_day$taux_de_nonvalidation, spans=10)

a <- locator()

theta <- c(0.08469352, 0.16434730, 0.24766715, 0.33598620, 0.41897277)

model <- lm(taux_de_nonvalidation ~ sin(2*pi*x*theta[1])
								   + cos(2*pi*x*theta[2])
								   + cos(2*pi*x*theta[4])
								   +sin(2*pi*x*theta[5]),
									data=lyon_validation_t1_32121_diff_day)

summary(model)

png("Serfling-Lyon-32121-(Gare  Part-Dieu).png", width=1024)
plot(taux_de_nonvalidation ~ x, type='l', ylim=c(0,1), xlim=c(100,200),
	 data=lyon_validation_t1_32121_diff_day,
	 xlab='Jours', ylab='Taux de Non-Validation', main="Arrêt 32121 (Gare  Part-Dieu)")

lines(predict(model)~x, col='red')

pred <- predict(model, interval="confidence", level=.99)[,c("lwr","upr")]

lines(x, pred[,'upr'], col=2, lty=3, pch=1)

#matlines(x, pred, col=2, lty=2, pch=1)

lines(pred[,'upr'] + .05 ~ x, col='blue', lty=3)

legend('topright', legend=c('Taux de Non-Validation', 'Modèle Serfling', 'Seuil d\'alert', 'Seuil à +5% du seuil d\'alert'), lty = c(1, 1, 3, 3), col=c(1,2,2,4))
dev.off()

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Arrêt :   Code arrêt = 46156   (Halle Tony Garnier)
#______________________________________________________________


# Extracting data

# Arret 46156
lyon_validation_t1_46156 <- lyon_validation_t1[which(lyon_validation_t1$arret==46156),]

lyon_validation_t1_46156 <- lyon_validation_t1_46156[order(lyon_validation_t1_46156$date_deb),]

# filtering nights
lyon_validation_t1_46156 <- lyon_validation_t1_46156[!lyon_validation_t1_46156$periode %in% night,]

lyon_validation_t1_46156_diff_day <- aggregate(difference_entrees_validations ~ date, lyon_validation_t1_46156, sum )

lyon_validation_t1_46156_entree_day <- aggregate(nombre_entrees ~ date, lyon_validation_t1_46156, sum )

lyon_validation_t1_46156_diff_day$taux_de_nonvalidation <- lyon_validation_t1_46156_diff_day$difference_entrees_validations/lyon_validation_t1_46156_entree_day$nombre_entrees

lyon_validation_t1_46156_diff_day[is.na(lyon_validation_t1_46156_diff_day$taux_de_nonvalidation),]$taux_de_nonvalidation = 0

# get rid of negative values
lyon_validation_t1_46156_diff_day[lyon_validation_t1_46156_diff_day$taux_de_nonvalidation<0,]$taux_de_nonvalidation = 0

x <- as.vector(time(lyon_validation_t1_46156_diff_day$taux_de_nonvalidation))

acf(lyon_validation_t1_46156_diff_day$taux_de_nonvalidation)

spectrum(lyon_validation_t1_46156_diff_day$taux_de_nonvalidation, spans=10)

#a <- locator()

theta <- c(0.08454686, 0.16647925, 0.24615663, 0.33748494, 0.41941733)

model <- lm(taux_de_nonvalidation ~ sin(2*pi*x*theta[1]) + cos(2*pi*x*theta[1])
								   +sin(2*pi*x*theta[2]) + cos(2*pi*x*theta[2]),
									data=lyon_validation_t1_46156_diff_day)

summary(model)

png("Serfling-Lyon-46156 (Halle Tony Garnier).png", width=1024)

plot(taux_de_nonvalidation ~ x, type='l', ylim=c(0,1), xlim=c(100,200),
	 data=lyon_validation_t1_46156_diff_day,
	 xlab='Jours', ylab='Taux de Non-Validation', main="Arrêt 46156 (Halle Tony Garnier)")

lines(predict(model)~x, col='red')

pred <- predict(model, interval="confidence", level=.99)[,c("lwr","upr")]

lines(x, pred[,'upr'], col=2, lty=3, pch=1)

#matlines(x, pred, col=2, lty=2, pch=1)

lines(pred[,'upr'] + .05 ~ x, col='blue', lty=3)

legend('topright', legend=c('Taux de Non-Validation', 'Modèle Serfling', 'Seuil d\'alert', 'Seuil à +5% du seuil d\'alert'), lty = c(1, 1, 3, 3), col=c(1,2,2,4))

dev.off()

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Arrêt :   Code arrêt = 32102 (Perrache)
#______________________________________________________________
# Extracting data

# Arret 32102
lyon_validation_t1_32102 <- lyon_validation_t1[which(lyon_validation_t1$arret==32102),]

lyon_validation_t1_32102 <- lyon_validation_t1_32102[order(lyon_validation_t1_32102$date_deb),]

# filtering nights
lyon_validation_t1_32102 <- lyon_validation_t1_32102[!lyon_validation_t1_32102$periode %in% night,]

lyon_validation_t1_32102_diff_day <- aggregate(difference_entrees_validations ~ date, lyon_validation_t1_32102, sum )

lyon_validation_t1_32102_entree_day <- aggregate(nombre_entrees ~ date, lyon_validation_t1_32102, sum )

lyon_validation_t1_32102_diff_day$taux_de_nonvalidation <- lyon_validation_t1_32102_diff_day$difference_entrees_validations/lyon_validation_t1_32102_entree_day$nombre_entrees

lyon_validation_t1_32102_diff_day[is.na(lyon_validation_t1_32102_diff_day$taux_de_nonvalidation),]$taux_de_nonvalidation = 0

# get rid of negative values
lyon_validation_t1_32102_diff_day[lyon_validation_t1_32102_diff_day$taux_de_nonvalidation<0,]$taux_de_nonvalidation = 0

x <- as.vector(time(lyon_validation_t1_32102_diff_day$taux_de_nonvalidation))

acf(lyon_validation_t1_32102_diff_day$taux_de_nonvalidation)

spectrum(lyon_validation_t1_32102_diff_day$taux_de_nonvalidation, spans=10)

#a <- locator()

theta <- c(0.08504821, 0.16244779, 0.24733765, 0.33305977, 0.41836576)

model <- lm(taux_de_nonvalidation ~ sin(2*pi*x*theta[3])
								   + cos(2*pi*x*theta[4])
								   +sin(2*pi*x*theta[5]) ,
									data=lyon_validation_t1_32102_diff_day)

summary(model)

png("Serfling-Lyon-32102 (Perrache).png", width=1024)

plot(taux_de_nonvalidation ~ x, type='l', ylim=c(0,1), xlim=c(100,200),
	 data=lyon_validation_t1_32102_diff_day,
	 xlab='Jours', ylab='Taux de Non-Validation', main="Arrêt 32102 (Perrache)")

lines(predict(model)~x, col='red')

pred <- predict(model, interval="confidence", level=.99)[,c("lwr","upr")]

lines(x, pred[,'upr'], col=2, lty=3, pch=1)

#matlines(x, pred, col=2, lty=2, pch=1)

lines(pred[,'upr'] + .05 ~ x, col='blue', lty=3)

legend('topright', legend=c('Taux de Non-Validation', 'Modèle Serfling', 'Seuil d\'alert', 'Seuil à +5% du seuil d\'alert'), lty = c(1, 1, 3, 3), col=c(1,2,2,4))

dev.off()

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
