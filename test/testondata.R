# source('functions/helper.R')
# library(dplyr)
# 
# kq_thpt_raw <- read.csv("datasets/diemthi2020.csv")[,c('sbd','Li','Hoa','Sinh','Su','Dia','GDCD','Toan','Van', 'Ngoai_ngu', 'Ma_mon_ngoai_ngu')]
# list_tinh <- read.csv("datasets/listtinh.csv")
# 
# kq_thpt_fixed <- handle_missing(kq_thpt_raw,-1)
# kq_thpt_fixed <- gan_ten_tinh(kq_thpt_fixed,list_tinh)[,c('sbd','Li','Hoa','Sinh','Su','Dia','GDCD','Toan','Van', 'Ngoai_ngu', 'Ma_ngoai_ngu', 'Ten.Tinh')]
# numericData = c('Li','Hoa','Sinh','Su','Dia','GDCD','Toan','Van', 'Ngoai_ngu')
# options(spinner.color="#0275D8", spinner.color.background="#ffffff", spinner.size=1)
# hoiquy_dat <- kq_thpt_fixed[,c('Li','Hoa','Sinh','Su','Dia','GDCD','Toan','Van', 'Ngoai_ngu')]



d5 <- hoiquy_dat
str(d5)

# one <- lm(Toan ~ Li, data = d5)
# summary(one)
# 
# multi <- lm(Toan ~ Li + Hoa, data = d5)
# summary(multi)
# 
# total <- lm(Toan ~ ., data = d5)
# summary(all)

#-----------stepwise regression Forward
#1. define intercept-only model 
intercept_only <- lm(Toan ~ 1, data=d5)

#define model with all predictors
all <- lm(Toan ~ ., data=d5)

#perform forward stepwise regression
forward <- step(intercept_only, direction='forward', scope=formula(all), trace=0)

#view results of forward stepwise regression
forward$anova
#view final model
forward$coefficients

#-----------stepwise regression Backward
#define intercept-only model
intercept_only <- lm(Toan ~ 1, data=d5)

#define model with all predictors
all <- lm(Toan ~ ., data=d5)

#perform backward stepwise regression
backward <- step(all, direction='backward', scope=formula(all), trace=0)

#view results of backward stepwise regression
backward$anova
#view final model
backward$coefficients

#-----------stepwise regression Forward
#define intercept-only model
intercept_only <- lm(Toan ~ 1, data=d5)

#define model with all predictors
all <- lm(Toan ~ ., data=d5)

#perform backward stepwise regression
both <- step(intercept_only, direction='both', scope=formula(all), trace=0)

#view results of backward stepwise regression
both$anova
#view final model
both$coefficients

#install.packages("performance")
library(performance)
compare_performance(forward, backward, both, multi, total,one, rank = TRUE)
# NLie     | Model |    R2 | R2 (adj.) |  RMSE | Sigma | AIC weights | AICc weights | BIC weights | Performance-Score
# -------------------------------------------------------------------------------------------------------------------
# backward |    lm | 0.850 |     0.834 | 2.300 | 2.459 |       0.496 |        0.496 |       0.496 |           100.00%
# forward  |    lm | 0.843 |     0.826 | 2.349 | 2.512 |       0.252 |        0.252 |       0.252 |             0.00%
# both     |    lm | 0.843 |     0.826 | 2.349 | 2.512 |       0.252 |        0.252 |       0.252 |             0.00%




