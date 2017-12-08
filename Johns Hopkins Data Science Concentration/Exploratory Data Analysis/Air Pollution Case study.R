# Air Pollution Case study
## uses RD....txt files for data



## Has fine particle pollution in the U.S. decreased from 1999 to
## 2012?



## Read in data from 1999

pm0 <- read.table("RD_501_88101_1999-0.txt", comment.char = "#", header = FALSE, sep = "|", na.strings = "")
### showing 117421 rows, 28 cols
dim(pm0)
### showing lots of NAs and no column names yet
head(pm0)
### getting the column names. Reading 1 line
cnames <- readLines("RD_501_88101_1999-0.txt", 1)
### Just one long string. Col names haven't been separated
print(cnames)
### splitting the col names. Fixed pattern not regular expression
cnames <- strsplit(cnames, "|", fixed = TRUE)
### Shows each col name now a character vector. Strsplit returns a list so just
### want first elt
print(cnames)
### assigning col names to the table. 
### Col names have spaces and <names(pm0)<-cname[[1]]>
### would leave the spaces. Using make.names adds dots and makes the col names valid
### for a data frame. Important for future analysis.
names(pm0) <- make.names(cnames[[1]])
head(pm0)

### Pulling out variable Sample.Value (micrograms per meter cubed).
x0 <- pm0$Sample.Value
### numeric
class(x0)
### 117421 values
str(x0)
### summary stats. Shows 13217 NAs
summary(x0)
### About 11% of the values are missing.
mean(is.na(x0))  ## Are missing values important here?
### not terrible but really depends on what type of question you're trying to answer.



## Read in data from 2012

### Many more air monitors in 2012 than 1999 so takes longer to read-in
pm1 <- read.table("RD_501_88101_2012-0.txt", comment.char = "#", header = FALSE, sep = "|", na.strings = "", nrow = 1304290)
dim(pm1)
head(pm1)
### same col names as before so adding those col names to this table
names(pm1) <- make.names(cnames[[1]])
x1 <- pm1$Sample.Value
### 1.3M elts., numeric
str(x1)



## Five number summaries for both periods


### Median shows a decrease from 1999 to 2012
summary(x1)
summary(x0)
### Only 6% missing for 2012. This amount isn't usually a big deal.
mean(is.na(x1))  ## Are missing values important here?

## Make a boxplot of both 1999 and 2012
### boxplot is smushed because of some extreme values (see max in summary)
boxplot(x0, x1)
### Taking the log to make it more readable
boxplot(log10(x0), log10(x1))

## Check negative values in 'x1'
### values measured by collecting particles in a filter and weighing.
### In the summary, we see that the min is negative which would mean negative mass
### which is impossible
summary(x1)
### creating a logical vector that will be true if value is negative
negative <- x1 < 0
### Showing about 26000 values that are negative. Straaaaange.
sum(negative, na.rm = T)
### These values make up about 2% of the total.
mean(negative, na.rm = T)
### Do these values only occur at certain times of the year
dates <- pm1$Date
### shows the dates are coded as integers. Not as useful. Need dates.
str(dates)
### Coercing these integers into date format.
dates <- as.Date(as.character(dates), "%Y%m%d")
str(dates)
### Making a histogram to see how much data is collected in each month.
### Most measurements in winter/spring
hist(dates, "month")  ## Check what's going on in months 1--6
### Most negative values in winter/spring. Count format not helpful here visually
### May be more useful to see percent of values negative per month
hist(dates[negative], "month")
### Dust/pollutants more prevalent in summer. Cold weather/low (harder to measure) 
### values maybe causing a measurement error.


## Monitoring can be inconsistent across the country so may be useful to pick a one
## and analyse its data.


## Find a monitor for New York State that exists in both datasets
## Creating a list that has the same monitors in both 1999 and 2012.

### Plucking out county code and site id cols 1999
site0 <- unique(subset(pm0, State.Code == 36, c(County.Code, Site.ID)))
### Same for 2012
site1 <- unique(subset(pm1, State.Code == 36, c(County.Code, Site.ID)))
head(site0)
### Combining both cols into a character vector. Prev. values separated by "." in the
### the new variable.
site0 <- paste(site0[,1], site0[,2], sep = ".")
site1 <- paste(site1[,1], site1[,2], sep = ".")
### Combo produces 33 values for 1999
str(site0)
### Combo produces only 18 values for 2012
str(site1)
### Creating a list showing monitors that are active in both years
both <- intersect(site0, site1)
### 10 monitors
print(both)


## Now to find one of those 10 monitors with lots of observations to look at.
## Find how many observations available at each monitor

