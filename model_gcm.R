# model for the simulations regarding the Generalized Covariance Measure in
# the Appendix

Z <- rnorm(n)

if ((dim_X == 2) & (dim_Y == 2)) {
  
  X1 <- exp(-Z^2 / 2) * sin(Z) + 0.3 * rnorm(n)
  X2 <- exp(-Z^2 / 2) * sin(Z) + 0.3 * rnorm(n) + tau * X1
  Y1 <- exp(-Z^2 / 2) * sin(Z) + 0.3 * rnorm(n)
  Y2 <- exp(-Z^2 / 2) * sin(Z) + 0.3 * rnorm(n) + tau * Y1 + rho * X2
  X <- cbind(X1, X2)
  Y <- cbind(Y1, Y2)
  
} else if ((dim_X == 3) & (dim_Y == 3)){
  
  X1 <- exp(-Z^2 / 2) * sin(Z) + 0.3 * rnorm(n)
  X2 <- exp(-Z^2 / 2) * sin(Z) + 0.3 * rnorm(n) + tau * X1
  X3 <- exp(-Z^2 / 2) * sin(Z) + 0.3 * rnorm(n) + tau * X2
  Y1 <- exp(-Z^2 / 2) * sin(Z) + 0.3 * rnorm(n)
  Y2 <- exp(-Z^2 / 2) * sin(Z) + 0.3 * rnorm(n) + tau * Y1
  Y3 <- exp(-Z^2 / 2) * sin(Z) + 0.3 * rnorm(n) + tau * Y2 + rho * X3
  X <- cbind(X1, X2, X3)
  Y <- cbind(Y1, Y2, Y3)
  
}
indep_set <- expand.grid(1:dim_X, 1:(dim_Y - 1))
Z <- cbind(Z)