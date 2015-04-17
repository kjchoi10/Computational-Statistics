Question for computational statistics course at Boston University:
Topic: Randomwalk, Monte Carlo estimation, Importance Sampling

A BU student leaves a party close to Agganis arena and two groups of friends invite
him to the Paradise Club (PC) and to the BU Pub (BP). Since he is undecided, he
decides to play the following game3: he divides the path between PC and BP in twenty
segments and labels the positions from 0, starting at PC, to 20, ending at BP. He’s
currently at position 1. At each round of the game he flips a fair coin; if it’s tails
he walks west and so decrements his current position; if it’s heads, he walks east and
increments his position. The game ends if he reaches either PC or BP.
The following R function simulates his random walk; parameter p is the probability of
moving east

(a) What is the probability that he ends up at BP? Run 100,000 simulations and
obtain a Monte Carlo estimate. Report a 95% confidence interval.

(b) What is the shape of the distribution of the length of a walk? Plot a histogram,
and provide an estimate for the probability that the student takes more than 200
“steps”4.

(c) What is the shape of the distribution of the length of a walk given that the student
reached BP? Plot a histogram and comment on the shape when compared to the
distribution in the previous item. (Hint: filter your MC samples to only consider
walks where the last position is 20.)

(d) The Dugout is at position 18. Estimate the expected number of times that the
student will be in front of this pub

Even with a large number of samples you still feel that the confidence interval for
the probability that the student goes to BP is too large. Now you wish to devise an
importance sampling (IS) scheme to make it smaller, and so you adopt a (slightly, but
“importantly”) loaded coin with probability of heads p = 0.55.

(e) Write a function that computes the importance sampling weight of a random
walk.

(f) Re-estimate the probability of ending up at BP. What is the ratio of the MC
standard deviation to the IS standard deviation?
