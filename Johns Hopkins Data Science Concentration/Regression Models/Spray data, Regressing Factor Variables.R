# Spray data, Regressing Factor Variables

## Poisson GLM should be used for counts but he's using this data set
## just to show how to regress factor variables. See notes for the list
## of issues and possible solutions




require(datasets);data(InsectSprays)
require(stats); require(graphics)

### Problems w/data set: 1. These are counts and shouldn't be linearly modelling, 2. Obvious
### effect by just looking at the medians of C,D,E. 3. Shows no chance of there
### being a constant variance between groups (size of boxes?).
boxplot(count ~ spray, data = InsectSprays,
        xlab = "Type of spray", ylab = "Insect count",
        main = "InsectSprays data", varwidth = TRUE, col = "lightgray")

### Spray is the factor. Spray A chosen automatically as the reference category
### lm choses the lowest order factor level as the reference category
### whether that's numerical or just being first in the list.
summary(lm(count ~ spray, data = InsectSprays))$coef
### Spray B coeff = 0.8333 is the estimated effect in mean insect count if you
### switched from Spray A to Spray B. (mean B - mean A)


## Coding it manually
### Operator I necessary for doing math ops in lm
### Multiplying by 1 changes boolean object into numeric, so 1's and 0's for T and F.
summary(lm(count ~ 
             I(1 * (spray == 'B')) + I(1 * (spray == 'C')) + 
             I(1 * (spray == 'D')) + I(1 * (spray == 'E')) +
             I(1 * (spray == 'F'))
           , data = InsectSprays))$coef

### Shows including the reference category results in a NA for its coefficient
### Since Spray A was entered last, lm chose it to put the NA value for the coef
### It does this because X6 (spray A) is a linear combo of the intercept 
### and 5 factor vars. x6=1-x1-x2-...-x5
lm(count ~ 
     I(1 * (spray == 'B')) + I(1 * (spray == 'C')) +  
     I(1 * (spray == 'D')) + I(1 * (spray == 'E')) +
     I(1 * (spray == 'F')) + I(1 * (spray == 'A')), data = InsectSprays)

### (-1) removes the intercept therefore x6 is no longer a linear combo.
### lm returns the mean count for each spray as the coefficients
### std error not correct so t stat and pval listed are bogus
summary(lm(count ~ spray - 1, data = InsectSprays))$coef
unique(ave(InsectSprays$count, InsectSprays$spray))

### relevel() sets C as the reference category
spray2 <- relevel(InsectSprays$spray, "C")
summary(lm(count ~ spray2, data = InsectSprays))$coef

### Doing it manually
fit <- lm(count ~ spray, data = InsectSprays) #A is ref
bbmbc <- coef(fit)[2] - coef(fit)[3] #B - C
temp <- summary(fit) 
se <- temp$sigma * sqrt(temp$cov.unscaled[2, 2] + temp$cov.unscaled[3,3] - 2 *temp$cov.unscaled[2,3])
t <- (bbmbc) / se
p <- pt(-abs(t), df = fit$df)
out <- c(bbmbc, se, t, p)
names(out) <- c("B - C", "SE", "T", "P")
round(out, 3)

## Many problems with this data and the model used. See notes