library(tidyverse)

### Films
filming <- read.csv('../data/Filming Locations.csv')
filming <- filming %>%
  select(Film,Year,Director.Filmmaker.Name,Location.Display.Text,
         LATITUDE,LONGITUDE,Borough,Neighborhood,IMDB.LINK)
colnames(filming) <- c('film','year','director','loc','lat','lon',
                       'borough','nbhd','imdb')
filming$lon <- as.numeric(as.character(filming$lon))
colnames(filming)[1] <-'name'
colnames(filming)[4] <-'address'
filming$type <- 'Films'
write_csv(filming, "../output/Final_Filming.csv")

### Restaurants
restaurant <- read.csv('../data/restaurant_NYC.csv',as.is = T)
colnames(restaurant) <- tolower(colnames(restaurant))
colnames(restaurant)[3] <- 'name'
colnames(restaurant)[4] <- 'borough'
colnames(restaurant)[6:8] <- c('zipcode','lat','lon')
colnames(restaurant)[10] <- 'tel'
restaurant <- restaurant %>%
  select(type,name,borough,address,zipcode,lat,lon,categories,tel,review_count,rating,price) 
restaurant$type <- 'Restaurants'
write_csv(restaurant, "../output/Final_Restaurant.csv")

### Landmarks
landmark <- read.csv('../output/landmarks_final_clean.csv',as.is = T)
colnames(landmark) <- tolower(colnames(landmark))
colnames(landmark)[10:11] <- c('lat','lon')
landmark$borough[which(landmark$borough=='MN')] <- 'Manhattan' 
landmark$borough[which(landmark$borough=='BK')] <- 'Brooklyn'
landmark$borough[which(landmark$borough=='QN')] <- 'Queens'
landmark$borough[which(landmark$borough=='BX')] <- 'Bronx' 
landmark$type <- 'Landmarks'
write_csv(landmark, "../output/Final_Landmarks.csv")

### Libraries 
libraries <- read.csv('../output/Library.csv',as.is = T)
colnames(libraries) <- tolower(colnames(libraries))
colnames(libraries)[2] <-'zipcode'
libraries$type <- 'Libraries'
write_csv(libraries, "../output/Final_Libraries.csv")

### Museums
museum <- read.csv('../output/Museum.csv',as.is = T)
colnames(museum) <- tolower(colnames(museum))
museum$type <- 'Museums'
write_csv(museum, "../output/Final_Museums.csv")