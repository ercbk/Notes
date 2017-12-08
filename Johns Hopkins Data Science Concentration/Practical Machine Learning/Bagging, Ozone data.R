# Bagging, Ozone data


## Predicting Temperature by Ozone



library(ElemStatLearn); data(ozone,package="ElemStatLearn")
### ordering data by ozone because... I dunno. Thought it'd 
### be easier to visualize something. Maybe will see what he's
### talking about further down.
ozone <- ozone[order(ozone$ozone),]
head(ozone)


## The hard way

### creating 10x155 matrix
ll <- matrix(NA,nrow=10,ncol=155)
### resampling, fitting, predicting ten times
for(i in 1:10){
  ### sampling with replacement
  ss <- sample(1:dim(ozone)[1],replace=T)
  ### creating new data set with resampled data, then ordering by ozone.
  ozone0 <- ozone[ss,]; ozone0 <- ozone0[order(ozone0$ozone),]
  ### fitting a low S curve (see notes pg 55) to new dataset
  ### span is a parameter on how "smooth" we want the curve.
  loess0 <- loess(temperature ~ ozone,data=ozone0,span=0.2)
  ### predicting using resampled model and original data
  ### Each row of matrix is the predicted values from this resampling iteratio
  ll[i,] <- predict(loess0,newdata=data.frame(ozone=1:155))
}

### Ozone vs temperature and the fitted curves for each iteration
plot(ozone$ozone,ozone$temperature,pch=19,cex=0.5)
for(i in 1:10){lines(1:155,ll[i,],col="grey",lwd=2)}
### The red line is the averaged curve
lines(1:155,apply(ll,2,mean),col="red",lwd=2)


## Advanced bagging in caret by creating your own bagging function

### creating a data frame with just the predictor variable
predictors = data.frame(ozone=ozone$ozone)
### outcome variable
temperature = ozone$temperature
### both passed to bag function of caret pkg
### B is the number of resampling iterations
treebag <- bag(predictors, temperature, B = 10,
               ### details on the model fitting
               bagControl = bagControl(fit = ctreeBag$fit,
                                       predict = ctreeBag$pred,
                                       aggregate = ctreeBag$aggregate))


plot(ozone$ozone,temperature,col='lightgrey',pch=19)
points(ozone$ozone,predict(treebag$fits[[1]]$fit,predictors),pch=19,col="red")
points(ozone$ozone,predict(treebag,predictors),pch=19,col="blue")


ctreeBag$fit
ctreeBag$pred
ctreeBag$aggregate
