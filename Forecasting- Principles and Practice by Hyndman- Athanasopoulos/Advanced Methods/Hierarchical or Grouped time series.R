# Hierarchical or Grouped Time Series

# Data: Total quarterly visitor nights from 1998-2011 for eight regions of Australia:

# Sydney
# The Sydney metropolitan area.
# 
# NSW
# New South Wales other than Sydney
# 
# Melbourne
# The Melbourne metropolitan area.
# 
# VIC
# Victoria other than Melbourne.
# 
# BrisbaneGC
# The Brisbane and Gold Coast area.
# 
# QLD
# Queensland other than Brisbane and the Gold Coast.
# 
# Capitals
# The other five capital cities: Adelaide, Hobart, Perth, Darwin and Canberra.
# 
# Other
# All other areas of Australia.



library(hts); library(fma); library(fpp)
### taking a look at the ts
vn

### Creates a 2 level hierarchical time series. There's actually 3 levels
### but the 0-level isn't counted. gts() would created a grouped ts (no hierarchical
### structure). 4 ts (nodes) on the first level and 2 ts under each of the 4 nodes
### for a total of 13 ts (counting the "total" ts on the 0-level).
y <- hts(vn, nodes=list(4,c(2,2,2,2)))

### Lists some basic info and the point forecasts for the "total" ts.
### Not all that useful except we need this object to graph the various levels
### and their forecasts
allf <- forecast(y, h=8)

### This function gives us all the point forecasts for each level
allfTS <- aggts(allf)
allfTS

### Summary: basic info + the forcasting methods that were used.
summary(allf)

### Graphs of the ts and their forecasts for each level
plot(allf)

### Version I'm looking at doesn't include a method for prediction intervals
### Also see his Hyndman's vignette for other examples
