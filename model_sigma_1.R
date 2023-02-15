# code for generating data according to Sigma^{(1)}

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
Sigma[1, dim_X + 1] <- rho
Sigma[dim_X + 1, 1] <- rho
indep_set <- expand.grid(1:dim_X, 1:dim_Y)[-1, ]

# generate multivariate normal data according to covariance matrix Sigma and
# mean 0
data <- rmvnorm(n, sigma = Sigma)
X <- data[, 1:dim_X, drop = FALSE]
Y <- data[, (dim_X + 1) : (dim_X + dim_Y), drop = FALSE]
Z <- data[, (dim_X + dim_Y + 1) : (dim_X + dim_Y + dim_Z), drop = FALSE]
