# In this directory, you will keep all source code files relevant for 
# preparing/cleaning your data.

library(dplyr)
library(tidyr)
library(tidyr)
library(ggplot2)

# merge basics and ratings
imdb <- inner_join(basics, ratings, by = "tconst")

# exploration of main question
imdb_all <- imdb %>% filter(numVotes >= 1000)

cor(imdb_all$numVotes, imdb_all$averageRating, use="complete.obs")

ggplot(imdb_all, aes(x=log10(numVotes), y=averageRating)) +
  geom_point(alpha=.2) +
  geom_smooth(method="lm") +
  labs(title="Votes vs Average Rating (All Titles)",
       x="log10(Number of Votes)", y="Average Rating")

# exploration of sub question 1
## Map to genre families
movies_fam <- imdb %>%
  filter(titleType=="movie", numVotes>=1000, !is.na(genres)) %>%
  select(tconst, genres, averageRating, numVotes) %>%
  separate_rows(genres, sep=",") %>%
  mutate(fam = case_when(
    genres %in% c("Fantasy","Comedy","Romance") ~ "Escapist",
    genres %in% c("Drama","Thriller")           ~ "Heavy",
    TRUE ~ NA_character_
  )) %>%
  filter(!is.na(fam)) %>%
  group_by(tconst) %>%
  summarise(
    genre_family = ifelse(n_distinct(fam)==1, first(fam), NA_character_),
    averageRating = first(averageRating),
    numVotes = first(numVotes),
    .groups="drop"
  ) %>%
  filter(!is.na(genre_family))

## Correlation per family (short table)
movies_fam %>%
  group_by(genre_family) %>%
  summarise(cor_votes_rating = cor(numVotes, averageRating, use="complete.obs"),
            n=n(), .groups="drop")

## Plot
ggplot(movies_fam, aes(x=log10(numVotes), y=averageRating, color=genre_family)) +
  geom_point(alpha=.3) +
  geom_smooth(method="lm") +
  labs(title="Votes vs Rating by Genre Family (Movies)",
       x="log10(Number of Votes)", y="Average Rating", color="Genre Family")

# exploration of sub question 2
imdb_types <- imdb %>%
  filter(titleType %in% c("movie","tvSeries","tvMiniSeries"), numVotes>=1000) %>%
  mutate(type = ifelse(titleType=="movie","movie","series"))

## Correlation per type
imdb_types %>%
  group_by(type) %>%
  summarise(cor_votes_rating = cor(numVotes, averageRating, use="complete.obs"),
            n=n(), .groups="drop")

## Plot
ggplot(imdb_types, aes(x=log10(numVotes), y=averageRating, color=type)) +
  geom_point(alpha=.3) +
  geom_smooth(method="lm") +
  labs(title="Votes vs Rating by Content Form",
       x="log10(Number of Votes)", y="Average Rating", color="Content form")
