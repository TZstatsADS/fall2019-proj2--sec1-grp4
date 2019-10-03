library(shiny)
library(shinyWidgets)
library(leaflet)
setwd('D:\\CUSTAT\\5243\\fall2019-proj2--sec1-grp4\\app')

ui <- navbarPage("A Guidance for NYC Travelers",
        
        tabPanel("Landmarks",
                 
                 div(class="outer",
                     tags$style(".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
                     leafletOutput("map1", width = "100%", height = "100%"),
                     
                     absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                   draggable = TRUE, top = 60, left = 0, right = 40, bottom = "auto",
                                   width = 330, height = "auto",
                                   
                                   h3("Panel"),
                                   
                                   prettyCheckboxGroup(inputId = "borough",
                                                       label = "Choose Borough", thick = TRUE,
                                                       choices = c("Manhattan", "Brooklyn", "Queen", "Bronx"),
                                                       selected = "Manhattan",
                                                       animation = "pulse", status = "info"),
                                   prettyCheckboxGroup(inputId = "view",
                                                       label = "View", thick = TRUE,
                                                       choices = c("Filming Locations", "Landarks", "Restaurants", 
                                                                   "Library",'Museums'),
                                                       selected = "Filming Locations",
                                                       animation = "pulse", status = "info")
                                   #verbatimTextOutput(outputId = "filming")
                     )
                 )
                 
                 
                ),
                 
        tabPanel("Details", value = "panel4",
                 h3(strong("Details"),align = "center"),
                 br(),
                 
                 fluidPage(
                   fluidRow(
                     br(),
                     br(),
                     column(6,
                            tableOutput('table1')
                     ),
                     
                     column(6,
                            tableOutput('table2')
                     )
                   )
                 )
        ),       
                 
        tabPanel("About Us")
                 
)
