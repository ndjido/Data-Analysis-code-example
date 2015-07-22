
#Libs

 require('ggplot2')

#Loading data
data_tram_lyon <- read.table('Keolis_data/Lyon/lyon_comptage_tram.tsv', sep="\x01")

header <- c('date', 'periode', 'ligne', 'arret', 'type_trans', 'nb_validations', 'mean_val_gp', 'group_gp', 'indice_val_s_mean',
'libelle_jour', 'libelle_mois', 'jvscolaire', 'jour_ouvre', 'date_TH', 'unix_timestamp', 'X', 'Y', 'nb_entrees_gp', 
'avg_entrees_gp', 'nb_sortie_gp', 'avg_sorties_gp', 'diff_entrees_validations', 'taux_validation')

names(data_tram_lyon) <- header

data_tram_lyon <- data_tram_lyon[which(data_tram_lyon$type_trans=='TRAM'),]

head(data_tram_lyon

# Nom Arret:

arrets_tram_lyon <- read.table('Keolis_data/Lyon/liste_arret_tram_lyon.csv', sep=",", header=TRUE)

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Distribution de l'indice de validation
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

summary(data_tram_lyon$indice_val_s_mean)

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
# 0.004603  0.636200  0.935100  0.993500  1.239000 17.080000 
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

log_indice_validation <- log(data_tram_lyon$indice_val_s_mean)

summary(log_indice_validation)
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
#-5.38100 -0.45220 -0.06714 -0.16780  0.21410  2.83800 
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


#png("Keolis_data/Lyon/Analyses_Indice/Hist_Indice.png")
hist(log_indice_validation, freq=F, col='lightblue', ylab="Densité", xlab="Log(Indice de Validation)", main="")
x <- seq(-4, 4, .01)
y <- dnorm(x, mean=mean(log(data_tram_lyon$indice_val_s_mean)), sd=sqrt(var(log(data_tram_lyon$indice_val_s_mean))))
lines(y ~ x, col=2, lty=3)
#dev.off()

# indice ~  mois
levels(data_tram_lyon$libelle_mois) <- c('Août', 'Avril', 'Décembre', 'Février', 'Janvier', "Juillet", 'Juin', 'Mai', 'Mars', 
                                         'Novembre', 'Octobre', 'Septembre')
mois_order <- c('Janvier', 'Février', 'Mars', 'Avril', 'Mai',  'Juin',  "Juillet", 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre')
data_tram_lyon$libelle_mois <- ordered(data_tram_lyon$libelle_mois, levels=mois_order)

#png("Keolis_data/Lyon/Analyses_Indice/Boxplot_Indice_Mois.png", width=650)
qplot(data_tram_lyon$libelle_mois, log_indice_validation,  geom=c('boxplot'), xlab="Mois", ylab="Log(Indice de Validation)")
#dev.off()

# indice ~  jour
jour_order <- c('Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche')
data_tram_lyon$libelle_jour <- ordered(data_tram_lyon$libelle_jour, levels=jour_order)

#png("Keolis_data/Lyon/Analyses_Indice/Boxplot_Indice_Jour.png", width=650)
qplot(data_tram_lyon$libelle_jour, log_indice_validation,  geom=c('boxplot'), xlab="Jour", ylab="Log(Indice de Validation)")
#dev.off()

# indice ~  tranche horaire
data_tram_lyon$periode <- ordered(data_tram_lyon$periode, levels=sort(levels(data_tram_lyon$periode)))
levels(data_tram_lyon$periode) <- paste("T", 1:48, sep='')

#png("Keolis_data/Lyon/Analyses_Indice/Boxplot_Indice_TH.png", width=1024)
qplot(periode, log_indice_validation, data=data_tram_lyon,  geom=c('boxplot'), xlab="Tranche Horaire", ylab="Log(Indice de Validation)")
#dev.off()

for (i in 1:dim(arrets_tram_lyon)[1]) {

	# code & name
	code <- arrets_tram_lyon[i,"code_arret"]
	nom_arret <- arrets_tram_lyon[i,"nom_arret"]

	# Histogramme
	if (sum(data_tram_lyon$arret==code)) {
		#png(paste("Keolis_data/Lyon/Analyses_Indice/Hist_Indice-", nom_arret ,".png", sep=''))
		#hist(log_indice_validation[which(data_tram_lyon$arret==code)], freq=F, col='lightblue', ylab="Densité", xlab="Log(Indice de Validation)", main=paste("Arrêt: ", nom_arret))
		#x <- seq(-4, 4, .01)
		#y <- dnorm(x, mean=mean(log(data_tram_lyon[which(data_tram_lyon$arret==code),]$indice_val_s_mean)), sd=sqrt(var(log(data_tram_lyon[which(data_tram_lyon$arret==code),]$indice_val_s_mean))))
		#lines(y ~ x, col=2, lty=3)
		#dev.off()

		#Boxplot
		#-1 indice ~  mois
		png(paste("Keolis_data/Lyon/Analyses_Indice/Boxplot_Indice_Mois-",nom_arret,".png", sep=''), width=650)
		qplot(data_tram_lyon[which(data_tram_lyon$arret==code),]$libelle_mois, log_indice_validation[which(data_tram_lyon$arret==code)],  geom=c('boxplot'), xlab="Mois", ylab="Log(Indice de Validation)", main=paste("Arrêt: ", nom_arret))
		dev.off()

		#-2 indice ~  Jour
		png(paste("Keolis_data/Lyon/Analyses_Indice/Boxplot_Indice_Jour-", nom_arret, ".png", sep=''), width=650)
		qplot(data_tram_lyon[which(data_tram_lyon$arret==code),]$libelle_jour, log_indice_validation[which(data_tram_lyon$arret==code)],  geom=c('boxplot'), xlab="Jour", ylab="Log(Indice de Validation)", main=paste("Arrêt: ", nom_arret))
		dev.off()

		#-3 indice ~  tranche horaire
		png(paste("Keolis_data/Lyon/Analyses_Indice/Boxplot_Indice_TH-", nom_arret, ".png", sep=''), width=1024)
		qplot(periode, log_indice_validation[which(data_tram_lyon$arret==code)], data=data_tram_lyon[which(data_tram_lyon$arret==code),],  geom=c('boxplot'), xlab="Tranche Horaire", ylab="Log(Indice de Validation)", main=paste("Arrêt: ", nom_arret))
		dev.off()
	}	
}


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Distribution du Taux de validation
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


data_tram_lyon$taux_validation <- as.numeric(as.character(data_tram_lyon$taux_validation))
log_taux_validation <- log(data_tram_lyon$taux_validation)


boxplot(log(data_tram_lyon$taux_validation), horizontal=TRUE)

hist(data_tram_lyon$taux_validation, freq=F, col='lightblue', ylab="Densité", xlab="Log(Taux de Validation)", main="")
x <- seq(-4, 4, .01)
y <- dnorm(x, mean=mean(data_tram_lyon$taux_validation), sd=sqrt(var(data_tram_lyon$taux_validation)))
lines(y ~ x, col=2, lty=3)


#png("Keolis_data/Lyon/Analyses_Taux/Hist_Taux.png")
hist(log_taux_validation, freq=F, col='lightblue', ylab="Densité", xlab="Log(Taux de Validation)", main="")
x <- seq(-4, 4, .01)
y <- dnorm(x, mean=mean(log(data_tram_lyon$taux_validation), na.rm = TRUE), sd=sqrt(var(log(data_tram_lyon$taux_validation), na.rm=TRUE)))
lines(y ~ x, col=2, lty=3)
#dev.off()

# Taux ~  mois
levels(data_tram_lyon$libelle_mois) <- c('Août', 'Avril', 'Décembre', 'Février', 'Janvier', "Juillet", 'Juin', 'Mai', 'Mars', 
                                         'Novembre', 'Octobre', 'Septembre')
mois_order <- c('Janvier', 'Février', 'Mars', 'Avril', 'Mai',  'Juin',  "Juillet", 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre')
data_tram_lyon$libelle_mois <- ordered(data_tram_lyon$libelle_mois, levels=mois_order)

#png("Keolis_data/Lyon/Analyses_Taux/Boxplot_Taux_Mois.png", width=650)
qplot(data_tram_lyon$libelle_mois, log_taux_validation,  geom=c('boxplot'), xlab="Mois", ylab="Log(Taux de Validation)")
#dev.off()

# Taux ~  jour
jour_order <- c('Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche')
data_tram_lyon$libelle_jour <- ordered(data_tram_lyon$libelle_jour, levels=jour_order)

#png("Keolis_data/Lyon/Analyses_Taux/Boxplot_Taux_Jour.png", width=650)
qplot(data_tram_lyon$libelle_jour, log_taux_validation,  geom=c('boxplot'), xlab="Jour", ylab="Log(Taux de Validation)")
#dev.off()

# Taux ~  tranche horaire
data_tram_lyon$periode <- ordered(data_tram_lyon$periode, levels=sort(levels(data_tram_lyon$periode)))
levels(data_tram_lyon$periode) <- paste("T", 1:48, sep='')

#png("Keolis_data/Lyon/Analyses_Taux/Boxplot_Taux_TH.png", width=1024)
qplot(periode, log_taux_validation, data=data_tram_lyon,  geom=c('boxplot'), xlab="Tranche Horaire", ylab="Log(Taux de Validation)")
#dev.off()

hist(data_tram_lyon$taux_validation, freq=F, col='lightblue', ylab="Densité", xlab="Log(Taux de Validation)", main="")
x <- seq(-4, 4, .01)
y <- dnorm(x, mean=mean(log(data_tram_lyon$taux_validation)), sd=sqrt(var(log(data_tram_lyon$taux_validation))))
lines(y ~ x, col=2, lty=3)


summary(data_tram_lyon$taux_validation<0)
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#-62.000   0.107   0.300   0.268   0.500   0.998    4865

# Nb valeurs positives: 506903 (87.68%)
# Nb valeurs négative:  66322  (11.47%)
# Nb Missing:           4865   (0.84%)
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

for (i in 1:dim(arrets_tram_lyon)[1]) {
	# code & name
	code <- arrets_tram_lyon[i,"code_arret"]
	nom_arret <- arrets_tram_lyon[i,"nom_arret"]

	# Histogramme
	#sink("Keolis_data/Lyon/Analyses_Taux/Stats.txt")
	print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
	print(paste("Arrêt:", nom_arret))
	if (sum(data_tram_lyon$arret==code)) {
		print(summary(data_tram_lyon[which(data_tram_lyon$arret==code),]$taux_validation))
		size <- length(data_tram_lyon[which(data_tram_lyon$arret==code),]$taux_validation)
		SUMMARY <- as.numeric(summary(data_tram_lyon[which(data_tram_lyon$arret==code),]$taux_validation<0)[-1])
		names(SUMMARY) <- c('Nb_POS', 'Nb_NEG', 'NB_MISSING')
		print(SUMMARY)
		SUMMARY2 <- 100*SUMMARY/size
		print(SUMMARY2)
	}
	#sink()
}


for (i in 1:dim(arrets_tram_lyon)[1]) {

	# code & name
	code <- arrets_tram_lyon[i,"code_arret"]
	nom_arret <- arrets_tram_lyon[i,"nom_arret"]

	# Histogramme
	if (sum(data_tram_lyon$arret==code)) {

		png(paste("Keolis_data/Lyon/Analyses_Taux/Hist_Taux-", nom_arret ,".png", sep=''))
		hist(log_Taux_validation[which(data_tram_lyon$arret==code)], freq=F, col='lightblue', ylab="Densité", xlab="Log(Taux de Validation)", main=paste("Arrêt: ", nom_arret))
		x <- seq(-4, 4, .01)
		y <- dnorm(x, mean=mean(log(data_tram_lyon[which(data_tram_lyon$arret==code),]$taux_validation)), sd=sqrt(var(log(data_tram_lyon[which(data_tram_lyon$arret==code),]$taux_validation))))
		lines(y ~ x, col=2, lty=3)
		dev.off()

		#Boxplot
		#-1 Taux ~  mois
		png(paste("Keolis_data/Lyon/Analyses_Taux/Boxplot_Taux_Mois-",nom_arret,".png", sep=''), width=650)
		qplot(data_tram_lyon[which(data_tram_lyon$arret==code),]$libelle_mois, log_Taux_validation[which(data_tram_lyon$arret==code)],  geom=c('boxplot'), xlab="Mois", ylab="Log(Taux de Validation)", main=paste("Arrêt: ", nom_arret))
		dev.off()

		#-2 Taux ~  Jour
		png(paste("Keolis_data/Lyon/Analyses_Taux/Boxplot_Taux_Jour-", nom_arret, ".png", sep=''), width=650)
		qplot(data_tram_lyon[which(data_tram_lyon$arret==code),]$libelle_jour, log_Taux_validation[which(data_tram_lyon$arret==code)],  geom=c('boxplot'), xlab="Jour", ylab="Log(Taux de Validation)", main=paste("Arrêt: ", nom_arret))
		dev.off()

		#-3 Taux ~  tranche horaire
		png(paste("Keolis_data/Lyon/Analyses_Taux/Boxplot_Taux_TH-", nom_arret, ".png", sep=''), width=1024)
		qplot(periode, log_Taux_validation[which(data_tram_lyon$arret==code)], data=data_tram_lyon[which(data_tram_lyon$arret==code),],  geom=c('boxplot'), xlab="Tranche Horaire", ylab="Log(Taux de Validation)", main=paste("Arrêt: ", nom_arret))
		dev.off()
	}	
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
require(AnomalyDetection)

#Debourg
Debourg_data <- data_tram_lyon[which(data_tram_lyon$arret==code),]
Debourg_dataTS <- na.omit(data.frame(Debourg_data$date_TH, Debourg_data$taux_validation)[which(Debourg_data$taux_validation>0),])
detection_mod_Debourg <- AnomalyDetectionTs(Debourg_dataTS, max_anoms=.3, direction='both', plot=TRUE, alpha=.05,  ylabel ="Taux de Validation")

detection_mod_Debourg <- AnomalyDetectionTs(Debourg_dataTS, max_anoms=.3, direction='neg', plot=TRUE, alpha=.25,  ylabel ="Taux de Validation")

#ALL
ALL_dataTS <- na.omit(data.frame(data_tram_lyon$date_TH, data_tram_lyon$taux_validation)[which(data_tram_lyon$taux_validation>0),])
detection_mod_ALL <- AnomalyDetectionTs(ALL_dataTS, max_anoms=.3, direction='both', plot=TRUE, alpha=.05,  ylabel ="Taux de Validation")

detection_mod_ALL <- AnomalyDetectionVec(ALL_dataTS[,2], max_anoms=.3, direction='both', plot=TRUE, period=48)


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
summary(data_tram_lyon[data_tram_lyon$taux_validation>=0,]$taux_validation)
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#  0.000   0.182   0.333   0.367   0.521   0.998    4865 
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>0,]$taux_validation
summary(TAUX)
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#  Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#  0.003   0.221   0.364   0.397   0.546   0.998    4865 
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>0,]$indice_val_s_mean
summary(INDICE)
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
# 0.005   0.632   0.924   0.972   1.215  14.070    4865 
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

cor(TAUX, INDICE, use="complete.obs", method="spearman")

## COR Taux vs Indice = -0.41649

# Correlation by Station
#sink("Keolis_data/Lyon/Corr_TAUX_INDICE_Arret.txt")
for (i in 1:dim(arrets_tram_lyon)[1]) {
	# code & name
	code <- arrets_tram_lyon[i,"code_arret"]
	nom_arret <- arrets_tram_lyon[i,"nom_arret"]
	# Corr
	if (sum(data_tram_lyon$arret==code)) {
		TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>0 & data_tram_lyon$arret==code,]$taux_validation
		INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>0 & data_tram_lyon$arret==code,]$indice_val_s_mean
		COR <- cor(TAUX, INDICE, use="complete.obs", method="spearman")
		print(paste("Arrêt: ", nom_arret, ', Corr=',  COR))
	}
}
# sink()

