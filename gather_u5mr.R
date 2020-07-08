# If you want the mortality data used in this app, it's in this file
library(WDI)
library(tidyverse)
library(magrittr)
library(geojsonio)

# Get mortality data
mortality <- WDI(country= "all", 
                 indicator="SH.DYN.MORT", start=1990, 
                 extra=TRUE, cache=NULL) %>% 
  filter(!is.na(SH.DYN.MORT)) %>% 
  mutate_at(vars(iso3c:lending), as.character)
# whole world
mortality.world <- mortality %>% 
  filter(iso2c=="1W") 
# only countries - not larger aggregates & add rank
mortality2 <- mortality %>% 
  filter(region != "Aggregates") %>% 
  group_by(year) %>% 
  mutate(rank = rank(SH.DYN.MORT)) %>% 
  ungroup
# store as csv files
write_csv(mortality2, "u5mr.csv")
write_csv(mortality.world, "u5mr-world.csv")

country.choices <- mortality2 %>% 
  distinct(country) %>% 
  arrange(country) %$% 
  country

# Get map data

#https://datacatalog.worldbank.org/dataset/world-bank-official-boundaries
# Online location of files
map.url <- file.path("https://development-data-hub-s3-public.s3.amazonaws.com",
                     "ddhfiles/779551")
map.file <- "wb_boundaries_geojson_lowres.zip"
# decompressing archive
map.subdirectory <- "WB_Boundaries_GeoJSON_lowres"
countries.map.file <- "WB_countries_Admin0_lowres.geojson"

download.file(file.path(map.url, map.file), map.file)
unzip(map.file, files=file.path(map.subdirectory, countries.map.file), 
      junkpaths=TRUE)
# cleaninup is optional!
rm(map.file)

map.countries <- geojsonio::geojson_read(countries.map.file, what = "sp")
# fix a problem with data for France and Norway
map.countries@data %<>% 
  mutate(ISO_A2 = case_when(NAME_EN=="France" ~ "FR",
                            NAME_EN=="Norway" ~ "NO",
                            TRUE ~ ISO_A2),
         ISO_A3 = case_when(NAME_EN=="France" ~ "FRA",
                            NAME_EN=="Norway" ~ "NOR",
                            TRUE ~ ISO_A3))

save(mortality2, mortality.world, country.choices, file="u5mr.RData")
save(map.countries, file="u5mr-map.RData")
