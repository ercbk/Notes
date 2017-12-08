# Poisson Outcomes, Leek's web traffic



destfile="./data/gaData.rda"

download.file("https://dl.dropboxusercontent.com/u/7710864/data/gaData.rda", destfile = "C:/Users/Kevin/Documents/gaData.rda")
load("gaData.rda")
### julian gives count of days since 1970-01-01
gaData$julian <- julian(gaData$date)
head(gaData)

### plots visits vs julian days count
plot(gaData$julian,gaData$visits,pch=19,col="darkgrey",xlab="Julian",ylab="Visits")

### modeled as linear regression
plot(gaData$julian,gaData$visits,pch=19,col="darkgrey",xlab="Julian",ylab="Visits")
lm1 <- lm(gaData$visits ~ gaData$julian)
abline(lm1,col="red",lwd=3)


## Log of outcomes

### 1 added to deal with zero counts (ln 0 not defined)
### exponential + log makes coeffs relative to geometric mean
### ex) b1 = estimated relative (percent) increase/decrease of 
### geometric mean hits per day.
round(exp(coef(lm(I(log(gaData$visits + 1)) ~ gaData$julian))), 5)
### 1 added so 1 needs subtracted from coeff to get percentage correct
### b1 = 1.007 so it's actuall a 0.7% increase in geo mean hits per day


## Fitting Poisson

### plotting the regression line of both models. Notice curve (nonlinear) in the
### Poisson fitted line.
plot(gaData$julian,gaData$visits,pch=19,col="darkgrey",xlab="Julian",ylab="Visits")
glm1 <- glm(gaData$visits ~ gaData$julian,family="poisson")
abline(lm1,col="red",lwd=3); lines(gaData$julian,glm1$fitted,col="blue",lwd=3)


## Residuals vs Fitted plot

### Plot looks out of whack. With Poisson, variation should increase as mean
### increases. This looks opposite. One possible soln is to try family="quasi-
### poisson"; another is to use "robust std errors."
plot(glm1$fitted,glm1$residuals,pch=19,col="grey",ylab="Residuals",xlab="Fitted")


## Robust Standard Errors (sandwich variance estimates) to compute CIs

library(sandwich)
confint.agnostic <- function (object, parm, level = 0.95, ...)
{
  cf <- coef(object); pnames <- names(cf)
  if (missing(parm))
    parm <- pnames
  else if (is.numeric(parm))
    parm <- pnames[parm]
  a <- (1 - level)/2; a <- c(a, 1 - a)
  pct <- stats:::format.perc(a, 3)
  fac <- qnorm(a)
  ci <- array(NA, dim = c(length(parm), 2L), dimnames = list(parm,
                                                             pct))
  ses <- sqrt(diag(sandwich::vcovHC(object)))[parm]
  ci[] <- cf[parm] + ses %o% fac
  ci
}

## Reg CI vs adjusted CI

### adjusted CI is a little larger providing more cushion
confint(glm1)
confint.agnostic(glm1)
### both say about a 0.2% increase per day

## Fitting Rates

### Modelling the percentage of hits for simplystats blog/total website hits
glm2 <- glm(gaData$simplystats ~ julian(gaData$date),offset=log(visits+1),
            family="poisson",data=gaData)
### Earlier poisson fitted values in red, fitted counts in blue
plot(julian(gaData$date),glm2$fitted,col="blue",pch=19,xlab="Date",ylab="Fitted Counts")
points(julian(gaData$date),glm1$fitted,col="red",pch=19)

### Plot of fitted rates in blue
plot(julian(gaData$date),gaData$simplystats/(gaData$visits+1),col="grey",xlab="Date",
     ylab="Fitted Rates",pch=19)
lines(julian(gaData$date),glm2$fitted/(gaData$visits+1),col="blue",lwd=3)