# Correlation by Tranche Horaire
#sink("Keolis_data/Lyon/Corr_TAUX_INDICE_THoraire.txt")
TH <- unique(data_tram_lyon$periode)
for (i in 1:length(TH)) {
	# Corr
		TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & data_tram_lyon$periode==TH[i],]$taux_validation
		INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & data_tram_lyon$periode==TH[i],]$indice_val_s_mean
		COR <- cor(TAUX, INDICE, use="complete.obs", method="spearman")
		print(paste("Periode", TH[i], ', Corr=',  COR))
}
#sink()


LJ <- unique(data_tram_lyon$libelle_jour)
for (i in 1:length(TH)) {
	# Corr
		TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & data_tram_lyon$libelle_jour==LJ[i],]$taux_validation
		INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & data_tram_lyon$libelle_jour==LJ[i],]$indice_val_s_mean
		COR <- cor(TAUX, INDICE, use="complete.obs", method="spearman")
		print(paste("JOUR", LJ[i], ', Corr=',  COR))
}

LM <- unique(data_tram_lyon$libelle_mois)
for (i in 1:length(LM)) {
	# Corr
		TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & data_tram_lyon$libelle_mois==LM[i],]$taux_validation
		INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & data_tram_lyon$libelle_mois==LM[i],]$indice_val_s_mean
		COR <- cor(log(TAUX+1), log(INDICE+1), use="complete.obs", method="pearson")
		print(paste("JOUR", LM[i], ', Corr=',  COR))
}

