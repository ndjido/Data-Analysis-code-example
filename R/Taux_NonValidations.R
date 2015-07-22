#Libs

 require('ggplot2')

#Loading data
# Data Tram Lyon
data_tram_lyon <- read.table("Keolis_data/Lyon/Tram_Lyon.csv", sep=';', header=TRUE)

#Libelle Arrets
arrets_tram_lyon <- read.table('Keolis_data/Lyon/liste_arret_tram_lyon.csv', sep=",", header=TRUE)


# Formating data

#MOIS
levels(data_tram_lyon$libelle_mois) <- c('Août', 'Avril', 'Décembre', 'Février', 'Janvier', "Juillet", 'Juin', 'Mai', 'Mars', 
                                         'Novembre', 'Octobre', 'Septembre')
mois_order <- c('Janvier', 'Février', 'Mars', 'Avril', 'Mai',  'Juin',  "Juillet", 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre')
data_tram_lyon$libelle_mois <- ordered(data_tram_lyon$libelle_mois, levels=mois_order)

#JOUR
jour_order <- c('Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche')
data_tram_lyon$libelle_jour <- ordered(data_tram_lyon$libelle_jour, levels=jour_order)

#Tranche Horaire
data_tram_lyon$periode <- ordered(data_tram_lyon$periode, levels=sort(levels(data_tram_lyon$periode)))
levels(data_tram_lyon$periode) <- paste("T", 1:48, sep='')


# Arrêts
data_tram_lyon$libelle_arret <- factor(data_tram_lyon$arret)

arrets_tram_lyon[arrets_tram_lyon$code_arret %in% data_tram_lyon$arret, 'nom_arret']

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# STATS
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Variable NB validations:


 Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 1       5      14      30      36     511 

     n    mean       sd         se lower95ci upper95ci
 577880 30.0009 42.45552 0.05584899  29.89144  30.11036

# Box plot Nb de validations
#png("Keolis_data/Lyon/Analyses_Taux/Boxplot_NombreValidation.png")
boxplot(data_tram_lyon$nb_validations, notch=TRUE, horizontal=TRUE, xlab="Nombre de Validations")
abline(v=mean(data_tram_lyon$nb_validations), col=2, lty=3)
#dev.off()
# Histogramme Nombre de Validation

#png("Keolis_data/Lyon/Analyses_Taux/Hist_NombreValidation.png")
hist(data_tram_lyon$nb_validations, type="h", col='lightblue', ylab="Fréquence", xlab="Nombre de Validations", main="")
#dev.off()

#png("Keolis_data/Lyon/Analyses_Taux/BOXPLOT_NombreValidation_vs_TH.png",width=1024)
qplot(periode, nb_validations, data=data_tram_lyon,  geom=c('boxplot'), xlab="Tranches Horaire", ylab="Nombre de Validation")
#dev.off()

#png("Keolis_data/Lyon/Analyses_Taux/BOXPLOT_NombreValidation_vs_Arret.png",width=1024)
qplot(factor(arret), nb_validations, data=data_tram_lyon,  geom=c('boxplot'), xlab="Arrêts", ylab="Nombre de Validations") + theme(axis.text.x = element_text(angle = 90, hjust = 1))
#dev.off()

   code_arret             nom_arret
1       46160               Debourg
2       32102              Perrache
3       32104   Quai Claude Bernard
4       32108           Saint-Andre
5       32118  Part-Dieu - Servient
7       32105   Quai Claude Bernard
8       32109           Saint-Andre
9       32119  Part-Dieu - Servient
11      46157              ENS Lyon
12      34834                Suchet
13      46158              ENS Lyon
14      32134   La Doua - G. Berger
15      34835                Suchet
16      32135   La Doua - G. Berger
17      32116     Palais de Justice
18      34067          Croix-Luizet
19      34836       Sainte-Blandine
20      34875 H. Region Montrochet.
21      32112               Liberte
22      32117     Palais de Justice
23      34068          Croix-Luizet
24      34837       Sainte-Blandine
25      46155    Halle Tony Garnier
26      32113               Liberte
27      32139       IUT - Feyssine.
28      46156    Halle Tony Garnier
29      32122    Thiers - Lafayette
31      32106   Rue de l'Universite
32      32120        Gare Part-Dieu
33      32123    Thiers - Lafayette
34      32128             Le Tonkin
35      32107   Rue de l'Universite
36      32114     Saxe - Prefecture
37      32124    College Bellecombe
38      32129             Le Tonkin
39      32136       INSA - Einstein
41      32115     Saxe - Prefecture
42      32125    College Bellecombe
43      32137       INSA - Einstein
44      35094 Musee des Confluences
45      46154 Musee des Confluences
46      32110           Guillotiere
47      32121       Gare  Part-Dieu
48      32126  Charpennes - C.Hernu
49      34874  H. Region Montrochet
50      32111           Guillotiere
51      32127  Charpennes - C.Hernu
53      32103             Perrache.
54      32130             Condorcet
55      32132     Universite Lyon 1
56      32138        IUT - Feyssine
57      32131             Condorcet
58      32133     Universite Lyon 1
60      46159               Debourg

 # 
for (i in 1:dim(arrets_tram_lyon)[1]) {
	# code & name
	code <- arrets_tram_lyon[i,"code_arret"]
	nom_arret <- arrets_tram_lyon[i,"nom_arret"]
	# Histogramme
	if (sum(data_tram_lyon$arret==code)) {
		#-3 indice ~  tranche horaire
		png(paste("Keolis_data/Lyon/Analyses_Taux/Boxplot_Indice_TH-", nom_arret, ".png", sep=''), width=1024)
		qplot(periode, nb_validations, data=data_tram_lyon[which(data_tram_lyon$arret==code),],  geom=c('boxplot'), xlab="Tranche Horaire", ylab="Log(Indice de Validation)", main=paste("Arrêt: ", nom_arret))
		dev.off()
	}	
}

#png("Keolis_data/Lyon/Analyses_Taux/BOXPLOT_NbValidations_vs_JourSem.png")
qplot(libelle_jour, log(nb_validations), data=data_tram_lyon,  geom=c('boxplot'), xlab="Jours de la semaine", ylab="Log(Nombre de Validations)") 
#dev.off()

summ(data_tram_lyon$nb_validations, by=data_tram_lyon$libelle_jour)
# For data_tram_lyon$libelle_jour = Lundi 
#  obs.  mean   median  s.d.   min.   max.  
#  81953 32.56  16      44.127 1      434   

# For data_tram_lyon$libelle_jour = Mardi 
#  obs.  mean   median  s.d.   min.   max.  
#  85245 34.54  18      45.646 1      511   

# For data_tram_lyon$libelle_jour = Mercredi 
#  obs.  mean   median  s.d.   min.   max.  
#  87127 34.58  18      45.994 1      449   

# For data_tram_lyon$libelle_jour = Jeudi 
#  obs.  mean   median  s.d.   min.   max.  
#  85258 34.56  18      45.728 1      499   

# For data_tram_lyon$libelle_jour = Vendredi 
#  obs.  mean   median  s.d.   min.   max.  
#  87876 34.31  18      44.996 1      416   

# For data_tram_lyon$libelle_jour = Samedi 
#  obs.  mean   median  s.d.   min.   max.  
#  79430 23.06  10      36.933 1      504   

# For data_tram_lyon$libelle_jour = Dimanche 
#  obs.  mean   median  s.d.   min.   max.  
#  70991 12.95  6       18.226 1      317 


# Taux de validations:

summary(data_tram_lyon$taux_validation)

#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#-62.000   0.107   0.300   0.267   0.500   0.998    4865 

#obs.   mean   median  s.d.   min.   max.  
#573015 0.267  0.3     0.52   -62    0.998 

# Nb ligne :            577880 (100%)
# Nb valeurs positives: 506696 (87.68%)
# Nb valeurs négative:  66319  (11.48%)
# Nb Missing:           4865   (0.84%)


df <- data.frame(
	tv_freq <-  c(87.86, 11.48, 0.84),
	tv_factors <- factor(c('Positives', 'Négatives', 'Manquantes'))
)

ggplot(df, aes(x = '', y = tv_freq, fill = tv_factors)) + geom_bar(width = 1, stat = "identity") + coord_polar("y", start = pi / 3)

summary(data_tram_lyon[data_tram_lyon$taux_validation>0,]$taux_validation)

#Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#0.003   0.221   0.364   0.397   0.546   0.998    4865

 #n      mean        sd           se lower95ci upper95ci
 #467821 0.3972288 0.2251242 0.0003291413 0.3965837 0.3978739


summary(data_tram_lyon[data_tram_lyon$taux_validation>=0,]$taux_validation)

#Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#0.000   0.182   0.333   0.367   0.521   0.998    4865 

#    n      mean        sd           se lower95ci upper95ci
# 506696 0.3667524 0.2407693 0.0003382419 0.3660894 0.3674153

#Hist Non-Validation

#png("Keolis_data/Lyon/Analyses_Taux/Hist_TauxNonValidation.png")
hist(data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation),]$taux_validation, col='lightblue', ylab="Densité", xlab="Taux de Non-Validation", main="", freq=FALSE)
x <- seq(-4, 4, .01)
y <- dnorm(x, mean=mean(data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation),]$taux_validation), sd=sqrt(var(data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation),]$taux_validation)))
lines(y ~ x, col=2, lty=3)
legend('topright', legend=c('Distribution Gaussienne Associée'),col=2, lty=3)
#dev.off()


