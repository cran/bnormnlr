\name{chainsum}
\alias{chainsum}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Function to summarize chain results of MCMC simulation obtained from bnlr
}
\description{
This function reports mean and desired quantiles of the samples obtained via Gibbs sampler of the posterior distribution of the parameters.
}
\usage{
chainsum(chains, q = c(0.025, 0.5, 0.975), burn = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{chains}{
A matrix where mcmc simulations of the posterior distributions of the regression parameters given the data are stored. Rows correspond to mcmc simulation and columns correspond to the regression parameters. Parameters associated with f1 are denoted by btai (i=1,2,...), parameters associated with f2 are denoted by gmai (i=1,2,...). In this matrix also is stored the Deviance of each iteration.
}
  \item{q}{
Vector of desired quantiles.
}
  \item{burn}{
A vector indicating which samples must be discarded from the mcmc simulation
}
}
\details{
This function can accept any kind of matrix but is highly recommended to pass only the matrix produced by bnlr, in order to avoid missuses.
}
\value{
A matrix with summary statistics of the chains.
}
\references{
Carlin, B. P. & Louis, T. A. (2009), Bayesian Methods for Data Analysis, 3rd edn, CRC Press, New York.

Gamerman, D. & Lopes, H. F. (2006), Markov Chain Monte Carlo: Stochastic Simulation for Bayesian Inference, 2nd edn, CRC Press, New York.
}
\author{
Nicolas Molano-Gonzalez, Marta Corrales Bossio, Maria Fernanda Zarate, Edilberto Cepeda-Cuervo.
}

\examples{
utils::data(muscle, package = "MASS")
plot(muscle$Conc,muscle$Length)

###mean and variance functions
fmu<-function(param,cov){ param[1] + param[2]*exp(-cov/exp(param[3]))}
fsgma<-function(param,cov){drop(exp(cov\%*\%param))}

##Note: use more MCMC chains (i.e NC=10000) for more accurate results.
m1b<-bnlr(y=muscle$Length,f1=fmu,f2=fsgma,x=muscle$Conc,
z=cbind(1,muscle$Conc),bta0=c(20,-30,0),gma0=c(.5,.5),Nc=1200)
chainsum(m1b$chains,burn=1:200)
}
