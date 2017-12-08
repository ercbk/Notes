# ggplot2 pt2
## data not included


## MAACS, basic plot

### Trying to answer whether BMI modifies relationship
### between pm25(airborne particulate matter) and 
### asthma symptoms
maacs <- read.csv("ggplot2_lecture2_data.csv")
library(ggplot2)
### similar plot in structure to end of last lecture
### 2 var = scatter, factor=bmicat, 2 cols, smoothed by linear model
qplot(logpm25, NocturnalSympt, data = maacs, facets = . ~ bmicat, 
      geom = c("point", "smooth"), method = "lm")
### shows possible link between obesity and symptoms

## Building Up in Layers

### Shows first six lines
head(maacs)
### saved ggplot to g - (dataset, aesthetic(xvar, yvar))
g <- ggplot(maacs, aes(logpm25, NocturnalSympt))
summary(g)

## No Plot Yet!

### not enough info given to make a plot yet
g <- ggplot(maacs, aes(logpm25, NocturnalSympt))
print(g)


## First Plot with Point Layer

g <- ggplot(maacs, aes(logpm25, NocturnalSympt))
### adding layers. g has the info geopoint() needs to make a plot
g + geom_point()
### This new object produces scatterplot and autoprints

## Adding More Layers: Smooth

### scatterplot with smoothing
g + geom_point() + geom_smooth()
### scatterplot with smoothing by linear model
g + geom_point() + geom_smooth(method = "lm")


## Adding More Layers: Facets

### adds panels, columns by factor, bmicat.
### automatically labels plots according to levels of the factor variable
g + geom_point() + facet_grid(. ~ bmicat) + geom_smooth(method = "lm")


## Modifying Aesthetics

### color, size of the dots changed; transparency halved with alpha arg
### modifying transparancy helps see where points concentrate
g + geom_point(color = "steelblue", size = 4, alpha = 1/2)
### aesthetic function called. Now points colored by factor
g + geom_point(aes(color = bmicat), size = 4, alpha = 1/2)


## Modifying Labels

### Labels automatic but can modify. Here with
### the general annotaton function, labs()
### Expression function also used for more complex labels.
### 2.5 will appear as a subscript to PM
g + geom_point(aes(color = bmicat)) + labs(title = "MAACS Cohort") + 
  labs(x = expression("log " * PM[2.5]), y = "Nocturnal Symptoms")


## Customizing the Smooth

### line thickened by size, 3 means dashed line, se=false
### turns of confidence interval
g + geom_point(aes(color = bmicat), size = 2, alpha = 1/2) + 
  geom_smooth(size = 4, linetype = 3, method = "lm", se = FALSE)


## Changing the Theme

### Instead of default gray with white grid lines, theme_bw changes
### it back to the common black/white theme.
### Font changed to "Times"
g + geom_point(aes(color = bmicat)) + theme_bw(base_family = "Times")


## A Note about Axis Limits

testdat <- data.frame(x = 1:100, y = rnorm(100))
testdat[50,2] <- 100  ## Outlier!
### In base plotting, this is how you'd adjust the y-axis
### so your graph doesn't show an outlier but still keeps
### the graph sort of continuous.
plot(testdat$x, testdat$y, type = "l", ylim = c(-3,3))
### the ggplot showing the outlier
g <- ggplot(testdat, aes(x = x, y = y))
g + geom_line()


## Axis Limits

### ggplot and ylim subsets the data as to not include
### the outlier point (not continuous)
g + geom_line() + ylim(-3, 3)
### coord_cartesian() makes graph quasi-continuous like
### base plotting example
g + geom_line() + coord_cartesian(ylim = c(-3, 3))


## Want to show how relationship between PM25 and nocturnal
## symptoms changes as BMI and NO2 changes
## Problem: NO2 is a continuous variable and not a 
## categorical one. Therefore, we use cut() to
## make NO$_2$ Tertiles

### Calculate the tertiles (3 different ranges) of the data
### This outputs 4 points, 3 ranges.
cutpoints <- quantile(maacs$logno2_new, seq(0, 1, length = 4), na.rm = TRUE)

### Cut the data at the tertiles and create a new factor variable
maacs$no2tert <- cut(maacs$logno2_new, cutpoints)

### See the levels of the newly created factor variable
levels(maacs$no2tert)


## Final Plot

###
### Setup ggplot with data frame
g <- ggplot(maacs, aes(logpm25, NocturnalSympt))

### Add layers
### using facet_wrap instead of facet_grid
g + geom_point(alpha = 1/3) + 
  facet_wrap(bmicat ~ no2tert, nrow = 2, ncol = 4) + 
  geom_smooth(method="lm", se=FALSE, col="steelblue") + 
  theme_bw(base_family = "Avenir", base_size = 10) + 
  labs(x = expression("log " * PM[2.5])) + 
  labs(y = "Nocturnal Symptoms") + 
  labs(title = "MAACS Cohort")
### Can save this whole thing to a new object ( object <- )
### then add to that if you want to 