summary(data_tram_lyon[data_tram_lyon$taux_validation>=0 & data_tram_lyon$periode=="19:00 - 19:29",]$taux_validation )

#sink("Keolis_data/Lyon/Corr_TAUX_INDICE_Arret_THoraire.txt")
for (i in 1:dim(arrets_tram_lyon)[1]) {
	# code & name
	code <- arrets_tram_lyon[i,"code_arret"]
	nom_arret <- arrets_tram_lyon[i,"nom_arret"]
	# Corr
	if (sum(data_tram_lyon$arret==code)) {
		print("++++++++++++++++++++++++++++++++++++++++++++")
		print(paste("Arrêt: ", nom_arret))
		print("++++++++++++++++++++++++++++++++++++++++++++")
		TH <- unique(data_tram_lyon$periode)
		for (j in 1:length(TH)) {
			TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>0 & data_tram_lyon$arret==code & data_tram_lyon$periode==TH[j],]$taux_validation
			INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>0 & data_tram_lyon$arret==code & data_tram_lyon$periode==TH[j],]$indice_val_s_mean
			COR <- cor(TAUX, INDICE, use="complete.obs", method="spearman")
			print(paste("Arrêt: ", nom_arret, 'TH:', TH[j] ,', Corr:',  COR))
		}
		
	}
}
#sink()