#BoxPlot taux Non-Validation

# ~ .
#png("Keolis_data/Lyon/Analyses_Taux/Boxplot_TauxNonValidation.png")
boxplot(data_tram_lyon[data_tram_lyon$taux_validation>=0,]$taux_validation, notch=TRUE, horizontal=TRUE, xlab="Taux de Non-Validation", col='lightgrey')
abline(v=mean(data_tram_lyon[data_tram_lyon$taux_validation>=0  & !is.na(data_tram_lyon$taux_validation),]$taux_validation), col=2, lty=3)
#dev.off()

# ~ TH
#png("Keolis_data/Lyon/Analyses_Taux/BOXPLOT_TauxNonValidation_vs_TH.png",width=1024)
qplot(periode, taux_validation, data=data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation),],  geom=c('boxplot'), xlab="Tranches Horaire", ylab="Taux de Non-Validation")
#dev.off()

# ~ Arret
#png("Keolis_data/Lyon/Analyses_Taux/BOXPLOT_TauxNonValidation_vs_Arret.png",width=1024)
qplot(factor(arret), taux_validation, data=data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation),],  geom=c('boxplot'), xlab="Arrêts", ylab="Taux de Non-Validation") + theme(axis.text.x = element_text(angle = 90, hjust = 1))
#dev.off()

