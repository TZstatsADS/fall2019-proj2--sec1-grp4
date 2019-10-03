library(shiny)
library(leaflet)
library(tigris)
#server <- function(input, output) {
#  output$value <- renderText({ input$somevalue })
#}

server <- function(input, output, session) {
  
  output$map1 <- renderLeaflet({
    
    map <- leaflet() %>% 
      setView(-73.983,40.7639,zoom = 13) %>% 
      addProviderTiles(providers$Esri.WorldTopoMap)
    
    
    if(input$view == 'Filming Locations'){
      choose_data <- filming %>%
        filter(borough==input$borough)
    }
    
    map <- map %>% 
      addMarkers(data = choose_data,lng = ~lon, 
                 lat = ~lat,
                 popup = ~film,
                 clusterOptions = markerClusterOptions())
    
    
    
  })
  
  table1 <- filming %>%
    group_by(borough) %>%
    summarise(n())
  output$table1 <- renderTable(table1)
  
}