#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# mutualInfo
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

require(entropy)

val_periodes <- c("04:00 - 04:29", "04:30 - 04:59", "05:00 - 05:29", "05:30 - 05:59", "06:00 - 06:29", "06:30 - 06:59"
, "07:00 - 07:29", "07:30 - 07:59", "08:00 - 08:29", "08:30 - 08:59", "09:00 - 09:29"
, "09:30 - 09:59", "10:00 - 10:29", "10:30 - 10:59", "11:00 - 11:29", "11:30 - 11:59"
, "12:00 - 12:29", "12:30 - 12:59", "13:00 - 13:29", "13:30 - 13:59", "14:00 - 14:29"
, "14:30 - 14:59", "15:00 - 15:29", "15:30 - 15:59", "16:00 - 16:29", "16:30 - 16:59"
, "17:00 - 17:29", "17:30 - 17:59", "18:00 - 18:29", "18:30 - 18:59", "19:00 - 19:29"
, "19:30 - 19:59", "20:00 - 20:29", "20:30 - 20:59", "21:00 - 21:29", "21:30 - 21:59"
, "22:00 - 22:29", "22:30 - 22:59")

for (i in 1:dim(arrets_tram_lyon)[1]) {
	# code & name
	code <- arrets_tram_lyon[i,"code_arret"]
	nom_arret <- arrets_tram_lyon[i,"nom_arret"]
	# Corr
	if (sum(data_tram_lyon$arret==code)) {
		TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>=0  & !is.na(data_tram_lyon$taux_validation) & data_tram_lyon$arret==code,]$taux_validation
		INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation) & data_tram_lyon$arret==code,]$indice_val_s_mean
		y2D <- discretize2d(log(TAUX+1), log(INDICE+1), numBins1=100, numBins2=100)
		H1 <- entropy(rowSums(y2D))
		H2 <- entropy(colSums(y2D))
		H12 <- entropy(y2D)
		mi <- (H1+H2-H12)/max(H1, H2)
		print(paste("Arrêt: ", nom_arret, ', MI=',  mi))
	}
}

TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>0  & !is.na(data_tram_lyon$taux_validation & data_tram_lyon$periode %in% val_periodes),]$taux_validation
INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>0 & !is.na(data_tram_lyon$taux_validation & data_tram_lyon$periode %in% val_periodes),]$indice_val_s_mean
y2D <- discretize2d(TAUX, INDICE, numBins1=100, numBins2=100)
H1 <- entropy(rowSums(y2D))
H2 <- entropy(colSums(y2D))
H12 <- entropy(y2D)
(mi <- (H1+H2-H12)/max(H1, H2))

TH <- unique(data_tram_lyon$periode)
for (i in 1:length(TH)) {
	# Corr
		TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>=0  & !is.na(data_tram_lyon$taux_validation) & data_tram_lyon$periode==TH[i],]$taux_validation
		INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation) & data_tram_lyon$periode==TH[i],]$indice_val_s_mean
		y2D <- discretize2d(log(TAUX+1), log(INDICE+1), numBins1=100, numBins2=100)
		H1 <- entropy(rowSums(y2D))
		H2 <- entropy(colSums(y2D))
		H12 <- entropy(y2D)
		mi <- (H1+H2-H12)/max(H1, H2)
		print(paste("Periode", TH[i], ', MI=',  mi))
}

for (i in 1:dim(arrets_tram_lyon)[1]) {
	# code & name
	code <- arrets_tram_lyon[i,"code_arret"]
	nom_arret <- arrets_tram_lyon[i,"nom_arret"]
	# Corr
	if (sum(data_tram_lyon$arret==code)) {
		print("++++++++++++++++++++++++++++++++++++++++++++")
		print(paste("Arrêt: ", nom_arret))
		print("++++++++++++++++++++++++++++++++++++++++++++")
		TH <- unique(data_tram_lyon$periode)
		for (j in 1:length(TH)) {
			TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>0 & !is.na(data_tram_lyon$taux_validation) & data_tram_lyon$arret==code & data_tram_lyon$periode==TH[j],]$taux_validation
			INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>0 & !is.na(data_tram_lyon$taux_validation) & data_tram_lyon$arret==code & data_tram_lyon$periode==TH[j],]$indice_val_s_mean
			y2D <- discretize2d(log(TAUX+1), log(INDICE+1), numBins1=100, numBins2=100)
			H1 <- entropy(rowSums(y2D))
			H2 <- entropy(colSums(y2D))
			H12 <- entropy(y2D)
			mi <- (H1+H2-H12)/max(H1, H2)
			print(paste("Arrêt: ", nom_arret, 'TH:', TH[j] ,', MI:',  mi))
		}
		
	}
}

