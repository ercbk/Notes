# Random Forests, iris data


## Predicting species



data(iris); library(ggplot2); library(caret)
inTrain <- createDataPartition(y=iris$Species,
                               p=0.7, list=FALSE)
training <- iris[inTrain,]
testing <- iris[-inTrain,]


### mtry=2 selected as optimal model, 95.8% accuracy
modFit <- train(Species~ .,data=training,method="rf",prox=TRUE)
modFit

### Look at a specific tree
getTree(modFit$finalModel,k=2)

### Centers actually called "prototypes." Can be used to represent a group
### of data points. Kinda like centroids in clustering.
irisP <- classCenter(training[,c(3,4)], training$Species, modFit$finalModel$prox)
irisP <- as.data.frame(irisP); irisP$Species <- rownames(irisP)
p <- qplot(Petal.Width, Petal.Length, col=Species,data=training)
p + geom_point(aes(x=Petal.Width,y=Petal.Length,col=Species),size=5,shape=4,data=irisP)

### table showing correct/incorrect predictions
pred <- predict(modFit,testing); testing$predRight <- pred==testing$Species
table(pred,testing$Species)

### visualizing the data points the model misclassified
qplot(Petal.Width,Petal.Length,colour=predRight,data=testing,main="newdata Predictions")



