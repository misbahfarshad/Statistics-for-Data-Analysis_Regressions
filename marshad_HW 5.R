
setwd("/Users/misbaharshad/Downloads/")
data <- read.csv("MTO (2).csv")
library(AER)

#1/a
reg <- lm(working_end ~ moved_using_voucher_end, data = data)
summary(reg)
#The control group (i.e. didn’t have a voucher) had an average likelihood of being 
#employed at 46%, and the voucher increased that likelihood by 15 percentage points 
#on average. The coefficient is statistically significant at the 5% level and hence 
#we reject the null that the voucher has no effect on employment at the end of the 
#study. However, even though we previously determined the characteristics are 
#balanced, OLS doesn’t guarantee a causal effect. 

#2/b
reg_HS <- lm(working_end ~ moved_using_voucher_end + high_school_grad_start, 
             data = data)
summary(reg_HS)
#Once we control for high school, the control group has an average likelihood of 
#being employed at 22% and the voucher increased that likelihood by 8 percentage 
#points on average at the end of the study. The coefficient is still statistically 
#significant at the 5% level (i.e. we still reject the null that the voucher has no 
#effect on employment at the end of the study). However, the fact that the estimate 
#decreased from 46% to 22% and 15pp to 8 pp suggests omitted variable bias in the 
#previous regression.  

#Without controlling for the confound, the outcome variable in the first regression 
#captured both the estimate of the treatment (the voucher) and the effect of the 
#omitted variable (high school). The fact the our second regression significantly 
#decreased suggests we overestimated the treatment effect in the analysis of (a). 

#3/c
#The independence assumption requires an instrument to be “as good as randomly 
#assigned” meaning that it is not related to the omitted variables. Using treated 
#satisfies the independence assumption because receiving a voucher is random, and 
#thus is not influenced by potential confounding variables that may lead to omitted 
#variable bias. Another way of explaining this is the instrument is not related to 
#anything in the error term. 

#The exclusion restriction means there is a single channel through which the 
#instrument affects the outcome. This means the instrument (“treated”) can’t 
#directly affect the outcome (i.e. everyone who receives the voucher automatically moved), otherwise we are not capturing a treatment effect, we are simply observing a sequence 
#of events. By ensuring the instrument passes through the explanatory to the outcome 
#is a single channel, we ensure we are observing the treatment effect and not an external variable. The exclusion restriction is satisfied because treated (Z) affects 
#moving (Y)  through the voucher (X). Z -> X -> Y

#4/d
reg4 <- lm(moved_using_voucher_end ~ treated, data = data)
summary(reg4)
#Yes, the instrument satisfies the first stage assumption because the F-stat is 
#1255 with a very small p-value, meaning that the instrument has strong 
#joint-significance. It is relevant for the endogenous variable, because “treated”
#is highly correlated with “moving”. The estimate being less than 1 can be 
#explained by the fact that the instrument does not perfectly predict the 
#treatment variable (i.e. receiving a voucher doesn’t necessarily mean the person 
#will move). 

#5/e
reg5 <- lm(working_end ~ treated, data = data)
summary(reg5)

#The ratio is the “reduced form” over the “first stage”
ratio <- -0.005464 / 0.524367385192118229
print(ratio)

#6/f
iv_reg_6 <- ivreg(working_end ~ moved_using_voucher_end | treated, data = data)
summary(iv_reg_6)
#When we calculate the ratio and verify with the instrument regression in R, we 
#get -0.01042 for both. We can interpret the local average treatment effect as 
#testing the subpopulation of compliers (those who receive the treatment only 
#because of the instrument and moved or didn’t receive a voucher and didn’t move) 
#being not statistically different from the control group. Although the estimate 
#is -0.01042 for both, it is not statistically significant. We fail to reject the
#null that the number employed after the survey is different between the treated 
#(received a voucher) and control (didn’t receive a voucher) groups. 

#7/g
attach(data)
x2 <- cbind(male_respondant, black_respondant, high_school_grad_start, never_married_start, 
            parent_before_18, verydissat_neighborhood_start, on_welfare_start, 
            victim_of_crime_start, want_move_gangs_drugs_start)
Z <- treated 

#first-stage 
first_stage <- lm(moved_using_voucher_end ~ Z + x2)
summary(first_stage)

#The estimate in (d) was 0.5243 and now when we include the baseline characteristics 
#it goes down slightly to 0.5221. This affirms that our instrument satisfies the 
#exclusion restriction because the instrument is only affecting our outcome through 
#1 channel. If the adding the controls changed the estimate significantly then we 
#violate the exclusion restriction because the instrument would be impacting the 
#controls. 

#8/h 
full_reg_iv <- ivreg(working_end ~ moved_using_voucher_end + x2 | Z + x2)
summary(full_reg_iv, diagnostics = TRUE)

#The coefficient changed slightly, form -0.0104 to –0.01939, both are negative 
#numbers suggesting that the voucher isn’t correlated with better employment outcomes
#at the end of the survey but neither are statistically significant. The standard 
#error decreased slightly from 0.03 to 0.02 as a results of greater precision from 
#adding the baseline characteristics. The regression with the baselines is slightly 
#better but doesn’t alter our conclusion in any significant way from (f). 

###########################################
#Question 2

#a
#False, median income doesn’t satisfy the exclusion restriction in order to be a valid good instrument. Median income can directly affect test scores and the instrument shouldn’t directly affect the outcome, it should pass through the X variable otherwise our regression is not capturing the true causal effect. Z -> X -> Y. 

#b
#False, precision falls compared to OLS. The IV estimator uses only a subset if 
#the variation in the explanatory variable to estimate the relationship between 
#the explanatory variable and the outcome variable.  By reducing the sample size 
#we lose precision. 

#c
#False IF nobody at Harris has low undergraduate grades to begin with. If nobody 
#has low undergrad grades to begin with, it is not selection bias to not include 
#students with low undergrad grades. However, it is true if she is singling out 
#only students with non-low undergrad grades. This will skew the results, and lead 
#to sample selection bias. 
