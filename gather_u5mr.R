# If you want the mortality data used in this app, it's in this file
library(choroplethrMaps)
library(WDI)
library(tidyverse)



data(country.regions)
country.regions <-  country.regions %>% 
  mutate(iso2c = case_when(region== "kosovo" ~ "XK", 
                           region == "namibia" ~  "NA", 
                           TRUE ~ iso2c))
mortality <- WDI(country= "all", #country.regions$iso2c, 
                 indicator="SH.DYN.MORT", start=1990, 
                 extra=FALSE, cache=NULL)
mortality2 <- merge(mortality, country.regions) %>% 
  filter(!is.na(SH.DYN.MORT)) %>% 
  rename(value=SH.DYN.MORT) %>% 
  group_by(year) %>% 
  mutate(rank = rank(value)) %>% 
  ungroup
write_csv(mortality2, "u5mr.csv")

region.choices <- mortality2 %>% 
  distinct(region) %>% 
  arrange(region) %$% 
  region

save(mortality2, region.choices, file="u5mr.RData")
