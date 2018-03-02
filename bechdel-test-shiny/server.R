#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library("shiny")
library("ggvis")
library("tidyverse")
library("dplyr")

# Set up WD
setwd('/Users/ssharma/code/nss-ds/bechdel_test')

# Read in the cleaned up data file as df.
bechdel <- read_tsv('bechdel-test-shiny/data/bechdel.tsv')
glimpse(bechdel)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
   
  bechdel_sub <- reactive({
    minRuntime <- input$runtimeMinutes[1]
    maxRuntime <- input$runtimeMinutes[2]
    minAvgRate <- input$averageRating[1]
    maxAvgRate <- input$averageRating[2]
    minNumVotes <- input$numVotes[1]
    maxNumVotes <- input$numVotes[2]
    minyear <- input$year[1]
    maxyear <- input$year[2]
    
    # Applying the slider filters
    b <- bechdel %>%
      filter(
        runtimeMinutes >= minRuntime,
        runtimeMinutes <= maxRuntime,
        averageRating >= minAvgRate,
        averageRating <= maxAvgRate,
        numVotes >= minNumVotes,
        numVotes <= maxNumVotes,
        year >= minyear,
        year <= maxyear
        
      ) %>%
      arrange(rating) 
    
    # Optional filtering by genre
    if (input$genres != "All") {
      b <- b %>% filter(grepl(input$genres, genres))
    }
    
    # Optional filtering by Title Type
    if (input$titleType != "All") {
      b <- b %>% filter(titleType %in% input$titleType)
    }
    
    # Optional filtering by gender
    if (input$gender != "All") {
      b <- b %>% filter(gender %in% input$gender)
    }
    
    b <- as.data.frame(b)
    
  })
  vis <- reactive({
    
    bechdel_sub %>%
      ggvis( ~ year, ~ averageRating) %>% 
      layer_points(size := 50, size.hover := 200,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5,
                   stroke = ~rating) %>% 
      set_options(width = 1000, height = 600)
      
    
  })
  
  vis %>% bind_shiny("plot")
  
  output$n_b_sum <- renderText({ nrow(bechdel_sub())})
  
})
