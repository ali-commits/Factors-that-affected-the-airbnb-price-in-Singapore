library('data.table')
library('readr')
library('dplyr')
library('tidyr')
library('stringr')
library('rlist')
library('Hmisc')


# Please update to current directory
# setwd("C:/Users/royku/Sem I Modules/WQD7004-Programming for DS/Project")

# Loading Overwatch data from github
SGAIRBNB <- read.csv("https://raw.githubusercontent.com/newaaa41/Factors-that-affected-the-airbnb-price-in-Singapore/master/Raw_data_set.csv")

#Shows strc dbl -> double (for double precision floating point numbers)
glimpse(SGAIRBNB)

dim(SGAIRBNB) #df has 7907*16

# show the Five-number summary
summary(SGAIRBNB)

#Shows Elaborate description for Categoriacal Variable (HMISC)
describe(SGAIRBNB)


###############################################################
##################### METADATA : START ########################
###############################################################
#id - Generic ID Column.
#name - Generic Property Name
#host_id - Generic Host ID Column
#host_name -  Generic Host Name
#neighbourhood_group - part/regioin of the city
#neighbourhood - name of the area of the city
#latitude - dictionary meaning
#longitude - dictionary meaning
#room type - classification of available room in the property listed
#price - price per room per night in SGD
#minimum_nights - minimum number of nights property being booked
#number_of_reviews - total number of reviews
#last_review - date of last review
#reviews_per_month - % of reviews received per month
#calculated_host_listings_count - total number of unique property ID's registered per host
#availability_365 - no of days property available for rent
###############################################################
##################### METADATA : END ##########################
###############################################################


# Check missingness
colMeans(is.na(SGAIRBNB))

sum(is.na(SGAIRBNB$reviews_per_month))
#we have got 2758 missing values
#its not logical to impute so many values so we are dropping the parameter
#Removing a column

SGAIRBNB <- select(SGAIRBNB, -reviews_per_month)

unique(SGAIRBNB$neighbourhood) #there are 43 specific area in the city 
unique(SGAIRBNB$neighbourhood_group) #mapped to 5 broader regions
unique(SGAIRBNB$room_type) #3 type of rental available

summary(SGAIRBNB$price) #0 price is not possible for any property
sum(SGAIRBNB$price == 0) #Removing only 1 data point
SGAIRBNB <- subset(SGAIRBNB,SGAIRBNB$price != 0)

########

str(SGAIRBNB)

#There are some wrong data type that we need to change it into corect type, and save it into new object 'airbnb'
#converting ids into factor
SGAIRBNB$id <- as.factor(SGAIRBNB$id)
SGAIRBNB$host_id <- as.factor(SGAIRBNB$host_id)
SGAIRBNB$neighbourhood_group <- as.factor(SGAIRBNB$neighbourhood_group)
SGAIRBNB$neighbourhood <- as.factor(SGAIRBNB$neighbourhood)
SGAIRBNB$room_type <- as.factor(SGAIRBNB$room_type)
str(SGAIRBNB)


# Checking the distribution of a column
# No apparent problem in the distribution of season, noting a downward trend in records as time increases though
hist(SGAIRBNB$availability_365)

# You should make a log version of a variable fi your histogram/density plot looks something like this:
price = rlnorm(500,1,.6)
hist(price)


# Checking if one row is identical to another
distinctdata <- distinct(SGAIRBNB)
nrow(SGAIRBNB)

# The dataset of distinct values has the same number of rows as the original, meaning there are no duplicates!
nrow(distinctdata)

write.csv(SGAIRBNB,'SGAIRBNB.csv')

#############################################
################# Question ##################
#############################################
#What is the most demanding type for staying in Singapore?
#Calcuting most occuring price-value across all properties

b <- boxplot(SGAIRBNB$price,
        main = "Price Spread of AIRBNB Properties across SG",
        xlab = "Price Spread",
        col = "Yellow",
        border = "Red",
        horizontal = TRUE,
        notch = TRUE)