summ(data_tram_lyon[data_tram_lyon$taux_validation>=0,]$taux_validation, by=data_tram_lyon[data_tram_lyon$taux_validation>=0,]$arret)

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32102 
#  obs.  mean   median  s.d.   min.   max.  
#  10981 0.291  0.258   0.189  0      0.992 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32103 
#  obs.  mean   median  s.d.   min.   max.  
#  12454 0.368  0.333   0.216  0      0.991 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32104 
#  obs.  mean   median  s.d.   min.   max.  
#  10803 0.306  0.273   0.212  0      0.982 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32105 
#  obs.  mean   median  s.d.   min.   max.  
#  10036 0.312  0.281   0.222  0      0.979 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32106 
#  obs.  mean   median  s.d.   min.   max.  
#  10855 0.29   0.25    0.205  0      0.976 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32107 
#  obs.  mean   median  s.d.   min.   max.  
#  10974 0.387  0.381   0.226  0      0.968 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32108 
#  obs.  mean   median  s.d.   min.   max.  
#  10778 0.327  0.32    0.211  0      0.983 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32109 
#  obs.  mean   median  s.d.   min.   max.  
#  10544 0.434  0.454   0.23   0      0.983 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32110 
#  obs.  mean   median  s.d.   min.   max.  
#  12121 0.34   0.321   0.179  0      0.987 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32111 
#  obs.  mean   median  s.d.   min.   max.  
#  12215 0.348  0.325   0.195  0      0.992 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32112 
#  obs.  mean   median  s.d.   min.   max.  
#  10871 0.317  0.302   0.201  0      0.987 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32113 
#  obs.  mean   median  s.d.   min.   max.  
#  10347 0.383  0.382   0.231  0      0.981 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32114 
#  obs. mean   median  s.d.   min.   max.  
#  9862 0.331  0.333   0.216  0      0.982 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32115 
#  obs. mean   median  s.d.   min.   max.  
#  9583 0.356  0.348   0.22   0      0.971 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32116 
#  obs.  mean   median  s.d.   min.   max.  
#  10988 0.352  0.339   0.204  0      0.983 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32117 
#  obs.  mean   median  s.d.   min.   max.  
#  11208 0.372  0.368   0.213  0      0.98  

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32118 
#  obs. mean   median  s.d.   min.   max.  
#  9486 0.436  0.46    0.24   0      0.99  

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32119 
#  obs. mean   median  s.d.   min.   max.  
#  9487 0.346  0.333   0.22   0      0.967 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32120 
#  obs.  mean   median  s.d.   min.   max.  
#  12275 0.322  0.298   0.181  0      0.992 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32121 
#  obs.  mean   median  s.d.   min.   max.  
#  12143 0.365  0.339   0.199  0      0.986 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32122 
#  obs.  mean   median  s.d.   min.   max.  
#  11574 0.424  0.426   0.228  0      0.984 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32123 
#  obs.  mean   median  s.d.   min.   max.  
#  11258 0.306  0.286   0.196  0      0.979 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32124 
#  obs. mean   median  s.d.   min.   max.  
#  8745 0.422  0.444   0.259  0      0.963 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32125 
#  obs. mean   median  s.d.   min.   max.  
#  9712 0.289  0.273   0.209  0      0.968 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32126 
#  obs.  mean   median  s.d.   min.   max.  
#  11837 0.288  0.259   0.187  0      0.989 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32127 
#  obs.  mean   median  s.d.   min.   max.  
#  12221 0.376  0.358   0.201  0      0.989 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32128 
#  obs. mean   median  s.d.   min.   max.  
#  9028 0.619  0.667   0.241  0      0.979 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32129 
#  obs.  mean   median  s.d.   min.   max.  
#  10195 0.28   0.25    0.204  0      0.976 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32130 
#  obs. mean   median  s.d.   min.   max.  
#  8574 0.624  0.667   0.241  0      0.998 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32131 
#  obs. mean   median  s.d.   min.   max.  
#  9463 0.228  0.194   0.191  0      0.986 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32132 
#  obs. mean   median  s.d.   min.   max.  
#  5715 0.543  0.587   0.267  0      0.974 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32133 
#  obs. mean   median  s.d.   min.   max.  
#  7118 0.265  0.226   0.227  0      0.956 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32134 
#  obs. mean   median  s.d.   min.   max.  
#  9165 0.485  0.5     0.236  0      0.993 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32135 
#  obs. mean   median  s.d.   min.   max.  
#  8026 0.22   0.167   0.208  0      0.99  

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32136 
#  obs. mean   median  s.d.   min.   max.  
#  6405 0.693  0.765   0.244  0      0.986 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32137 
#  obs. mean   median  s.d.   min.   max.  
#  9076 0.217  0.179   0.186  0      0.989 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32138 
#  obs. mean   median  s.d.   min.   max.  
#  924  0.601  0.667   0.285  0      0.991 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 32139 
#  obs. mean   median  s.d.   min.   max.  
#  7865 0.405  0.393   0.265  0      0.998 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 34067 
#  obs. mean   median  s.d.   min.   max.  
#  626  0.657  0.75    0.302  0      0.983 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 34068 
#  obs. mean   median  s.d.   min.   max.  
#  8720 0.243  0.2     0.211  0      0.969 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 34834 
#  obs.  mean   median  s.d.   min.   max.  
#  11281 0.309  0.286   0.204  0      0.98  

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 34835 
#  obs.  mean   median  s.d.   min.   max.  
#  11333 0.449  0.463   0.223  0      0.989 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 34836 
#  obs.  mean   median  s.d.   min.   max.  
#  10904 0.248  0.217   0.185  0      0.987 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 34837 
#  obs.  mean   median  s.d.   min.   max.  
#  10457 0.57   0.605   0.236  0      0.983 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 34874 
#  obs. mean   median  s.d.   min.   max.  
#  9952 0.477  0.478   0.219  0      0.993 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 34875 
#  obs.  mean   median  s.d.   min.   max.  
#  10650 0.233  0.192   0.188  0      0.994 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 35094 
#  obs. mean   median  s.d.   min.   max.  
#  8650 0.341  0.333   0.222  0      0.991 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 46154 
#  obs. mean   median  s.d.   min.   max.  
#  6999 0.536  0.593   0.267  0      0.978 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 46155 
#  obs. mean   median  s.d.   min.   max.  
#  8188 0.296  0.272   0.219  0      0.988 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 46156 
#  obs. mean   median  s.d.   min.   max.  
#  7510 0.486  0.5     0.258  0      0.99  

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 46157 
#  obs. mean   median  s.d.   min.   max.  
#  9104 0.277  0.25    0.201  0      0.986 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 46158 
#  obs. mean   median  s.d.   min.   max.  
#  7396 0.563  0.615   0.257  0      0.98  

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 46159 
#  obs. mean   median  s.d.   min.   max.  
#  9277 0.279  0.246   0.201  0      0.989 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$arret = 46160 
#  obs. mean   median  s.d.   min.   max.  
#  737  0.814  0.9     0.216  0      0.986 
# ~ Jour de semaine
#png("Keolis_data/Lyon/Analyses_Taux/BOXPLOT_TauxNonValidation_vs_JourSem.png",width=1024)
qplot(libelle_jour, taux_validation, data=data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation),],  geom=c('boxplot'), xlab="Jours de la semaine", ylab="Taux de Non-Validation") #dev.off()
#dev.off()


