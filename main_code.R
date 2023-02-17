library(GeneralisedCovarianceMeasure)
library(mvtnorm)
library(energy)
source("test_ci_by_par_cor.R")
source("execute_standard_test.R")
source("execute_novel_test.R")


set.seed(2021) # random seed

N <- 100 # number of replications
kappa <- 0.5 # related to max conditioning set
sample_sizes <- c(216, 432, 864)
alpha <- 0.05 # significance level for the main step
alpha_pre <- 0.5 # significance level for the pre step

dims_X_Y <- c(5, 7)
dim_Z <- 1
rhos <- seq(0, 0.15, 0.005) # between-group correlations
tau <- 0.9 # within-group correlation

# choose conditional independence test: either "par_corr" or "gcm"
ci_test = "par_corr"

# initialization of storage dataframe
rejection_rate_df <- as.data.frame(matrix(numeric(0), ncol = 9))
names(rejection_rate_df) <-
  c("n",
    "mean_rejection_rate",
    "se_rejection_rate",
    "alg",
    "rho",
    "tau",
    "dim_X",
    "dim_Y",
    "dim_Z")

"iteration through all possible dimensions, between-group dependencies and 
 sample sizes"
for(dim_X_Y in dims_X_Y) {
  
  dim_X <- dim_X_Y
  dim_Y <- dim_X_Y
  
    for (rho in rhos) {
      
      for(n in sample_sizes) {
        
        # initialization of storage vectors
        rejection_rate1 <- numeric(N)
        rejection_rate2 <- numeric(N)
        rejection_rate3 <- numeric(N)
        rejection_rate4 <- numeric(N)
        rejection_rate5 <- numeric(N)
        print(n)
        
        # N replications for each possible above case
        for(i in 1:N) {
        print(i)
          
        # generate data according to the underlying model
        source("model_sigma_2.R")
      
        # simple approach
        p_tot1 <- execute_standard_test(X, Y, Z,
                                        alpha_pre,
                                        sbo = 0.2,
                                        mcs,
                                        ci_test = ci_test)
        if(p_tot1 <= alpha) {
          rejection_rate1[i] <- 1
        }
      
      
        # no_oracle_0.2 approach
        # maximum conditioning set
        mcs <- max(0, floor((floor((1 - 0.2) * n) - 2 - dim_Z) * (1 - kappa)))
        # calculate p-value
        p_tot2 <- execute_novel_test(X, Y, Z,
                                     alpha_pre,
                                     sbo = 0.2,
                                     mcs,
                                     ci_test = ci_test)
        if(p_tot2 <= alpha) {
          rejection_rate2[i] <- 1
        }
        
        # no_oracle_0.5 approach
        # maximum conditioning set
        mcs <- max(0, floor((floor((1 - 0.5) * n) - 2 - dim_Z) * (1 - kappa)))
        # calculate p-value
        p_tot3 <- execute_novel_test(X, Y, Z,
                                     alpha_pre,
                                     sbo = 0.5,
                                     mcs,
                                     ci_test = ci_test)
        if(p_tot3 <= alpha) {
          rejection_rate3[i] <- 1
        }
      
        # oracle approach
        # maximum conditioning set
        mcs <- max(0, (n - 2 - dim_Z) * (1 - kappa))
        p_tot4 <- execute_novel_test(X, Y, Z,
                                     alpha_pre,
                                     sbo = NULL,
                                     mcs,
                                     ci_test = ci_test,
                                     indep_set = indep_set)
        if(p_tot4 <= alpha) {
          rejection_rate4[i] <- 1
        }
      
        # partial distance correlation
        p_tot5 <- pdcor.test(X, Y, Z, R=1000)$p.value
        if(p_tot5 <= alpha) {
          rejection_rate5[i] <- 1
        }
        
        
        }
        
        # store mean and standard deviation of rejection rates in dataframe
        rejection_rate_df[dim(rejection_rate_df)[1] + 1, ] <-
          c(n,
            mean(rejection_rate1),
            sd(rejection_rate1) / sqrt(N),
            "simple",
            rho,
            tau,
            dim_X,
            dim_Y,
            dim_Z)
        rejection_rate_df[dim(rejection_rate_df)[1] + 1, ] <-
          c(n,
            mean(rejection_rate2),
            sd(rejection_rate2) / sqrt(N),
            "no_oracle_0.2",
            rho,
            tau,
            dim_X,
            dim_Y,
            dim_Z)
        rejection_rate_df[dim(rejection_rate_df)[1] + 1, ] <-
          c(n,
            mean(rejection_rate3),
            sd(rejection_rate3) / sqrt(N),
            "no_oracle_0.5",
            rho,
            tau,
            dim_X,
            dim_Y,
            dim_Z)
        rejection_rate_df[dim(rejection_rate_df)[1] + 1, ] <-
          c(n,
            mean(rejection_rate4),
            sd(rejection_rate4) / sqrt(N),
            "oracle",
            rho,
            tau,
            dim_X,
            dim_Y,
            dim_Z)
        rejection_rate_df[dim(rejection_rate_df)[1] + 1, ] <-
          c(n,
            mean(rejection_rate5),
            sd(rejection_rate5) / sqrt(N),
            "pdcor",
            rho,
            tau,
            dim_X,
            dim_Y,
            dim_Z)    
        
    }                                          
  }
}

# export results
write.csv(rejection_rate_df, file = "rejection_rate_df_dist_corr_tau09.csv")
rejection_rate_df