for (i in 1:dim(arrets_tram_lyon)[1]) {
	# code & name
	code <- arrets_tram_lyon[i,"code_arret"]
	nom_arret <- arrets_tram_lyon[i,"nom_arret"]
	# Corr
	if (sum(data_tram_lyon$arret==code)) {
		print("++++++++++++++++++++++++++++++++++++++++++++")
		print(paste("Arrêt: ", nom_arret))
		print("++++++++++++++++++++++++++++++++++++++++++++")
		TH <- unique(data_tram_lyon$periode)
		for (j in 1:length(TH)) {
			TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>0 & !is.na(data_tram_lyon$taux_validation) & data_tram_lyon$arret==code & data_tram_lyon$periode==TH[j],]$taux_validation
			INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>0 & !is.na(data_tram_lyon$taux_validation) & data_tram_lyon$arret==code & data_tram_lyon$periode==TH[j],]$indice_val_s_mean
			y2D <- discretize2d(log(TAUX+1), log(INDICE+1), numBins1=100, numBins2=100)
			H1 <- entropy(rowSums(y2D))
			H2 <- entropy(colSums(y2D))
			H12 <- entropy(y2D)
			mi <- (H1+H2-H12)/max(H1, H2)
			print(paste("Arrêt: ", nom_arret, 'TH:', TH[j] ,', MI:',  mi))
		}
		
	}
}

