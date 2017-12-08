# Boosting, Wage data


## Predicting Wage



library(ISLR); data(Wage); library(ggplot2); library(caret);
### predicting wage, so you don't want to log(wage)in your group of predictors.
Wage <- subset(Wage,select=-c(logwage))
inTrain <- createDataPartition(y=Wage$wage,
                               p=0.7, list=FALSE)
training <- Wage[inTrain,]; testing <- Wage[-inTrain,]

### shows a algorithm using a mix of different interaction depths with
### different #s of trees to find model with least error
### Outputs a lot of info so verbose=F limits it.
modFit <- train(wage ~ ., method="gbm",data=training,verbose=FALSE)
print(modFit)

### can definitely spot a nice linear rel between the predictions and
### the truth. Still quite a bit of variablity but a better model is produced.
qplot(predict(modFit,testing),wage,data=testing)

