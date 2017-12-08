# Modeling functions, splines

### 500pts, x=0 to 4pi, y= sine wave with some normal errors
n <- 500; x <- seq(0, 4 * pi, length = n); y <- sin(x) + rnorm(n, sd = .3)
### 20 equally spaced knot pts
knots <- seq(0, 8 * pi, length = 20); 
### especially see notes on this; function recognizable in the model equation
splineTerms <- sapply(knots, function(knot) (x > knot) * (x - knot))
### x matrix, 3 columns. "1" is just a col w/all 1s.
### 1-col is the intercept. Need it because we want to subtract out the intercept
### in the linear model.
### When called, a lot of zero-columns are included. Don't understand why it just
### doesn't have three columns.
xMat <- cbind(1, x, splineTerms)
### yhat values are returned when using predict()
### yhat2 <- lm(y~xMat-1)$fitted.values does the same thing
yhat <- predict(lm(y ~ xMat - 1))
plot(x, y, frame = FALSE, pch = 21, bg = "lightblue", cex = 2)
### fitted line but line isn't "smooth." It's pointed and blocked near the knot areas.
lines(x, yhat, col = "red", lwd = 2)

### Squaring the spline terms smooths the regression line out; makes it more curvy.
splineTerms <- sapply(knots, function(knot) (x > knot) * (x - knot)^2)
xMat <- cbind(1, x, x^2, splineTerms)
yhat <- predict(lm(y ~ xMat - 1))
plot(x, y, frame = FALSE, pch = 21, bg = "lightblue", cex = 2)
lines(x, yhat, col = "red", lwd = 2)

