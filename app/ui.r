library(shiny)
library(shinyWidgets)
library(leaflet)
setwd('D:\\CUSTAT\\5243\\fall2019-proj2--sec1-grp4\\app')

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
              fluidPage(
                titlePanel("Introduction"),
                  sidebarLayout(
                    sidebarPanel(
                        h2("New York Travlers,"),
                        p("This app is made to make your New York adventure go as smooth as possible."),
                        br(),
                        img(src="newyorkmap.png", height=150, width=200),
                        br(),
                        br(),
                        "This app is a product of ",
                        em("Group 4")
                    ),
                    mainPanel(
                        h1("Introducing \"New\" Yorkers"),
                        p("When it comes to vacation, travelers are relying on their smartphones more than ever, as they are not familiar with",
                            em("where they are!"),
                            "To give a little help to those people, we made this app."),
                        br(),
                        p("We hope this app will help you feel more comfortable and relaxed in New York City."),
                        br(),
                        h2("Features"),
                        p("- Type in where you are. It will provide you the information about the great places that are near your location!"),
                        p("- The belly has no eyes! Before travelling, you must fill your belly first. This app will help you find the food that you want to have now!"),
                        p("- NYC is amazing. But still, there are some places that you won't want to visit. This app also provides the information about crimes in NYC.")
                    )
                  )#sidebarLayout
              )#fluidPage
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
                                         ),
                                tabPanel(
                                  strong("Details"), 
                                  radioButtons(inputId = "details",NULL,
                                               choices = c("Films",
                                                           "Landmarks",
                                                           "Restaurants",
                                                           "Museums",
                                                           "Libraries"),
                                               ),
                                         
                                  #plotlyOutput("satactPlot"),
                                  dataTableOutput("datatable2")
                                )
                    ),
                    position = "right"
                  )
                )
              )
              
            ), # tabitem - stat
        
            tabItem( # directory of data
              tabName = "directory"
            ) # tabitem - directory
          )
        )
      )

