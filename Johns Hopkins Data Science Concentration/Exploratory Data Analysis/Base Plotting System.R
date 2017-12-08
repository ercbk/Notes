# Base Plotting System


## Simple Base Graphics: Histogram

### frequency (count) vs Ozone
library(datasets)
hist(airquality$Ozone)  ## Draw a new plot


## Simple Base Graphics: Scatterplot

### Ozone(y) vs Wind
library(datasets)
with(airquality, plot(Wind, Ozone))


## Simple Base Graphics: Boxplot

### Character variable transformed into a factor variable. Box plot for each
### month
library(datasets)
airquality <- transform(airquality, Month = factor(Month))
boxplot(Ozone ~ Month, airquality, xlab = "Month", ylab = "Ozone (ppb)")


## Base Plot with Annotation

### Add a title
library(datasets)
with(airquality, plot(Wind, Ozone))
title(main = "Ozone and Wind in New York City") 


## cont.

### Title in plot-call this time
### First with() plots Ozone vs wind
### Second with() colors the data points in May blue.
### So one plot but two with() calls.
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City"))
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue"))


## cont.

### type="n" incl. because of multiple subsetting, not fully explained.
### legend added
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City", type = "n"))
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue"))
with(subset(airquality, Month != 5), points(Wind, Ozone, col = "red"))
legend("topright", pch = 1, col = c("blue", "red"), legend = c("May", "Other Months"))


## Base Plot with Regression Line

### regression line added
### linear model created, then passed to abline to be plotted.
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City", pch = 20))
model <- lm(Ozone ~ Wind, airquality)
abline(model, lwd = 2)


## Multiple Base Plots

### par + mfrow specifies how you want your multiple plots displayed. Here: 1 row, 2 col
par(mfrow = c(1, 2))
with(airquality, {
  plot(Wind, Ozone, main = "Ozone and Wind")
  plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
})


## cont.

### Overall Title for the 3 plots added w/mtext. So inner margin(mar) decreased and 
### outer margin(oma) increased from default values
par(mfrow = c(1, 3), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
with(airquality, {
  plot(Wind, Ozone, main = "Ozone and Wind")
  plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
  plot(Temp, Ozone, main = "Ozone and Temperature")
  mtext("Ozone and Weather in New York City", outer = TRUE)
})
