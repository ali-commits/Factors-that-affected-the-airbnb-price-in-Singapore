library(shiny)
library(shinydashboard)
library(DT)
library(data.table)
library(plotly)
library(leaflet)
library(readr)
library(googleVis)

library('ggmap')
library('sf')
library('mapview')

# NYC <- read_csv("~/Downloads/new-york-city-airbnb-open-data/AB_NYC_2019.csv", 
#                                col_types = cols(host_id = col_skip(), 
#                                                 id = col_skip()))
SGSIN <- read_csv("singapore-Airbnb-final.csv", 
                col_types = cols(
                  # host_id = col_skip(), 
                  # host_name = col_skip(), 
                                 id = col_skip(), 
                  # latitude = col_number(), 
                  # longitude = col_number(), 
                                 price = col_number()))
rownames(SGSIN) <- NULL
choice <- colnames(SGSIN)
borough_choice <- unique(SGSIN$neighbourhood_group)
neighbor_choice <- unique(SGSIN$neighbourhood)
room_choice <- unique(SGSIN$room_type)




data <- SGSIN
# clean up the data 
processed_data <- dplyr::filter(data, 
                                # remove if the price is less than 0
                                data$price > 0,
                                # remove if the availability is less than 0
                                data$availability_365 > 0,
                                # remove if the last_review is empty
                                !is.na(data$last_review)
)


# for all region
allregionhost <- processed_data %>% 
  dplyr::group_by(host_id, host_name) %>% 
  dplyr::count() %>% 
  dplyr::arrange(dplyr::desc(n))

top_host_in_all_region <- dplyr::top_n(allregionhost, n>100)
# show the host list who hosted more than 100 units in SG airbnb
#####################################################################
# to run airbnb as business, choose a good location is the top strategy,
# find out this host, apparently these ppl know what they are doing.
# and we are following their movement.
#####################################################################

data_for_display <- data.frame(name=processed_data$name,
                               hostid=processed_data$host_id,
                               hostname=processed_data$host_name,
                               lon=processed_data$longitude,
                               lat=processed_data$latitude)
# only show the top host
data_for_display <- data_for_display[data_for_display$hostid == top_host_in_all_region$host_id,]



# convert to tibble
data_locations <- tidyr::as_tibble(data_for_display)

# convert to sf (simple feature format)
# longitude and latitude to be plotted using the World Geographic System 1984 projection, 
# which is referenced as European Petroleum Survey Group (EPSG) 4326
data_locations_sf <- sf::st_as_sf(data_locations, coords = c("lon", "lat"), crs = 4326)
#str(data_locations_sf)
data_locations_sf$hostname <- as.character(data_locations_sf$hostname)
#str(data_locations_sf)
#head(data_locations_sf)
as.factor(data_locations_sf$hostname)
#####################################################
# FINDINGS : now we see the top host are posting their unit in central region
# that means, if you are going to start airbnb in SG, choose an area around the dot.
#####################################################