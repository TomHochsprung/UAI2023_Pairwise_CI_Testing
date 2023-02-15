# code for generating data according to Sigma^{(2)}

# define submatrix Sigma_X
Sigma_X <- diag(x = 1, nrow = dim_X, ncol = dim_X)
for (row_it in 1:dim_X) {
  for (col_it in 1:dim_X) {
    Sigma_X[row_it, col_it] <- tau^(abs(row_it - col_it))
  }
}

# define submatrix Sigma_Y
Sigma_Y <- diag(x = 1, nrow = dim_Y, ncol = dim_Y)
for (row_it in 1:dim_Y) {
  for (col_it in 1:dim_Y) {
    Sigma_Y[row_it, col_it] <- tau^(abs(row_it - col_it))
  }
}

# aggregate all submatrices to overall matrix
Sigma <- cbind(rbind(cbind(rbind(Sigma_X, matrix(numeric(dim_X * dim_Y), nrow = dim_Y, ncol = dim_X)),
                           rbind(matrix(numeric(dim_X * dim_Y), nrow = dim_X, ncol = dim_Y), Sigma_Y)), 
                     numeric(dim_X + dim_Y)), c(numeric(dim_X + dim_Y), 1))
indices_non_zero <- sample(1:(dim_X * dim_Y), size = 10, replace = FALSE)
indices_zero <- setdiff((1:(dim_X * dim_Y)), indices_non_zero)
non_zero_entries <- expand.grid(1:dim_X, 1:dim_Y)[indices_non_zero, ]
indep_set <- expand.grid(1:dim_X, 1:dim_Y)[indices_zero, ]
for (nze_iterate in 1:10) {
  Sigma[non_zero_entries[nze_iterate, 1],
        dim_X + non_zero_entries[nze_iterate, 2]] <- 
    runif(1, rho/100, rho/10) * sign(runif(1, -1, 1))
  Sigma[dim_X + non_zero_entries[nze_iterate, 2],
        non_zero_entries[nze_iterate, 1]] <-
    Sigma[non_zero_entries[nze_iterate, 1],
          dim_X + non_zero_entries[nze_iterate, 2]]
}
# generate multivariate normal data according to covariance matrix Sigma and
# mean 0
data <- rmvnorm(n, sigma = Sigma)
X <- data[, 1:dim_X, drop = FALSE]
Y <- data[, (dim_X + 1) : (dim_X + dim_Y), drop = FALSE]
Z <- data[, (dim_X + dim_Y + 1) : (dim_X + dim_Y + dim_Z), drop = FALSE]
