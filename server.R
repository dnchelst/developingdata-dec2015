library(shiny)
library(choroplethr)
library(choroplethrMaps)
library(dplyr)
require(markdown)
library(ggplot2)
mortality2 <- read.csv("u5mr.csv", stringsAsFactors=FALSE)

MortalityValues <- function(year1, region1){
  mortality.dfs <- list()
  mortality.dfs$a = filter(mortality2, year==year1) %>%
    mutate(rank=rank(value))
  mortality.dfs$b = filter(mortality2, region==region1)
  return(mortality.dfs)
}

title_first_part <- "Under 5 Mortality Rates (per 1000 births):\n"

shinyServer(function(input, output) {

  # render the boxplot
  output$summary <- renderPrint({
    #input$gobutton
    mortality.dfs <- MortalityValues(input$year, input$region)
    mortality.val <- filter(mortality.dfs$a, region==input$region)
    direction.percent <- with(mortality.dfs$b, 
                              1 - value[year==2015] / value[year==1990])
    direction.val <- ifelse(direction.percent > 1, "increased", "decreased")
    
    line1 <- paste("The region's mortality rate is", mortality.val$value, 
                   "per 1,000 births." )
    line2 <- paste0("The region ranks ", mortality.val$rank, " out of ",
                   sum(!is.na(mortality.dfs$a$value)), 
                  " in the world for mortality rates in ", input$year,".")
    line3 <- paste("Between 1990 and 2015, the region's mortality rates", 
                    direction.val, "by", 
                   round(100 * abs(direction.percent)), "percent.")
    cat(line1, fill=TRUE)
    cat(line2, fill=TRUE)
    cat(line3)
  })
  
  # render the state choropleth map
  output$map_country <- renderPlot({
    mortality.a <- filter(mortality2, year==input$year) %>%
      mutate(rank=rank(value))
    choro = CountryChoropleth$new(mortality.a)
    choro$title = paste(input$year, "Under 5 Mortality Rates")
    choro$ggplot_scale = scale_fill_brewer(name="U5MR", palette='RdYlGn', 
                                           direction=-1)
    choro$set_num_colors(9)
    choro$render()
    
  })
  
  output$country_trend <- renderPlot({
    mortality.b <- filter(mortality2, region==input$region) 
    mortality.c <- filter(mortality.b, year==input$year)
    qplot(mortality.b$year, mortality.b$value, group=1) + 
      geom_line(colour="blue", size=1) + 
      geom_point(colour="black", shape=16, size=3, fill="black") + 
      xlab("Year") + ylab("Mortality rate (per 1,000 births)") + 
      geom_point(data=mortality.c, aes(x=year, y=value), 
                 colour="red", size=4)
  })
  
})