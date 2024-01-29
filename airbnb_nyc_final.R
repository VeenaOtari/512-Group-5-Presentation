# Loading pre-installed libraries
library(readr)
library(tidyverse)
library(dplyr)
library(ggplot2)

# Setting work directory
setwd("C:\\Users\\DELL\\Downloads\\MBusAn\\R programming")

# Reading data from CSV
data <- read_csv("new_york_listings_2024.csv")

# Creating a dataframe
data_df <- data.frame(data)

## Data Cleaning

# Removing "name" column
data_df <- data_df %>% select(-name)

# Adding surrogate key
data_df$s_id <- seq(1, nrow(data_df)) 

# Specify columns to be processed
columns_to_process <- c("rating", "bedrooms", "baths")

# Loop through specified columns
for (col in columns_to_process) {
  # Check if the current column contains character data
  if (is.character(data_df[[col]])) {
    # Convert 'Studio' to 0, and replace 'No rating' and 'New' with NA in character columns
    data_df[[col]] <- ifelse(data_df[[col]] == "Studio", 0, data_df[[col]])
    data_df[[col]] <- ifelse(data_df[[col]] == "No rating"|data_df[[col]] == "New", NA, data_df[[col]])
    # Convert the column to numeric
    data_df[[col]] <- as.numeric(as.character(data_df[[col]]))
  }
}

str(data_df)

## Analysis

# Q1 - What is the overall distribution of listing prices in New York?

# 1. The average price per night for all the listings.
mean(data_df$price, na.rm = TRUE)      

# 2. The median price per night for all the listings
median(data_df$price, na.rm = TRUE)     

# 3. The standard deviation of listing price
sd(data_df$price)

# 4. The mode price (most common price) per night for all the listings
get_mode <- function(v) {
  unique_value <- unique(v)
  unique_value[which.max(tabulate(match(v, unique_value)))]
}
get_mode(data_df$price)                 

# 5. The quantile distribution of the price
quantile(data_df$price, na.rm = FALSE)

# 6. The interquartile range
IQR(data_df$price)


# 7. Visualization of the distribution of listing prices using a scatter plot
ggplot(data = data_df, aes(x = s_id, y = price)) +
  geom_point() +
  labs(title = "New York Airbnb Listing Prices",
       x = "Listing ID",
       y = "Listing Price") +
  theme_minimal()


# Q2 - How many listings are available per neighbourhood group?
neighbourhood_group_counts <- table(data_df$neighbourhood_group)
print(neighbourhood_group_counts)

# Function to get the mode of categorical values 
get_mode <- function(v) {
  unique_value <- unique(v)
  unique_value[which.max(tabulate(match(v, unique_value)))]
}
get_mode(data_df$neighbourhood_group)

# Create a bar chart of neighbourhood_group 
counts <- data_df %>% 
  group_by(neighbourhood_group) %>% 
  summarise(Count = n())  %>%
  arrange(desc(Count))
counts$neighbourhood_group <- factor(counts$neighbourhood_group, levels =counts$neighbourhood_group)


ggplot(counts, aes(x = neighbourhood_group, y = Count, fill = neighbourhood_group)) + 
  geom_bar(stat = "identity") + 
  labs(title = "Airbnb Listings by NY borough", 
       x = "NY borough", 
       y = "Total Number of Listings") +
  theme_minimal()

# Plotting with counts for Top10 neighbourhood
neighbourhood_counts <- data_df %>%
  group_by(neighbourhood) %>%
  summarise(Count = n()) %>%
  arrange(desc(Count)) %>%
  slice_head(n = 10)  # Select the top 10 neighbourhoods

ggplot(neighbourhood_counts, aes(x = reorder(neighbourhood, -Count), y = Count, fill = neighbourhood)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 10 Neighborhoods by Number of Airbnb Listings", 
       x = "Neighborhood", 
       y = "Number of Listings") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Q3 - Does the number of Airbnb listings in New York's boroughs, 
# as a measure of their popularity, correlate with the price of Airbnb listings in those boroughs?

# 1. Calculate popularity (here using the number of listings as proxy) and average_price and create a new data frame  
analysis_df <- data_df %>% 
  group_by(neighbourhood_group) %>% 
  summarise( 
    popularity = n(), 
    average_price = mean(price, na.rm = TRUE) 
  ) 

# 2. Visualize the relationship between popularity and average price
ggplot(analysis_df, aes(x = popularity, y = average_price)) +  
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE, color = "red") + 
  geom_text(aes(label = neighbourhood_group, group = neighbourhood_group), vjust = 1, color = "blue", hjust = 1.1, check_overlap = TRUE) +
  labs(title = "Popularity vs Average Price in Neighbourhood Groups", 
       x = "Popularity (Number of Listings)", 
       y = "Average Price") +
  theme_minimal()

# 3. Calculate and display the correlation coefficient and linear regression model
cor_r <- cor(analysis_df$popularity, analysis_df$average_price)
cat("Coefficient of Correlation:", cor_r, "\n")
linear_m <- lm(average_price ~ popularity, data = analysis_df)
summary(linear_m)



# Q4 - What is the average price of listings by the number of bedrooms?

# Convert bedrooms to numeric if needed
data_df$bedrooms <- as.numeric(as.character(data_df$bedrooms))

# Calculate average price by bedrooms
average_price_by_bedrooms <- aggregate(price ~ bedrooms, data = data_df, FUN = mean, na.rm = TRUE)
print(average_price_by_bedrooms)

# Calculate the correlation coefficient
correlation_coefficient <- cor(average_price_by_bedrooms$bedrooms, average_price_by_bedrooms$price)
cat("Coefficient of Correlation:", correlation_coefficient, "\n")

# Fit a linear regression model
linear_model <- lm(price ~ bedrooms, data = average_price_by_bedrooms)
summary_linear_model <- summary(linear_model)

# Extract and print the p-value and R squared value
p_value <- format(summary_linear_model$coefficients[2,4], scientific = TRUE, digits = 5)
r_squared <- summary_linear_model$r.squared

cat("P-value:", p_value, "\n")
cat("R squared value:", r_squared, "\n")

# Display the linear regression equation
cat("Linear Regression Equation: Price =", coef(linear_model)[1], "+", coef(linear_model)[2], "* Bedrooms", "\n")

# Plot the data and the linear regression line
ggplot(average_price_by_bedrooms, aes(x = bedrooms, y = price)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Average Price of Listings by Number of Bedrooms",
       x = "Number of Bedrooms",
       y = "Average Price") +
  theme_minimal()


