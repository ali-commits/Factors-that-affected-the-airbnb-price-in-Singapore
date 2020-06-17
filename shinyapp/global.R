library(shiny)
library(shinydashboard)
library(DT)
library(data.table)
library(plotly)
library(leaflet)
library(readr)
library(googleVis)
# NYC <- read_csv("~/Downloads/new-york-city-airbnb-open-data/AB_NYC_2019.csv", 
#                                col_types = cols(host_id = col_skip(), 
#                                                 id = col_skip()))
SGSIN <- read_csv("../singapore-Airbnb-final.csv", 
                col_types = cols(host_id = col_skip(), 
                                 host_name = col_skip(), id = col_skip(), 
                                 latitude = col_number(), longitude = col_number(), 
                                 price = col_number()))
rownames(SGSIN) <- NULL
choice <- colnames(SGSIN)
borough_choice <- unique(SGSIN$neighbourhood_group)
neighbor_choice <- unique(SGSIN$neighbourhood)
room_choice <- unique(SGSIN$room_type)