#This provide us with the upper extreme and lower extreme
#As we can see from the graph, there are many data points which are out of the box.
#We are not taking out those data points
#We are checking for the most common price for properties

library('psych') 
describeBy(SGAIRBNB$price, group = SGAIRBNB$room_type)

#Creating mode function to get the common value

fun_mode <- function(x) {
  uniqx <- unique(x)
  uniqx[which.max(tabulate(match(x, uniqx)))]
}

fun_mode(SGAIRBNB$price) 
#60 sgd is d most common pricing

demand<-filter(SGAIRBNB, price == 60)
fun_mode(demand$room_type) #Private Room is the most demanding type of property based on price

qplot(room_type,data = demand, color = room_type)


#############################################
################# Question ##################
#############################################

#Most demanding area in the Central Region?
library('treemap')
demand1<-filter(SGAIRBNB, neighbourhood_group == "Central Region")
mean(demand1$price) #176.65

#Checking areas which are near about the range of average prices
demand2<-filter(demand1, price >= 150 & price <= 200)
fun_mode(demand1$neighbourhood)

qplot(neighbourhood,data = demand1, color = room_type)
#Based on price
treemap(demand1, index = "neighbourhood", vSize = "price", type = "index")
#Based on minimum_nights
treemap(demand, index = "neighbourhood", vSize = "minimum_nights", type = "index")

#############################################
################# Question ##################
#############################################

library('viridisLite')
library('viridis')
library('ggplot2')
library('plotly')

#Which area with most populated for high rental cost?
options(scipen = 88)
Plot_density <- SGAIRBNB %>% 
  select(price, neighbourhood_group) %>% 
  ggplot(aes(price, fill = neighbourhood_group, col = neighbourhood_group))+
  geom_density (alpha = 0.5, round=2) +
  scale_fill_viridis(discrete = TRUE)+
  scale_color_viridis(discrete = TRUE)+
  geom_vline(aes(xintercept=mean(price, na.rm=T)),   
             color="red", linetype="dashed", size=1)+
  theme(text = element_text(size = 12))+
  scale_x_continuous(limits = c(0,800), breaks = seq(0,800,100))+
  labs(x="Price", y = NULL)

Plot_density

ggplotly(Plot_density, tooltip = "y")


#############################################
################# Question ##################
#############################################

data <- SGAIRBNB
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
    group_by(host_id, host_name) %>% 
    count() %>% 
    arrange(desc(n))

top_host_in_all_region <- top_n(allregionhost, n>100)
# show the host list who hosted more than 100 units in SG airbnb
top_host_in_all_region
#####################################################################
# to run airbnb as business, choose a good location is the top strategy,
# find out this host, apparently these ppl know what they are doing.
# and we are following their movement.
#####################################################################

# plot in ggmap

head(processed_data)

data_for_display <- data.frame(name=processed_data$name,
                               hostid=processed_data$host_id,
                               hostname=processed_data$host_name,
                               lon=processed_data$longitude,
                               lat=processed_data$latitude)
head(data_for_display)
# only show the top host
data_for_display <- data_for_display[data_for_display$hostid == top_host_in_all_region$host_id,]
head(data_for_display)

library(ggmap)
library(sf)
library(mapview)

# convert to tibble
data_locations <- as_tibble(data_for_display)
head(data_locations)

# convert to sf (simple feature format)
# longitude and latitude to be plotted using the World Geographic System 1984 projection, 
# which is referenced as European Petroleum Survey Group (EPSG) 4326
data_locations_sf <- st_as_sf(data_locations, coords = c("lon", "lat"), crs = 4326)
str(data_locations_sf)
data_locations_sf$hostname <- as.character(data_locations_sf$hostname)
str(data_locations_sf)
head(data_locations_sf)
as.factor(data_locations_sf$hostname)
# show the map view
mapview(data_locations_sf,
        zcol = "hostname",
        legend = T,
        legend.opacity = 0.5,
        layer.name = 'Host Name'
)
#####################################################
# FINDINGS : now we see the top host are posting their unit in central region
# that means, if you are going to start airbnb in SG, choose an area around the dot.
#####################################################


