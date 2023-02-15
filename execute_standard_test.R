execute_standard_test <- function(x, y, z,
                           alpha_pre,
                           sbo,
                           mcs,
                           ci_test = "par_corr") {
  #' Standard pairwise independence testing as in Section 3.2 and 3.3 of the paper
  #' @param x matrix of size n * dim_X
  #' @param y vector of size n * dim_Y
  #' @param z vector of size n * dim_Z
  #' @param sbo fraction of samples for step 1, number between 0 and 1
  #' @param mcs maximum size of the conditioning set
  #' @param ci_test indicates the ci_test that should be used: either partial
  # correlation ("par_corr") or the generalized covariance measure ("gcm")
  #' @return a p-value
  dim_X <- dim(x)[2]
  dim_Y <- dim(y)[2]
  dim_Z <- dim(z)[2]
  n <- dim(x)[1]
  
  p_vals <- matrix(numeric(dim_X * dim_Y), nrow = dim_X)
  test_stats <- matrix(numeric(dim_X * dim_Y), nrow = dim_X)
  
  # start pairwise testing
  for(j in 1:dim_X) {
    
    for(jj in 1:dim_Y) {
      
      if(ci_test == "par_corr") {
        
        test_result <- test_ci_by_par_cor(X[, j, drop = FALSE],
                                          Y[, jj, drop = FALSE],
                                          Z)
        p_vals[j, jj] <- test_result[[1]]
        test_stats[j, jj] <- abs(test_result[[2]])
        
      } else if (ci_test == "gcm") {
        
        test_result <- gcm.test(X[, j, drop = FALSE],
                                Y[, jj, drop = FALSE],
                                Z,
                                regr.method = "gam")
        p_vals[j, jj] <- test_result$p.value
        test_stats[j, jj] <- test_result$test.statistic
        
      }
    }
  }
  
  # aggregate univariate test or test statistics by Bonferroni
  p_vals <- as.numeric(p_vals)
  test_stats <- as.numeric(test_stats)
  t_tot <- max(abs(test_stats))
  p_tot <- p.adjust(min(p_vals, na.rm = TRUE),
                      method = "bonferroni",
                      n = length(p_vals))
  
  return(p_tot)
}
