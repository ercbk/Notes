# Function for calculating RMSE for mult ARIMA models


getrmse <- function(x,h,...)
{
  train.end <- time(x)[length(x)-h]
  test.start <- time(x)[length(x)-h+1]
  train <- window(x,end=train.end)
  test <- window(x,start=test.start)
  fit <- Arima(train,...)
  fc <- forecast(fit,h=h)
  return(accuracy(fc,test)[2,"RMSE"])
}

getrmse(h02,h=24,order=c(3,0,0),seasonal=c(2,1,0),lambda=0)
getrmse(h02,h=24,order=c(3,0,1),seasonal=c(2,1,0),lambda=0)
getrmse(h02,h=24,order=c(3,0,2),seasonal=c(2,1,0),lambda=0)
getrmse(h02,h=24,order=c(3,0,1),seasonal=c(1,1,0),lambda=0)
getrmse(h02,h=24,order=c(3,0,1),seasonal=c(0,1,1),lambda=0)
getrmse(h02,h=24,order=c(3,0,1),seasonal=c(0,1,2),lambda=0)
getrmse(h02,h=24,order=c(3,0,1),seasonal=c(1,1,1),lambda=0)
getrmse(h02,h=24,order=c(4,0,3),seasonal=c(0,1,1),lambda=0)
getrmse(h02,h=24,order=c(3,0,3),seasonal=c(0,1,1),lambda=0)
getrmse(h02,h=24,order=c(4,0,2),seasonal=c(0,1,1),lambda=0)
getrmse(h02,h=24,order=c(3,0,2),seasonal=c(0,1,1),lambda=0)
getrmse(h02,h=24,order=c(2,1,3),seasonal=c(0,1,1),lambda=0)
getrmse(h02,h=24,order=c(2,1,4),seasonal=c(0,1,1),lambda=0)
getrmse(h02,h=24,order=c(2,1,5),seasonal=c(0,1,1),lambda=0)