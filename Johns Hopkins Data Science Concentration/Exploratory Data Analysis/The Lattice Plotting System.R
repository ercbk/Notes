#The Lattice Plotting System



## Simple Lattice Plot

### Ozone (y), Wind (x)
library(lattice)
library(datasets)
## Simple scatterplot
xyplot(Ozone ~ Wind, data = airquality)


## cont.

###
library(datasets)
library(lattice)
### Convert 'Month' to a factor variable
airquality <- transform(airquality, Month = factor(Month))
### scatterplot of ozone and wind for every month; 5 plots, 1 row.
xyplot(Ozone ~ Wind | Month, data = airquality, layout = c(5, 1))


## Lattice Behavior

### Just calling xyplot engages autoprint feature but assigning
### to p requires the print function
p <- xyplot(Ozone ~ Wind, data = airquality)  ## Nothing happens!
print(p)  ## Plot appears
xyplot(Ozone ~ Wind, data = airquality)  ## Auto-printing


## Lattice Panel Functions

### Looks like trivial scatterplots with factor
set.seed(10)
x <- rnorm(100)
f <- rep(0:1, each = 50)
y <- x + f - f * x+ rnorm(100, sd = 0.5)
f <- factor(f, labels = c("Group 1", "Group 2"))
xyplot(y ~ x | f, layout = c(2, 1))  ## Plot with 2 panels


## cont.

### Custom panel function
xyplot(y ~ x | f, panel = function(x, y, ...) {
  panel.xyplot(x, y, ...)  ## First call the default panel function for 'xyplot'
  panel.abline(h = median(y), lty = 2)  ## Add a horizontal line at the median
})


## Lattice Panel Functions: Regression line

### Custom panel function
xyplot(y ~ x | f, panel = function(x, y, ...) {
  panel.xyplot(x, y, ...)  ## First call default panel function (makes pts,axes appear)
  panel.lmline(x, y, col = 2)  ## Overlay a simple linear regression line
})


## Many Panel Lattice Plot

### Mouse Allergen and Asthma Cohort Study
### How does indoor airborne mouse allergen vary over time and across subjects
### Panel plot allow you to look at a lot of data at once. Each plot is one patient.
### Just fyi: xplot line is LONG so don't miss an argument
library(lattice)
env <- readRDS("maacs_env.rds")
### transforms dataset that makes MxNum variable a factor variable
env <- transform(env, MxNum = factor(MxNum))
### airmus = mouse allergen level vs number of visits.
xyplot(log2(airmus) ~ VisitNum | MxNum, data = env, strip = FALSE, pch = 20, xlab = "Visit Number", ylab = expression(Log[2] * " Airborne Mouse Allergen"), main = "Mouse Allergen and Asthma Cohort Study (Baltimore City)")
