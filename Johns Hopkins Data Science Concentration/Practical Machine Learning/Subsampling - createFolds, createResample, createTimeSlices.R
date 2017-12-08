#Subsampling - createFolds, createResample, createTimeSlices
## see notes




library(caret); library(kernlab); data(spam)
inTrain <- createDataPartition(y=spam$type,
                               p=0.75, list=FALSE)
training <- spam[inTrain,]
testing <- spam[-inTrain,]
dim(training)


## see notes on the specifics of k-fold sampling

### returning 10 training folds
set.seed(32323)
foldsTrain <- createFolds(y=spam$type,k=10,
                     list=TRUE,returnTrain=TRUE)
sapply(foldsTrain,length)
foldsTrain[[1]][1:10]

### now returning the 10 test folds
set.seed(32323)
foldsTest <- createFolds(y=spam$type,k=10,
                     list=TRUE,returnTrain=FALSE)
sapply(foldsTest,length)
foldsTest[[1]][1:10]

### bootstrap resampling
set.seed(32323)
foldsBoot <- createResample(y=spam$type,times=10,
                        list=TRUE)
sapply(folds,length)
folds[[1]][1:10]

### Time slicing for time data
set.seed(32323)
tme <- 1:1000
folds <- createTimeSlices(y=tme,initialWindow=20,
                          horizon=10)
names(folds)
folds$train[[1]]
folds$test[[1]]