summ(data_tram_lyon[data_tram_lyon$taux_validation>=0,]$taux_validation, by=data_tram_lyon[data_tram_lyon$taux_validation>=0,]$libelle_jour)

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$libelle_jour = Lundi 
#  obs.  mean   median  s.d.   min.   max.  
#  72134 0.354  0.333   0.235  0      0.99  

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$libelle_jour = Mardi 
#  obs.  mean   median  s.d.   min.   max.  
#  74798 0.347  0.318   0.233  0      0.991 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$libelle_jour = Mercredi 
#  obs.  mean   median  s.d.   min.   max.  
#  76325 0.355  0.333   0.234  0      0.998 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$libelle_jour = Jeudi 
#  obs.  mean   median  s.d.   min.   max.  
#  74244 0.364  0.333   0.237  0      0.988 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$libelle_jour = Vendredi 
#  obs.  mean   median  s.d.   min.   max.  
#  76970 0.366  0.333   0.234  0      0.99  

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$libelle_jour = Samedi 
#  obs.  mean   median  s.d.   min.   max.  
#  69770 0.39   0.364   0.253  0      0.993 

# For data_tram_lyon[data_tram_lyon$taux_validation >= 0, ]$libelle_jour = Dimanche 
#  obs.  mean   median  s.d.   min.   max.  
#  62455 0.398  0.385   0.258  0      0.998 

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Indice de validations: ALL

