\name{bnormnlr-package}
\alias{bnormnlr-package}
\alias{bnormnlr}
\docType{package}
\title{
Bayesian Estimation for Normal Heteroscedastic Nonlinear Regression Models
}
\description{
Implementation of Bayesian estimation in normal heteroscedastic nonlinear regression Models following Cepeda-Cuervo, (2001).
}
\details{
\tabular{ll}{
Package: \tab bnormnlr\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2014-12-09\cr
License: \tab GPL-2\cr
}
The package provides three functions: bnlr to perform Bayesian estimation for heteroscedastic normal nonlinear regression models; chainsum to summarize the MCMC chains obtained from bnlr and infocrit to extract information criteria measures from the model fit.
}
\author{
Nicolas Molano-Gonzalez, Marta Corrales Bossio, Maria Fernanda Zarate, Edilberto Cepeda-Cuervo.

Maintainer: Nicolas Molano-Gonzalez <nmolanog@unal.edu.co>
}
\references{
Cepeda-Cuervo, E. (2001). Modelagem da variabilidade em modelos lineares generalizados. Unpublished Ph.D. tesis. Instituto de Matematicas. Universidade Federal do Rio do Janeiro.
 
Cepeda-Cuervo, E. and Gamerman, D. (2001). Bayesian modeling of variance heterogeneity in normal regression models. Brazilian Journal of Probability and Statistics 14.1: 207-221.

Cepeda-Cuervo, E. and Achcar, J.A. (2010). Heteroscedastic nonlinear regression models. Communications in Statistics-Simulation and Computation 39.2 : 405-419.
}
\keyword{ package }
\examples{
utils::data(muscle, package = "MASS")
###mean and variance functions
fmu<-function(param,cov){ param[1] + param[2]*exp(-cov/exp(param[3]))}
fsgma<-function(param,cov){drop(exp(cov\%*\%param))}

##Note: use more MCMC chains (i.e NC=10000) for more accurate results.
m1b<-bnlr(y=muscle$Length,f1=fmu,f2=fsgma,x=muscle$Conc,
z=cbind(1,muscle$Conc),bta0=c(20,-30,0),gma0=c(2,0),Nc=1200)
chainsum(m1b$chains,burn=1:200)
infocrit(m1b,1:8000)
}
