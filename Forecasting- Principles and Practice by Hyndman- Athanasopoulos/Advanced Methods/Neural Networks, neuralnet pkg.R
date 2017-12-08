# Neural Networks, neuralnet pkg

## Dataframe: Predicting Housing Values in Suburbs of Boston

# This data frame contains the following columns:
# crim - per capita crime rate by town.
# zn - proportion of residential land zoned for lots over 25,000 sq.ft.
# indus - proportion of non-retail business acres per town.
# chas - Charles River dummy variable (= 1 if tract bounds river; 0 otherwise).
# nox - nitrogen oxides concentration (parts per 10 million).
# rm - average number of rooms per dwelling.
# age - proportion of owner-occupied units built prior to 1940.
# dis - weighted mean of distances to five Boston employment centres.
# rad - index of accessibility to radial highways.
# tax - full-value property-tax rate per \$10,000.
# ptratio - pupil-teacher ratio by town.
# black - 1000(Bk - 0.63)^2 where Bk is the proportion of blacks by town.
# lstat - lower status of the population (percent).
# medv (Response variable) - median value of owner-occupied homes in \$1000s.



# Set a seed
set.seed(500)

library(MASS)
data <- Boston

# Check that no data is missing
apply(data,2,function(x) sum(is.na(x)))

# Train-test random splitting for linear model
### Not a big deal but prefer createDataPartition() in the caret pkg
index <- sample(1:nrow(data),round(0.75*nrow(data)))
train <- data[index,]
test <- data[-index,]

# Fitting linear model

lm.fit <- glm(medv~., data=train)
### Awful that the proportion of Af-Americans is so predictive but since this data
### seems to be early 80s/late 70s, maybe that's changed some.
### Crime seems borderline predictive but I'd think you'd have to include that one.
### % of Non-retail businesses and age of bldgs might be discarded.
summary(lm.fit)

# Predicted data from lm
pr.lm <- predict(lm.fit,test)

# Test MSE
### Guess this is fine if you're just using it to compare models but I prefer
### the interpretability of RMSE. Need to watch for outliers in both, though.
MSE.lm <- sum((pr.lm - test$medv)^2)/nrow(test)


## Extracurricular by me

### Seeing a nonlinear trend in the Resid vs Fitted graph; Q-Q looks hinky too
### Nothing violated Cook's distance in a cursory examination for outliers
plot(lm.fit)

### predicted vs observed plot shows model has problems predicting
### median home values greater than ~$33,000.
qplot(medv, pr.lm, data=test)


#-------------------------------------------------------------------------------
# Neural net fitting

# Scaling data for the NN
maxs <- apply(data, 2, max) 
mins <- apply(data, 2, min)
scaled <- as.data.frame(scale(data, center = mins, scale = maxs - mins))

# Train-test split
train_ <- scaled[index,]
test_ <- scaled[-index,]

# NN training
library(neuralnet)
### Getting column names
n <- names(train_)
### creating a regression formula object
f <- as.formula(paste("medv ~", paste(n[!n %in% "medv"], collapse = " + ")))
### Two hidden layers, 5 neurons and 3 neurons; 1 model trained
### linear.output = TRUE, means model is linear regression
###      "        = FALSE, means model is classification
nn <- neuralnet(f,data=train_,hidden=c(5,3),linear.output=T)
### The lifesign arg lets you watch it work. Default is "none".
nnTrace <- neuralnet(f,data=train_,hidden=c(5,3), lifesign="minimal", linear.output=T)
### The rep arg specifies how many models you want to train
nnRep <- neuralnet(f,data=train_,hidden=c(5,3), rep=25, lifesign="full", linear.output=T)

# Visual plot of the model
## Shows bias nodes, which in regression, bias can be thought of as the intercept.
plot(nn)

# Predict
### Response var not included.
pr.nn <- compute(nn,test_[,1:13])
pr.nn.rep <- compute(nnRep, test_[,1:13])
# Results from NN are normalized (scaled)
# Descaling for comparison
### Looks right
descaled.pr.nn_ <- pr.nn$net.result*(max(data$medv)-min(data$medv))+min(data$medv)
descaled.pr.nn.rep <- pr.nn.rep$net.result*(max(data$medv)-min(data$medv))+min(data$medv)
test.r <- (test_$medv)*(max(data$medv)-min(data$medv))+min(data$medv)

# Calculating MSE
MSE.nn <- sum((test.r - descaled.pr.nn_)^2)/nrow(test_)
MSE.nn.rep <- sum((test.r - descaled.pr.nn.rep)^2)/nrow(test_)
# Compare the two MSEs
### "21.6297593507225 15.5184659857055 12.6874184311306"
print(paste(MSE.lm,MSE.nn,MSE.nn.rep))
### Neural network better in this case.
### On a side note, I win. It's good to train many models.


# Plot predictions
par(mfrow=c(1,3))

### Predicted values vs Observed (test set) values
plot(test$medv,descaled.pr.nn_,col='red',main='Real vs predicted NN',pch=18,cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend='NN',pch=18,col='red', bty='n')

plot(test$medv,pr.lm,col='blue',main='Real vs predicted lm',pch=18, cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend='LM',pch=18,col='blue', bty='n', cex=.95)

plot(test$medv,descaled.pr.nn.rep,col='red',main='Real vs predicted many model NN',pch=18,cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend='NN',pch=18,col='red', bty='n')

# Compare predictions on the same plot
par(mfrow=c(1,1))
plot(test$medv,pr.nn_,col='red',main='Real vs predicted NN',pch=18,cex=0.7)
points(test$medv,pr.lm,col='blue',pch=18,cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend=c('NN','LM'),pch=18,col=c('red','blue'))

#-------------------------------------------------------------------------------
# Cross validating

library(boot)
set.seed(200)

# Linear model cross validation
lm.fit <- glm(medv~.,data=data)
### This function calculates the estimated K-fold cross-validation 
### prediction error for generalized linear models.
### The first delta component is the raw cross-validation estimate of prediction error. 
### delta[2] is the adjusted version. He's using 10 folds which is
### probably the floor for NOT using the adjusted estimate.
cv.glm(data,lm.fit,K=10)$delta[1]
 
### Looks like he's doing a manual cross-validation below for this nn.
### Caret pkg should be able to this automatically

# Neural net cross validation
set.seed(450)
cv.error <- NULL
k <- 10

# Initialize progress bar
library(plyr) 
pbar <- create_progress_bar('text')
pbar$init(k)

for(i in 1:k){
  index <- sample(1:nrow(data),round(0.9*nrow(data)))
  train.cv <- scaled[index,]
  test.cv <- scaled[-index,]
  
  nn <- neuralnet(f,data=train.cv,hidden=c(5,2),linear.output=T)
  
  pr.nn <- compute(nn,test.cv[,1:13])
  pr.nn <- pr.nn$net.result*(max(data$medv)-min(data$medv))+min(data$medv)
  
  test.cv.r <- (test.cv$medv)*(max(data$medv)-min(data$medv))+min(data$medv)
  
  cv.error[i] <- sum((test.cv.r - pr.nn)^2)/nrow(test.cv)
  
  pbar$step()
}

# Average MSE
### 10.67757198
mean(cv.error)

# MSE vector from CV
### 7 of the 10 errors are below the mean value
cv.error

# Visual plot of CV results
### visually shows the variablity with the median
### below the mean value
boxplot(cv.error,xlab='MSE CV',col='cyan',
        border='blue',names='CV error (MSE)',
        main='CV error (MSE) for NN',horizontal=TRUE)

