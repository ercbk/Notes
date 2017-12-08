# Choosing bt ARIMA, ETS, or STLf part qautre

## From fpp ebook Ch 8 exercises
## Data: Quarterly retail trade index in the Euro area (17 countries)
## , 1996-2011, covering wholesale and retail trade, and repair of motor 
## vehicles and motorcycles. (Index: 2005 = 100).
## "#" means Hyndman's comments. "###" is mine.

### Hyndman's lab uses some kind of retail file. I'm using a retail set
### from fpp. His is monthly while mine is quarterly.



library(fpp); library(ggplot2)

# Question 3
data(euretail)


# # Download retail.xls file and convert to csv
# retail <- ts(read.table("retail.csv", skip=1,
#                         sep = ",", header = TRUE,
#                         stringsAsFactors = FALSE)[,-1], frequency=12, start=c(1982,4))
# # Choose one of the columns at random
# col <- sample(1:ncol(retail),1)
# # Select series
# x <- retail[,col] 

autoplot(euretail)
BoxCox.lambda(euretail) #1.999924
ggtsdisplay(euretail)
autoplot(log(euretail))
ggtsdisplay(log(euretail))
ndiffs(euretail, alpha=0.05, test="adf") # 2
nsdiffs(euretail, m=4, test="ch") # 0
nsdiffs(euretail, m=4, test="ocsb") # 1
ggtsdisplay(diff(diff(euretail)))
ggtsdisplay(diff(euretail,4))
ggtsdisplay(diff(diff(euretail,4))) ### (spoiler: winner)
ggtsdisplay(diff(diff(diff(euretail,4))))
ggtsdisplay(diff(diff(diff(log(euretail),4))))
### Really shooting in the dark since I'm using a different data set
### with quarterly seasonality.
### I'd guess just seasonal diff is out but the other 4 out of
### the last five have a shot. Guess we'll see what auto.arima spits out.


fit <- auto.arima(euretail)
fit ### ARIMA(1,1,2)(0,1,1)[4] so seasonal and 1st diff
checkresiduals(fit) ### acf looks great; passed LB test too. hist good.
# For some of the retail series, the residuals might fail this test.
### Kinda curious about other arima models but doesn't seem necessary when
### you've hit so close to the mark.

fc <- forecast(fit)
autoplot(fc)

# Other models:
fc1 <- forecast(ets(euretail))
fc2 <- stlf(euretail)
fc3 <- stlf(euretail, method="arima")
df <- cbind(arima=fc$mean, ets=fc1$mean, stl=fc2$mean, stlA=fc3$mean)
autoplot(df)
### arima and stl(hybrid ets,arim) pretty much in lock step with stl slightly
### more conservative. Stl-arima really conservative comparatively. Ets
### the most ambitious one out of the group.

### Lets check their residuals
checkresiduals(ets(euretail)) ### acf looks great, hist fine, failed LB
checkresiduals(stlf(euretail)) ### spike at lag 4 but okay, failed LB
checkresiduals(stlf(euretail, method="arima")) ### huge spike at lag 4, failed LB

### Yeah, so looks like ARIMA again. Can't have decent PIs w/o good residuals
### I think in all four of these exercise ets and stlf have failed LB. 