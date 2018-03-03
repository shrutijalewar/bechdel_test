#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(
  fluidPage(theme = shinytheme("spacelab"),
  
  # Application title
  titlePanel("Grading Hollywood: The Bechdel Test"),
  fluidRow(
    column(12,
           wellPanel(
      span("One of the most enduring tools to measure Hollywood’s gender bias is a test originally promoted by cartoonist Alison Bechdel
            in a 1985 strip from her “Dykes To Watch Out For” series. Bechdel said that if a movie can satisfy three criteria — 
            1. there are at least two named women in the picture, 
            2. they have a conversation with each other at some point, 
            3. and that conversation isn’t about a male character. 
            Then it passes “The Test,” whereby female characters are allocated a bare minimum of depth."
            ),
      span("Using Bechdel test data from bechdeltest.com, imdb datasets and a gender-prediction software and, I analyzed 5464 films released 
            from 1895 to 2017 to examine the relationship between the prominence of women in a film and the gender of film’s director, genre, 
           ratings and run time.")
     ))),
  fluidRow(
    column(3,
      wellPanel(  
        h4("Filter"),
  # Sidebar with a slider input for number of bins 
  # sidebarLayout(
    # sidebarPanel(
      sliderInput("year", "Year Released", 1890, 2018, value = c(1950, 2014), sep = ''),
      sliderInput("runtimeMinutes", "Run Time in Mins", 1, 400, value = c(1, 200)),
      sliderInput("averageRating", "IMDB Rating", 1, 10, value = c(4, 9)),
      sliderInput("numVotes", "Minimum number of Votes",0, 2000000, value = c(800,800000)),
      selectInput("gender", "Gender of Director", c("All", "male", "female"),selected = 'All'),
      selectInput("genres", "Genre (a movie can have multiple genres)",
                  c("All", "Action", "Adventure", "Animation", "Biography", "Comedy",
                    "Crime", "Documentary", "Drama", "Family", "Fantasy", "History",
                    "Horror", "Music", "Musical", "Mystery", "Romance", "Sci-Fi",
                    "Short", "Sport", "Thriller", "War", "Western"),selected = 'All'),
      selectInput("titleType", "Title Type",c("All", "movie", "short", "video", 
                  "tvMiniSeries" ,"tvMovie", "tvSeries", "tvShort", "tvEpisode","videoGame"),selected = 'All')
      
    )
  ),
   
  column(9,
    
    # Show a plot of the generated distribution
    # mainPanel(
    wellPanel(
      fluidRow(
        column(1,
               HTML('')
               ),
        column(3,
           HTML(
            paste(tags$b("Total movies selected:", textOutput("total")))
              )),
        column(3,
               HTML(
                 paste(tags$b(style="color:blue",'Passed : ', textOutput("pass")))
               )),
        column(3,
               HTML(
                 paste(tags$b(style="color:red",'Failed : ', textOutput("fail")))
                      )),
        column(2,
               HTML('')
        )
               ),
      ggvisOutput("plot")
              )
    
        )
      )
    )
  )

