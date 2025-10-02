print('start load dataset prep')
# Load required packages
source("../1-raw-data/loading-packages.R")

# Load imdb dataset
imdb_analysis <- read_csv("../../data/clean/imdb_enriched.csv")
print('dataset loaded')

# Transformations
print('start transformation prep')
# Create quadratic votes term
imdb_analysis <- imdb_analysis %>%
  mutate(votes2 = numVotes^2)

# Log transform to deal with skewed data
imdb_analysis <- imdb_analysis %>%
  mutate(
    log_votes = log1p(numVotes),
    log_votes2 = log_votes^2
  )

# Create period variable
imdb_analysis <- imdb_analysis %>%
  mutate(period = case_when(
    startYear <= 1925 ~ "Pre-War",
    startYear <= 1960 ~ "Interwar",
    startYear <= 1995 ~ "Post-War",
    startYear >  1995 ~ "Modern",
    TRUE ~ NA_character_
  ))

# Create rating groups
imdb_analysis <- imdb_analysis %>%
  mutate(rating_category = cut(
    averageRating,
    breaks = seq(0, 10, by = 2),  
    labels = c("Very Bad", "Bad", "Average", "Good", "Excellent"),
    include.lowest = TRUE,
    right = TRUE                   
  ))

imdb_analysis <- imdb_analysis %>% 
  mutate(rating_category = factor(
    rating_category,
    levels = c("Very Bad", "Bad", "Average", "Good", "Excellent"),
    ordered = TRUE
  ))
print('transformation prep done')

# Output
write_csv(imdb_analysis, "../../data/clean/imdb_analysis.csv")
write_rds(imdb_analysis, "../../data/clean/imdb_analysis.rds")
print('output prep added')