\name{bnlr}
\alias{bnlr}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Bayesian Estimation for Normal Heteroscedastic Nonlinear Regression Models.
}
\description{
Implementation of Bayesian estimation in Heteroscedastic Nonlinear Regression Models following Cepeda-Cuervo, (2001).
}
\usage{
bnlr(y, f1, f2, f1g = NULL, f2g = NULL, x, z, bta0, gma0, 
b = rep(0, length(bta0)), B = diag(10^6, length(bta0)),
g = rep(0, length(gma0)), G = diag(10^6, length(gma0)), Nc)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{y}{
A vector with the response variable.
}
  \item{f1}{
Non-linear function to specify the mean of the model. This function must have two arguments (param and cov) and must return a number in order to be accepted by the function. See details.
}
  \item{f2}{
Non-linear function to specify the variance of the model. This function must have two arguments (param and cov) and must return a positive number in order to be accepted by the function. See details.
}
  \item{f1g}{
A function which returns the gradient of the function f1 with respect to argument param. This function must have two arguments (param and cov) and must return a vector where each entry corresponds to the derivative of f1 with respect to param[i] evaluated at param.
}
  \item{f2g}{
A function which returns the gradient of the function f2 with respect to argument param. This function must have two arguments (param and cov) and must return a vector where each entry corresponds to the derivative of f2 with respect to param[i] evaluated at param.
}
  \item{x}{
Matrix of covariates associated with f1. This will be passed to f1 as argument cov. Thus f1(param0,x) should return a vector of length dim(x)[1] with the nonlinear function evaluated at each x[i,] for the parameter values param0.
}
  \item{z}{
Matrix of covariates associated with f2. This will be passed to f2 as argument cov. Thus f2(param0,z) should return a vector of length dim(z)[1] with the nonlinear function evaluated at each z[i,] for the parameter values param0.
}
  \item{bta0}{
Initial values for the parameters associated with f1. This vector will be passed to f1 together with x, so f1(bta0,x) should return a vector of length dim(x)[1] with the nonlinear function evaluated at each x[i,] for the parameter values bta0.
}
  \item{gma0}{
Initial values for the parameters associated with f2. This vector will be passed to f2 together with z, so f1(bta0,x) should return a vector of length dim(z)[1] with the nonlinear function evaluated at each z[i,] for the parameter values gma0.
}
  \item{b}{
Mean of the normal prior distribution of the mean parameters. Should have same length as bta0.
}
  \item{B}{
Covariance matrix of the normal prior distribution of the mean parameters.
}
  \item{g}{
Mean of the normal prior distribution of the variance parameters. Should have same length as gma0.
}
  \item{G}{
Covariance matrix of the normal prior distribution of the variance parameters.
}
  \item{Nc}{
Number mcmc simulations of the posterior distributions of the regression parameters given the data.
}
}
\details{
The matrices x and z should have the same number of rows as observations are in vector y. The functions f1 and f2 should be constructed in such a way that f1(bta0,x) and f2(gma0,z) returns a vector of the same length of y. f1g and f2g should be constructed in such a way that f1g(bta0,x) and f2g(gma0,z) returns a matrix where each row corresponds to the gradient (with respect to param) evaluated at bta0 (gma0) given the covariate values of x[i,] (z[i,]).
}
\value{
A list with the following objects:
\item{chains}{A matrix where mcmc simulations of the posterior distributions of the regression parameters given the data are stored. Rows correspond to mcmc simulation and columns correspond to the regression parameters. Parameters associated with f1 are denoted by btai, parameters associated with f2 are denoted by gmai. In this matrix also is stored the Deviance of each iteration.}
\item{accept.bta}{An integer presenting the number of samples accepted by the Metropolis-Hastings algorithm for the mean parameters.}
\item{accept.gma}{An integer presenting the number of samples accepted by the Metropolis-Hastings algorithm for the variance parameters.}
\item{y}{Response variable used in the fit.}
\item{x}{Covariates associated with the mean used in the fit.}
\item{z}{Covariates associated with the variance used in the fit.}
\item{f1}{Fucntion used to model the mean.}
\item{f2}{Fucntion used to model the variance.}


}
\references{
Cepeda-Cuervo, E. (2001). Modelagem da variabilidade em modelos lineares generalizados. Unpublished Ph.D. tesis. Instituto de Matematicas. Universidade Federal do Rio do Janeiro.
 
Cepeda-Cuervo, E. and Gamerman, D. (2001). Bayesian modeling of variance heterogeneity in normal regression models. Brazilian Journal of Probability and Statistics 14.1: 207-221.

Cepeda-Cuervo, E. and Achcar, J.A. (2010). Heteroscedastic nonlinear regression models. Communications in Statistics-Simulation and Computation 39.2 : 405-419.
}
\author{
Nicolas Molano-Gonzalez, Marta Corrales Bossio, Maria Fernanda Zarate, Edilberto Cepeda-Cuervo.
}

\examples{

######################################################
###Simulation of heteroscedastic model, using gradient
######################################################
library(car)
library(coda)
utils::data(muscle, package = "MASS")
###mean and variance functions
fmu<-function(param,cov){ param[1] + param[2]*exp(-cov/exp(param[3]))}
fsgma<-function(param,cov){drop(exp(cov\%*\%param))}

###simulate heteroscedastic data
muscle$Length<-fmu(c(28.9632978, -34.2274097,  -0.4972977),muscle$Conc)+
rnorm(60,0,sqrt(exp(log(2)+.8*muscle$Conc)))

####gradients
fmug<-function(param,cov){ 
cbind(1,exp(-cov/exp(param[3])),param[2]*exp(-cov/exp(param[3]))*cov/exp(param[3]))}
fsgmag<-function(param,cov){ cbind(drop(exp(cov\%*\%param)),drop(exp(cov\%*\%param))*cov[,2])}

###without gradient
m1b<-bnlr(y=muscle$Length,f1=fmu,f2=fsgma,x=muscle$Conc,z=cbind(1,muscle$Conc)
,bta0=c(20,-30,0),gma0=c(.5,.5),Nc=500)
###with gradient
m2b<-bnlr(y=muscle$Length,f1=fmu,f2=fsgma,x=muscle$Conc,z=cbind(1,muscle$Conc),
bta0=c(20,-30,0),gma0=c(.5,.5),Nc=500)

chainsum(m1b$chains,burn=1:50)
chainsum(m2b$chains,burn=1:50)
infocrit(m1b,1:50)
infocrit(m2b,1:50)
##Note: use more MCMC chains (i.e NC=10000) for more accurate results.

}
