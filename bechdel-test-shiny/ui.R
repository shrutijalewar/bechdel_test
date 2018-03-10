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
library(ggvis)

# Define UI for application that draws a histogram
shinyUI(
  fluidPage(theme = shinytheme("united"),
  
  # Application title
  titlePanel("Grading Hollywood: The Bechdel Test"),
  fluidRow(
    column(12,
           wellPanel(
      span("One of the most enduring tools to measure Hollywood’s gender bias is a test originally promoted by cartoonist Alison Bechdel
            in a 1985"), a("comic strip",href="http://alisonbechdel.blogspot.com/2005/08/rule.html",target="_blank"), span("from her"), a(" “Dykes To Watch Out For”", href="http://dykestowatchoutfor.com/", target="_blank"), 
      span("series. Bechdel said that if a movie can satisfy three criteria — "),
        tags$ol(tags$li("There are at least two named women in the picture. "),
                  tags$li("They have a conversation with each other at some point. "),
                  tags$li("That conversation isn’t about a male character. ")
           ),
      span("Then it passes “The Rule,” whereby female characters are allocated a bare minimum of depth."),
      span("Using Bechdel scores data from "),a("bechdeltest.com,", href = "https://bechdeltest.com/", target="_blank"), a("Kaggle,",href="https://www.kaggle.com/rounakbanik/the-movies-dataset/data",target="_blank"),
          a("imdb datasets,", href="http://www.imdb.com/interfaces/", target="_blank"), span(" and a "),a("gender-prediction package", href="https://cran.r-project.org/web/packages/gender/vignettes/predicting-gender.html", target="_blank"),
      span(" and, I analyzed over 5000 films released from 1895 to 2017 to examine the relationship between the prominence of women in a film and the gender of film’s director, genre, 
           ratings, budget, revenue and run time.")
     ))),
  fluidRow(
    column(3,
      wellPanel(  
        h4("Filter"),
  # Sidebar with a slider input for number of bins 
  # sidebarLayout(
    # sidebarPanel(
      sliderInput("year", "Year Released", 1890, 2018, value = c(1950, 2014), sep = ''),
      sliderInput("averageRating", "IMDB Rating", 1, 10, value = c(4, 9)),
      sliderInput("revenue", "Revenue in USD",0, 2000000000, value = c(0,1500000000)),
      sliderInput("budget", "Budget in USD",0, 300000000, value = c(0,200000000)),
      selectInput("gender", "Gender of Director", c("All", "male", "female"),selected = 'All'),
      selectInput("genres", "Genre (a movie can have multiple genres)",
              c("All", "Action", "Adventure", "Animation", "Biography", "Comedy",
                "Crime", "Documentary", "Drama", "Family", "Fantasy", "History",
                "Horror", "Music", "Musical", "Mystery", "Romance", "Sci-Fi",
                "Short", "Sport", "Thriller", "War", "Western"),selected = 'All')
      ),
    wellPanel(
      h4("Select Your Axis"),
      selectInput("xvar", "X-axis variable", axis_vars, selected = "year"),
      selectInput("yvar", "Y-axis variable", axis_vars, selected = "averageRating")
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
      ),
  wellPanel(
    h4("Some Cool Links"),
    tags$ol( 
      tags$li(a("Creating the Next Bechdel Test", href="https://projects.fivethirtyeight.com/next-bechdel/", target="_blank")),
      tags$li(a("Hollywood's Gender Divide and its Effect on Films", href="https://pudding.cool/2017/03/bechdel/", target="_blank")),
      tags$li(a("The Dollar-And-Cents Case Against Hollywood’s Exclusion of Women", href="https://fivethirtyeight.com/features/the-dollar-and-cents-case-against-hollywoods-exclusion-of-women/", target="_blank")),
      tags$li(a("The Data Behind Hollywood's Sexism, How Inclusion Riders Work — and Why Hollywood Needs Them", href="https://www.ted.com/talks/stacy_smith_the_data_behind_hollywood_s_sexism?utm_campaign=tedspread&utm_content=talk&utm_medium=referral&utm_source=tedcomshare&utm_term=humanities", target="_blank"))
    )
  )
    )
  )

