setwd('/Users/ssharma/code/nss-ds/bechdel_test')

library("jsonlite")
library("tidyverse")
library("dplyr")
library("magrittr")
library("ggplot2")
library("readxl")
library("ggvis")
library("gender")
library("genderdata")

# Reading in data from bechdel api and imdb
bechdel_scores <- read_json('rawData/bechdel_scores', simplifyVector = TRUE)
ratings <- read_tsv('rawData/title.ratings.tsv')
name <- read_tsv('rawData/name.basics.tsv')
crew <- read_tsv('rawData/title.crew.tsv')
dollars <- read_csv('rawData/movies_metadata.csv')
# principals <- read_tsv('rawData/title.principals.tsv')
title <- read_tsv('rawData/title.basics.tsv')
# https://pudding.cool/2017/03/bechdel/#methodology

# editing the bechdelIds to work with imdb_ids
bechdel_scores$tconst <- paste('tt',bechdel_scores$imdbid, sep = '')
bechdel_merge <- merge(bechdel_scores, crew, by='tconst')
bechdel_merge <- merge(bechdel_merge, ratings, by='tconst')
bechdel_merge <- merge(bechdel_merge, title, by='tconst')

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
glimpse(bechdel_merge3)
bechdel <- select(bechdel_merge3, tconst, nconst, rating, id, title, year, averageRating, numVotes, titleType, primaryTitle, originalTitle, 
                  isAdult, runtimeMinutes, genres, Firstname, Lastname, gender)
write_tsv(bechdel_merge3, 'data/bechdel_merge.tsv')
write_tsv(bechdel, 'data/bechdel.tsv')
bechdel_merge3 <- read_tsv('bechdel-test-shiny/data/bechdel_merge.tsv')
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

bechdel_merge3$year <- as.numeric(bechdel_merge3$year) 

bechdel_f <- bechdel_merge3 %>% 
  filter(gender %in% 'female')
bechdel_m <- bechdel_merge3 %>% 
  filter(gender == 'male')
# https://austinwehrwein.com/post/bechdel/

ggplot(bechdel_merge3,aes(x=year))+
  geom_point(stat='count',aes(color=rating))+
  geom_line(stat='count',aes(color=rating))+
  # a_robot_theme()+
  # a_step_color()+
  theme(legend.position = 'right')+
  labs(title='Bechdel test scores over the years',
       subtitle='Count of Bechdel test film scores.',
       caption="Data from http://bechdeltest.com")

ggplot(bechdel_m,aes(x=year))+
  geom_point(stat='count',aes(color=rating))+
  geom_line(stat='count',aes(color=rating))+
  # a_robot_theme()+
  # a_step_color()+
  theme(legend.position = 'right')+
  labs(title='Bechdel test scores over the years with male directors',
       subtitle='Count of Bechdel test film scores.',
       caption="Data from http://bechdeltest.com")

generes <-distinct(bechdel_merge3,genres) 
titleType <-distinct(bechdel_merge3, titleType)

ggplot(bechdel_f,aes(x=year))+
  geom_point(stat='count',aes(color=rating))+
  geom_line(stat='count',aes(color=rating))+
  # a_robot_theme()+
  # a_step_color()+
  theme(legend.position = 'right')+
  labs(title='Bechdel test scores over the years with female directors',
       subtitle='Count of Bechdel test film scores.',
       caption="Data from http://bechdeltest.com")


bechdel_merge3 %>%
  ggvis( ~ year, ~ averageRating) %>% 
  layer_points(size = 50, size.hover = 200,
               fillOpacity = 0.2, fillOpacity.hover = 0.5)
  
  # layer_points(size = 50, size.hover = 200,
  #              fillOpacity = 0.2, fillOpacity.hover = 0.5,
  #              stroke = as.factor(bechdel_merge3$gender), key = ~tconst) 
   add_tooltip(bechdel_merge3$title, "hover") 
   add_axis("x", title = rating) %>%
   add_axis("y", title = year) %>%
   add_legend("stroke", title = "gender:", values = c("male", "female")) 
  # scale_nominal("stroke", domain = c("male", "female"),
  #               range = c("orange", "#aaa")) 
  # set_options(width = 500, height = 500)

dollars <- select(dollars, budget,revenue,imdb_id)
dollars$tconst <- dollars$imdb_id
bechdel_merge4 <- merge(bechdel_merge3,dollars, by='tconst')

glimpse(dollars)
bechdel_merge4 %>% filter(revenue>0) %>% count()
