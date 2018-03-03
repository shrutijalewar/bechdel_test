#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(
  fluidPage(
  
  # Application title
  titlePanel("Grading Hollywood: The Bechdel Test"),
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
      
    )),
   
  column(9,
    
    # Show a plot of the generated distribution
    # mainPanel(
    wellPanel(
      # tags$div(
      #   HTML(paste("Total movies selected: ", textOutput("total")
      #     # "This text is ", tags$span(style="color:red", "red"), sep = ""))
      # )))
      tags$div(
           HTML(paste("Total movies selected:",
           textOutput("total"),
      "Pass:",
      tags$span(style="color:blue",textOutput("pass")),
      "Fail:",
      tags$span(style="color:red",textOutput("fail"))
    ))),
      ggvisOutput("plot")
      
      )
    
  )
  )
))

