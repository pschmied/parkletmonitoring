## install.packages(c("BEST", "lubridate", "plyr"))
library(BEST)
library(lubridate)
library(plyr)

##
## Noise comparisons
##

noise <- read.csv("./data/noise-cleaned.csv",
                  stringsAsFactors=FALSE, header=TRUE)

## The cheaters way of resampling: truncate timestring to desired
## level of precision, then aggregate
noise$Time10 <- paste0(substr(noise$Time, 1, 7), "0")
noise10 <- ddply(noise, .(Date, Time10, site, outdoor),
                 summarize, Average=mean(Average))


best.cortona <- with(noise10[noise10$site=="Cortona", ],
                     BESTmcmc(y1=Average[outdoor==TRUE],
                              y2=Average[outdoor==FALSE]))

t.cortona <- with(noise10[noise10$site=="Cortona", ],
                  t.test(x=Average[outdoor==TRUE],
                         y=Average[outdoor==FALSE]))

best.montana <- with(noise10[noise10$site=="Montana", ],
                     BESTmcmc(y1=Average[outdoor==TRUE],
                              y2=Average[outdoor==FALSE]))

t.montana <- with(noise10[noise10$site=="Montana", ],
                  t.test(x=Average[outdoor==TRUE],
                         y=Average[outdoor==FALSE]))

best.siff <- with(noise10[noise10$site=="Siff", ],
                  BESTmcmc(y1=Average[outdoor==TRUE],
                           y2=Average[outdoor==FALSE]))

t.siff <- with(noise10[noise10$site=="Siff", ],
               t.test(x=Average[outdoor==TRUE],
                      y=Average[outdoor==FALSE]))

## Plots
pdf("./results/figures/best_noise10_cortona.pdf", width=10, height=7)
plotAll(best.cortona)
dev.off()

pdf("./results/figures/best_noise10_montana.pdf", width=10, height=7)
plotAll(best.montana)
dev.off()

pdf("./results/figures/best_noise10_siff.pdf", width=10, height=7)
plotAll(best.siff)
dev.off()
