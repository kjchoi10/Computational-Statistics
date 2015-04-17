###
# Using the faraway package in R, let's study the use of quasi-regression modeling using the dispersion
# of your initial regression model. In this case, we are using the motorins dataset and we are only
# looking at zone 2. We compare the residuals of our variance function with the initial model
# until our betas converge. 
###


# [ Dispersion Modeling Example ]

# [ Loading data ]
library(faraway)
data(motorins)
motor2 <- motorins[(motorins$Zone==2),]

# [ Plot the variables of interest ]
plot(motor2[c(1, 3, 4, 5, 7)])

# [ Log transformation ]
motor2 <- within(motor2, {
  Km = as.numeric(Kilometres)
  lpayment = log(Payment)
  linsured = log(Insured)
})

# [ Gamma regression ]
lmod <- glm(Payment ~ linsured + Km + Bonus + Make, data = motor2, family = Gamma(link='log'))

# [ Checking residuals ]
plot(lmod, 1)
plot(lmod, 2)

# [ Plot ]
plot(motor2[c(3, 4, 9, 10, 11)])

# [ The Ds from the main level and regress to fit the disperion ] 
d <- residuals(lmod)^2

# [ Plot of d against the covariates ]
with(motor2, pairs(cbind(log(d), linsured, Km, Bonus, Make)))

# [ Variance function ]
gmod <- glm(d ~ linsured + Km + Bonus + Make, data = motor2, family = quasi(link='log', variance = 'mu'))

# [ Let's use Beta as a criteron for convergence ]
beta = coef(lmod)

# [ Updating the quasi-likehood model ]
repeat{
  d <- residuals(lmod)^2
  gmod <- glm(d ~ linsured + Km + Bonus + Make, data = motor2, family = quasi(link='log', variance =   'mu^2'))
  lmod <- glm(Payment ~ linsured + Km + Bonus + Make, data = motor2, family = quasi(link='log', variance ='mu^2'), weight = 1 / fitted(gmod))
  beta.new <- coef(lmod)
  if(sqrt(sum(beta.new - beta)^2) < 1e-6) break
  beta <- beta.new
}