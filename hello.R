#!/usr/bin/Rscript
##
## Start the interpreter  with M-R. Use C-c C-j to  eval a line, C-M-x
## to eval a paragraph.
##
## Back of the evelope calculation ... Say it takes 0.1s to simulate a
## distribution  in  the  future  for   a  single  "disk  usage"  time
## series. In 30s which is a timeout for a Zabbix Item you can only do
## as many as 300 "disks", that is about 30-100 VMs max.  On the other
## hand if we agree to simulate the future once an hour one can manage
## several thousands VMs.
##

##
## Simulating Data might be usefull as a tutorial [1].
##
## [1] https://clayford.github.io/dwir/dwr_12_generating_data.html
##
## In this  particular distribution  the increments are  usually small
## and positive or large and negative:
prior <- c(1,1,1,1,1,1,1,1,1,-10);

## This outputs the frequency table:
table (prior);
mean (prior);                           # -0.1
## plot (ecdf (prior), do.points = FALSE, verticals = TRUE);

## In case you want to exclude drift:
## prior <- prior - mean (prior);

## There are 7 * 24 = 168 hours in a week
day <- 24;
week <- 7 * day;
usage <- cumsum (sample (prior, size = week, replace = TRUE));
par (pty = "s");                        # square windows
plot (usage, type = "l");

## One week of  data, in fact only  167 = 168 -  1 differences, should
## give us  some idea of prior  distribution. Still it will  often not
## suffice to recover the prior accurately.
distr <- diff (usage);
table (distr);
mean (distr);
## plot (table (distr));

## Min, Last,  and Max as  a few  observations derived from  a cusmsum
## trajectory:
f3 <- function (s) {
    c (min (cumsum (s)), sum (s), max (cumsum (s)))
}

simulate <- function (distr, size) {
    f3 (sample (distr, size = day, replace = TRUE))
}

## We can reduce a ditribution to a single value in at least two ways:
## (1) return a specific quantile like  median or 95th or (2) return a
## probablity  measure  for  crossing  a  specific  threshold.   Which
## threshold?  The  current "disk usage"  may change every  minute ---
## you  dont  want  to  recompute that  probability  that  often.   So
## reducing the future deistribution  to few quantiles for pre-defined
## probabilities, like fivenums() does, is probably more practical.
wip <- function (distr, size) {
    sim3 <- replicate (n = 10000, simulate (distr, size = day))
    ## Trajectory maxima:
    sims <- sim3[3, ]
    ## Maybe compute a specific qauntile:
    print (fivenum (sims))
    ## For histograms return all of them:
    sim3
}

## Simulate the evolution over one day  many times. In fact you may be
## interested in the behaviour of max(cumsum(...)) or min(cumsum(...))
## and not  just sum(...). Since f()  returns a 3-vector the  shape of
## the resulte is 3 x n:
system.time (
    sim3 <- wip (distr, day)
)
sims <- sim3[2, ];
fivenum (sims);
## The expectation value of a sum is  a multiple of that for the prior
## distribution:
c (mean (sims),  day * mean (distr), day * mean (prior));

## Histograms
xlim <- c(-100, 100);
hist (sim3[1, ], prob = TRUE, xlab = "Min", xlim = xlim);
hist (sim3[2, ], prob = TRUE, xlab = "Sum", xlim = xlim);
hist (sim3[3, ], prob = TRUE, xlab = "Max", xlim = xlim);
## lines (density (sim3[1, ], bw = 5));
## lines (density (sim3[3, ], bw = 5));

## Empirical cumulative distribution function:
## plot (ecdf (sims), do.points = FALSE, verticals = TRUE);
## qqnorm (sims); qqline (sims);
