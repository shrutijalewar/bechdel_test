setwd('/Users/ssharma/code/nss-ds/bechdel_test')

library("jsonlite")
library("tidyverse")
library("dplyr")
library("magrittr")
library("ggplot2")
library("readxl")

# Reading in data from bechdel api and imdb
bechdel_scores <- read_json('rawData/bechdel_scores', simplifyVector = TRUE)
View(bechdel_scores)
ratings <- read_tsv('rawData/title.ratings.tsv')
name <- read_tsv('rawData/name.basics.tsv')
crew <- read_tsv('rawData/title.crew.tsv')
principals <- read_tsv('rawData/title.principals.tsv')

# editing the bechdelIds to work with imdb_ids
bechdel_scores$tconst <- paste('tt',bechdel_scores$imdbid, sep = '')
bechdel_merge <- merge(bechdel_scores, crew, by='tconst')
bechdel_merge <- merge(bechdel_merge, ratings, by='tconst')

# creating a df with unique_nmIds
# unique_nm <- distinct(bechdel_merge,directors,writers)
