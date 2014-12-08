\name{infocrit}
\alias{infocrit}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Expected Number of Parameters, DIC, AIC and BIC for bnlr fit.
}
\description{
Function to calculate Expected Number of Parameters, DIC, AIC and BIC for bnlr output.
}
\usage{
infocrit(model, burn)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{model}{
A list derived from bnlr function
}
  \item{burn}{
A vector indicating which samples must be discarded from the mcmc simulation
}
}

\value{
a vector with:
\item{pd}{Expected Number of Parameters}
\item{DIC}{Deviance Information Criterion}
\item{AIC}{Akaike  Information Criterion}
\item{BIC}{Bayesian Information Criterion}

}
\references{
Carlin, B. P. & Louis, T. A. (2009), Bayesian Methods for Data Analysis, 3rd edn, CRC Press, New York.

Gamerman, D. & Lopes, H. F. (2006), Markov Chain Monte Carlo: Stochastic Simulation for Bayesian Inference, 2nd edn, CRC Press, New York.
}
\author{
Nicolas Molano-Gonzalez, Marta Corrales Bossio, Maria Fernanda Zarate, Edilberto Cepeda-Cuervo.
}

\examples{
#######################################
###Simulation of heteroscedastic model
#######################################
utils::data(muscle, package = "MASS")
###mean and variance functions
fmu<-function(param,cov){ param[1] + param[2]*exp(-cov/exp(param[3]))}
fsgma<-function(param,cov){drop(exp(cov\%*\%param))}

###simulate heteroscedastic data
muscle$Length<-fmu(c(28.9632978, -34.2274097,  -0.4972977),muscle$Conc)+
rnorm(60,0,sqrt(exp(log(2)+.8*muscle$Conc)))

##Note: use more MCMC chains (i.e NC=10000) for more accurate results.
m2b<-bnlr(y=muscle$Length,f1=fmu,f2=fsgma,x=muscle$Conc,
z=matrix(rep(1,length(muscle$Length)),ncol=1),bta0=c(20,-30,-1),gma0=2,Nc=650)
m1b<-bnlr(y=muscle$Length,f1=fmu,f2=fsgma,x=muscle$Conc,z=cbind(1,muscle$Conc),
bta0=c(20,-30,0),gma0=c(.5,.5),Nc=650)

chainsum(m1b$chains,burn=1:65)
chainsum(m2b$chains,burn=1:65)
infocrit(m1b,1:65)
infocrit(m2b,1:65)
}
