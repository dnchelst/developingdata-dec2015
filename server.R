library(shiny)
library(choroplethr)
library(choroplethrMaps)
library(tidyverse)
require(markdown)

data(country.regions)
load("u5mr.RData")
first.year <- 1990
last.year <- 2018

MortalityValues <- function(year1, region1){
  mortality <- list()
  one.year <- mortality2 %>% filter(year==year1) 
  one.region <- mortality2 %>% filter(region==region1)
  one.region.year <- one.region %>% 
    filter(year==year1)
  value1 <- one.region.year$value
  rank1 <- one.region.year$rank
  percent1 <- 100 * with(one.region, 
    1 - value[year==last.year] / value[year==first.year])
  direction <- if_else(percent1 > 100, "in", "de") %>% paste0("creased")
  mortality <- list(one.year = one.year, 
                    one.region=one.region,
                    percent=percent1, 
                    direction=direction,
                    value=value1,
                    rank=rank1)
    return(mortality)
}

title_first_part <- "Under 5 Mortality Rates (per 1000 births):\n"

shinyServer(function(input, output) {

  # render the boxplot
  output$summary <- renderPrint({
    #input$gobutton
    mortality <- MortalityValues(input$year, input$region)
    line1 <- paste("The region's mortality rate is", mortality$value, 
                   "per 1,000 births." )
    line2 <- paste0("The region ranks ", mortality$rank, " out of ",
                   nrow(mortality$one.year), 
                  " in the world for mortality rates in ", input$year,".")
    line3 <- paste0("Between ", first.year, " and ", last.year, 
                    ", the region's mortality rates ", mortality$direction, 
                    " by ", round(abs(mortality$percent)), " percent.")
    cat(line1, fill=TRUE)
    cat(line2, fill=TRUE)
    cat(line3)
  })
  
  # render the state choropleth map
  output$map_country <- renderPlot({
    mortality.a <- filter(mortality2, year==input$year) 
    choro <- CountryChoropleth$new(mortality.a)
    choro$title <- paste(input$year, "Under 5 Mortality Rates")
    choro$ggplot_scale <- scale_fill_brewer(name="U5MR", palette='RdYlGn', 
                                           direction=-1)
    choro$set_num_colors(9)
    choro$warn <- FALSE
    choro$render()
    
  })
  
  output$country_trend <- renderPlot({
    mortality.b <- filter(mortality2, region==input$region) 
    mortality.c <- filter(mortality.b, year==input$year)
    qplot(mortality.b$year, mortality.b$value, group=1, ymin=0) + 
      geom_line(colour="blue", size=1) + 
      geom_point(colour="black", shape=16, size=3, fill="black") + 
      xlab("Year") + ylab("Mortality rate (per 1,000 births)") + 
      geom_point(data=mortality.c, aes(x=year, y=value), 
                 colour="red", size=4)
  })
  
})