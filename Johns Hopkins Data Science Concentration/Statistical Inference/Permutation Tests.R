# Permutation Tests

## good for group comparisons

## Null hypothesis: Spray Type B and C have the same disributions. In other words
## the types B and C have the same efficacy in killing bugs.

### Col vars are Spray Type and Count, where count is the number of 
### insects killed by that spray type for that observation. 72 obs.
data(InsectSprays)
str(InsectSprays)
head(InsectSprays)
boxplot(count ~ spray, data = InsectSprays)

## Subsetting data for sprays B and C
### %in% is a logical operator
subdata <- InsectSprays[InsectSprays$spray %in% c("B", "C"),]
### Count vector
y <- subdata$count
### Spray vector
group <- as.character(subdata$spray)
### Subtracting the Count mean for Spray B from the Count Mean for Spray C
### Using "group" to index the count values for each spray type. Both vectors
### have the same length so indexes will match-up.
testStat <- function(w, g) mean(w[g == "B"]) - mean(w[g == "C"])
### The difference of the two means
observedStat <- testStat(y, group)


### "sample" mixes up the labels. It has a "n" and "size" argument but
### not used so its going to choose n items from a group of n. No
### replacement is the default value so this is a permutation.
### This new group of indices along w/y vector is passed to testStat.
### sapply does this 10000 times returning a vector of mean differences
permutations <- sapply(1 : 10000, function(i) testStat(y, sample(group)))
observedStat
### 10000 Falses. Not a single permutation was larger.
table(permutations > observedStat)
### Mean = 0 here but this output mightve lead to something interpretable as
### a p-value. Mean = 0 so the pvalue is very small so we reject H0.
mean(permutations > observedStat)

## Showing the null (hypothesis) distribution
## Illustratively shows how far our observed value is on the tail
## which also leads us to believe the H0 distr isn't the true
## distribution

### Gives percentages on the y axis by default
library(lattice)
histogram(permutations)
### Gives count on the y axis by default
library(ggplot2)
qplot(permutations)