summary(data_tram_lyon$indice_val_s_mean)
#     Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
# 0.004603  0.636400  0.935200  0.993800  1.239000 17.080000 

summ(data_tram_lyon$indice_val_s_mean)
#  obs.   mean   median  s.d.   min.   max.  
#  577880 0.994  0.935   0.57   0.005  17.082

ci(data_tram_lyon$indice_val_s_mean)
#      n      mean        sd           se lower95ci upper95ci
# 577880 0.9938495 0.5670324 0.0007459145 0.9923875 0.9953114

log_indice_validation <- log(data_tram_lyon$indice_val_s_mean)

#png("Keolis_data/Lyon/Analyses_Taux/Hist_Indice.png")
hist(log_indice_validation, freq=F, col='lightblue', ylab="Densité", xlab="Log(Indice de Validation)", main="")
x <- seq(-4, 4, .01)
y <- dnorm(x, mean=mean(log(data_tram_lyon$indice_val_s_mean)), sd=sqrt(var(log(data_tram_lyon$indice_val_s_mean))))
lines(y ~ x, col=2, lty=3)
legend('topleft', legend=c('Distribution Normale Associée'), col=2, lty=3)
#dev.off()

#png("Keolis_data/Lyon/Analyses_Taux/Boxplot_Indice_Mois.png", width=650)
qplot(data_tram_lyon$libelle_mois, log_indice_validation,  geom=c('boxplot'), xlab="Mois", ylab="Log(Indice de Validation)")
#dev.off()

