library(tidyverse)
filming <- read.csv('../data/Filming Locations.csv')
filming <- filming %>%
  select(Film,Year,Director.Filmmaker.Name,Location.Display.Text,
         LATITUDE,LONGITUDE,Borough,Neighborhood,IMDB.LINK)
colnames(filming) <- c('film','year','director','loc','lat','lon',
                       'borough','nbhd','imdb')
filming$lon <- as.numeric(as.character(filming$lon))
write_csv(filming, "../output/Filming.csv")