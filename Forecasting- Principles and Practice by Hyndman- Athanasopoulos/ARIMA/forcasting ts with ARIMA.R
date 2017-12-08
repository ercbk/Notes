# forcasting ts with ARIMA






library(forecast)
data <- read.csv("UKCPI.csv")
print(is.ts(data$UKCPI))  # check whether it is a time-series object
data$UKCPI <- ts(data$UKCPI, start=c(1988, 1), end=c(2013, 4), frequency=4)


dUKCPI <- diff(data$UKCPI)

plot(dUKCPI)


dUKCPI_subset <- window(dUKCPI, start=c(2001, 1), end=c(2012, 4))


fit_diff_400 <- Arima(dUKCPI, order=c(4,0,0))
Arima(data$UKCPI, order=c(4,1,0))
names(fit_diff_400)
fit_diff <- auto.arima(dUKCPI,seasonal=FALSE)



fit_diff_400f <- forecast(fit_diff_400,h=10)
plot(forecast(fit_diff_400,h=10))
plot(forecast(fit_diff_400,h=10), include = 40)
