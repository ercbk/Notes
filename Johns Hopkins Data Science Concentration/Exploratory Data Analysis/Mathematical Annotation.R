# Mathematical Annotation



## Examples

plot(0, 0, main = expression(theta == 0),
     ylab = expression(hat(gamma) == 0),
     xlab = expression(sum(x[i] * y[i], i==1, n)))

## pasting strings together

x <- rnorm(100)
hist(x,
     xlab=expression("The mean (" * bar(x) * ") is " *
                       sum(x[i]/n,i==1,n)))

## Substituting

x <- rnorm(100)
y <- x + rnorm(100, sd = 0.5)
plot(x, y,
     xlab=substitute(bar(x) == k, list(k=mean(x))),
     ylab=substitute(bar(y) == k, list(k=mean(y)))
)

## loop of plots

par(mfrow = c(2, 2))
for(i in 1:4) {
  x <- rnorm(100)
  hist(x, main=substitute(theta==num,list(num=i)))
}