# Creating Covariates, Dummy Vars, wage data
## also, finding low variable predictors, and spline fitting





library(ISLR); library(caret); data(Wage);
inTrain <- createDataPartition(y=Wage$wage,
                               p=0.7, list=FALSE)
training <- Wage[inTrain,]; testing <- Wage[-inTrain,]

### information, industrial are the levels for factor jobclass
table(training$jobclass)
### Creating dummy variables (0s,1s)
dummies <- dummyVars(wage ~ jobclass,data=training)
head(predict(dummies,newdata=training))
jobclassD <- predict(dummies,newdata=training)

### Finding predictors of low variability and thus have little to no
### predictive power.
nsv <- nearZeroVar(training,saveMetrics=TRUE)
nsv


## Fitting curvy lines

### returns age, age^2, age^3, which are scaled for computational purposes
library(splines)
### object that could be added to training df
bsBasis <- bs(training$age,df=3) 
bsBasis

### Regressing with the three predictors
lm1 <- lm(wage ~ bsBasis,data=training)
### plotting the curvilinear line
plot(training$age,training$wage,pch=19,cex=0.5)
points(training$age,predict(lm1,newdata=training),col="red",pch=19,cex=0.5)

### The newly created vars need to be applied the test set now
predict(bsBasis,age=testing$age)
### object that could be added to test df
TbsBasis <- predict(bsBasis,age=testing$age)

