# predicting w/Trees, iris data


## Trying to predict flower species for from sepal/petal length/width



data(iris); library(ggplot2); library(caret)
names(iris)
table(iris$Species)


inTrain <- createDataPartition(y=iris$Species,
                               p=0.7, list=FALSE)
training <- iris[inTrain,]
testing <- iris[-inTrain,]
dim(training); dim(testing)

### sepal width vs petal width, color by species
qplot(Petal.Width,Sepal.Width,colour=Species,data=training)


### rpart is the method for trees
modFit <- train(Species ~ .,method="rpart",data=training)
### Shows different splits and the percentages of flowers in sample that
### adhere to a certain classification std and which species they belong
### to.
print(modFit$finalModel)

### Basic plot of dendogram that show splits and percentages
plot(modFit$finalModel, uniform=TRUE, 
     main="Classification Tree")
text(modFit$finalModel, use.n=TRUE, all=TRUE, cex=.8)

### Prettier dendogram
library(rattle)
fancyRpartPlot(modFit$finalModel)

### predict classifications with new data
predict(modFit,newdata=testing)

