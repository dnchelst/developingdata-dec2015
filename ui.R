library(shiny)
library(leaflet)

# the names of the demographic variables are the column names of this data.frame
# the first column name is a list of the regions, so skip it
load("u5mr.RData")

shinyUI(fluidPage(
  
  titlePanel("Mortality Rates from World Bank's World Demographic Indicators"),
  
  fluidRow(column(12, includeMarkdown("text.md"))),
  
  sidebarLayout(
    sidebarPanel(      
      selectInput("year",
                  label = "Select year",
                  choices = c(1990:2019),
                  selected = 2010),
      selectInput("country",
                  label = "Select country",
                  choices = country.choices,
                  selected = "United States")
    ),
    
    mainPanel(
      
      h4("Ranking"),
      verbatimTextOutput("summary"),

      leafletOutput("map_country"),
      plotOutput("country_trend")
    )
  )
))
