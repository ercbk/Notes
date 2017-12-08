# Neural Networks


## Data: Credit Score, annual averages of daily sunspot area for the full sun
## Sunspot area being a time series


library(caret); library(fpp)
set.seed(1234)
creditlog  <- data.frame(score=credit$score,
                         log.savings=log(credit$savings+1),
                         log.income=log(credit$income+1),
                         log.address=log(credit$time.address+1),
                         log.employed=log(credit$time.employed+1),
                         fte=credit$fte, single=credit$single)

### avNNet fits single-hidden-layer neural network, possibly with skip-layer connection
### for a dataframe or matrix. see nnet link in avNNet documentation for more details.
### Only 3 out of the 25 networks converged
fit  <- avNNet(score ~ log.savings + log.income + log.address +
                 log.employed, data=creditlog, repeats=25, size=3, decay=0.1,
               linout=TRUE)

### After normalizing the data, 14 out 25 networks converged
### Came back a few days later and got 18 converges.
creditlogN <- as.data.frame(scale(creditlog))
fitN  <- avNNet(score ~ log.savings + log.income + log.address +
                 log.employed, data=creditlogN, repeats=25, size=3, decay=0.1,
               linout=TRUE)
### I don't know if the reason I can't get an output is because not all the networks
### converged or I'm just not looking in the right place. I'll see if it lets me
### predict() and get some accuracy comparisons


inTrain <- createDataPartition(y=creditlog$score,
                               p=0.7, list=FALSE)
training <- creditlog[inTrain,]; testing <- creditlog[-inTrain,]
trainingN <- creditlogN[inTrain,]; testingN <- creditlogN[-inTrain,]
dim(trainingN); dim(testingN)


### 8 converges
fit  <- avNNet(score ~ log.savings + log.income + log.address +
                 log.employed, data=training, repeats=25, size=3, decay=0.1,
               linout=TRUE)
### 23 converges
fitN  <- avNNet(score ~ log.savings + log.income + log.address +
                  log.employed, data=trainingN, repeats=25, size=3, decay=0.1,
                linout=TRUE)

pred <- predict(fit, newdata = testing)
predN <- predict(fitN, newdata = testingN)

### Denormalizing the predictions so we can compare results
predNdenorm <- predN*(sd(creditlog$score))+mean(creditlog$score)

RMSE <- sqrt(sum(testing$score-pred)^2/nrow(testing))
RMSEN <- sqrt(sum(testing$score-predNdenorm)^2/nrow(testing))
### "11.8702677168893 13.4355924381442" This was without setting the seed which I
### should have done in the first place.
print(paste(RMSE,RMSEN))
### Normalizing may help convergence but it didn't result in a better
### error score which surprised me. Still believe it's good practice.

mean(testing$score)
### 36.48387  -- error seems pretty damn high in this context


## Average Sunspot area
### nnetar fits a feed forward nn w/1 hidden layer and lagged inputs for a
### univariate time series; part of forecast pkg.
fitSA <- nnetar(sunspotarea)
plot(forecast(fitSA,h=20))


## This is a univariate time series so no need to normalize but
## I'm just going to leave this here as an example of how to.

### Getting relevant info for the ts coerce
head(sunspotarea)
sunNorm <- scale(sunspotarea)
sunspotNorm <- ts(sunNorm, start = 1875, end = 2011, frequency = 1)

### forecasts breach into the negative region and given you can't have
### a negative area we're doing a log transform
fitlog <- nnetar(sunspotarea,lambda=0)
plot(forecast(fitlog,h=20))




