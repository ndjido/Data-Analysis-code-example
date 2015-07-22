
# libs
require('lme4')
require('MASS')
require('epicalc')
require('languageR')
require('lmerTest')

lyon_taux_fraude_mesure <- read.table('Lyon_TauxFraudeMesure_TauxControle.csv', sep=';', header=TRUE)

summary(lyon_taux_fraude_mesure)

cor(lyon_taux_fraude_mesure$taux_de_controle, lyon_taux_fraude_mesure$taux_de_fraude_mesure, use="complete.obs")

lyon_taux_fraude_mesure <- lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$Nombre_de_titres_incorrects <= lyon_taux_fraude_mesure$Nombre_de_controles,]

lyon_taux_fraude_mesure$weekend <- lyon_taux_fraude_mesure$Jour=="Samedi" | lyon_taux_fraude_mesure$Jour=="Dimanche"


# Filtering

#lyon_taux_fraude_mesure <- lyon_taux_fraude_mesure[which(lyon_taux_fraude_mesure$taux_de_fraude_mesure!=0 ),]

#lyon_taux_fraude_mesure <- lyon_taux_fraude_mesure[which(lyon_taux_fraude_mesure$taux_de_fraude_mesure!=1 ),]

# Model: weekend
model1 <- lm(taux_de_fraude_mesure ~ log(taux_de_controle), data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$weekend==TRUE,])
summary(model1)

plot(taux_de_fraude_mesure ~ taux_de_controle, pch=20, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$weekend==TRUE,])
abline(model1, col=2, lwd=2)


model1_ <- locfit(taux_de_fraude_mesure ~ taux_de_controle, alpha=c(0, 0.1), deg=1, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$weekend==TRUE,])

plot(taux_de_fraude_mesure ~ taux_de_controle, pch=20, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$weekend==TRUE,])
lines(model1_, col=2, lwd=2)

# Model: Jour ouvres
model2 <- lm(taux_de_fraude_mesure ~ log(taux_de_controle), data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$weekend==FALSE,])
summary(model2)

plot(taux_de_fraude_mesure ~ taux_de_controle, pch=20, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$weekend==TRUE,])
abline(model2, col=2, lwd=2)


model2_ <- locfit(taux_de_fraude_mesure ~ taux_de_controle, alpha=c(0, 0.1), deg=1, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$weekend==TRUE,])

plot(taux_de_fraude_mesure ~ taux_de_controle, pch=20, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$weekend==TRUE,])
lines(model2_, col=2, lwd=2)


#
# Model: T1 : arrêt 32102
model3 <- lm(taux_de_fraude_mesure ~ log(taux_de_controle), data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$arret==32102,])
summary(model3)

plot(taux_de_fraude_mesure ~ taux_de_controle, pch=20, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$arret==32102,])
abline(model3, col=2, lwd=2)

# Model: T1 : arrêt 32103
model4 <- lm(taux_de_fraude_mesure ~ log(taux_de_controle), data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$arret==32103,])
summary(model4)

plot(taux_de_fraude_mesure ~ taux_de_controle, pch=20, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$arret==32103,])
abline(model4, col=2, lwd=2)

#+++++++++++++++++


model5 <- lm(taux_de_fraude_mesure ~ log(taux_de_controle), data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$arret==32104,])
summary(model5)

plot(taux_de_fraude_mesure ~ taux_de_controle, pch=20, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$arret==32104,])
abline(model5, col=2, lwd=2)


#++++++++++++++++++++++++++++++++++++++++++++

model7 <- locfit(taux_de_fraude_mesure ~ taux_de_controle, alpha=c(0, 0.1), deg=1, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$arret==32104,])

nu = as.numeric(model7$dp[6])
nutilde = as.numeric(model7$dp[7])

sigmasqrhat = sum(residuals(model7)^2)/(dim(lyon_taux_fraude_mesure)[1]-2*nu+nutilde)

critval = kappa0(model7)$crit.val

diaghat = predict(model7,where="data",what="infl")
norm_ = predict(model7,where="data",what="vari")

plot(taux_de_fraude_mesure ~ taux_de_controle, pch=20, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$arret==32104,])
lines(model7, col=2, lwd=2)

