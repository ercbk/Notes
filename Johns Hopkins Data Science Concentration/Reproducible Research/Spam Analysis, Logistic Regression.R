# Spam Analysis Example
## Logistic Regression

## From lecture Structure of Data Analysis part 2
## Can I automatically detect whether an email is spam or not?
## More concretely, can I use quantitative characteristics of the emails
## to classify them as SPAM?


## If it isn't installed, install the kernlab package
## Dataset is part of the package. Also in UCI machine learning repository
library(kernlab)
data(spam)
### data already cleaned; 4601 observations (each email), 58 variables
### In the lecture he said 4600 obs, but used 4601 for rbinom arg

### Perform the subsampling, Train (train our model) and Test (test the model)
set.seed(3435)
trainIndicator = rbinom(4601,size=1,prob=0.5)
### 2314 in one half, 2287 in the other
table(trainIndicator)
### Loop not needed. Sorta subsets it automatically with this Boolean test
trainSpam = spam[trainIndicator==1,]
testSpam = spam[trainIndicator==0,]


## Looking at the data

### Columns are mostly words and rows are the percentages the word/char occurs
### out of the total number of words in each email. So 1.92 is 1.92%.
names(trainSpam)
head(trainSpam)
### variable "type" has values, spam or nonspam
### nonspam: 1381, spam: 906
### It's a binary variable so good to check and see if you have
### an imbalanced variable.
table(trainSpam$type)




## Exploratory Analysis

## Plots

### box plots of capital average vs nonspam or spam
### capitalAve is the average number of capital letters used in
### the email.
plot(trainSpam$capitalAve ~ trainSpam$type)
### boxplots not readable (skewness of variables). So taking Logs of variables
### Adding 1 because there a lot of zeros for the words variables
### A zero value corresponds to the word not appearing in the email
### Adding 1 helps get a sense of the data. Okay for exploratory analysis.
### Spam shown to have many more capital letters
plot(log10(trainSpam$capitalAve + 1) ~ trainSpam$type)
### looking at pairwise plots between the first four variables.
### useful for seeing relationships.
plot(log10(trainSpam[,1:4]+1))





## Clustering

###
par(mar=c(0,0,0,0))
### type variable not included in the cluster. Makes sense.
### Note: transform taken
hCluster = hclust(dist(t(trainSpam[,1:57])))
### Not much to see but since we did see variable skewness in the
### boxplots we'll adjust our clustering.
plot(hCluster)


### new clustering
### Aside from taking log and adding 1, he reduced number of 
### variables again. Capital Total and Capital Long additionly removed.
### They were the intial branch splits in the first dendogram. He may
### have seen these as highly correlated vars and just kept CapAve
### to reduce the number of predictors.
hClusterUpdated = hclust(dist(t(log10(trainSpam[,1:55]+1))))
### capitalAve and some "you" words each with its own cluster
plot(hClusterUpdated)




## Statistical prediction/modeling
## Predicting SPAM from a single variable

### generlized model: logistic regression with a single variable
### without the "-1" would've coerced into 2s and 1s instead of 1s and 0s.
trainSpam$numType = as.numeric(trainSpam$type)-1

costFunction = function(x,y) sum(x!=(y > 0.5)) 
### This is the cost function given in the cv.glm documentation example for 
### logistic regression. They act this is the standard cost function for this type
### of classifier.
costFunc2 <- function(r, pi = 0) mean(abs(r-pi) > 0.5)
cvError = rep(NA,55)
library(boot)
### Cycling thru the variables and fitting the models to find a predictor.
for(i in 1:55){
  ### reformulate creates formula using numType var and each other variable
  lmFormula = reformulate(names(trainSpam)[i], response = "numType")
  glmFit = glm(lmFormula,family="binomial",data=trainSpam)
  ### Calculates the cross-validated error rate
  cvError[i] = cv.glm(trainSpam,glmFit,costFunction,2)$delta[2]
  # cvError[i] = cv.glm(trainSpam,glmFit,costFunc2,2)$delta[2]
}

## Which predictor has minimum cross-validated error?
names(trainSpam)[which.min(cvError)]
### charDollar (number of dollar signs in the email) is the winner
### Re the two different different cost functions, values were different and
### on a different scale, but both chose the same variable.




## We've trained our model. Time to test it.

### Use the best model from the group
predictionModel = glm(numType ~ charDollar,family="binomial",data=trainSpam)


## Get predictions on the test set
predictionTest = predict(predictionModel,testSpam)
predictedSpam = rep("nonspam",dim(testSpam)[1])
### return value is a probablity of whether an email will be spam or not.


## Classify as `spam' for those with prob > 0.5
predictedSpam[predictionModel$fitted > 0.5] = "spam"

## Classification table
table(predictedSpam,testSpam$type)
### Table show correctly and incorrectly predicted emails
### It's like a typeI,typeII error table. Nonspams predicted correctly:
### 1346 times, wrong: 458. Spams predicted correctly: 449, wrong: 61

### Can also take a look at the confusion matrix for other metrics
library(caret)
confusionMatrix(testSpam$type, predictedSpam)

## Error rate (correct/total)
(61+458)/(1346+458 + 61 + 449)
### 22% so 78% accurate off one variable

