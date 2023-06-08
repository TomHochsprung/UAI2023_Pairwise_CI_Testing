test_ci_by_par_cor <- function(x, y, z) {
  #' Test independence between two random variables x and y given a third
  #' random variable z. Each vector is assumed to have n observations
  #' @param x matrix of size n * 1
  #' @param y vector of size n * 1
  #' @param z vector of size n * k
  #' @examples 
  #' # No conditioning vector z
  #' test_ci_by_par_cor(cbind(rnorm(100)), cbind(rnorm(100)), matrix(numeric(0), nrow = 100, ncol = 0))
  #' # With conditioning vector z
  #' test_ci_by_par_cor(cbind(rnorm(100)), cbind(rnorm(100)), cbind(rnorm(100), rnorm(100)))
  #' @return a list of the p-value and the test-statistic
  n <- dim(x)[1]
  k <- dim(z)[2]
  
  # decide whether to use partial correlation or usual correlation
  if(k == 0) {
    parcor = cor(x, y)
  } else {
    res1 <- lm(x ~ z - 1)$residuals
    res2 <- lm(y ~ z - 1)$residuals
    parcor <- cor(res1, res2)
  }
  z_parcor <- 1/2 * log((1 + parcor) / (1 - parcor))
  teststat <- (n - 3 - k)^0.5 * z_parcor 
  pval <- 2 * pnorm(abs(teststat), lower.tail = FALSE)
  
  return(list(pval, teststat))
}