LJ <- unique(data_tram_lyon$libelle_jour)
for (i in 1:length(LJ)) {
	# Corr
		TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>=0  & !is.na(data_tram_lyon$taux_validation) & data_tram_lyon$libelle_jour==LJ[i],]$taux_validation
		INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation) & data_tram_lyon$libelle_jour==LJ[i],]$indice_val_s_mean
		y2D <- discretize2d(log(TAUX+1), log(INDICE+1), numBins1=100, numBins2=100)
		H1 <- entropy(rowSums(y2D))
		H2 <- entropy(colSums(y2D))
		H12 <- entropy(y2D)
		mi <- (H1+H2-H12)/max(H1, H2)
		print(paste("Jour", LJ[i], ', MI=',  mi))
}



LM <- unique(data_tram_lyon$libelle_mois)
for (i in 1:length(LM)) {
	# Corr
		TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>=0  & !is.na(data_tram_lyon$taux_validation) & data_tram_lyon$libelle_mois==LM[i],]$taux_validation
		INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation) & data_tram_lyon$libelle_mois==LM[i],]$indice_val_s_mean
		y2D <- discretize2d(log(TAUX+1), log(INDICE+1), numBins1=200, numBins2=200)
		H1 <- entropy(rowSums(y2D))
		H2 <- entropy(colSums(y2D))
		H12 <- entropy(y2D)
		mi <- (H1+H2-H12)/max(H1, H2)
		print(paste("Jour", LM[i], ', MI=',  mi))
}

------------------

data_tram_lyon_2 <- read.table('Keolis_data/Lyon/lyon_comptage_tram.csv', sep=";", header=TRUE)
data_tram_lyon_2$TAUX_VALIDATION <- as.numeric(as.character(data_tram_lyon_2$TAUX_VALIDATION))

cor(data_tram_lyon_2$TAUX_VALIDATION, data_tram_lyon_2$MOVING_SUM/data_tram_lyon_2$MEAN_VAL_GP, use="complete.obs", method="spearman")

TH <- unique(data_tram_lyon_2$AGG_VALIDATIONS_DIVERS_PERIODE)
for (i in 1:length(TH)) {
	# Corr
		TAUX <- data_tram_lyon[data_tram_lyon_2$TAUX_VALIDATION>=0  & !is.na(data_tram_lyon_2$TAUX_VALIDATION) & data_tram_lyon_2$AGG_VALIDATIONS_DIVERS_PERIODE==TH[i],]$TAUX_VALIDATION
		MS <- data_tram_lyon_2[data_tram_lyon_2$TAUX_VALIDATION>=0 & !is.na(data_tram_lyon_2$TAUX_VALIDATION) & data_tram_lyon_2$AGG_VALIDATIONS_DIVERS_PERIODE==TH[i],]$indice_val_s_mean
		y2D <- discretize2d(log(TAUX+1), log(MS+1), numBins1=100, numBins2=100)
		H1 <- entropy(rowSums(y2D))
		H2 <- entropy(colSums(y2D))
		H12 <- entropy(y2D)
		mi <- (H1+H2-H12)/max(H1, H2)
		print(paste("Periode", TH[i], ', MI=',  mi))
}




