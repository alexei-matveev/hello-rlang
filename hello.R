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

## This outputs the frequency table:
table (prior);
mean (prior);                           # 0.6363636
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
f <- function (s) c (min (cumsum (s)), sum (s), max (cumsum (s)));

## Simulate the evolution over one day  many times. In fact you may be
## interested in the behaviour of max(cumsum(...)) or min(cumsum(...))
## and not  just sum(...). Since f()  returns a 3-vector the  shape of
## the resulte is 3 x n:
sim3 <- replicate (n = 10000, f (sample (distr, size = day, replace = TRUE)));
sims <- sim3[2, ];
fivenum (sims);
## The expectation value of a sum is  a multiple of that for the prior
## distribution:
c (mean (sims),  day * mean (distr), day * mean (prior));

## Histograms
hist (sim3[1, ], breaks = 50, prob = TRUE, xlab = "Min", xlim = c(-150, 150));
hist (sim3[2, ], breaks = 50, prob = TRUE, xlab = "Sum", xlim = c(-150, 150));
hist (sim3[3, ], breaks = 50, prob = TRUE, xlab = "Max", xlim = c(-150, 150));
## lines (density (sim3[1, ], bw = 5));
## lines (density (sim3[3, ], bw = 5));

## Empirical cumulative distribution function:
## plot (ecdf (sims), do.points = FALSE, verticals = TRUE);
## qqnorm (sims); qqline (sims);
