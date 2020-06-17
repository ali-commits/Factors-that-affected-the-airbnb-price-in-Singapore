#Team Members:

# 17220389	Kumarmangal Roy
# 17006969	Prabavathi Papa Rao
# 17220137	ADEDIGBA STEPHEN OLAMILEKAN
# 17219152	Ali Alrabeei
# 17044032	Kaveenaasvini Chandran
# 17219523	Ng See Kiat


library('data.table')
library('readr')
library('dplyr')
library('tidyr')
library('stringr')
library('rlist')
library('Hmisc')

# Please update to current directory
setwd("C:/Users/royku/Sem I Modules/WQD7004-Programming for DS/Project")

# Loading Overwatch data from Kaggle
SGAIRBNB <- read.csv("Raw_data_set.csv")

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

# Checking if one row is identical to another
distinctdata <- distinct(SGAIRBNB)
nrow(SGAIRBNB)

# The dataset of distinct values has the same number of rows as the original, meaning there are no duplicates!
nrow(distinctdata)

#Price parameter is being compare based on grouping of room_type
library('psych') 
describeBy(SGAIRBNB$price, group = SGAIRBNB$room_type)

write.csv(SGAIRBNB,'SGAIRBNB.csv')






