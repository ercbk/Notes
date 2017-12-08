# Binary Outcomes, Ravens data
## See Notes



## Using Scores (points) to predict Wins.

download.file("https://dl.dropboxusercontent.com/u/7710864/data/ravensData.rda"
              , destfile="./data/ravensData.rda",method="curl")
load("./data/ravensData.rda")
head(ravensData)

## Fitting a linear regression model

### Doesn't work well for interpretablility of coeffs. Can have uses w/prediction.
lmRavens <- lm(ravensData$ravenWinNum ~ ravensData$ravenScore)
summary(lmRavens)$coef


## Logistic Regression
logRegRavens <- glm(ravensData$ravenWinNum ~ ravensData$ravenScore,family="binomial")
summary(logRegRavens)

## Plotting the regression

### plot of [exp(b0+b1x)]/[1+exp(b0+b1x)] (pdf) vs x (score)
plot(ravensData$ravenScore,logRegRavens$fitted,pch=19,col="blue",xlab="Score",ylab="Prob Ravens Win")

### converting coefficients from in terms of log odds to in terms of odds
exp(logRegRavens$coeff)
### confidence intervals for each coefficient
exp(confint(logRegRavens))

### see notes for analysis of this Chi Squared test
anova(logRegRavens,test="Chisq")
