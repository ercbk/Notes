# R plotting in Color



## colorRamp

### Ramp returns function. Saved to pal
pal <- colorRamp(c("red", "blue"))

### Function takes values between 0 and 1. 0 max value for red
pal(0)
#[,1] [,2] [,3]
#[1,]  255    0    0

### 1 max value for blue. Middle value is green.
pal(1)
#[,1] [,2] [,3]
#[1,]    0    0  255

### half red, half blue
pal(0.5)
#[,1] [,2]  [,3]
#[1,] 127.5    0 127.5

### slowly increasing portions of red to blue. aka interpolating
pal(seq(0, 1, len = 10))
# [,1] [,2]       [,3]
# [1,] 255.00000    0          0
# [2,] 226.66667    0   28.33333
# [3,] 198.33333    0   56.66667
# [4,] 170.00000    0   85.00000
# [5,] 141.66667    0  113.33333
# [6,] 113.33333    0  141.66667
# [7,]  85.00000    0  170.00000
# [8,]  56.66667    0  198.33333
# [9,]  28.33333    0  226.66667
# [10,]  0.00000    0  255.00000

pal <- colorRampPalette(c("red", "yellow"))

### gives character vector of hex decimals. These are max red
### (ff....), max green(ffff..), zero blue(....00) which
### max red + max green = yellow. ff is the max value in hexidecimal
pal(2)
#[1] "#FF0000" "#FFFF00"

### interpolation between red and yellow
pal(10)
#[1] "#FF0000" "#FF1C00" "#FF3800" "#FF5500" "#FF7100"
#[6] "#FF8D00" "#FFAA00" "#FFC600" "#FFE200" "#FFFF00"



library(RColorBrewer)

### 3 is number of color in your palette, BuGn is name of palette
### names of palette on help page for RColorBrewer package
cols <- brewer.pal(3, "BuGn")

cols
#[1] "#E5F5F9" "#99D8C9" "#2CA25F"

pal <- colorRampPalette(cols)

image(volcano, col = pal(20))


### Uses Color Brewer palette
### darker areas mean higher density of points
### default colors are the blues from brewer package
x <- rnorm(10000)
Y <- rnorm(10000)
smoothScatter(x,y)

### rgb is a red, green, blue function, 0.2 is the value for
### the alpha parameter for degree of transparency
plot(x,y, col=rgb(0,0,0,0.2), pch=19)
