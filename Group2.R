
library('data.table')
library('readr')
library('dplyr')
library('tidyr')
library('stringr')
library('rlist')
library('Hmisc')

setwd("C:/Users/royku/Sem I Modules/WQD7004-Programming for DS/Project")

# Loading Overwatch data from Kaggle
SGAIRBNB <- read.csv("singapore-Airbnb-final.csv")

glimpse(SGAIRBNB) #Shows strc dbl -> double (for double precision floating point numbers)

#str(SGAIRBNB)

dim(SGAIRBNB) #df has 7907*16

codebook(SGAIRBNB) #Forming of codebook is required
summary(SGAIRBNB)

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


# Check missingness
colMeans(is.na(SGAIRBNB))

sum(is.na(SGAIRBNB$reviews_per_month)) #we have got 2758 missing values
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

nrow(distinctdata)  # The dataset of distinct values has the same number of rows as the original, meaning there are no duplicates!


#What is the most demanding type for staying in Singapore? (But how do we evaluate demand in this context?)
#Calcuting most occuring price-value across all properties

fun_mode <- function(x) {
  uniqx <- unique(x)
  uniqx[which.max(tabulate(match(x, uniqx)))]
}

fun_mode(SGAIRBNB$price) #60 sgd is d most common pricing
demand<-filter(SGAIRBNB, price == 60)
fun_mode(demand$room_type) #Private Room is the most demanding type of property based on price



