library(tigris)
library(png)
library(dtplyr)
library(dplyr)
library(DT)
library(lubridate)
library(shiny)
library(choroplethr)
library(choroplethrZip)
library(ggplot2)
library(ggmap)
library(readr)
library(plyr)
library(tmap)
library(sf)
require(leaflet)
require(raster)
require(spData)
require(shinydashboard)
require(shinythemes)
require(leaflet.extras)
require(magrittr)
require(gmapsdistance)
require(plotly)
require(googleway)
require(mapview)
require(shinyBS)
require(shinyjs)
require(htmltools)
require(bsplus)
require(shinyWidgets)
require(shinycssloaders)
require(shinycustomloader)
require(shinyFeedback)
require(geosphere)
register_google(key="AIzaSyC37N09VQDrlBw-myPO42263tqOj_He9xA")

data <- read.csv('FINAL.csv')
filming <- read.csv('Final_Filming.csv')
landmark <- read.csv('Final_Landmarks.csv')
libraries <- read.csv('Final_Libraries.csv')
museums <- read.csv('Final_Museums.csv')
restaurant <- read.csv('Final_Restaurant.csv')
final_data <- merge(filming,landmark,all = T)
final_data <- merge(final_data,libraries,all = T)
final_data <- merge(final_data,museums,all = T)
final_data <- merge(final_data,restaurant,all = T)

