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

blackcarbon.plot <- ggplot(blackcarbon, aes(y=BC, x=outdoor)) +
  geom_boxplot() + facet_wrap(~ site) +
  theme_bw() + xlab("Outdoors") + ylab("Black Carbon")

ggsave("./results/figures/blackcarbon-box.pdf", width=6, height=6)


blackcarbon.tab <- ddply(blackcarbon, .(site, outdoor), summarize,
                         N=length(BC),
                         Min=min(BC), Median=median(BC),
                         Mean=mean(BC), Max=max(BC),
                         SD=sd(BC))
write.csv(blackcarbon.tab, "./results/figures/blackcarbon-tab.csv")
