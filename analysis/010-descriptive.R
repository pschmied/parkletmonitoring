## install.packages(c("ggplot2", "xtable", "dplyr"))
library(ggplot2)
library(xtable)
library(plyr)

## Noise
noise <- read.csv("./data/noise-cleaned.csv", header=TRUE, stringsAsFactors=FALSE)

noise.box <- ggplot(noise, aes(y=Average, x=outdoor)) +
  geom_boxplot() + facet_wrap(~ site) +
  theme_bw() + xlab("Outdoors") + ylab("Decibels")

ggsave("./results/figures/noise-box.pdf", width=6, height=6)

noise.tab <- ddply(noise, .(site, outdoor), summarize,
                   N=length(Average),
                   Min=min(Average), Median=median(Average),
                   Mean=mean(Average), Max=max(Average),
                   SD=sd(Average))
write.csv(noise.tab, "./results/figures/noise-tab.csv")


## Black carbon
blackcarbon <- read.csv("./data/blackcarbon-cleaned.csv",
                        header=TRUE, stringsAsFactors=FALSE)
blackcarbon$X <- NULL

odat <- read.csv("~/Projects/ae51summary/data/spot-sample.csv", header=TRUE,
                 stringsAsFactors=FALSE, skip=15)
odat <- odat[odat$Point != "Walk",]
odat$Point <- mapvalues(odat$Point,
                        from=c(1:4),
                        to=c("University Way", "40th St", "15th Ave", "Green wall"))
odat$outdoor <- TRUE
names(odat) <- names(blackcarbon)

blackcarbon.plot <- ggplot(blackcarbon, aes(y=BC, x=outdoor)) +
  geom_boxplot() + facet_wrap(~ site) +
  theme_bw() + xlab("Outdoors") + ylab("Black Carbon")

ggsave("./results/figures/blackcarbon-box.pdf", width=6, height=6)


oldblackcarbon.plot <- ggplot(odat, aes(y=BC, x=site)) +
  geom_boxplot() +
  theme_bw() + xlab("Outdoors") + ylab("Black Carbon")

ggsave("./results/figures/oldblackcarbon-box.pdf", width=6, height=6)


blackcarbon.tab <- ddply(blackcarbon, .(site, outdoor), summarize,
                         N=length(BC),
                         Min=min(BC), Median=median(BC),
                         Mean=mean(BC), Max=max(BC),
                         SD=sd(BC))
write.csv(blackcarbon.tab, "./results/figures/blackcarbon-tab.csv")



## Density plots might also be useful for cross-site comparisons
noise.dens <- ggplot(noise, aes(x=Average, color=site, linetype=outdoor)) +
  geom_density() + theme_bw() + xlab("Decibels (averaged by 0.1 second intervals)")
ggsave("./results/figures/noise-density.pdf", width=8, height=4)


blackcarbon.dens <- ggplot(blackcarbon, aes(x=BC, color=site, linetype=outdoor)) +
  geom_density() + theme_bw() + xlab("Black carbon")
ggsave("./results/figures/blackcarbon-density.pdf", width=8, height=4)
