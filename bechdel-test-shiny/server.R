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
  
  b_tooltip <- function(x) {
    reactive({print(x$UID)})
    if(is.null(x)) return(NULL)
    if (is.null(x$UID)) return(NULL)
    
    movie <- bechdel[bechdel$UID == x$UID, ]
    paste0("<b>", movie$title, "</b><br>",
           movie$year, "<br>",
           "Bechdel Score: ", movie$rating,"<br>",
           "Director: ", movie$Firstname, ' ', movie$Lastname
    )
  }
  
  vis <- reactive({
    # Lables for axes
    xvar_name <- names(axis_vars)[axis_vars == input$xvar]
    yvar_name <- names(axis_vars)[axis_vars == input$yvar]
    
    # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
    # but since the inputs are strings, we need to do a little more work.
    xvar <- prop("x", as.symbol(input$xvar))
    yvar <- prop("y", as.symbol(input$yvar))
    
    bechdel_sub %>%
      ggvis( x = xvar, y = yvar, key := ~UID) %>% 
      layer_points(size := 50, size.hover := 200,
                   fillOpacity := 0.4, fillOpacity.hover := 0.8,
                   fill = ~factor(rating)) %>% 
      add_tooltip(b_tooltip,"hover") %>% 
     
      add_axis("x", title = xvar_name, format = '####', title_offset = 50, properties = axis_props(labels = list(fontSize = 15),title = list(fontSize = 18))) %>%
      add_axis("y", title = yvar_name, title_offset = 50, properties = axis_props(labels = list(fontSize = 15),title = list(fontSize = 18))) %>%
      add_legend("fill", title = "Bechdel Score", values = c("0", "1", "2", "3") , properties = legend_props(labels = list(fontSize = 15),title = list(fontSize = 15))) %>%
      scale_nominal("fill", domain = c("0", "1", "2", "3"),
                    range = c("magenta", "red", "orange", "blue")) %>%
      set_options(width = 1100, height = 795)
      
      
      
    
  })
  
  vis %>% bind_shiny("plot")
  
  output$total <- renderText({ nrow(bechdel_sub())})
  output$pass <- renderText({ paste(sprintf(((nrow(bechdel_sub() %>% filter(rating == 3))/nrow(bechdel_sub())) * 100), fmt='%.0f'),' %') })
  output$fail <- renderText({ paste(sprintf(((nrow(bechdel_sub() %>% filter(rating < 3))/nrow(bechdel_sub())) * 100), fmt='%.0f'),' %') })
  
})
