_By Dov Chelst_

This application allows you to examine World Bank data on under-5 mortality 
rates.

It collects information between 1990 and 2020.

The map shows variation in mortality rates throughout the world for a specified 
year.

The trend line shows changes in mortality rate for a specific country. 
(Try "south korea" to see something interesting.)

It relies on the [Leaflet for R](https://https://rstudio.github.io/leaflet/)
package. Other dependencies include _shiny_, _markdown_, _geojsonio_, and 
core _tidyverse_ packages. 
[World Bank Development Indicator Data](http://wdi.worldbank.org/table/2.18) 
was collected with the aid of the 
[WDI](https://cran.r-project.org/web/packages/WDI/WDI.pdf) package and 
associated maps can be downloaded from its 
[data catalog](https://datacatalog.worldbank.org/) 
[here](https://development-data-hub-s3-public.s3.amazonaws.com/ddhfiles/779551/wb_boundaries_geojson_lowres.zip).