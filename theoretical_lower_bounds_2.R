# this script generates the first 3d-plot in the main paper
# (Figure 2, left-hand side)
library(lattice)
library(latex2exp)
alpha <- 0.05
rhoX1Y2 <- 0.05
# Q_i\{j}
qz <- 1
betas <- seq(0.3, 0.9, 0.02)
rhosY1Y2 <- seq(0.4, 0.8, 0.02)
data <- data.frame(
  betas = rep(betas, each = length(rhosY1Y2)),
  rhosY1Y2s = rep(rhosY1Y2, length(betas))
)
# z transform
z <- function(x) {
  val <- 1/2 * log((1 + x) / (1 - x))
  return(val)
}
# inverse z transform
z_inv <- function(x) {
  val <- (exp(2 * x) - 1) / (exp(2 * x) + 1)
  return(val)
}

rhosX1Y2_Y1 <- rhoX1Y2 / (1 - data$rhosY1Y2^2)^0.5
data$dn <- ((qnorm(1-alpha / 2) - qnorm(1 - data$betas + alpha / 2)) / z(rhoX1Y2))^2 -
  ((qnorm(1-alpha / 2) - qnorm(1 - data$betas)) / z(rhosX1Y2_Y1))^2 -
  1
# fontsizes
fz <- 0.6
fz2 <- 0.85
wireframe(dn ~ rhosY1Y2s * betas, data = data, xlab = list(label = TeX("$\\rho_{Y_1Y_2|Z}$"), cex = fz2, rot = 310),
          ylab = list(label = TeX("$\\beta$"), cex = fz2), zlab = list(label = TeX("$\\Delta n$"), cex = fz2), 
          screen = list(z = -245, x = -70), scales=list(arrows=FALSE,  x=list(cex=fz), y=list(cex=fz), z = list(cex=fz))) 