server <- function(input, output) {
  #################### Map ####################
  output$map1 <- renderLeaflet({
    current_loc <- geocode(input$inaddress)
    dlat <- final_data$lat
    dlon <- final_data$lon
    loc <- cbind(dlon,dlat)
    loc <- as.matrix(loc)
    dist <- distHaversine(loc, current_loc)
    
    data <- final_data[as.logical(match(final_data$type, input$type, nomatch=0)) & dist<input$range*1609.34,]
    
    leaflet(data) %>%
      addTiles() %>%
      addMarkers(lng = ~current_loc$lon,
                 lat = ~current_loc$lat,
                 popup = "You are here") %>%
      addCircles(lng = ~current_loc$lon,
                 lat = ~current_loc$lat,
                 radius = input$range*1609.34) %>%
      setView(-73.968285, 40.785091, zoom=12) %>%
      addMarkers(lng = ~lon, 
                 lat = ~lat, 
                 popup = paste(
                   "Type:", data$type, "<br>",
                   "Name:", data$name, "<br>",
                   "Address:", data$address, "<br>"
                 ),
                 clusterOptions = markerClusterOptions()
      ) 
  })
  
  output$text1_1 <- renderText({ 
    "Tell us where you are. There are so many great places near you!"
  })
  
  #################### List ####################
  output$map2 <- renderLeaflet({
    land_loc <- geocode(na.omit(as.character(final_data[final_data$name==input$land_list,]$address)))
    film_loc <- geocode(na.omit(as.character(final_data[final_data$name==input$film_list,]$address)))
    museum_loc <- geocode(na.omit(as.character(final_data[final_data$name==input$museum_list,]$address)))
    library_loc <- geocode(na.omit(as.character(final_data[final_data$name==input$library_list,]$address)))
    
    rest_cat <- restaurant[restaurant$categories==input$rest_type,]
    
    rlat <- rest_cat$lat
    rlon <- rest_cat$lon
    rloc <- cbind(rlon,rlat)
    rloc <- as.matrix(rloc)
    r_land_dist <- distHaversine(rloc, land_loc)
    r_film_dist <- distHaversine(rloc, film_loc)
    r_museum_dist <- distHaversine(rloc, museum_loc)
    r_library_dist <- distHaversine(rloc, library_loc)
    
    rest_list <- rest_cat[r_land_dist<input$range_list |
                          r_film_dist<input$range_list |
                          r_museum_dist<input$range_list |
                          r_library_dist<input$range_list,]
    
    leaflet() %>%
      addTiles() %>%
      setView(-73.968285, 40.785091, zoom=12) %>%
      addProviderTiles(providers$Esri.WorldTopoMap) %>%
      addMarkers(data = land_loc,#LANDMARK
                 lng = ~lon, 
                 lat = ~lat,
                 popup = paste("Landmark: ", input$land_list)
                ) %>%
      addCircles(data = land_loc,
                 lng = ~lon,
                 lat = ~lat,
                 radius = input$range_list,
                 popup = paste("Landmark: ", input$land_list),
                 stroke = FALSE,
                 color = "green"
                ) %>% ##
      addMarkers(data = film_loc,# FILM
                 lng = ~lon, 
                 lat = ~lat,
                 popup = paste("Film: ", input$film_list)
                ) %>%
      addCircles(data = film_loc,
                 lng = ~lon,
                 lat = ~lat,
                 radius = input$range_list,
                 popup = paste("Film: ", input$film_list),
                 stroke = FALSE,
                 color ="black"
                ) %>% ##
      addMarkers(data = museum_loc,# MUSEUM
                 lng = ~lon, 
                 lat = ~lat,
                 popup = paste("Museum: ", input$museum_list)
                ) %>%
      addCircles(data = museum_loc,
                 lng = ~lon,
                 lat = ~lat,
                 radius = input$range_list,
                 popup = paste("Museum: ", input$museum_list),
                 stroke = FALSE,
                 color= "brown"
                ) %>% ##
      addMarkers(data = library_loc,# LIBRARY
                 lng = ~lon, 
                 lat = ~lat,
                 popup = paste("Library: ", input$library_list)
                ) %>%
      addCircles(data = library_loc,
                 lng = ~lon,
                 lat = ~lat,
                 radius = input$range_list,
                 popup = paste("Library: ", input$library_list),
                 stroke = FALSE,
                 color="red"
                ) %>% ##
      
      addMarkers(data = rest_list,
                 lng = ~lon, 
                 lat = ~lat, 
                 popup = paste(
                   "Name:", rest_list$name, "<br>",
                   "Category:", rest_list$categories, "<br>",
                   "Rating / Price level:", rest_list$rating, " / ", 
                   rest_list$price, "<br>",
                   "Address:", rest_list$address, "<br>",
                   "Phone #:", rest_list$tel, "<br>")
                )
    
  })
  
############ stats
  data<-read.csv('FINAL.csv',header = TRUE)
  restaurant1<-data[which(data$Type=="restaurant"),][sample(1:3165,400),]
  df<-rbind(data[which((data$Type=="film")|(data$Type=="landmarks")|(data$Type=="library")),],restaurant1)
  
  x<-data.frame(df %>%filter((Type=="film")|(Type=="landmarks")|(Type=="library")|(Type=="restaurant"))%>%group_by(Type) %>% summarise(n()))
  y<-data.frame(df %>% filter((Borough=="Brooklyn")|(Borough=="Manhattan")|(Borough=="Queens")|(Borough=="The Bronx"))%>%group_by(Type,Borough) %>% summarise(n()))
  # plot 1
  scatter<-data.frame("X"=c(rep(x[1,2],4),rep(x[2,2],4),rep(x[3,2],3),rep(x[4,2],3)),"Y"=y)
  axis1=list(
    title = "Entertainment Type",
    range = c(100,600),
    autorange = FALSE,                           
    rangemode = "normal",                                                   
    fixedrange = TRUE,
    showticklabels = FALSE
  )
  axis2=list(
    title = "The Number of Size"                       
  )
  p <- plot_ly(scatter, x = ~X, y = ~Y.n.., text = ~Y.Borough, type = 'scatter', mode = 'markers', size = ~Y.n.., color = ~Y.Borough, colors = 'Paired',
               sizes = c(10, 50),
               marker = list(opacity = 0.5, sizemode = 'diameter')) %>%
    layout(title = 'The Number of Sites per Borough',
           xaxis = axis1,
           yaxis = axis2,
           showlegend = TRUE)
  
  #plot 2
  x1<-data.frame(data %>%filter((Type=="film")|(Type=="landmarks")|(Type=="library")|(Type=="restaurant"))%>%group_by(Type) %>% summarise(n()))
  y1<-data.frame(data %>% filter((Borough=="Brooklyn")|(Borough=="Manhattan")|(Borough=="Queens")|(Borough=="The Bronx"))%>%group_by(Type,Borough) %>% summarise(n()))
  scatter_new<-data.frame("X"=c(rep(x1[1,2],4),rep(x1[2,2],4),rep(x1[3,2],3),rep(x1[4,2],3)),"Y"=y1)
  scatter1<-data.frame(scatter_new,"percent"=round(scatter$Y.n../scatter$X,digit=2))
  p2 <- ggplot() + 
    geom_bar(aes(y = percent, x = Y.Type, fill = Y.Borough), 
             data = scatter1, stat = "identity")+ labs(x = "entertainment type", title = "The distribution of Sites per Borough")+
    theme(plot.title = element_text(hjust = 0.5))
  p3 <- ggplotly(p2)
  #output$plot2<-renderPlot(p3)
  
  
  output$Plot1<-renderPlotly({
    if (input$basic_info == "plot1"){
      p
    }
    else if  (input$basic_info == "plot2"){
      p3
    }
  })
  
  #table
  output$datatable2 <- renderDataTable(
                         options = list(pageLength = 10, autowidth = TRUE),
                         {
                           if (input$details == "Films"){
                             data %>% filter(Type=="film")%>%
                               select(Name, Year, Director, Address, Borough)
                           }
                           else if(input$details == "Landmarks"){
                             data %>% filter(Type=="landmarks")%>%
                               select(Name, Year, Address, Borough, Number_of_Complaints,Style,Material,Use)
                           }
                           else if(input$details == "Museums"){
                             data %>% filter(Type=="Museum")%>%
                               select(Name, Address, Tel,Url)
                           }
                           else if(input$details == "Libraries"){
                             data %>% filter(Type=="library")%>%
                               select(Name, Address, Borough,System)
                           }
                           else if(input$details == "Restaurants"){
                             data %>% filter(Type=="restaurant")%>%
                               select(Name, Address, Borough,Categories,Phone,Rating,Price,Zip_code)
                           }
                         }
  )
  
}