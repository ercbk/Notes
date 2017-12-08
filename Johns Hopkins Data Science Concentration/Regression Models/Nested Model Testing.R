# Nested Model Testing

## Useful for finding best model when pool of available variables is small
## See notes (pg 122) for how to analysis the output.

library(datasets)
data(swiss)
fit1 <- lm(Fertility ~ Agriculture, data = swiss)
fit3 <- update(fit1, Fertility ~ Agriculture + Examination + Education)
fit5 <- update(fit3, Fertility ~ Agriculture + Examination + Education + Catholic + Infant.Mortality)
anova(fit1, fit3, fit5)