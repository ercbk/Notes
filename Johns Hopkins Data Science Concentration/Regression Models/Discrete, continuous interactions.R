# Discrete, continuous interactions
# (see notes)

## WHO children's data on world hunger



## download.file("http://apps.who.int/gho/athena/data/GHO/WHOSIS_000008.csv?profile=text&filter=COUNTRY:*;SEX:*","hunger.csv")
## (Had to download.file the first time but hunger.csv should be in the data
## folder now)

hunger1 <- read.csv("hunger.csv")
### removes rows with "Both sexes" value for sex variable in the data set
hunger1 <- hunger1[hunger1$Sex!="Both sexes",]
head(hunger1)

## hunger1$Year has ranges of years along with single years for values.
## Hence, R treats this as a factor var instead of a numeric and it screws up the
## plots and regression models below. I removed the rows with ranges in
## them just so I could make this work but it cost 25% of the observations.
## I'm sure there's a better way but I'm not messing with it now.

### The ranges have "-" and grepl searched them out and I removed them.
### Put the "clean" rows in a new df
hunger <- hunger1[!grepl("-", hunger1$Year),]
### Even without the ranges, Year is still a factor.
str(hunger$Year)
### Factor to character to numeric
hunger$Year <- as.numeric(as.character(hunger$Year))
### All is finally well
str(hunger$Year)


### plot of Numeric (% "hungry" of population) vs Year
plot(hunger$Year,hunger$Numeric,pch=19,col="blue")

### model with % hungry as outcome and Year as the predictor
### No "data =" arg, lm knows the dataset I guess. Still gd practice
### to include it though.
lm1 <- lm(hunger$Numeric ~ hunger$Year)
plot(hunger$Year,hunger$Numeric,pch=19,col="blue")
### lines() adds the fitted line to the plot from the model
lines(hunger$Year,lm1$fitted,lwd=3,col="darkgrey")

plot(hunger$Year,hunger$Numeric,pch=19)
### adds color to distinguish gender. "*1" changes the boolean into a numeric
### "+1" makes False=1 (Female, Black) and True=2 (Male, Red)
### col indexes from palette()
points(hunger$Year,hunger$Numeric,pch=19,col=((hunger$Sex=="Male")*1+1))

### Modelling by gender and fitting separately
lmM <- lm(hunger$Numeric[hunger$Sex=="Male"] ~ hunger$Year[hunger$Sex=="Male"])
lmF <- lm(hunger$Numeric[hunger$Sex=="Female"] ~ hunger$Year[hunger$Sex=="Female"])
plot(hunger$Year,hunger$Numeric,pch=19)
points(hunger$Year,hunger$Numeric,pch=19,col=((hunger$Sex=="Male")*1+1))
lines(hunger$Year[hunger$Sex=="Male"],lmM$fitted,col="black",lwd=3)
lines(hunger$Year[hunger$Sex=="Female"],lmF$fitted,col="red",lwd=3)

## Fitting simultaneously (see notes)
## Both groups will have differenct slopes, intercepts, means, residual
## variances, etc. but sometimes these differences aren't significant (pvals).

### 2 lines, same slope, different intercept with Sex as the factor variable
lmBoth <- lm(hunger$Numeric ~ hunger$Year + hunger$Sex)
plot(hunger$Year,hunger$Numeric,pch=19)
points(hunger$Year,hunger$Numeric,pch=19,col=((hunger$Sex=="Male")*1+1))
abline(c(lmBoth$coeff[1],lmBoth$coeff[2]),col="red",lwd=3)
abline(c(lmBoth$coeff[1] + lmBoth$coeff[3],lmBoth$coeff[2] ),col="black",lwd=3)


### 2 lines, different slope, different intercept
lmBoth <- lm(hunger$Numeric ~ hunger$Year + hunger$Sex + hunger$Sex*hunger$Year)
plot(hunger$Year,hunger$Numeric,pch=19)
points(hunger$Year,hunger$Numeric,pch=19,col=((hunger$Sex=="Male")*1+1))
abline(c(lmBoth$coeff[1],lmBoth$coeff[2]),col="red",lwd=3)
abline(c(lmBoth$coeff[1] + lmBoth$coeff[3],lmBoth$coeff[2] +lmBoth$coeff[4]),col="black",lwd=3)

### Looking below we'll see that the reference category is "female" for
### the model above. Here I'm releveling so "Male" is ref.Cat..
Sex2 <- relevel(hunger$Sex, "Male")
lmBoth2 <- lm(hunger$Numeric ~ hunger$Year + Sex2 + Sex2*hunger$Year)

### Here we have coefficients for female intercept, female slope, Male-female intercepts, difference between male and female slopes.
summary(lmBoth)
### Here we have coefficients for male intercept, male slope, female-male intercepts, female
### -male slopes
summary(lmBoth2)
### Also note the pvalues for the differences. Says these slope, intercept differences
### aren't significant.

