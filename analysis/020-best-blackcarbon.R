## install.packages(c("BEST"))
library(BEST)

##
## Black Carbon comparisons
##

blackcarbon <- read.csv("./data/blackcarbon-cleaned.csv", header=TRUE)

best.cortona <- with(blackcarbon[blackcarbon$site=="Cortona", ],
                     BESTmcmc(y1=BC[outdoor==TRUE],
                              y2=BC[outdoor==FALSE]))

t.cortona <- with(blackcarbon[blackcarbon$site=="Cortona", ],
                  t.test(x=BC[outdoor==TRUE],
                         y=BC[outdoor==FALSE]))

best.montana <- with(blackcarbon[blackcarbon$site=="Montana", ],
                     BESTmcmc(y1=BC[outdoor==TRUE],
                              y2=BC[outdoor==FALSE]))

t.montana <- with(blackcarbon[blackcarbon$site=="Montana", ],
                  t.test(x=BC[outdoor==TRUE],
                         y=BC[outdoor==FALSE]))

best.siff <- with(blackcarbon[blackcarbon$site=="Siff", ],
                     BESTmcmc(y1=BC[outdoor==TRUE],
                              y2=BC[outdoor==FALSE]))

t.siff <- with(blackcarbon[blackcarbon$site=="Siff", ],
               t.test(x=BC[outdoor==TRUE],
                      y=BC[outdoor==FALSE]))

## Plots
pdf("./results/figures/best_bc_cortona.pdf", width=10, height=7)
plotAll(best.cortona)
dev.off()

pdf("./results/figures/best_bc_montana.pdf", width=10, height=7)
plotAll(best.montana)
dev.off()

pdf("./results/figures/best_bc_siff.pdf", width=10, height=7)
plotAll(best.siff)
dev.off()
