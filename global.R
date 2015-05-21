# global.r

library(shiny)
require(rCharts)
library(ggplot2)
library(RCurl)
library(jsonlite)
library(lubridate)
library(dplyr)

# Create url to read from
food_url <- getURLContent("http://api.fda.gov/food/enforcement.json?search=report_date:[20040101+TO+20131231]&limit=100")

# Parse the url in json data format
food_js_url <- fromJSON(food_url, simplifyVector=TRUE)

# Extract data contained in "results" in a data frame
tmp_f_df <-food_js_url[["results"]]

# Remove the columns not required
food_df <- select(tmp_f_df, -contains("@"), -reason_for_recall, -code_info, -openfda, -initial_firm_notification, -distribution_pattern, -country)

# Parse the date vaiables
food_df$recall_initiation_date <- ymd(food_df$recall_initiation_date)
food_df$report_date <- ymd(food_df$report_date)

# Change classification variable to ordered factor
food_df$classification <- factor(food_df$classification, levels = c("Class I", "Class II", "Class III"))