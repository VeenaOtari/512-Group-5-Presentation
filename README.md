# Airbnb New York Listings Dataset

## Overview

This dataset is used for the MBUA512 Databases and Analytics Group Presentation, which provides information on the most recent Airbnb listing activity in New York City as of January 5th, 2024. The dataset contains a variety of information, including geographical coordinates, room kinds, pricing, ratings, and more.
## Context

Airbnb, Inc., established in 2008, runs an online marketplace for short- and long-term homestays and activities. Originally called AirBedandBreakfast.com, the company has evolved to be a major participant in the hotel industry. This dataset shines light on New York City Airbnb listings, providing useful data for trend research and comprehension.

## Content

The dataset includes the following key columns:

- `id` (numeric): Unique identifier for each listing.
- `host_id` (numeric): Unique identifier for each host.
- `host_name` (character): Name of the host.
- `neighbourhood_group` (character): The borough or area in New York City.
- `neighbourhood` (character): Specific neighbourhood within the borough.
- `latitude` (numeric): Latitude coordinates of the listing.
- `longitude` (numeric): Longitude coordinates of the listing.
- `room_type` (character): Type of room (e.g., Private room, Entire home/apt).
- `price` (numeric): Listing price.
- `minimum_nights` (numeric): Minimum number of nights required for booking.
- `number_of_reviews` (numeric): Total number of reviews received.
- `last_review` (Date): Date of the last review.
- `reviews_per_month` (numeric): Average number of reviews received per month.
- `calculated_host_listings_count` (numeric): Count of listings by the host.
- `availability_365` (numeric): Number of days the listing is available in a year.
- `number_of_reviews_ltm` (numeric): Number of reviews in the last twelve months.
- `license` (character): Licensing status of the listing.
- `rating` (numeric): Average rating of the listing.
- `bedrooms` (numeric): Number of bedrooms in the listing.
- `beds` (numeric): Number of beds in the listing.
- `baths` (numeric): Number of bathrooms in the listing.
- `s_id` (integer): Sequential identifier.

## Acknowledgements

The dataset is sourced from Kaggle (https://www.kaggle.com/datasets/vrindakallu/new-york-dataset), modified from the original dataset (http://insideairbnb.com/get-the-data/) by adding columns such as ratings, bedrooms, beds, and baths, and removing null values.

## Data Analysis

The dataset has been used for data analysis, including the exploration of the impact of the number of bedrooms on Airbnb listing prices. The analysis involved calculating correlation coefficients, p-values, R-squared values, and creating visualizations.

## Important Note

This README serves as a guide to understanding the dataset and its context. For detailed analyses and code implementation, refer to the associated scripts and documentation provided in the project.
