# Caret Overview
## createDataPartition, train, predict, confusionMatrix




### loading caret machine leaning pkg
library(caret); library(kernlab); data(spam)
### creating row indices vector for training set
inTrain <- createDataPartition(y=spam$type,
                               p=0.75, list=FALSE)
### creating train/test sets from those indices
training <- spam[inTrain,]
testing <- spam[-inTrain,]
dim(training)

### basic use of train function
set.seed(32343)
modelFit <- train(type ~.,data=training, method="glm")
modelFit

### final model returns coefficients for each predictor
modelFit <- train(type ~.,data=training, method="glm")
modelFit$finalModel


## see notes on the following

### default argument values for train function
args(train.default)

### trainControl is a function call in the one of the train arguments
### it makes available for a bunch of options that give precise control over
### how the train function goes about its business.
args(trainControl)



### basic use of the predict function
predictions <- predict(modelFit,newdata=testing)
predictions

### Returns table of predictions vs truth and various error measurements
confusionMatrix(predictions,testing$type)


