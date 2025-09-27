# In this directory, you will keep all source code files relevant for 
# preparing/cleaning your data.
source("loading-packages.R")

# read sample files
basics_path  <- "src/data/title.basics.tsv.gz"
ratings_path <- "src/data/title.ratings.tsv.gz"

basics  <- read_tsv(basics_path,  na = "\\N",
                    col_select = c(tconst, titleType, startYear, genres),
                    show_col_types = FALSE)

ratings <- read_tsv(ratings_path, na = "\\N",
                    col_select = c(tconst, averageRating, numVotes),
                    show_col_types = FALSE)

# TRANSFORMATION
# Merge on tconst
imdb_raw <- basics %>%
  inner_join(ratings, by = "tconst")

# type casting and selection of relevant title types
imdb_raw <- imdb_raw %>%
  mutate(
    startYear = suppressWarnings(as.integer(startYear)),
    type = if_else(titleType %in% c("movie", "tvMovie"), "movie",
                   if_else(titleType %in% c("tvSeries", "tvMiniSeries"), "series", "other"))
  ) %>%
  filter(type %in% c("movie", "series"))

# remove duplicates 
imdb_dedup <- imdb_raw %>%
  distinct(tconst, .keep_all = TRUE)

# filter out the noise 
imdb_clean <- imdb_dedup %>%
  filter(numVotes >= 1000)

# Feature engineering: genre_family
genre_map <- imdb_clean %>%
  filter(!is.na(genres), genres != "") %>%
  select(tconst, genres) %>%
  separate_rows(genres, sep = ",") %>%
  mutate(fam = case_when(
    genres %in% c("Fantasy","Comedy","Romance","Action","Adventure","Animation","Family") ~ "Escapist",
    genres %in% c("Drama","Thriller","Biography","Crime","Documentary") ~ "Heavy",
    TRUE ~ NA_character_
  )) %>%
  group_by(tconst) %>%
  summarise(
    genre_family = case_when(
      all(is.na(fam))               ~ NA_character_,
      n_distinct(na.omit(fam)) == 1 ~ first(na.omit(fam)),
      n_distinct(na.omit(fam)) >  1 ~ "Gemixt"
    ),
    .groups = "drop"
  )

# merge with extra features
imdb_enriched <- imdb_clean %>%
  left_join(genre_map, by = "tconst") %>%
  select(tconst, titleType, type, startYear, genres, genre_family,
         averageRating, numVotes)

# OUTPUT
dir.create("data/clean", showWarnings = FALSE, recursive = TRUE)

write_csv(imdb_clean,    "data/clean/imdb_clean.csv")
write_rds(imdb_clean,    "data/clean/imdb_clean.rds")

write_csv(imdb_enriched, "data/clean/imdb_enriched.csv")
write_rds(imdb_enriched, "data/clean/imdb_enriched.rds")
