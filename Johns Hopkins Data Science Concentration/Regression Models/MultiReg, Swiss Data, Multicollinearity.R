# Multivariate Examples





## Regressing Fertility as the outcome. Example of Multicollinearity
## screwing up the works.


library(datasets); data(swiss); require(stats); require(graphics)
### Don't understand where the blue/green distinction comes from unless
### its counties w/>50% Catholics are one of the colors. From I can find
### though 3 isn't an index for green or blue.
pairs(swiss, panel = panel.smooth, main = "Swiss data", col = 3 + (swiss$Catholic > 50))
### Gives info about the data set
?swiss
### All variables in terms of percentages of population except fertility
### which is in terms of an archaic index (Ig) of total number of children of
### married women/ maximum number of children possible for the number of
### married women... I think.


### regression w/response = Fertility and the rest of the variables as
### predictors.
### Agriculture has coeff = -0.1721 which says, "we estimate an expected
### 0.17 decrease in standardized fertility for 1% increase in percentage
### males involved in agriculture in holding the other variables constant.
### H0(agriculture)=0 and Ha != 0. t test pvalue significant so H0 rejected. 
summary(lm(Fertility ~ . , data = swiss))$coefficients
### Coefficient for Agriculture changes signs and value, coeff=0.1942
### and pvalue still significant. So what's goin on?
summary(lm(Fertility ~ Agriculture, data = swiss))$coefficients


## Simulation for demonstration of this phenomenon


n <- 100; x2 <- 1 : n; x1 <- .01 * x2 + runif(n, -.1, .1); y = -x1 + x2 + rnorm(n, sd = .01)
### Going from positive to negative. This is backwards re: the above fertility
### data. Here he adds a variable where before we subtracted, but... same
### difference really.
summary(lm(y ~ x1))$coef
summary(lm(y ~ x1 + x2))$coef

## This shit is kind of complicated. Had to go thru the 3 multiple regression vids
## discussing the coefficient relationships to the other variables. Also part3 using
## code showing how residuals are in the mix helps make sense of the following plots.

## What's happened is Education and Examination are negatively correlated with
## Agriculture. I believe since the magnitudes of their coefficients dominate that
## of Agriculture, their influence dominates Ag's positive coefficient (seen when other
## variables are removed). Example illustrates what's termed Multicollinearity which
## is discussed in the bookmarked Regression tutorial.

par(mfrow = c(1, 2))
plot(x1, y, pch=21,col="black",bg=topo.colors(n)[x2], frame = FALSE, cex = 1.5)
title('Unadjusted, color is X2')
abline(lm(y ~ x1), lwd = 2)

### plotting the residuals reveals the Multicollinearity aka the negative correlation
### between x2 and x1. 
plot(resid(lm(x1 ~ x2)), resid(lm(y ~ x2)), pch = 21, col = "black", bg = "lightblue", frame = FALSE, cex = 1.5)
title('Adjusted')
abline(0, coef(lm(y ~ x1 + x2))[2], lwd = 2)

## Showing linear combos of variables produce a NA.
z <- swiss$Agriculture + swiss$Education
lm(Fertility ~ . + z, data = swiss)

