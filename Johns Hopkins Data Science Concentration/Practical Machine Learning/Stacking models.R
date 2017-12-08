# Model Stacking






library(ISLR); data(Wage); library(ggplot2); library(caret);
Wage <- subset(Wage,select=-c(logwage))

## Create a building data set and validation set
## Validation set will be the test set for the overall model
## training and test sets will subsampled from a subsample

### Never really looked at this object before but it's a col vector
### of row indices for the subsampling
inBuild <- createDataPartition(y=Wage$wage,
                               p=0.7, list=FALSE)
### The validation set is what has previously been the test set taking
### what was left behind during the subsampling
validation <- Wage[-inBuild,]
### buildData is now the training set using the indices in inBuild
buildData <- Wage[inBuild,]
### Col vector of indices for a second subsampling
inTrain <- createDataPartition(y=buildData$wage,
                               p=0.7, list=FALSE)
### Here's the training and testing sets to do model building on.
training <- buildData[inTrain,]; testing <- buildData[-inTrain,]

### 1474 obs, 11 vars
dim(training)
### 628 obs
dim(testing)
### 898 obs
dim(validation)

### two models built on same training set
### general linear model and random forest
mod1 <- train(wage ~.,method="glm",data=training)
### rf using cross-validation, subsampling 3 times
mod2 <- train(wage ~.,method="rf",
              data=training, 
              trControl = trainControl(method="cv"),number=3)

### Predictions using the two models using the same test set
pred1 <- predict(mod1,testing); pred2 <- predict(mod2,testing)
### plotting the predictions vs each other
qplot(pred1,pred2,colour=wage,data=testing)
### Pretty good agreement. Lots of variation towards tail end though.


## Combining the models

### create new df with predictions and wage var from test set
predDF <- data.frame(pred1,pred2,wage=testing$wage)
### predictors are the predictions from the separate models
### method is generalized additive model
combModFit <- train(wage ~.,method="gam",data=predDF)
### predictions for the combo model
combPred <- predict(combModFit,predDF)

### error for glm, 827.1
sqrt(sum((pred1-testing$wage)^2))
### error for rf, 866.8
sqrt(sum((pred2-testing$wage)^2))
### error for combomodel, 813.9
sqrt(sum((combPred-testing$wage)^2))
### combomodel was the lowest on the test data


## Now for the validation set

### getting preds for glm and rf
pred1V <- predict(mod1,validation); pred2V <- predict(mod2,validation)
### new pred data frame; no need for wage var since model training done
predVDF <- data.frame(pred1=pred1V,pred2=pred2V)
### using combomodel to make predictions on validation set
combPredV <- predict(combModFit,predVDF)
### This whole thing iskinda complex re: what gets passed to what function

### glm error on val. set, 1003
sqrt(sum((pred1V-validation$wage)^2))
### rf error on val.set, 1068
sqrt(sum((pred2V-validation$wage)^2))
### combomodel error on val.set, 999.9
sqrt(sum((combPredV-validation$wage)^2))
### interesting that glm held onto the lead against random forest
### modest gain in combining models