### Creating that new variable in each original dataframe
pm0$county.site <- with(pm0, paste(County.Code, Site.ID, sep = "."))
pm1$county.site <- with(pm1, paste(County.Code, Site.ID, sep = "."))
### Subsetting the dataframes for just NY state and new county.site variable
### but only taking values that are in both 1999 and 2012 by
### using the list created in the previous chunk.
cnt0 <- subset(pm0, State.Code == 36 & county.site %in% both)
cnt1 <- subset(pm1, State.Code == 36 & county.site %in% both)
### finding the number of rows for each monitor
### example: county 1, site 12 has 61 observations in 1999
### split(dataframe, factor); sapply returns a vector or matrix
### sapply needs a list as input and split returns a list.
sapply(split(cnt0, cnt0$county.site), nrow)
### county 1, site 12 has 31 observations in 2012
sapply(split(cnt1, cnt1$county.site), nrow)

## subsetting county 63 and side ID 2008
pm1sub <- subset(pm1, State.Code == 36 & County.Code == 63 & Site.ID == 2008)
pm0sub <- subset(pm0, State.Code == 36 & County.Code == 63 & Site.ID == 2008)
dim(pm1sub)
dim(pm0sub)
### Uh, this is simpler. Don't know why he did it the other way.
### I mean, why go to the trouble to create that new variable and hardly
### use it.
cnt0sub <- subset(cnt0, county.site == 63.2008)

## Plot data for 2012

### extract the dates
dates1 <- pm1sub$Date
### extract the polution measurement
x1sub <- pm1sub$Sample.Value
### dates are integer vectors so need converting
plot(dates1, x1sub)
### Converting
dates1 <- as.Date(as.character(dates1), "%Y%m%d")
### Confirming date format
str(dates1)
### Values all over the place. Note data only covered 3 months.
plot(dates1, x1sub)

## Plot data for 1999
dates0 <- pm0sub$Date
dates0 <- as.Date(as.character(dates0), "%Y%m%d")
x0sub <- pm0sub$Sample.Value
### Same. Note data is only for half the year
plot(dates0, x0sub)

## Plot data for both years in same panel
### mfrow creating 2 panels
par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
plot(dates0, x0sub, pch = 20)
abline(h = median(x0sub, na.rm = T))
plot(dates1, x1sub, pch = 20)  ## Whoa! Different ranges
abline(h = median(x1sub, na.rm = T))
### yaxis range different for each plot. Misleading. Also Misleading since these
### 2 dataframes cover different times of the year but we'll see where this goes.
### Probably need to go back and see if we can choose a monitor that covers similar
### times of the year.

## Find global range for both sets

### range over both sets shows between 3 and 40.1 micrograms/meter^3
range(x0sub, x1sub, na.rm = T)
rng <- range(x0sub, x1sub, na.rm = T)
### Plot again
par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
plot(dates0, x0sub, pch = 20, ylim = rng)
abline(h = median(x0sub, na.rm = T))
plot(dates1, x1sub, pch = 20, ylim = rng)
abline(h = median(x1sub, na.rm = T))
### Shows 2012 with lower values and much smaller variability (extreme values go away)


## EPA enforces the regs but states create their own policies to conform with the regs.
## Interesting to see which states have come-up with the potentially better policies.

## Show state-wide means and make a plot showing trend
head(pm0)
### subsetting mean Sample values by state for both years
### tapply takes a vector, factor, and function. Returns a vectorish obj by default.
### array returned
mn0 <- with(pm0, tapply(Sample.Value, State.Code, mean, na.rm = T))
str(mn0)
summary(mn0)
mn1 <- with(pm1, tapply(Sample.Value, State.Code, mean, na.rm = T))
str(mn1)
summary(mn1)

## Make separate data frames for states / mean polution(sample.value)
### Converting from array to data.frame. dF has two cols: state, mean
d0 <- data.frame(state = names(mn0), mean = mn0)
d1 <- data.frame(state = names(mn1), mean = mn1)
### 1 state per row; 1 col for 1999 averages and 1 col for 2012 averages
mrg <- merge(d0, d1, by = "state")
dim(mrg)
head(mrg)

## Connect lines
par(mfrow = c(1, 1))
### he used rep(1999, 52) in the vid and c(1998, 2013)
with(mrg, plot(rep(1, 52), mrg[, 2], xlim = c(.5, 2.5)))
### add points for 2012; used rep(2012, 52) in the vid
with(mrg, points(rep(2, 52), mrg[, 3]))
### connects dots; same changes to rep as before in the vid
segments(rep(1, 52), mrg[, 2], rep(2, 52), mrg[, 3])
### connections help look at the trend from 1999 to 2012
### mixed bag
