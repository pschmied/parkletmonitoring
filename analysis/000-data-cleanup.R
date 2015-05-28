## install.packages(c("stringr"))
library(stringr)

## 
## Clean up black carbon samples
##

## Lists of BC data files
indoorbc <- c(
    "./data/blackcarbon/Cortona_1b_AE51-S5-803_20150516-123000.csv", 
    "./data/blackcarbon/Cortona_2a_AE51-S5-803_20150516-130600.csv", 
    "./data/blackcarbon/Cortona_3b_AE51-S5-803_20150519-151800.csv", 
    "./data/blackcarbon/Cortona_4a_AE51-S5-803_20150519-155100.csv", 
    "./data/blackcarbon/Montana_1b_AE51-S5-803_20150515-193000.csv", 
    "./data/blackcarbon/Montana_2a_AE51-S5-803_20150515-202400.csv", 
    "./data/blackcarbon/Montana_3b_AE51-S5-803_20150519-184500.csv", 
    "./data/blackcarbon/Montana_4a_AE51-S5-803_20150519-191700.csv", 
    "./data/blackcarbon/Siff-AE51-S5-802_20150519-140500.csv",
    "./data/blackcarbon/Siff-AE51-S5-802_20150520-140500.csv",
    "./data/blackcarbon/Siff-AE51-S5-802_20150522-135300.csv",
    "./data/blackcarbon/Siff-AE51-S5-802_20150523-144030.csv"
    )

outdoorbc <- c(
    "./data/blackcarbon/Cortona_1a_AE51-S5-803_20150516-115000.csv", 
    "./data/blackcarbon/Cortona_2b_AE51-S5-803_20150516-133600.csv", 
    "./data/blackcarbon/Cortona_3a_AE51-S5-803_20150519-144530.csv", 
    "./data/blackcarbon/Cortona_4b_AE51-S5-803_20150519-162800.csv", 
    "./data/blackcarbon/Montana_1a_AE51-S5-803_20150515-185400.csv", 
    "./data/blackcarbon/Montana_2b_AE51-S5-803_20150515-205500.csv", 
    "./data/blackcarbon/Montana_3a_AE51-S5-803_20150519-181300.csv", 
    "./data/blackcarbon/Montana_4b_AE51-S5-803_20150519-195600.csv", 
    "./data/blackcarbon/Siff-AE51-S5-802_20150519-142700.csv",
    "./data/blackcarbon/Siff-AE51-S5-802_20150520-142800.csv", 
    "./data/blackcarbon/Siff-AE51-S5-802_20150522-141100.csv",
    "./data/blackcarbon/Siff-AE51-S5-802_20150523-150000.csv"
    )

## Custom read function takes
## file :: character, outdoor :: boolean
## returns dataframe
readae51 <- function(file, outdoor) {
    ## Skip the blank line [-1,]. Also skip any bogus columns that
    ## were added when one of the CSV files was annotated in Excel
    ## [,1:10]
    df <- read.csv(file, header=TRUE, skip=15)[-1,1:10]
    site <- str_extract(file, "Cortona|Montana|Siff")
    df$site <- site
    df$outdoor <- outdoor
    df
}

## Clean AE51 data
cleanae51 <- function(df) {
    df[! is.na(df$BC), ]
}

bc.combined <- rbind(
    do.call(rbind, lapply(outdoorbc, readae51, outdoor=TRUE)),
    do.call(rbind, lapply(indoorbc, readae51, outdoor=FALSE)))

bc.cleaned <- cleanae51(bc.combined)

write.csv(bc.cleaned, "./data/blackcarbon-cleaned.csv")


##
## Clean up noise samples
##

indoornoise <- c(
    "./data/noise/Cortona_1b_DecibelData.csv", 
    "./data/noise/Cortona_2a_DecibelData.csv", 
    "./data/noise/Cortona_3b_inside_DecibelData.csv", 
    "./data/noise/Cortona_4a_inside_DecibelData.csv", 
    "./data/noise/Montana_1b_DecibelData.csv", 
    "./data/noise/Montana_2a_DecibelData.csv", 
    "./data/noise/Montana_3b_inside_DecibelData.csv", 
    "./data/noise/Montana_4a_inside_DecibelData.csv", 
    "./data/noise/Uptown-Indoor-19May2015.csv", 
    "./data/noise/Uptown-Indoor-20May2015.csv", 
    "./data/noise/Uptown-Indoor-22May2015.csv", 
    "./data/noise/Uptown-Indoor-23May2015.csv"
    )

outdoornoise <- c(
    "./data/noise/Cortona_1a_DecibelData.csv", 
    "./data/noise/Cortona_2b_DecibelData.csv", 
    "./data/noise/Cortona_3a_out_DecibelData.csv", 
    "./data/noise/Cortona_4b_outside_DecibelData.csv", 
    "./data/noise/Montana_1a_DecibelData.csv", 
    "./data/noise/Montana_2b_DecibelData.csv", 
    "./data/noise/Montana_3a_outside_DecibelData.csv", 
    "./data/noise/Montana_4b_outside_DecibelData.csv", 
    "./data/noise/Uptown-Outdoor-19May2015.csv", 
    "./data/noise/Uptown-Outdoor-20May2015.csv", 
    "./data/noise/Uptown-Outdoor-22May2015.csv", 
    "./data/noise/Uptown-Outdoor-23May2015.csv"
    )

## Read decibel 10th datasets appropriately
## file :: character, outdoor :: boolean
readdb <- function(file, outdoor) {
    df <- read.csv(file, header=FALSE, stringsAsFactors=FALSE)
    names(df) <- c("Date", "Time", "Average", "Peak")
    site <- str_extract(file, "Cortona|Montana|Uptown")
    df$site <- site
    df$site[df$site == "Uptown"] <- "Siff" #for consistency w/bc
    df$outdoor <- outdoor
    df
}


noise.combined <- rbind(
    do.call(rbind, lapply(outdoornoise, readdb, outdoor=TRUE)),
    do.call(rbind, lapply(indoornoise, readdb, outdoor=FALSE)))

write.csv(noise.combined, "./data/noise-cleaned.csv")
