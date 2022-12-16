d5 <- mtcars
str(d5)

one <- lm(mpg ~ am, data = d5)
summary(one)

multi <- lm(mpg ~ am + hp, data = d5)
summary(multi)

all <- lm(mpg ~ ., data = d5)
summary(all)

#-----------stepwise regression Forward
#1. define intercept-only model 
intercept_only <- lm(mpg ~ 1, data=mtcars)

#define model with all predictors
all <- lm(mpg ~ ., data=mtcars)

#perform forward stepwise regression
forward <- step(intercept_only, direction='forward', scope=formula(all), trace=0)

#view results of forward stepwise regression
forward$anova
#view final model
forward$coefficients

#-----------stepwise regression Backward
#define intercept-only model
intercept_only <- lm(mpg ~ 1, data=mtcars)

#define model with all predictors
all <- lm(mpg ~ ., data=mtcars)

#perform backward stepwise regression
backward <- step(all, direction='backward', scope=formula(all), trace=0)

#view results of backward stepwise regression
backward$anova
#view final model
backward$coefficients

#-----------stepwise regression Forward
#define intercept-only model
intercept_only <- lm(mpg ~ 1, data=mtcars)

#define model with all predictors
all <- lm(mpg ~ ., data=mtcars)

#perform backward stepwise regression
both <- step(intercept_only, direction='both', scope=formula(all), trace=0)

#view results of backward stepwise regression
both$anova
#view final model
both$coefficients

#install.packages("performance")
library(performance)
compare_performance(forward, backward, both, rank = TRUE)
# Name     | Model |    R2 | R2 (adj.) |  RMSE | Sigma | AIC weights | AICc weights | BIC weights | Performance-Score
# -------------------------------------------------------------------------------------------------------------------
# backward |    lm | 0.850 |     0.834 | 2.300 | 2.459 |       0.496 |        0.496 |       0.496 |           100.00%
# forward  |    lm | 0.843 |     0.826 | 2.349 | 2.512 |       0.252 |        0.252 |       0.252 |             0.00%
# both     |    lm | 0.843 |     0.826 | 2.349 | 2.512 |       0.252 |        0.252 |       0.252 |             0.00%