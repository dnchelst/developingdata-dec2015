library(shiny)
library(dplyr)
library(ggplot2)
require(markdown)
library(leaflet)

#data(country.regions)
load("u5mr.RData")
load("u5mr-map.RData")
first.year <- 1990
last.year <- 2019

MortalityRates <- function(year1, country1){
  mortality <- list()
  one.year <- mortality2 %>% filter(year==year1) 
  one.country <- mortality2 %>% filter(country==country1)
  one.country.year <- one.country %>% filter(year==year1)
  rate1 <- one.country.year$SH.DYN.MORT
  rank1 <- one.country.year$rank
  percent1 <- 100 * with(one.country, 
    1 - SH.DYN.MORT[year==last.year] / SH.DYN.MORT[year==first.year])
  direction <- if_else(percent1 > 100, "in", "de") %>% paste0("creased")
  mortality <- list(one.year = one.year, 
                    one.country=one.country,
                    percent=percent1, 
                    direction=direction,
                    rate=rate1,
                    rank=rank1)
    return(mortality)
}

title_first_part <- "Under 5 Mortality Rates (per 1000 births):\n"

shinyServer(function(input, output) {

  # render the boxplot
  output$summary <- renderPrint({
    mortality <- MortalityRates(input$year, input$country)
    line1 <- paste("The region's mortality rate is", mortality$rate, 
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
  output$map_country <- renderLeaflet({
    mortality.a <- filter(mortality2, year==input$year) 
    mortality.map <- map.countries 
    mortality.map@data <- mortality.map@data %>% 
      left_join(mortality.a, by=c("ISO_A2"="iso2c")) 
    
    # choro <- CountryChoropleth$new(mortality.a)
    # choro$title <- paste(input$year, "Under 5 Mortality Rates")
    # choro$ggplot_scale <- scale_fill_brewer(name="U5MR", palette='RdYlGn',
    #                                        direction=-1)
    # choro$set_num_colors(9)
    # choro$warn <- FALSE
    
    pal1 <- colorQuantile("RdYlGn", 
                          domain=mortality.map@data$SH.DYN.MORT, 
                          reverse=TRUE, n=10)
    labels <- sprintf("<strong>%s</strong><br/>%g deaths per 1,000 births",
                      mortality.map$NAME_EN, mortality.map$SH.DYN.MORT) %>% 
      lapply(gsub, pattern="NA deaths per 1,000 births", 
             replacement="Unknown") %>% 
      lapply(htmltools::HTML) 
    
    choro <- leaflet(mortality.map) %>% 
      setView(0, 0, 2) %>% 
      #addTiles() %>% 
      addPolygons(
        fillColor = ~pal1(SH.DYN.MORT),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "10px",
          offset=c(10,10),
          direction = "auto")) %>% 
      addLegend(pal = pal1, values = ~SH.DYN.MORT, opacity = 0.7, title = NULL,
                position = "bottomright")
    
  })
  
  output$country_trend <- renderPlot({
    mortality.b <- filter(mortality2, country==input$country) 
    mortality.c <- filter(mortality.b, year==input$year)
    qplot(mortality.b$year, mortality.b$SH.DYN.MORT, group=1, ymin=0) + 
      geom_line(colour="blue", size=1) + 
      geom_point(colour="black", shape=16, size=3, fill="black") + 
      xlab("Year") + ylab("Mortality rate (per 1,000 births)") + 
      geom_point(data=mortality.c, aes(x=year, y=SH.DYN.MORT), 
                 colour="red", size=4)
  })
  
})