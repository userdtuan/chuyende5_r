forward <- function(d5) {
  intercept_only <- lm(Toan ~ 1, data=d5)
  all <- lm(Toan ~ ., data=d5)
  forward <- step(intercept_only, direction='forward', scope=formula(all), trace=0)
  return(forward)
}
backward <- function(d5) {
  intercept_only <- lm(Toan ~ 1, data=d5)
  all <- lm(Toan ~ ., data=d5)
  backward <- step(all, direction='backward', scope=formula(all), trace=0)
  return(backward)
}
both <- function(d5) {
  intercept_only <- lm(Toan ~ 1, data=d5)
  all <- lm(Toan ~ ., data=d5)
  both <- step(intercept_only, direction='both', scope=formula(all), trace=0)
  return(both)
}
# #view results of backward stepwise regression
# both$anova
# #view final model
# both$coefficients
# library(performance)
# compare_performance(forward, backward, both, rank = TRUE)