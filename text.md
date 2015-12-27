_By Dov Chelst_

This application allows you to examine World Bank data on under-5 mortality rates.

It collects information between 1990 and 2015.

The map shows variation in mortality rates throughout the world for a specified year.

The trend line shows changes in mortality rate for a specific country. (Try "South Korea" to see something interesting.)

It relies on the [choroplethr](https://cran.r-project.org/web/packages/choroplethr/index.html) 
and 
[choroplethrMaps](https://cran.r-project.org/web/packages/choroplethrMaps/index.html) 
packages by [Ari Lamstein](http://www.arilamstein.com). The other dependencies include _shiny_, _dplyr_, and _ggplot2_. Data was collected with the aid of the [WDI](https://cran.r-project.org/web/packages/WDI/WDI.pdf) package.