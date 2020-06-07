library(dplyr)

# read raw data from github master branch
data <- read.csv('https://raw.githubusercontent.com/newaaa41/Factors-that-affected-the-airbnb-price-in-Singapore/master/Raw_data_set.csv')

data <- tbl_df(data) # convert to local data frame (same as R DataFrame but with better printing)

print(data)
###############################################################################################

# replace empty strings in data$last_review with NaN


data$last_review %>% lapply( function(x){   
                                  if(x == '') {return(NaN)} 
                                  else {return(x)}  
                                        }) -> data$last_review


is.na(data) %>% colSums() #check na values

###############################################################################################

# filter usable data

data %>% filter(  
                data$price > 0, # remove if the price is less than 0
                data$availability_365 > 0, # remove if the availability is less than 0
                data$price < 1000  # remove if price is more the 1000
                ) -> filterd_data 

                            
print(filterd_data)


filterd_data %>% filter(
                        !is.na(filterd_data$last_review) # remove if there is no reviews 
                        ) -> reviews_only_data

print(reviews_only_data)


filterd_data %>% filter(
                        is.na(filterd_data$last_review) # remove if there is no reviews 
                        ) -> no_reviews_data

print(no_reviews_data)

