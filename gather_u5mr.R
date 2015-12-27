# If you want the mortality data used in this app, it's in this file
library(choroplethrMaps)
library(WDI)
data(country.regions)
country.regions <-  country.regions %>% 
  mutate(iso2c = ifelse(region=="kosovo", "XK", iso2c),
         iso2c = ifelse(region=="namibia", "NA", iso2c))
mortality <- WDI(country= "all", #country.regions$iso2c, 
                 indicator="SH.DYN.MORT", start=1990, end=2015, 
                 extra=FALSE, cache=NULL)
mortality2 <- merge(mortality, country.regions)
mortality2 <- mortality2 %>% 
  rename(value=SH.DYN.MORT) 
write.csv(mortality2, "u5mr.csv", row.names=FALSE)