#png("Keolis_data/Lyon/Analyses_Taux/Boxplot_Indice_Jour.png", width=650)
qplot(data_tram_lyon$libelle_jour, log_indice_validation,  geom=c('boxplot'), xlab="Jour de la semaine", ylab="Log(Indice de Validation)")
#dev.off()

#png("Keolis_data/Lyon/Analyses_Taux/Boxplot_Indice_TH.png", width=1024)
qplot(periode, log_indice_validation, data=data_tram_lyon,  geom=c('boxplot'), xlab="Tranche Horaire", ylab="Log(Indice de Validation)")
#dev.off()

qplot(factor(arret), log_indice_validation, data=data_tram_lyon,  geom=c('boxplot'), xlab="Arrêt", ylab="Log(Indice de Validation)") + theme(axis.text.x = element_text(angle = 90, hjust = 1))




#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Indice de validations: Restricted to data_tram_lyon$taux_validation>=0


summary(data_tram_lyon[data_tram_lyon$taux_validation>=0,]$indice_val_s_mean)
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
#  0.005   0.621   0.916   0.965   1.211  14.070    4865 

summ(data_tram_lyon[data_tram_lyon$taux_validation>=0,]$indice_val_s_mean)
#obs.   mean   median  s.d.   min.   max.  
#  506696 0.965  0.916   0.53   0.005  14.067


ci(data_tram_lyon[data_tram_lyon$taux_validation>=0,]$indice_val_s_mean)
#   n      mean        sd           se lower95ci upper95ci
# 506696 0.9649963 0.5301157 0.0007447267 0.9635367  0.966456

log_indice_validation_2 <- log(data_tram_lyon[data_tram_lyon$taux_validation>=0,]$indice_val_s_mean)

#png("Keolis_data/Lyon/Analyses_Taux/Hist_Indice.png")
hist(log_indice_validation_2, freq=F, col='lightblue', ylab="Densité", xlab="Log(Indice de Validation)", main="")
x <- seq(-4, 4, .01)
y <- dnorm(x, mean=mean(log(data_tram_lyon[data_tram_lyon$taux_validation>=0,]$indice_val_s_mean)), sd=sqrt(var(log(data_tram_lyon[data_tram_lyon$taux_validation>=0,]$indice_val_s_mean))))
lines(y ~ x, col=2, lty=3)
legend('topleft', legend=c('Distribution Normale Associée'), col=2, lty=3)
#dev.off()


#png("Keolis_data/Lyon/Analyses_Taux/Boxplot_Indice_Mois.png", width=650)
qplot(data_tram_lyon[data_tram_lyon$taux_validation>=0,]$libelle_mois, log_indice_validation_2,  geom=c('boxplot'), xlab="Mois", ylab="Log(Indice de Validation)")
#dev.off()

#png("Keolis_data/Lyon/Analyses_Taux/Boxplot_Indice_Jour.png", width=650)
qplot(data_tram_lyon[data_tram_lyon$taux_validation>=0,]$libelle_jour, log_indice_validation_2,  geom=c('boxplot'), xlab="Jour de la semaine", ylab="Log(Indice de Validation)")
#dev.off()

#png("Keolis_data/Lyon/Analyses_Taux/Boxplot_Indice_TH.png", width=1024)
qplot(periode[data_tram_lyon$taux_validation>=0], log_indice_validation_2, data=data_tram_lyon,  geom=c('boxplot'), xlab="Tranche Horaire", ylab="Log(Indice de Validation)")
#dev.off()

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Taux de Non-Validation VS Indice
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#plot taux_validation ~ indice_val_s_mean
#png("Keolis_data/Lyon/Analyses_Taux/plot_Taux_vs_Indice.png", width=650)
plot(taux_validation ~ indice_val_s_mean, data=data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation),], pch=19, xlab="Indice de Validation", ylab="Taux de Non-Validation")
#dev.off()


