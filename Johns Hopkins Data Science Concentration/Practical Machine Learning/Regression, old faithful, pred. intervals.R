# Regression, old faithful, pred. intervals



## Predicting duration of geyser blast by the waiting time between blasts


library(caret); data(faithful); set.seed(333)
inTrain <- createDataPartition(y=faithful$waiting,
                               p=0.5, list=FALSE)
trainFaith <- faithful[inTrain,]; testFaith <- faithful[-inTrain,]
head(trainFaith)
plot(trainFaith$waiting,trainFaith$eruptions,pch=19,col="blue",xlab="Waiting",ylab="Duration")


## linear fit the regular way

lm1 <- lm(eruptions ~ waiting,data=trainFaith)
summary(lm1)
### plotting the fit
plot(trainFaith$waiting,trainFaith$eruptions,pch=19,col="blue",xlab="Waiting",ylab="Duration")
lines(trainFaith$waiting,lm1$fitted,lwd=3)
### comparing the fit for the training to that same fit on the test data
par(mfrow=c(1,2))
plot(trainFaith$waiting,trainFaith$eruptions,pch=19,col="blue",xlab="Waiting",ylab="Duration")
lines(trainFaith$waiting,predict(lm1),lwd=3)
plot(testFaith$waiting,testFaith$eruptions,pch=19,col="blue",xlab="Waiting",ylab="Duration")
lines(testFaith$waiting,predict(lm1,newdata=testFaith),lwd=3)

### plotting the CI, line over test data
pred1 <- predict(lm1,newdata=testFaith,interval="prediction")
ord <- order(testFaith$waiting)
plot(testFaith$waiting,testFaith$eruptions,pch=19,col="blue")
matlines(testFaith$waiting[ord],pred1[ord,],type="l",col=c(1,2,2),lty = c(1,1,1), lwd=3)


### Regression with caret pkg

modFit <- train(eruptions ~ waiting,data=trainFaith,method="lm")
summary(modFit$finalModel)

### CIs of fitted data. ggplot needs a data frame
pred2 <- data.frame(predict(modFit$finalModel,newdata=testFaith,interval="prediction"))
pred2$eruptions = testFaith$eruptions
pred2$waiting = testFaith$waiting
### plotting the line and CI over the test data
g <- ggplot(testFaith, aes(waiting, eruptions))
g + geom_point()  + geom_smooth(data = trainFaith, method = "lm") 
  + geom_ribbon(data = pred2, aes(ymin = lwr, ymax = upr), alpha = 0.1)
