print('start load dataset prep')
# Load required packages
source("../1-raw-data/loading-packages.R")

# Load imdb dataset
imdb_analysis <- read_csv("../../data/clean/imdb_enriched.csv")
print('dataset loaded')

#Create quadratic votes term
imdb_analysis <- imdb_analysis %>%
  mutate(votes2 = numVotes^2)

#Log transform to deal with skewed data
imdb_analysis <- imdb_analysis %>%
  mutate(
    log_votes = log1p(numVotes),
    log_votes2 = log_votes^2)

#Create period variable
"Create a variable of time periods with each time period being of approximately equal length. In this way, we can control whether in certain periods certain genres were more or less popular for example"
imdb_analysis <- imdb_analysis %>%
  mutate(period = case_when(
    startYear <= 1925 ~ "Pre-War",
    startYear <= 1960 ~ "Interwar",
    startYear <= 1995 ~ "Post-War",
    startYear >  1995 ~ "Modern",
    TRUE ~ NA_character_
  ))

#Create rating groups 
"Instead of a continuous variable for ratings, we could test whether the rating category (very bad, average etc) would give insightful results, beside the regression with rating as a continuous variable. The reason is that because very often reviews are provided in number of stars on websites, and this might provide for a managerially relevant addition to the main analysis."
imdb_analysis <- imdb_analysis %>%
  mutate(rating_category = cut(
    averageRating,
    breaks = seq(0, 10, by = 2),  
    labels = c("Very Bad", "Bad", "Average", "Good", "Excellent"),
    include.lowest = TRUE,
    right = TRUE))

imdb_analysis <- imdb_analysis %>%
  mutate(rating_category = factor(rating_category, levels = c("Very Bad", "Bad", "Average", "Good", "Excellent"), ordered = TRUE))


# Output
write_csv(imdb_analysis, "../../data/clean/imdb_analysis.csv")
write_rds(imdb_analysis, "../../data/clean/imdb_analysis.rds")
print('output prep added')