set.seed(20)

x <- rnorm(100, 1, 3)
mx <- mean(x)
stdx <- sqrt(var(x))
x <- (x - mx)/stdx

CUMSUM <- function(x) {
     res <- numeric(length(x))
     for (i in seq_along(x) + 1) {
         res[i] <- max(0, res[i-1] + x[i-1] - mx)
     }
     res
 }

U <- mx + stdx
L <- mx - stdx

plot(CUMSUM(x), type='b', ylim=c(U+sqrt(mx), L-sqrt(mx)))
abline(h=U, col=2)
abline(h=L, col=2)


library(qcc)

MyCUSUM <- cusum(x, sizes=1, center=mx, std.dev=stdx, decision.interval = U, se.shift =.5)

summary(MyCUSUM)