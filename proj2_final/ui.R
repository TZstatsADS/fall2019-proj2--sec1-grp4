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
library(leaflet)
library(raster)
library(spData)
library(shinydashboard)
library(shinythemes)
library(leaflet.extras)
library(magrittr)
library(gmapsdistance)
library(plotly)
library(googleway)
library(mapview)
library(shinyBS)
library(shinyjs)
library(htmltools)
library(bsplus)
library(shinyWidgets)
library(shinycssloaders)
library(shinycustomloader)
library(shinyFeedback)
library(geosphere)
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


ui <- dashboardPage(
  dashboardHeader(title = "\"New\" Yorkers"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "intro", icon = icon("fas fa-info")),
      menuItem("Map", tabName = "mapping", icon = icon("map")),
      menuItem("List", tabName = "listing", icon = icon("fas fa-list")),
      menuItem("Stats", icon = icon("fas fa-chart-bar"), tabName = "stat"),
      menuItem("Directory", icon = icon("book"), tabName = "directory")
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(# Introduction
        tabName="intro", 
        div(class = "intro",
            
            tags$head(
              # Include our custom CSS
              includeCSS("www/intro.css")
              
            ),
            align="center",
            br(),
            br(),
            br(),
            br(),
            br(),
            h1("A Guidance for New York Travlers",style="color:white;font-family: Times New Roman;font-size: 300%;font-weight: bold;"),
            br(),
            br(),
            h3("Hello \"New\" Yorkers",style="color:white;font-family: Times New Roman;font-size: 200%;font-weight: bold;"),
            h3("This app is made to make your New York adventure go as smoothly as possible.",style="color:white;font-family: Times New Roman;font-size: 200%;font-weight: bold;"),
            h5("Cho, Sung In",style="color:white;font-family: Times New Roman;font-size: 200%;font-weight: bold;"),
            h5("Li, Yanan",style="color:white;font-family: Times New Roman;font-size: 200%;font-weight: bold;"),
            h5("Qiang, Runzi",style="color:white;font-family: Times New Roman;font-size: 200%;font-weight: bold;"),
            h5("Ye, Xuanhong",style="color:white;font-family: Times New Roman;font-size: 200%;font-weight: bold;")
            
        )
      ),#tabItem
      
      tabItem(# Map
        tabName= "mapping",
        fluidRow(
          box(leafletOutput("map1")),
          box(textInput(h3("Current Location"), inputId = "inaddress")),
          box(
            checkboxGroupInput(
              inputId = "type",
              label=h4("Types of Place"),
              choices = list("Landmarks"="Landmarks",
                             "Films"="Films",
                             "Museums"="Museums",
                             "Libraries"="Libraries",
                             "Restaurants"="Restaurants"))
          ),
          
          box(submitButton("Locate me")),
          box(sliderInput(inputId = "range", "Radius Range(mile):",
                          min=0, max=5, value=1)),
          box(h4(textOutput("text1_1")))
        )#fluidRow
      ),#tabItem - map
      
      tabItem( # List of Places and Restaurants
        tabName = "listing", 
        fluidRow(
          box( 
            # list of landmarks
            selectizeInput("land_list", 
                           label="List of Landmarks (Green)",
                           choices=final_data[final_data$type=="Landmarks",]$name, 
                           selected = NULL, 
                           options = list(create = TRUE)),
            # list of films
            selectizeInput("film_list", 
                           label="List of Films (Black)",
                           choices=final_data[final_data$type=="Films",]$name, 
                           selected = NULL, 
                           options = list(create = TRUE)),
            # list of Museums
            selectizeInput("museum_list", 
                           label="List of Museums (Brown)",
                           choices=final_data[final_data$type=="Museums",]$name, 
                           selected = NULL, 
                           options = list(create = TRUE)),
            # list of Library
            selectizeInput("library_list", 
                           label="List of Libraries (Red)",
                           choices=final_data[final_data$type=="Libraries",]$name, 
                           selected = NULL, 
                           options = list(create = TRUE))
          ),
          
          # Map showing restaurnats near that place
          box(leafletOutput("map2",width = "100%", height="300px")),
          
          # Restaurant Type Filter
          box(selectInput(inputId = "rest_type", 
                          label= "Restaurnat Categories",
                          choices = unique(restaurant$categories)),
              submitButton("Yummy!")),
          
          # Range Slider
          box(sliderInput(inputId = "range_list", "Radius Range(meter):",
                          min=0, max=500, value=250))
          
        )
      ), # tabitem - lists
      
      tabItem( # stats
        tabName = "stat",
        fluidPage(
          sidebarLayout(
            absolutePanel(NULL, id = "controls", class = "panel panel-default", fixed = TRUE,draggable = TRUE, left = "auto", right = 20,
                          top = 90, bottom = "auto", width = 250, height = "auto", cursor = "move",
                          uiOutput("uni_reset", inline = TRUE),
                          fluidRow(column(12, align = "center", offset = 0,
                                          actionButton("reset_input2", "Reset"),
                                          tags$style(type = "text/css", "#reset_input2 {width:100%}")
                          )
                          )
            ),
            mainPanel(
              width = 10,
              tabsetPanel(type = "tabs",
                          tabPanel(strong("Basic Infomation"), 
                                   radioButtons("basic_info", NULL,choices = c("plot1","plot2"), 
                                                inline = TRUE
                                   ),
                                   
                                   plotlyOutput("Plot1")
                          )
              ),
              position = "right"
            )
          )
        )
        
      ), # tabitem - stat
      
      tabItem( # directory of data
        tabName = "directory",
        navbarPage("Directory",
                   tabPanel("Films",
                            h3("Film Directory"),
                            dataTableOutput("film_dir")
                   ),
                   tabPanel("Landmarks",
                            h3("Landmark Directory"),
                            dataTableOutput("land_dir")
                   ),
                   tabPanel("Libraries",
                            h3("Library Directory"),
                            dataTableOutput("lib_dir")
                   ),
                   tabPanel("Museums",
                            h3("Museum Directory"),
                            dataTableOutput("museum_dir")
                   ),
                   tabPanel("Restaurants",
                            h3("Restaurant Directory"),
                            dataTableOutput("res_dir"))
        )
      ) # tabitem - directory
    )
  )
)
