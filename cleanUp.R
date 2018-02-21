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
bechdel_merge$nconst <- bechdel_merge$directors
bechdel_merge2 <- merge(bechdel_merge, name, by = 'nconst')
glimpse(bechdel_merge2)
bechdel_merge2$birthYear <- as.numeric(bechdel_merge2$birthYear)
# gender prediction
# install.packages("gender")
# install.packages("genderdata", type = "source",
#                  repos = "http://packages.ropensci.org")
library(gender)
library(genderdata)
data(package = "genderdata")
gender(c("Madison", "Hillary"), years = 2000, method = "ssa")

bechdel_merge2 <- bechdel_merge2 %>%
    separate(primaryName, c("Firstname", "Lastname"), " ")

gender_prediction <- gender(c(bechdel_merge2$Firstname), years = c(1880, 1992), method = "ssa")
View(gender_prediction)
gender_pred <- gender_prediction %>%
    distinct(name,gender,year_min,year_max,proportion_male,proportion_female)
gender_pred$Firstname <- gender_pred$name
str(gender_pred)

# Merging the gender into the main file
bechdel_merge3 <- merge(bechdel_merge2, gender_pred, by= 'Firstname')
rating_bechdel <- bechdel_merge3 %>%
    group_by(rating,gender) %>%
    count()

male_bechdel <- bechdel_merge3 %>%
    filter(gender == 'male') %>%
    group_by(rating) %>%
    count()

female_bechdel <- bechdel_merge3 %>%
    filter(gender == 'female') %>%
    group_by(rating) %>%
    count()
rating_bechdel <- as.data.frame(rating_bechdel)

    plot(rating_bechdel)
