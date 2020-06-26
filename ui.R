library(shiny)

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
                  choices = c(1990:2018),
                  selected = 2010),
      selectInput("region",
                  label = "Select region",
                  choices = region.choices,
                  selected = "united states of america")#,
      #actionButton("goButton", "Go!")
    ),
    
    mainPanel(
      
      h4("Ranking"),
      verbatimTextOutput("summary"),

      plotOutput("map_country"),
      plotOutput("country_trend")
    )
  )
))