#++++++++++
# Corr
#++++++++++
cor(data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation),]$taux_validation, data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation),]$indice_val_s_mean, , method = c("spearman"))
# Spearman cor = -32.56%

# Correlation by Station
#sink("Keolis_data/Lyon/Corr_TAUX_INDICE_Arret.txt")
CODE <- c()
ARRET <- c()
CORR <- c()
for (i in 1:dim(arrets_tram_lyon)[1]) {
	# code & name
	code <- arrets_tram_lyon[i,"code_arret"]
	nom_arret <- arrets_tram_lyon[i,"nom_arret"]
	# Corr
	if (sum(data_tram_lyon$arret==code)) {
		TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & data_tram_lyon$arret==code,]$taux_validation
		INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & data_tram_lyon$arret==code,]$indice_val_s_mean
		COR <- cor(TAUX, INDICE, use="complete.obs", method="spearman")
		print(paste("Code Arrêt: ", code ," Arrêt: ", nom_arret, ', Corr=',  COR))
		CODE <- cbind(CODE, code)
		ARRET <- cbind(ARRET, nom_arret)
		CORR <- cbind(CORR, COR)
	}
}
# sink()

#png("Keolis_data/Lyon/Analyses_Taux/DIST_CORR_Taux_vs_Indice.png", width=650)
boxplot(CORR[!is.na(CORR)], horizontal=T, notch=T, col="lightblue", xlab="Corrélation de Spearman")
abline(v=mean(CORR[!is.na(CORR)]), col=2, lty=3)
legend('topleft', legend=c('Taux de corrélation moyen'), col=2, lty=3)
#dev.off()

# Correlation by Tranche Horaire
#sink("Keolis_data/Lyon/Corr_TAUX_INDICE_THoraire.txt")
TH <- unique(data_tram_lyon$periode)
CORR_TH <- c()
for (i in 1:length(TH)) {
	# Corr
		TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & data_tram_lyon$periode==TH[i],]$taux_validation
		INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & data_tram_lyon$periode==TH[i],]$indice_val_s_mean
		COR <- cor(TAUX, INDICE, use="complete.obs", method="spearman")
		CORR_TH <- cbind(CORR_TH, COR)
		print(paste("Periode", TH[i], ', Corr=',  COR))
}
#sink()

#png("Keolis_data/Lyon/Analyses_Taux/DIST_CORR_Taux_vs_Indice_TH.png", width=650)
boxplot(CORR_TH[!is.na(CORR_TH)], horizontal=T, notch=T, col="lightblue", xlab="Corrélation de Spearman")
abline(v=mean(CORR_TH[!is.na(CORR_TH)]), col=2, lty=3)
legend('topleft', legend=c('Taux de corrélation moyen'), col=2, lty=3)
#dev.off()

#++++++++++
# MI
#++++++++++

TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>=0  & !is.na(data_tram_lyon$taux_validation) & !is.na(data_tram_lyon$indice_val_s_mean) ,]$taux_validation
INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation) & !is.na(data_tram_lyon$indice_val_s_mean) ,]$indice_val_s_mean
y2D <- discretize2d(TAUX, INDICE, numBins1=100, numBins2=100)
H1 <- entropy(rowSums(y2D))
H2 <- entropy(colSums(y2D))
H12 <- entropy(y2D)
(mi <- (H1+H2-H12)/min(H1, H2))

# MI : 5.60%
MI_TH  <- c()
TH <- unique(data_tram_lyon$periode)
for (i in 1:length(TH)) {
	# Corr
		TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>=0  & !is.na(data_tram_lyon$taux_validation) & data_tram_lyon$periode==TH[i],]$taux_validation
		INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation) & data_tram_lyon$periode==TH[i],]$indice_val_s_mean
		y2D <- discretize2d(log(TAUX+1), log(INDICE+1), numBins1=100, numBins2=100)
		H1 <- entropy(rowSums(y2D))
		H2 <- entropy(colSums(y2D))
		H12 <- entropy(y2D)
		mi <- (H1+H2-H12)/min(H1, H2)
		print(paste("Periode", TH[i], ', MI=',  mi))
		MI_TH  <- cbind(MI_TH, mi)
}

