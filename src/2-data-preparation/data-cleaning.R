print('start importing data for clean')
# In this directory, you will keep all source code files relevant for 
# preparing/cleaning your data.

# Load packages (subfolder-relative)
source("../1-raw-data/loading-packages.R")

# READ RAW DATA (from root-level data folder)
basics  <- read_tsv("../../data/title.basics.tsv.gz",  na = "\\N",
                    col_select = c(tconst, titleType, startYear, genres),
                    show_col_types = FALSE)

ratings <- read_tsv("../../data/title.ratings.tsv.gz", na = "\\N",
                    col_select = c(tconst, averageRating, numVotes),
                    show_col_types = FALSE)
print('imported data for clean')

# TRANSFORMATION
print('start transformation clean')
# Merge datasets on tconst
imdb_raw <- basics %>%
  inner_join(ratings, by = "tconst")

# Cast types and filter to movies/series
imdb_raw <- imdb_raw %>%
  mutate(
    startYear = suppressWarnings(as.integer(startYear)),
    type = if_else(titleType %in% c("movie", "tvMovie"), "movie",
                   if_else(titleType %in% c("tvSeries", "tvMiniSeries"), "series", "other"))
  ) %>%
  filter(type %in% c("movie", "series"))

# Remove duplicates
imdb_dedup <- imdb_raw %>%
  distinct(tconst, .keep_all = TRUE)

# Filter by minimum votes
imdb_clean <- imdb_dedup %>%
  filter(numVotes >= 20)

# Map genres into families
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
      n_distinct(na.omit(fam)) >  1 ~ "Mixed"
    ),
    .groups = "drop"
  )

# Final enrichment
imdb_clean <- imdb_clean %>% 
  filter(!is.na(genres), genres != "")

imdb_enriched <- imdb_clean %>%
  left_join(genre_map, by = "tconst") %>%
  select(tconst, titleType, type, startYear, genres, genre_family,
         averageRating, numVotes)
print('cleaned transformed')

# OUTPUT (to root-level data/clean)
dir.create("../../data/clean", showWarnings = FALSE, recursive = TRUE)

write_csv(imdb_clean,    "../../data/clean/imdb_clean.csv")
write_rds(imdb_clean,    "../../data/clean/imdb_clean.rds")

write_csv(imdb_enriched, "../../data/clean/imdb_enriched.csv")
write_rds(imdb_enriched, "../../data/clean/imdb_enriched.rds")
print('output added to data/clean')