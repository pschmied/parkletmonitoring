## install.packages(c("BEST"))
library(BEST)

##
## Noise comparisons
##

noise <- read.csv("./data/noise-cleaned.csv", header=TRUE)

best.cortona <- with(noise[noise$site=="Cortona", ],
                     BESTmcmc(y1=Average[outdoor==TRUE],
                              y2=Average[outdoor==FALSE]))

t.cortona <- with(noise[noise$site=="Cortona", ],
                  t.test(x=Average[outdoor==TRUE],
                         y=Average[outdoor==FALSE]))

best.montana <- with(noise[noise$site=="Montana", ],
                     BESTmcmc(y1=Average[outdoor==TRUE],
                              y2=Average[outdoor==FALSE]))

t.montana <- with(noise[noise$site=="Montana", ],
                  t.test(x=Average[outdoor==TRUE],
                         y=Average[outdoor==FALSE]))

best.siff <- with(noise[noise$site=="Siff", ],
                  BESTmcmc(y1=Average[outdoor==TRUE],
                           y2=Average[outdoor==FALSE]))

t.siff <- with(noise[noise$site=="Siff", ],
               t.test(x=Average[outdoor==TRUE],
                      y=Average[outdoor==FALSE]))

## Plots
pdf("./results/figures/best_noise_cortona.pdf", width=10, height=7)
plotAll(best.cortona)
dev.off()

pdf("./results/figures/best_noise_montana.pdf", width=10, height=7)
plotAll(best.montana)
dev.off()

pdf("./results/figures/best_noise_siff.pdf", width=10, height=7)
plotAll(best.siff)
dev.off()
