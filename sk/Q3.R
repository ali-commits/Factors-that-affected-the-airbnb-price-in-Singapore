library(dplyr)

# check the working directory
setwd('D:/Workspace/toitoi/Factors-that-affected-the-airbnb-price-in-Singapore/sk')

# read the file
data <- read.csv("singapore-Airbnb.csv")
nrow(data)

# clean up the data 
processed_data <- dplyr::filter(data, 
                                # remove if the price is less than 0
                                data$price > 0,
                                # remove if the availability is less than 0
                                data$availability_365 > 0,
                                # remove if the last_review is empty
                                !is.na(data$last_review)
                              )

# check the file 
head(processed_data)
colnames(processed_data)
nrow(processed_data)

# Q3 : where is the most demanding area in Central Region?
# we dont have the past transaction

# group by region (neighbourhood_group)

# first check how many region
processed_data$neighbourhood_group[!duplicated(processed_data$neighbourhood_group)]

# north region dataset
data_north_region <- processed_data %>% dplyr::filter(processed_data$neighbourhood_group == "North Region")
typeof(data_north_region)
head(data_north_region)
# get the 5 number summary
fivenum(data_north_region$price)

# central region dataset
data_central_region <- dplyr::filter(processed_data, processed_data$neighbourhood_group == "Central Region")
typeof(data_central_region)
head(data_central_region)
# get the 5 number summary
fivenum(data_central_region$price)

# east region dataset
data_east_region <- dplyr::filter(processed_data, processed_data$neighbourhood_group == "East Region")
#typeof(data_east_region)
#head(data_east_region)
# get the 5 number summary
fivenum(data_east_region$price)

# west region dataset
data_west_region <- dplyr::filter(processed_data, processed_data$neighbourhood_group == "West Region")
#typeof(data_west_region)
#head(data_west_region)
# get the 5 number summary
fivenum(data_west_region$price)

# north east region dataset
data_north_east_region <- dplyr::filter(processed_data, processed_data$neighbourhood_group == "North-East Region")
#typeof(data_north_east_region)
#head(data_north_east_region)
# get the 5 number summary
fivenum(data_north_east_region$price)


# Q : find out who get more money from the hosting activities ? 
# we dont have transactions...

# Q : top 3 host name with the most unit listed (by Central region)...
data_central_region %>% group_by(host_id, host_name) %>% count() %>% arrange(desc(n))

# for all region
processed_data %>% group_by(host_id, host_name) %>% count() %>% arrange(desc(n))


