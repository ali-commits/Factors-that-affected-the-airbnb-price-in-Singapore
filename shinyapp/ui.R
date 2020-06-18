#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shinythemes)
shinyUI(dashboardPage(
  dashboardHeader(title = "Airbnb"),
  dashboardSidebar(
    sidebarUserPanel("Airbnb Singapore", image = "https://fintechnews.sg/wp-content/uploads/2019/10/Smart-Cities-AI-Singapore-1440x564_c.jpg"),
    sidebarMenu(
      menuItem("Intro", tabName = "intro", icon = icon("image")),
      menuItem("Map", tabName = "map", icon = icon("map")),
      menuItem("Bar Plot", tabName = "plot1", icon = icon("chart-bar")),
      menuItem("Price Chart", tabName = "price", icon = icon("chart-line")),
      menuItem("Data", tabName = "data", icon = icon("database")),
      menuItem("Top 3 Host", tabName = "mapview", icon = icon("database")),
      menuItem("About Group", tabName = "Group", icon = icon("user-circle")))
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "intro",
              HTML('<img src="https://fintechnews.sg/wp-content/uploads/2019/10/Smart-Cities-AI-Singapore-1440x564_c.jpg?auto=compress&cs=tinysrgb&h=750&w=1260" width=500 height=700>')
      ),
      
      tabItem(tabName = "map",
              fluidPage(
                
                box(
                  
                  title = "listing based on search",
                  leafletOutput("map"),
                  selectizeInput("selected0",
                                 "Select Item to Display",
                                 unique(SGSIN$neighbourhood_group)),
                  
                  selectizeInput("selected1",
                                 "Select Item to Display",
                                 unique(SGSIN$neighbourhood)),
                  
                  selectizeInput("selected2",
                                 "Select Item to Display",
                                 unique(SGSIN$room_type))),
                box(
                  title = "Frquency of room types based on Price",
                  plotOutput("plotmap"),
                  dataTableOutput('table1')
                ))),
      
      tabItem(tabName = "price",
              tabsetPanel(type= "tabs",
                          tabPanel("Borough",
                                   fluidRow(
                                     plotOutput('plot2'),
                                     box(
                                       sliderInput("selected6",
                                                   "Pick minimum nights",
                                                   min = 1, max = 1250, value = c(1,1250))
                                     )
                                   )
                          ),
                          tabPanel("Neighborhood",
                                   fluidRow(
                                     plotOutput('plot3'),
                                     box(
                                       selectizeInput("selected7",
                                                      "Select Borough",
                                                      unique(SGSIN$neighbourhood_group)),
                                       sliderInput("selected5",
                                                   "Pick minimum nights",
                                                   min = 1, max = 1250, value = c(1,1250))
                                     )
                                   ))
                          
              )),
      
      tabItem(tabName = "plot1",
              fluidRow(
                # box(
                plotOutput('plot1'),
                box(sliderInput("selected3",
                                "Pick a price range", pre = "$",
                                min=1, max= 10000, value = c(1, 10000)),
                    sliderInput("selected4",
                                "Pick minimum nights",
                                min = 1, max = 1250, value = c(1,1250))
                )
                
              )),
      
      tabItem(tabName = "data",
              fluidPage(dataTableOutput('table')
              )),
      tabItem(tabName = "mapview",
              fluidPage(
                sidebarPanel(
                  h3(strong("Objective :")),
                  h4("Show the host list who hosted more than 100 units in SG airbnb."),
                  h3(strong("Motivation :")),
                  h4("To run airbnb as business, choose a good location is the top strategy, find out these hosts, apparently these people know what they are doing. And we are following their movement."),
                  h3(strong("Finding :")),
                  h4("The map showing top hosts focusing their business in certain areas, that means, if we were to start airbnb in SG, we could just need to look for cluster units of these 'top hosts'."),
                  h6(""),
                  h4("For example, Balestier, Geylang, and Tanjong Pagar are all good spots.")
                ),
                mainPanel(leaflet::leafletOutput("mapplot"))
              )),
      tabItem(tabName = "Group",
              fluidPage(
                h4("Prabavathi WQD 180030", br(),
                   "ADEDIGBA STEPHEN OLAMILEKAN 17220137", br(),
                    "Ali Alrabeei 17219152",
                    "Kaveenaasvini WQD 180017",br(),
                    "Ng see kiat 17219523", br(),
                    "Kumarmangal Roy 17220389", br()),
                h4(a(icon= icon("github"),"Github Link", href="https://github.com/kroy69/Factors-that-affected-the-airbnb-price-in-Singapore/blob/master/Group2.R"))
                
              )
              
              
              
      )
    ))))