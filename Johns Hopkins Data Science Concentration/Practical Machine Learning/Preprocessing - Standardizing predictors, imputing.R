# Preprocessing - Standardizing predictors, Box Cox, imputing






library(caret); library(kernlab); data(spam)
inTrain <- createDataPartition(y=spam$type,
                               p=0.75, list=FALSE)
training <- spam[inTrain,]
testing <- spam[-inTrain,]
### shows variable is very skewed to the left
hist(training$capitalAve,main="",xlab="ave. capital run length")


mean(training$capitalAve)
### sd >> mean
sd(training$capitalAve)


## The manual way to standardize

### The skewness and high variability are reasons to standardize.
trainCapAve <- training$capitalAve
trainCapAveS <- (trainCapAve  - mean(trainCapAve))/sd(trainCapAve) 
mean(trainCapAveS)
sd(trainCapAveS)

### If we standardize in the training, we have to standardize in the 
### test set. Although here, we subtract the *training mean* from the
### test mean.
testCapAve <- testing$capitalAve
testCapAveS <- (testCapAve  - mean(trainCapAve))/sd(trainCapAve) 
mean(testCapAveS)
sd(testCapAveS)


## Using preProcess,predict to standardize capitalAve

### Never seen predict used this way. Won't hazard a guess as to what's
### exactly happening here so just going to accept this as the process 
### and that's that.
preObj <- preProcess(training[,-58],method=c("center","scale"))
trainCapAveS <- predict(preObj,training[,-58])$capitalAve
mean(trainCapAveS)
sd(trainCapAveS)

### Now for the test set...
testCapAveS <- predict(preObj,testing[,-58])$capitalAve
mean(testCapAveS)
sd(testCapAveS)

### Preprocessing within the train function
set.seed(32343)
modelFit <- train(type ~.,data=training,
                  preProcess=c("center","scale"),method="glm")
modelFit


## Another soln for a highly skewed variable is the Box Cox transformation

### Unfortunately here there are a lot of zeroes and since this is a 
### continuous transformation it doesn't handle repaeated values well.
### Nevertheless it's another tool.
preObj <- preProcess(training[,-58],method=c("BoxCox"))
trainCapAveS <- predict(preObj,training[,-58])$capitalAve
par(mfrow=c(1,2)); hist(trainCapAveS); qqnorm(trainCapAveS)


## Models don't work with NAs so one sol'n is imputing

set.seed(13343)

### Make some values NA
training$capAve <- training$capitalAve
selectNA <- rbinom(dim(training)[1],size=1,prob=0.05)==1
training$capAve[selectNA] <- NA

### Impute and standardize
preObj <- preProcess(training[,-58],method="knnImpute")
capAve <- predict(preObj,training[,-58])$capAve

### Standardize true values
capAveTruth <- training$capitalAve
capAveTruth <- (capAveTruth-mean(capAveTruth))/sd(capAveTruth)

### imputed values stand up well against the standardized values;
### not much difference at all.
quantile(capAve - capAveTruth)
quantile((capAve - capAveTruth)[selectNA])
quantile((capAve - capAveTruth)[!selectNA])


