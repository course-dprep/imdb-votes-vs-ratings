
# In this directory, you will keep all source code files relevant for 
# preparing/cleaning your data.

library(dplyr)
library(tidyr)
library(tidyr)
library(ggplot2)

# merge basics and ratings
imdb <- inner_join(sample_basics, sample_ratings, by = "tconst")

# exploration of main question
imdb_all <- imdb %>% filter(numVotes >= 1000)

cor(imdb_all$numVotes, imdb_all$averageRating, use="complete.obs")


# exploration of sub question 1
## Map to genre families
movies_fam <- imdb %>%
  filter(titleType %in% c("movie", "tvMovie", "tvSeries", "tvMiniSeries"), 
         numVotes >= 1000, !is.na(genres)) %>%
  select(tconst, genres, averageRating, numVotes) %>%
  separate_rows(genres, sep = ",") %>%
  mutate(fam = case_when(
    genres %in% c("Fantasy","Comedy","Romance","Action","Adventure", "Animation", "Family") ~ "Escapist",
    genres %in% c("Drama","Thriller","Biography", "Crime", "Documentary") ~ "Heavy",
    TRUE ~ NA_character_
  )) %>%
  filter(!is.na(fam)) %>%
  group_by(tconst) %>%
  summarise(
    genre_family = case_when(
      n_distinct(fam) == 1 ~ first(fam),
      n_distinct(fam) > 1 ~ "Gemixt"
    ),
    averageRating = first(averageRating),
    numVotes = first(numVotes),
    .groups = "drop"
  )

## Correlation per family (short table)
movies_fam %>%
  group_by(genre_family) %>%
  summarise(cor_votes_rating = cor(numVotes, averageRating, use="complete.obs"),
            n=n(), .groups="drop")

# exploration of sub question 2
imdb_types <- imdb %>%
  filter(titleType %in% c("movie", "tvMovie", "tvSeries","tvMiniSeries"), numVotes>=1000) %>%
  mutate(type = ifelse(titleType %in% c("movie", "tvMovie"),"movie","series"))

## Correlation per type
imdb_types %>%
  group_by(type) %>%
  summarise(cor_votes_rating = cor(numVotes, averageRating, use="complete.obs"),
            n=n(), .groups="drop")


# merging imdb_types and movies_fam to a complete dataset
imdb_complete <- imdb_types %>%
  select(tconst, titleType, genres, averageRating, numVotes, type) %>%  
  inner_join(
    movies_fam %>% select(tconst, genre_family),
    by = "tconst")