#png("Keolis_data/Lyon/Analyses_Taux/DIST_MI_Taux_vs_Indice_TH.png", width=650)
boxplot(MI_TH[!is.na(MI_TH)], horizontal=T, notch=T, col="lightblue", xlab="Information Mutuelle Normalisée")
abline(v=mean(MI_TH[!is.na(MI_TH)]), col=2, lty=3)
legend('topright', legend=c('Information Mutuelle moyenne'), col=2, lty=3)
#dev.off()

MI_ARRET  <- c()
for (i in 1:dim(arrets_tram_lyon)[1]) {
	# code & name
	code <- arrets_tram_lyon[i,"code_arret"]
	nom_arret <- arrets_tram_lyon[i,"nom_arret"]
	# Corr
	if (sum(data_tram_lyon$arret==code)) {
		TAUX <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation) & data_tram_lyon$arret==code ,]$taux_validation
		INDICE <- data_tram_lyon[data_tram_lyon$taux_validation>=0 & !is.na(data_tram_lyon$taux_validation) & data_tram_lyon$arret==code,]$indice_val_s_mean
		y2D <- discretize2d(TAUX, INDICE, numBins1=50, numBins2=50)
		H1 <- entropy(rowSums(y2D))
		H2 <- entropy(colSums(y2D))
		H12 <- entropy(y2D)
		mi <- (H1+H2-H12)/min(H1, H2)
		print(paste("Arrêt: ", nom_arret, ', MI:',  mi))
		MI_ARRET  <- cbind(MI_ARRET, mi)
	}
}


#png("Keolis_data/Lyon/Analyses_Taux/DIST_MI_Taux_vs_Indice_ARRET.png", width=650)
boxplot(MI_ARRET[!is.na(MI_ARRET)], horizontal=T, notch=T, col="lightblue", xlab="Information Mutuelle Normalisée")
abline(v=mean(MI_ARRET[!is.na(MI_ARRET)]), col=2, lty=3)
legend('topright', legend=c('Information Mutuelle moyenne'), col=2, lty=3)
#dev.off()


#++++++++++++++++++++++++

TS_diff[TS_diff>=0]

TS_diff <- data_tram_lyon$diff_entrees_validations

x <- as.vector(time(TS_diff))

model <- lm( TS_diff ~
						   sin(2*pi*x/1108) + cos(2*pi*x/1108)
						 + sin(2*pi*x/39) + cos(2*pi*x/39) 
						 + sin(2*pi*x/19) + cos(2*pi*x/19) )

plot(TS_diff ~ x, type='l')

lines(predict(model)~x, col='red')


plot(predict(model)[1:50]~x[1:50], col='red', type='l')
lines(TS_diff[1:50]~x[1:50], col='green')


plot(TS_diff[1:200] ~ x[1:200], type='l')

pred <- predict(model_52_dimance, interval="predict", level = 0.9)

lines(pred[,1]~x, col='red')

lines(pred[,2]~x, col='red', lty=3)

lines(pred[,3]~x, col='red', lty=3)


fit <- auto.arima(count[1:ceiling(length(count)/2)])
plot(forecast(fit, h=30))


#@@@@@@@@@@@@@@@

newdata <- data_tram_lyon[which(data_tram_lyon$diff_entrees_validations>=0 & !is.na(data_tram_lyon$diff_entrees_validations)),]
tramTS <- data.frame(newdata$date_TH, newdata$diff_entrees_validations)
detectMod <- AnomalyDetectionTs(tramTS, max_anoms=0.3, direction='pos', plot=TRUE, alpha=.05, longterm=TRUE, ylabel ="Nombre de Validations")

count <- tramTS[,2]
fit <- auto.arima(count[1:ceiling(length(count)/2)])
plot(forecast(fit, h=30))



