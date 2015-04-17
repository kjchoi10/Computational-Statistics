# [ Loading Data ]
library(survival)
setwd("/Users/kevin/Desktop/Spring 2015/MA576/5")
hep <- read.csv("hepatitis.csv") 
attach(hep)

# [ Data pre-processing ]
event <- ifelse(hep$censored=='no', 1, 0) # 'w' in our notes
sl <- Surv(hep$time, event=event) # survival object, to be used as response
case <- hep$treatment
sf <- survfit(sl ~ case, data=hep) # Kaplan-Meier estimate of survival function
plot(sf)


# [ Exponential base ]
plot(sf$time, -log(sf$surv), main = "Exponential")

# [ Weibull ]
plot(log(sf$time), log(-log(sf$surv)), main = "Weibull")

# [ Proportional odds ]
plot(log(sf$time), -log(sf$surv), main = "Proportional")

# Accelerated Failure: lambda(t) = lambda * alpha * t ^ (alpha - 1)
ph.weibull <- function (t, w, x, tolerance=1e-4) {
  alpha <- 1
  lhood <- Inf
  repeat {
    gmod <- glm(w ~ x + offset(alpha * log(t)), family=poisson)
    mu <- fitted(gmod)
    alpha <- sum(w) / sum((mu - w) * log(t))
    lhood.new <- sum(w * log(mu) - mu + w * log(alpha / t))
    if (abs(lhood.new - lhood) < tolerance) break
    lhood <- lhood.new
  }
  list(alpha=alpha, gmod=gmod, lhood=lhood)
}

# [ Fit Weibull ]
phw <- ph.weibull(hep$time, event, hep$treatment) # weibull fit
print(phw)

# [ Exponential baseline function]
# constant hazard: lambda(t) = lambda
ph.exp <- function (t, w, x) {
  gmod <- glm(w ~ x + offset(log(t)), family=poisson)
  mu <- fitted(gmod)
  lhood <- sum(w * log(mu) - mu + w * log(1 / t))
  list(alpha=1, gmod=gmod, lhood=lhood)
}

# [ Exponential ]
phe <- ph.exp(hep$time, event, hep$treatment) # exp fit, initially

# [ Test ]
lr <- 2 * (phw$lhood - phe$lhood) # likelihood-ratio statistic
pchisq(lr, 1, lower=F) # p-value for H0: alpha = 1

# [ Cox Proportional Hazards ]
cox <- coxph(sl ~ case, data=hep) # Cox proportional hazards model; compare to exp fit
beta <- cox$coef 
print(beta)

# [ Comparing Coefficient Estimates for the models ]
print(phe$gmod$coef[2])
print(phw$gmod$coef[2])
print(cox$coef)