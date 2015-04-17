####
#
# A BU student leaves a party close to Agganis arena and two groups of friends invite
# him to the Paradise Club (PC) and to the BU Pub (BP). Since he is undecided, he
# decides to play the following game3: he divides the path between PC and BP in twenty
# segments and labels the positions from 0, starting at PC, to 20, ending at BP. He’s
# currently at position 1. At each round of the game he flips a fair coin; if it’s tails
# he walks west and so decrements his current position; if it’s heads, he walks east and
# increments his position. The game ends if he reaches either PC or BP.
# The following R function simulates his random walk; parameter p is the probability of
# moving east.
#
####

# (a) What is the probability that he ends up at BP? Run 100,000 simulations and
# obtain a Monte Carlo estimate. Report a 95% confidence interval

# [ Random Walk Function ]
rwalk <- function (p) {
  j <- 1 # start
  walk <- c() # store movements
  repeat {
    j <- j + (2 * rbinom(1, 1, p) - 1) # move
    walk <- append(walk, j)
    if (j == 0 || j == 20) return(walk)
  }
}

# [ Probability of Random Walk ]
probability.rwalk <- function(){
  
  n <- 100000
  p <- 0.5
  
  success <- 0 # count for success
  i <- 0 # count for total
  
  repeat{
  vector <- rwalk(p) # calls rwalk
  length.rwalk <- length(vector) # length of rwalk
  last.value.rwalk <- vector[length.rwalk] # last value of the vector rwalk
  
  i <- i + 1 # count for total amount of random walks

  if(last.value.rwalk == 20) # if the last value of the vector is 20 then you are at PC
  
  success <- success + 1 # count all successes
  
  if(i == 100000) break # break you've done 100,000 random walks
  
  }
  
  print("The probability is: ")
  return(success / i) # returns the porportion of success over total number of random walk

}

# [ Confidence Interval for Probability of Random Walk ]

confidence.interval.rwalk <- function(){
  
  n <- 100000 # sample size
  p <- probability.rwalk()  # probability
  s <- sqrt(p * (1 - p)) # standard deviation
  
  standard.error <- s / sqrt(n)
  margin.error <- 1.96 * standard.error
  confidence.interval <- c(p - margin.error, p + margin.error)
  
  print('The confidence interval is: ')
  print(confidence.interval)
    
}

# (b) What is the shape of the distribution of the length of a walk? Plot a histogram,
# and provide an estimate for the probability that the student takes more than 200
# “steps”

# [ Distribution of the walk ]
distribution <- function(p){
  
    j <- 1 # start
    walk <- c() # store movements
    
    repeat {
      j <- j + (2 * rbinom(1, 1, p) - 1) # move
      walk <- append(walk, j)
      if (j == 0 || j == 20) 
      return(length(walk))
    }
}

# [ Histogram of the walk ]
#hist(replicate(100000, distribution(.5)))

# [ Probability the student's walk is over or equal to 200 steps ]
probability.200.steps <- function(n){
  
  p <- 0.5
  i <- 0 # count for random being more than 200 steps
  j <- 0 # count for total
  
  repeat{
    vector <- distribution(p) 
    j <- j + 1
    if(vector >= 200)
    i <- i + 1
    if(j == n) break
  }
  return(i/j)
}

# (c) What is the shape of the distribution of the length of a walk given that the student
# reached BP? Plot a histogram and comment on the shape when compared to the
# distribution in the previous item. (Hint: filter your MC samples to only consider 
# walks where the last position is 20.)

# [ Distribution of walk going to BP ]
distribution.bp <- function(p){
  
  repeat{
    vector <- rwalk(p)
    if(vector[length(vector)] == 20) break
  }
  return(length(vector))
}

# [ Histogram of the distribution of BP ]
#distribution.histogram.bp <- hist(replicate(100000, distribution.bp(.5)))

# (d) The Dugout is at position 18. Estimate the expected number of times that the
# student will be in front of this pub.

# [ Dugout ]

dugout <- function(t, p){
  i <- 0 # count for walking by the dugout
  n <- 0 # count for walking
  repeat{
    vector <- rwalk(p) # begins the walk
    i <- i + sum(vector == 18) # everytime the vector has the value 18 it will add them up and update
    
    n <- n + 1 # counts total
    if(n == t) break # breaks when total equals sample size
  }
  return(i)
}

# (e) Write a function that computes the importance sampling weight of a random
# walk.

# [ BP with p = 0.55 ]
# [ The new loaded rwalk function ]
important.weight <- function(x){
  numerator <- 0.5^sum(diff(x) == 1) * .5^sum(diff(x) == -1)
  denominator <- 0.55^sum(diff(x) == 1) *.45^sum(diff(x) == -1)
  return(numerator/denominator)
}


# (f) Re-estimate the probability of ending up at BP. What is the ratio of the MC
# standard deviation to the IS standard deviation?

# [ Re.estimate function ]
re.estimate <- function(rwalk){
  if(walk[length(rwalk)] == 20)
    return(important.weight.sampling(rwalk))
  else if (walk[length(rwalk)] == 0)
    return(0)
}

new.walk <- replicate(100000, re.estimate(rwalk(0.55)))
probability.pub <- mean(new.walk)
print(probability.pub)


