execute_novel_test <- function(x, y, z,
                           alpha_pre,
                           sbo,
                           mcs,
                           ci_test = "par_corr",
                           indep_set = NULL) {
  #' Novel pairwise independence testing as in Section 3.2 and 3.3 of the paper
  #' @param x matrix of size n * dim_X
  #' @param y vector of size n * dim_Y
  #' @param z vector of size n * dim_Z
  #' @param sbo fraction of samples for step 1, number between 0 and 1
  #' @param mcs maximum size of the conditioning set
  #' @param ci_test indicates the ci_test that should be used: either partial
  # correlation ("par_corr") or the generalized covariance measure ("gcm")
  #' @param indep_set set of a priori known conditional independencies, should be
  #' entered as a matrix with 2 columns. The first column corresponds to X_i
  #' and the second column corresponds to Y_j
  #' @return a p-value
  dim_X <- dim(x)[2]
  dim_Y <- dim(y)[2]
  dim_Z <- dim(z)[2]
  n <- dim(x)[1]
  
  "first step of the algorithm, that either learns conditional
  independencies or does nothing, when conditional independencies are known
  are priori"
  p_vals_pre <- matrix(numeric(dim_X * dim_Y), nrow = dim_X)
  if (is.null(indep_set) == TRUE) {
    
    for(j in 1:dim_X) {
      
      for(jj in 1:dim_Y) {
        
        if (ci_test == "par_corr") {
          test_result <- test_ci_by_par_cor(X[1:floor(sbo * n), j, drop = FALSE],
                                            Y[1:floor(sbo * n), jj, drop = FALSE],
                                            Z[1:floor(sbo * n), , drop = FALSE])
          p_vals_pre[j, jj] <- test_result[[1]]
        } else if (ci_test == "gcm") {
          p_vals_pre[j, jj] <-gcm.test(X[1:floor(sbo * n), j, drop = FALSE],
                                       Y[1:floor(sbo * n), jj, drop = FALSE],
                                       Z[1:floor(sbo * n), , drop = FALSE],
                                       regr.method = "gam")$p.value
        }
      }
    }
    indep_set <- which(p_vals_pre > alpha_pre, arr.ind = TRUE)
    
  } else {
    sbo = 0
  }

  # main step of the algorithm
  p_vals_main <- matrix(numeric(dim_X * dim_Y), nrow = dim_X)
  test_stats <- matrix(numeric(dim_X * dim_Y), nrow = dim_X)
  
  for(j in 1:dim_X) {
    for(jj in 1:dim_Y) {
      indicesY <- numeric(0)
      indicesX <- numeric(0)
      
      if (j %in% indep_set[, 1]) {
        indicesY <- setdiff(indep_set[indep_set[, 1] == j, 2], jj)
      }
      if (jj %in% indep_set[, 2]) {
        indicesX <- setdiff(indep_set[indep_set[, 2] == jj, 1], j)
      }
      if(length(indicesX) >= length(indicesY)) {
        if(length(indicesX) > mcs) {
          indicesX <- sample(indicesX, mcs, replace = FALSE)
        }
        if (ci_test == "par_corr") {
          test_result <- test_ci_by_par_cor(X[(floor(sbo * n) + 1):n, j, drop = FALSE],
                                            Y[(floor(sbo * n) + 1):n, jj, drop = FALSE],
                                            cbind(Z[(floor(sbo * n) + 1):n, , drop = FALSE],
                                                  X[(floor(sbo * n) + 1):n, indicesX,
                                                    drop = FALSE]))
          p_vals_main[j, jj] <- test_result[[1]]
          test_stats[j, jj] <- abs(test_result[[2]])

        } else if (ci_test == "gcm") {
          p_vals_main[j, jj] <- gcm.test(X[(floor(sbo * n) + 1):n, j, drop = FALSE],
                                         Y[(floor(sbo * n) + 1):n, jj, drop = FALSE],
                                         cbind(Z[(floor(sbo * n) + 1):n, , drop = FALSE],
                                               X[(floor(sbo * n) + 1):n,
                                                 indicesX,
                                                 drop = FALSE]),
                                         regr.method = "gam")$p.value
        }
      } else {
        if(length(indicesY) > mcs) {
          indicesY <- sample(indicesY, mcs, replace = FALSE)
        }
        if (ci_test == "par_corr") {
          test_result <- test_ci_by_par_cor(X[(floor(sbo * n) + 1):n, j, drop = FALSE],
                                            Y[(floor(sbo * n) + 1):n, jj, drop = FALSE],
                                            cbind(Z[(floor(sbo * n) + 1):n, , drop = FALSE],
                                                  Y[(floor(sbo * n) + 1):n,
                                                    indicesY,
                                                    drop = FALSE]))
          p_vals_main[j, jj] <- test_result[[1]]
          test_stats[j, jj] <- abs(test_result[[2]])
      
        } else if (ci_test == "gcm") {
          p_vals_main[j, jj] <- gcm.test(X[(floor(sbo * n) + 1):n, j, drop = FALSE],
                                         Y[(floor(sbo * n) + 1):n, jj, drop = FALSE],
                                         cbind(Z[(floor(sbo * n) + 1):n, , drop = FALSE], Y[(floor(sbo * n) + 1):n, indicesY, drop = FALSE]),
                                         regr.method = "gam")$p.value
        }
      }
    }
  }
  
  # aggregate univariate test or test statistics by Bonferroni
  
  p_vals_main <- as.numeric(p_vals_main)
  test_stats <- as.numeric(test_stats)
  t_tot <- max(abs(test_stats))
  p_tot_main <- p.adjust(min(p_vals_main, na.rm = TRUE),
                           method = "bonferroni",
                           n = length(p_vals_main))
  
  return(p_tot_main)
}