lines(fitted(model7)+critval*sqrt(sigmasqrhat*norm_) ~ taux_de_controle, col=2, lwd=3, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$arret==32104,])
lines(fitted(model7)-critval*sqrt(sigmasqrhat*norm_) ~ taux_de_controle, col=2, lwd=3, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$arret==32104,])

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

lyon_taux_fraude_mesure <- lyon_taux_fraude_mesure[which(lyon_taux_fraude_mesure$taux_de_fraude_mesure!=0 ),]

lyon_taux_fraude_mesure <- lyon_taux_fraude_mesure[which(lyon_taux_fraude_mesure$taux_de_fraude_mesure!=1 ),]

lyon_taux_fraude_mesure <- lyon_taux_fraude_mesure[which(lyon_taux_fraude_mesure$taux_de_controle!=0 ),]

lyon_taux_fraude_mesure <- lyon_taux_fraude_mesure[which(lyon_taux_fraude_mesure$taux_de_controle!=1 ),]

model_lm_1_ <- locfit(taux_de_fraude_mesure ~ log(taux_de_controle), data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$arret==32104,])

#plot(taux_de_fraude_mesure ~ taux_de_controle, pch=20, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$weekend==TRUE,])
Arrets <- unique(lyon_taux_fraude_mesure$arret)


png('TauxFM_TauxCtl_Lyon_T1_LMLog.png', width=1024, height=650)

plot(taux_de_fraude_mesure ~ taux_de_controle, lwd=2, ylim=c(0,1), pch=20, cex=.3, data=lyon_taux_fraude_mesure,
     xlab="Taux de contrôle",
     ylab="Taux de fraude mesuré",
     main="Modélisation du taux de fraude mesuré par les contrôle sur le T1 à Lyon")
grid()
for (i in 1:40) {
  model_lm__ <- lm(taux_de_fraude_mesure ~ log(taux_de_controle), data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$arret==Arrets[i],])
  abline(model_lm__, col=i)
  }

dev.off()

# legend("toptop", legend=Arrets, col=1:length(Arrets), lwd=2, lty=1)



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

model1_ <- locfit(taux_de_fraude_mesure ~ taux_de_controle, alpha=c(0, 0.1), deg=1, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$arret==32104,])

#plot(taux_de_fraude_mesure ~ taux_de_controle, pch=20, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$weekend==TRUE,])
Arrets <- unique(lyon_taux_fraude_mesure$arret)

png('TauxFM_TauxCtl_Lyon_T1.png', width=1024, height=650)

plot(model1_, col=0, lwd=3, ylim=c(0,1),
     xlab="Taux de contrôle",
     ylab="Taux de fraude mesuré",
     main="Modélisation du taux de fraude mesuré par les contrôle sur le T1 à Lyon")
grid()
for (i in 1:40) {
  model_ <- locfit(taux_de_fraude_mesure ~ taux_de_controle, alpha=c(0, 0.1), deg=1, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$arret==Arrets[i],])
  lines(model_, col=i)
  }

dev.off()

# legend("toptop", legend=Arrets, col=1:length(Arrets), lwd=2, lty=1)


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


model2_ <- locfit(taux_de_fraude_mesure ~ taux_de_controle, alpha=c(0, 0.1), deg=1, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$arret==32104 & lyon_taux_fraude_mesure$weekend==FALSE,])

plot(model2_, col=0, lwd=3, ylim=c(0,1),
     xlab="Taux de contrôle",
     ylab="Taux de fraude mesuré",
     main="Modélisation du taux de fraude mesuré par les contrôle sur le T1 à Lyon")
grid()
for (i in 2:35) {
  model_ <- locfit(taux_de_fraude_mesure ~ taux_de_controle, alpha=c(0, 0.1), deg=1, data=lyon_taux_fraude_mesure[lyon_taux_fraude_mesure$arret==Arrets[i] & lyon_taux_fraude_mesure$weekend==FALSE,])
  lines(model_, col=i)
  }



#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

lyon_taux_fraude_mesure_2 <- lyon_taux_fraude_mesure[,c("date", "periode", "taux_de_fraude_mesure", "taux_de_controle", "arret")]

write.table(lyon_taux_fraude_mesure_2, "lyon_taux_fraude_mesure_2.csv", sep=";", row.names=FALSE)


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
