# ggplot2 pt1



## Example Dataset, "Hello, world!"

### vars: displacement, highway mileage in a simple plot
library(ggplot2)
str(mpg)
qplot(displ, hwy, data = mpg)


## Modifying aesthetics

### drive the vehicle used as a factor. Color coding and legend automatic
qplot(displ, hwy, data = mpg, color = drv)
### Adding a geom. Point adds the points, smooth adds
### a line with 95% conf. intervals shaded in.
qplot(displ, hwy, data = mpg, geom = c("point", "smooth"))


## Histograms

### histograms created by only having a single
### variable. Fill uses to drv as a factor to color
### appropriate levels on the bars
qplot(hwy, data = mpg, fill = drv)


## Facets

### like panels in lattice
### scatter (2 var) - 0 rows, 3 cols b/c of 3 levels to drv
qplot(displ, hwy, data = mpg, facets = . ~ drv)
### histogram (1 var) - 3 rows, 0 cols
qplot(hwy, data = mpg, facets = drv ~ ., binwidth = 2)


## (MAACS) Mouse Allergen and Asthma Cohort Study

### exhaled nitric oxide (pulmonary inflamation)
eno <- read.csv("eno.csv")
skin <- read.csv("skin.csv")
env <- read.csv("environmental.csv")
m <- merge(eno, env, by = "id")
maacs <- merge(m, skin, by = "id")
str(maacs)


## Histogram of eNO

### 1 var - eno
qplot(log(eno), data = maacs)
### by Group
### mopos = skin test, factor
qplot(log(eno), data = maacs, fill = mopos)


## Density Smooth

### Density smooths. Visually it looks sort of like outlining the histogram
qplot(log(eno), data = maacs, geom = "density")
### mopos used as a factor. Colors the lines
### good way to visualize 1 dim data w/factor
qplot(log(eno), data = maacs, geom = "density", color = mopos)


## Scatterplots: eNO vs. PM$_{2.5}$

### simple scatter
qplot(log(pm25), log(eno), data = maacs)
### separted using mopos factor; distinguished by shapes
qplot(log(pm25), log(eno), data = maacs, shape = mopos)
### colors dots
qplot(log(pm25), log(eno), data = maacs, color = mopos)


## with geom

### regression lines, confidence intervals added
### smooth calcs regression lines using "low S" method by default
### Utilizing method to specify lines to be calc'ed by linear model
qplot(log(pm25), log(eno), data = maacs, color = mopos, 
      geom = c("point", "smooth"), method = "lm")


## with geom, method, facets

### Instead of one plot w/color coding,
### now separated into two plots using facet
### .~ <factor> means 0 rows, #cols=#levels
qplot(log(pm25), log(eno), data = maacs, geom = c("point", "smooth"), 
      method = "lm", facets = . ~ mopos)


