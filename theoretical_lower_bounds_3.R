# this script generates the second 3d-plot in the main paper
# (Figure 2, right-hand side)
library(latex2exp)
library(lattice)
# z transform
z <- function(x) {
  val <- 1/2 * log((1 + x) / (1 - x))
  return(val)
}
# inverse z-transform
z_inv <- function(x) {
  val <- (exp(2 * x) - 1) / (exp(2 * x) + 1)
  return(val)
}
#Q_1\{2}
qz <- 1
# |Z|
sz <- 1
# n's
ns <- seq(100, 800, 20)
# n_2's
ns2 <- seq(0.5, 1, 0.05)

# true rho_{X_1Y2|Z}
rho <- 0.05

data <- data.frame(
  ns = rep(ns, each = length(ns2)),
  ns2 = rep(ns2, length(ns))
)
data$results <- sqrt(1 - rho^2 / (z_inv( ((data$ns - 3 - sz)^0.5 * z(rho))  / ((data$ns2 * data$ns - 3 - sz - qz)^0.5)))^2)

# font sizes
fz <- 0.6
fz2 <- 0.85
wireframe(results ~ ns2 * ns, data = data, xlab = list(label = TeX("$n_2/n$"), cex = fz2, rot = 310), ylab = list(label = TeX("$n$"), cex = fz2), zlab = list(label = TeX("$|\\rho_{Y_1Y_2|Z}|$"), cex = fz2, rot = 270), screen =
            list(z = -65, x = -70), scales=list(arrows=FALSE,  x=list(cex=fz), y=list(cex=fz), z = list(cex=fz)))
⎄
