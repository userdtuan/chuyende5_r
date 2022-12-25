forward <- function(d5) {
  intercept_only <- lm(hp ~ 1, data=d5)
  all <- lm(hp ~ ., data=d5)
  forward <- step(intercept_only, direction='forward', scope=formula(all), trace=0)
  return(forward)
}
backward <- function(d5) {
  intercept_only <- lm(hp ~ 1, data=d5)
  all <- lm(hp ~ ., data=d5)
  backward <- step(all, direction='backward', scope=formula(all), trace=0)
  return(backward)
}
both <- function(d5) {
  intercept_only <- lm(hp ~ 1, data=d5)
  all <- lm(hp ~ ., data=d5)
  both <- step(intercept_only, direction='both', scope=formula(all), trace=0)
  return(both)
}
d5 <- mtcars
fo <- forward(d5)
ba <- backward(d5)
bo <- both(d5)
library(performance)
compare_performance(fo, ba, bo, rank = TRUE)