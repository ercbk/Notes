# Exponential Smoothing, oil data, ts ebook

## Also various other methods w/livestock data




library(fpp)
oildata <- window(oil,start=1996,end=2007)

### alpha = smoothing parameter, h = number of periods (here in years)
### that you want to forecast ahead, initial = simple means
### L0 set to y1
fit1 <- ses(oildata, alpha=0.2, initial="simple", h=3)
fit2 <- ses(oildata, alpha=0.6, initial="simple", h=3)
### Shows errors and forcast values; under inital states,confirms L0 = y1
summary(fit1)
### default value is alpha=.89 and initial=optimal which means L0 found by
### using ets(), essientially minimizing SSE
fit3 <- ses(oildata, h=3)

### All these produced fitted values; maybe with different methods
### (like those with trend, seasonality) you get some different things
fit1$fitted
fit1$model$states
fitted(fit1)


### plotting results
plot(fit1, plot.conf=FALSE, ylab="Oil (millions of tonnes)",
     xlab="Year", main="", fcol="white", type="o")
lines(fitted(fit1), col="blue", type="o")
lines(fitted(fit2), col="red", type="o")
lines(fitted(fit3), col="green", type="o")
lines(fit1$mean, col="blue", type="o")
lines(fit2$mean, col="red", type="o")
lines(fit3$mean, col="green", type="o")
legend("topleft",lty=1, col=c(1,"blue","red","green"), 
       c("data", expression(alpha == 0.2), expression(alpha == 0.6),
         expression(alpha == 0.89)),pch=1)

## Asia sheep population
livestock2 <- window(livestock,start=1970,end=2000)
fit1 <- ses(livestock2)
### Holt Linear Trend method
fit2 <- holt(livestock2)
### Exponential Trend method
fit3 <- holt(livestock2,exponential=TRUE)
### Additive Damped method
fit4 <- holt(livestock2,damped=TRUE)
### Multiplicative Damped method
fit5 <- holt(livestock2,exponential=TRUE,damped=TRUE)
# Results for first model:
fit1$model
### Holt Linear Trend most accurate followed by additive damped
accuracy(fit1) # training set
### Exponential Trend leads in MAE, MAPE, MASE, while Holt's Linear Trend
### leads in RMSE. Conflicting error measurements not uncommon and nothing
### to fret over. Both models would do an adequate job.
accuracy(fit1,livestock) # test set

### Just showing trend component of Holt's is constant thus linear which
### is expected. Linear is in the name and stuff
plot(fit2$model$state)
### Showing additive damped trend component is decreasing which is expected
### since it's being damped
plot(fit4$model$state)

### Showing the differences in forecasts for each model
plot(fit3, type="o", ylab="Livestock, sheep in Asia (millions)", 
     flwd=1, plot.conf=FALSE)
lines(window(livestock,start=2001),type="o")
lines(fit1$mean,col=2)
lines(fit2$mean,col=3)
lines(fit4$mean,col=5)
lines(fit5$mean,col=6)
legend("topleft", lty=1, pch=1, col=1:6,
       c("Data","SES","Holt's","Exponential",
         "Additive Damped","Multiplicative Damped"))