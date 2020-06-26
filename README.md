# Developing Data, December 2018 (updated)
_Dov Chelst_

This repository includes a small application that allows you to examine 
World Bank data on under-5 mortality rates.

It collects information between 1990 and 2018.

* _ui.R_ and _server.R_ deploy the application which is also available on [shinyapps.io](https://dnchelst.shinyapps.io/u5mr-app).
* The data is available in _u5mr.csv_ and an RData file. 
You can download the same data using the _gather\_u5mr.R_ script.

***Dependencies***

It relies on the [choroplethr](https://cran.r-project.org/web/packages/choroplethr/index.html) 
and 
[choroplethrMaps](https://cran.r-project.org/web/packages/choroplethrMaps/index.html) 
packages by [Ari Lamstein](http://www.arilamstein.com). 
The other dependencies include _shiny_, _markdown_, and core _tidyverse_ packages. 
Data was collected with the aid of the 
[WDI](https://cran.r-project.org/web/packages/WDI/WDI.pdf) package.

***Usage***

The map shows variation in mortality rates throughout the world for a specified year.

The trend line shows changes in mortality rate for a specific country. 
(Try "south korea" to see something interesting.)

***Issues***

The app expects every region in the _country.regions_ data set. 
However, the following are either missing or lack data: Antarctica, Kosovo, Taiwan, and Western Sahara. 
The app will work, but the map will not color these four regions. 
The problem already exists in the _choroplethr_ code samples.
The current version suppresses a warning about the missing data but the problem
still exists.