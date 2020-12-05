#!/usr/bin/Rscript
##
## Start the interpreter with M-R. Use C-c C-j to eval a line.
##

##
## Simulating Data might be usefull as a tutorial [1].
##
## [1] https://clayford.github.io/dwir/dwr_12_generating_data.html
##
## In this  particular distribution  the increments are  usually small
## and positive or large and negative:
prior <- c(1,2,3,4,4,4,5,7,7,-10,-20);
mean (prior);                           # 0.6363636

## In case you want to exclude drift:
## prior <- prior - mean (prior);


## This outputs the frequency table:
table (prior);

## There are 7 * 24 = 168 hours in a week
week <- 7 * 24;
usage <- cumsum (sample (prior, size = week, replace = TRUE));
plot (usage, type = "l");

## Simulate the eveolution over one week  many times. One year of data
## is amounts to 52 one-week simulations, this 52 * 10 is ten years of
## data! You will never have that much in reality!
sims <- replicate (n = 52 * 10, sum (sample (prior, size = week, replace = TRUE)));

## The expectation value of a sum is  a multiple of that for the prior
## distribution:
c (mean (sims), week * mean (prior));

## Histogram
hist (sims, breaks=25);

