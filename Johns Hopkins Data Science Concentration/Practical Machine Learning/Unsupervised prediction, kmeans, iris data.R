# Unsupervised prediction, kmeans, iris data


## Clustering (by species)



data(iris); library(ggplot2)
inTrain <- createDataPartition(y=iris$Species,
                               p=0.7, list=FALSE)
training <- iris[inTrain,]
testing <- iris[-inTrain,]
dim(training); dim(testing)


## Clustering

### We're clustering by species so we're subsetting it out. Here we
### have named labels ready-made. Usually don't have names for out
### clusters. Though it is necessary to name them so we can classify
### in the test set.
kMeans1 <- kmeans(subset(training,select=-c(Species)),centers=3)
training$clusters <- as.factor(kMeans1$cluster)
qplot(Petal.Width,Petal.Length,colour=clusters,data=training)

### table with our clusters(1,2,3) vs truth
table(kMeans1$cluster,training$Species)
### virginica difficult to cluster, mixed between our 1st and 3rd

### Using regression trees for the model
modFit <- train(clusters ~.,data=subset(training,select=-c(Species)),method="rpart")
### Predictions for virginica mixed in the predictions as well
table(predict(modFit,training),training$Species)

### Now predicting on the test set
testClusterPred <- predict(modFit,testing)
### Model actually performs well on the test set, only two misclassifications.
table(testClusterPred ,testing$Species)
