# randomForest,ROCRpkgs,OptCutoff,OOB,ROC,GINI






## Using randomForest pkg


library(randomForest)
data(iris)
set.seed(1)
### ntree = # of trees; importance=T allows purity values calc'd
### ,nodesize = minimum size of terminal nodes
model.rf <- randomForest(Species~., training, ntree=25, importance=TRUE, nodesize=5)
### Gives different info than train. OOB, confusion matrix, classif. error
model.rf
### Returns mean decrease accuracy, mean decrease GINI for each outcome
### factor level
varImpPlot(model.rf)


## Virginica has an 8% misclassification error which ain't bad.
trainingVg <- iris[inTrain,]
testingVg <- iris[-inTrain,]

### If value = virginica then keep value as virginica, if false, change to other.
trainingVg$Species <- factor(ifelse(training$Species=='virginica','virginica','other'))
testingVg$Species <- factor(ifelse(testing$Species=='virginica','virginica', 'other'))

### ntree = # of trees; importance=T allows purity values calc'd
### ,nodesize = minimum size of terminal nodes
model.rf2 <- randomForest(Species~., trainingVg, ntree=25, importance=TRUE, nodesize=5)
model.rf2
### Shows mean decrease in accuracy and Mean Decrease Gini
### Used to rank variable importance
varImpPlot(model.rf2)



## ROC and precision vs recall(PRC) curves (see bookmark)
### (below) The ROC and PRC curves look damn near perfect and the
### AUC values is .99 so yeah.

library(ROCR)
trainingVg$labels <- factor(1*(trainingVg$Species=='virginica'))
testingVg$labels <- factor(1*(testingVg$Species=='virginica'))

### instead of returning the actual predicted values, it returns the
### probabilities the model used at each observation in order to classify
### the flower as a virginica or other
OOB.votes <- predict(model.rf2, trainingVg, type="prob")
OOB.pred <- OOB.votes[,2]
pred.obj <- prediction(OOB.pred,trainingVg$labels)
### Recall(aka sensitivity) vs Precision
RP.perf <- performance(pred.obj, "prec", "rec")
plot(RP.perf)
### Receiver Operating Characteristic (ROC) curve
### True positive rate vs false positive rate
ROC.perf <- performance(pred.obj, "tpr", "fpr")
plot(ROC.perf)

### On the testing set

OOB.votes <- predict(model.rf2, testingVg, type="prob")
OOB.pred <- OOB.votes[,2]
pred.obj <- prediction(OOB.pred,testingVg$labels)
RP.perf <- performance(pred.obj, "prec", "rec")
ROC.perf <- performance(pred.obj, "tpr", "fpr")
plot(RP.perf)
plot(ROC.perf)

### optimal settings for sensitivity, specificity, cutoff
opt.cut = function(perf, pred){
  cut.ind = mapply(FUN=function(x, y, p){
    d = (x - 0)^2 + (y-1)^2
    ind = which(d == min(d))
    c(sensitivity = y[[ind]], specificity = 1-x[[ind]], 
      cutoff = p[[ind]])
  }, perf@x.values, perf@y.values, pred@cutoffs)
}
print(opt.cut(ROC.perf, pred.obj))

### This one just gives optimal cutoff
cost.perf = performance(pred.obj, "cost")
pred.obj@cutoffs[[1]][which.min(cost.perf@y.values[[1]])]

### Returns AUC value
auc.perf = performance(pred.obj, measure = "auc")
auc.perf@y.values

### Need to check the bookmark. Don't know what the pauc and fpr.stop are about.
pauc.perf = performance(pred.obj, measure = "auc", fpr.stop=0.1)
pauc.perf@y.values

pauc.perf@y.values = lapply(pauc.perf@y.values, function(x) x / 0.1)
pauc.perf@y.values