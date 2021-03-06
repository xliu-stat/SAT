% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SAT.stage2.sampling.r
\name{SAT.stage2.sampling}
\alias{SAT.stage2.sampling}
\title{Second stage sampling with SAT.}
\usage{
SAT.stage2.sampling(r1, n, S, Rpar = 0.5, r, stage1.index, stage1.y, X, method = "SAT-S")
}
\arguments{
\item{r1}{pilot subsample size.}

\item{n}{total sample size.}

\item{S}{a binary vector of length n. Surrogate observations for all samples.}

\item{Rpar}{case proportion parameter. Should be the same as in \code{SAT.stage1.sampling}.}

\item{r}{second stage subsample size.}

\item{stage1.index}{a vector of length r1. The output of \code{SAT.stage1.sampling}, i.e., the index of pilot sampled patients.}

\item{stage1.y}{a binary vector of length r1. The manual chart review results for patients in \code{stage1.index}.}

\item{X}{a matrix of dimension n times p (the first column needs to be 1). The covariate matrix contains observations for all n samples.}
}
\value{
The function returns a list:
\item{beta.pilot}{the pilot estimator.}
\item{stage1.index}{a vector of index for patients who are selected in pilot sampling.}
\item{stage2.index}{a vector of index for patients who are selected in the second stage sampling.}
\item{stage1.weights}{a vector of weights used in fitting weighted logistic regression for patients who are selected in pilot sampling.}
}
\description{
This function implements the second stage sampling in SAT by SAT-S or SAT-cY.
}
\examples{
library(SAT)
set.seed(0)
n <- 1e5
beta0  <- c(1/5, 0, 0, 1/2, rep(1/2, 4))
d <- length(beta0)

X <- rnorm(n*(d-1), -1.5, 1)
X <- matrix(X, nrow = n, ncol = d - 1)
X <- cbind(1, X)

P  <- 1 - 1 / (1 + exp(X \%*\% beta0))
Y  <- rbinom(n, 1, P)

a1 <- 0.85 # sensitivity
a2 <- 0.95 # specificity
pr_s <- vector(mode = "numeric", length = n)
pr_s <- a1*(Y==1) + (1-a2)*(Y==0)
S <- rbinom(n, 1, pr_s)

stage1.index <- SAT.stage1.sampling(r1 = 400, n = 1e5, S, Rpar = 0.5)
stage1.y <- Y[stage1.index]
stage2 <- SAT.stage2.sampling(r1 = 400, n = 1e5, S, Rpar = 0.5, r = 800,
                              stage1.index, stage1.y, X, method = "SAT-S")
stage$beta.pilot

}
\references{
Liu, X., Chubak, J., Hubbard, R. A. & Chen, Y. (2021).
SAT: a Surrogate Assisted Two-wave case boosting sampling method, with application to EHR-based association studies.
}
