# Two Group Hypothesis Testing

## Question: In terms of weight gain, are diet 1 and
## diet 4 statistically equivalent?


## ChickWeight data set has four variables: Chick, weight, Time, Diet
library(datasets); data(ChickWeight); library(reshape2)
head(ChickWeight)
names(ChickWeight)
str(ChickWeight)

## dcast creates new df where Diet, Chick (factor vars) and
## all values for time become col vars. The values under the
## time vars are the chick weights at those times.
wideCW <- dcast(ChickWeight, Diet + Chick ~ Time, value.var = "weight")
wideCW[1:15,]


## The time col vars names are numbers. We want them to be
## more name-like -- time12, time13, etc..
library(dplyr)
names(wideCW)[-(1:2)] <- paste("time", names(wideCW)[-(1:2)], sep="")
wideCW[1:15,]

## mutate creates the new var, "gain" by subtracting the weight at
## the beginning of the study from the end weight.
wideCW <- mutate(wideCW, gain = time21 - time0)
wideCW[1:15,]


## The "~" in the t.test function requires the predictor variable (Diet)
## to have only two levels. It has four so two were
## subsetted.
wideCW14 <- subset(wideCW, Diet %in% c(1,4))
## Chick in group 1 w/diet 4 is different from chick
## in group 1 w/diet 1 so not "paired". Unequal variance
## is probably more accurate but set to true here.
t.test(gain ~ Diet, paired = F, var.equal=T, data = wideCW14)
### Our H0 is that the gain means from diet 1 and diet 4
### equal. They are not. Means, CI shown. He also said t stat was large
### but didn't explain further. Said pvalue lecture would explain.
