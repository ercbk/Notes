# Principle Component Analysis (PCA)






library(caret); library(kernlab); data(spam)
inTrain <- createDataPartition(y=spam$type,
                               p=0.75, list=FALSE)
training <- spam[inTrain,]
testing <- spam[-inTrain,]

### making correlation matrix
M <- abs(cor(training[,-58]))
### diagonal of the matrix is just the correlation of a var vs itself so this
### removes those meaningless values
diag(M) <- 0
### searching for variables with correlations > 80%
which(M > 0.8,arr.ind=T)
### returns two vars

### col names of the two vars
names(spam)[c(34,32)]
### showing the big time correlation, almost all values lie on the y=x line
plot(spam[,34],spam[,32])

## Nuts and bolts of using PCA to predict

### we want to keep the portion of the vars with variabiliy (predictive power)
### and remove most of the multicollinearity so taking linear combos helps
### do that.
X <- 0.71*training$num415 + 0.71*training$num857
Y <- 0.71*training$num415 - 0.71*training$num857
### plot shows most of the variability in the x values where as the y values
### center around zero. Therefore, x would be the variable we'd want to use in
### place of num415,num857.
plot(X,Y)

### same thing but using prcomp function
smallSpam <- spam[,c(34,32)]
prComp <- prcomp(smallSpam)
plot(prComp$x[,1],prComp$x[,2])

### extracting rotation shows us the weights used which how the above ones were
### obtained.
prComp$rotation

### PCA'ing over the whole spam dataset. Some vars are skewed so log10 taken to
### make them more Guassian. 1 added because of the zero counts. Models don't like
### NAs or 0s.
typeColor <- ((spam$type=="spam")*1 + 1)
prComp <- prcomp(log10(spam[,-58]+1))
plot(prComp$x[,1],prComp$x[,2],col=typeColor,xlab="PC1",ylab="PC2")

### PCA'ing with the caret pkg
preProc <- preProcess(log10(spam[,-58]+1),method="pca",pcaComp=2)
spamPC <- predict(preProc,log10(spam[,-58]+1))
### plot looks different but most of it is probably due to different axis values
plot(spamPC[,1],spamPC[,2],col=typeColor)

### Now using PCA values to predict
preProc <- preProcess(log10(training[,-58]+1),method="pca",pcaComp=2)
trainPC <- predict(preProc,log10(training[,-58]+1))
trainPC <- data.frame(trainPC, training$type)
modelFit <- train(training.type ~ .,method="glm",data=trainPC)
testPC <- predict(preProc,log10(testing[,-58]+1))
### confusionMatrix shows how the model performed on the test set
confusionMatrix(testing$type,predict(modelFit,testPC))

### Same thing but doing all the work with the train options
modelFit <- train(type ~ .,method="glm",preProcess="pca",data=training)
confusionMatrix(testing$type,predict(modelFit,testing))
### good accuracy with minimal variables (compression)
