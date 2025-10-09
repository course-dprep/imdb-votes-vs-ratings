print('start importing data for clean')

# Load packages (subfolder-relative)
if (!requireNamespace("here", quietly = TRUE)) install.packages("here")
library(here)

source(here("src", "1-raw-data", "loading-packages.R"))


# READ RAW DATA (from root-level data folder)
basics  <- read_tsv("../../data/title.basics.tsv.gz",  na = "\\N",
                    col_select = c(tconst, titleType, startYear, genres),
                    show_col_types = FALSE)

ratings <- read_tsv("../../data/title.ratings.tsv.gz", na = "\\N",
                    col_select = c(tconst, averageRating, numVotes),
                    show_col_types = FALSE)
print('imported data for clean')

# creating basic statistics for the data we just downloaded
out_png <- here::here("gen","output","basic_descriptives.png")
dir.create(dirname(out_png), recursive = TRUE, showWarnings = FALSE)

imdb <- dplyr::inner_join(basics, ratings, by = "tconst") |>
  dplyr::mutate(startYear = suppressWarnings(as.numeric(startYear)))

desc_num <- function(x) {
  x <- x[!is.na(x)]
  c(Obs = length(x), Mean = mean(x), `Std.Dev.` = stats::sd(x), Min = min(x), Max = max(x))
}

vars <- list(
  startYear     = imdb$startYear,
  averageRating = imdb$averageRating,
  numVotes      = imdb$numVotes
)

desc <- dplyr::bind_rows(lapply(vars, desc_num), .id = "Variable")

desc_fmt <- desc |>
  dplyr::mutate(
    Obs       = format(Obs, big.mark = ","),
    Mean      = dplyr::if_else(Variable == "averageRating", sprintf("%.2f", Mean), sprintf("%.1f", Mean)),
    `Std.Dev.`= dplyr::if_else(Variable == "averageRating", sprintf("%.2f", `Std.Dev.`), sprintf("%.1f", `Std.Dev.`)),
    Min       = dplyr::if_else(Variable == "averageRating", sprintf("%.1f", Min), format(round(Min), big.mark=",")),
    Max       = dplyr::if_else(Variable == "averageRating", sprintf("%.1f", Max), format(round(Max), big.mark=","))
  )

# save as PNG
if (!requireNamespace("gridExtra", quietly = TRUE)) install.packages("gridExtra")
g <- gridExtra::tableGrob(desc_fmt, rows = NULL)   # <- use desc_fmt here

png(out_png, width = 1800, height = 600, res = 200)
grid::grid.newpage()
grid::grid.draw(g)
dev.off()


# TRANSFORMATION
#Merge the datasets based on the common identifier (tconst)
imdb_raw <- basics %>%
  inner_join(ratings, by = "tconst")

#Type casting and selection of relevant title types
# - Convert startYear into integer
# - Classify titles into simplified categories: movie, series, other
# - Filter to keep only movies and series
imdb_raw <- imdb_raw %>%
  mutate(
    startYear = suppressWarnings(as.integer(startYear)),
    type = if_else(titleType %in% c("movie", "tvMovie"), "movie",
                   if_else(titleType %in% c("tvSeries", "tvMiniSeries"), "series", "other"))
  ) %>%
  filter(type %in% c("movie", "series"))

#Remove duplicates based on the identifier - i.e., if any titletype appears more than once in the dataset. 
imdb_dedup <- imdb_raw %>%
  distinct(tconst, .keep_all = TRUE)

#Filter out titles with very few votes to reduce noise
"Inspect numVotes variable; median is 49, mean is 2746 votes. This means that the numVotes is heavlity skewed to the right; ie, many titles have just a few votes. Although number of votes (numVotes) presents the variable of interest of our research question, we have decided to only keep titles which have at least 20 votes. The reason is to reduce noise: titles with just one or two reviews ma have ratings which are not representative for the movie, whilst ratings by several people may reduce this noise whilst keeping more extreme opinions of a small group." 
imdb_dedup %>%
  summarise(
    min_votes = min(numVotes, na.rm = TRUE),
    max_votes = max(numVotes, na.rm = TRUE),
    median_votes = median(numVotes, na.rm = TRUE),
    mean_votes = mean(numVotes, na.rm = TRUE),
    sd_votes = sd(numVotes, na.rm = TRUE)
  )
imdb_clean <- imdb_dedup %>%
  filter(numVotes >= 20)

# Map individual genres into broader genre families
# 1.Remove rows with missing or empty genres. Note that this is necessary because data-filing processes do not make sense here; one cannot infer the genre of a title based on the genre of the title that was realized in the same year (or based on another variable).
# 2.Split multiple genres into separate rows
# 3.Assign each genre to a family: 'Escapist'(fantasy, romance, action, adventure, animation, family) or 'Heavy' (drama, thriller, biography, crime, documentary and heavy) or mixed (both escapist and heavy)
# 4.Summarize back to one row per title, combining genre families
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

#Merge new genre categories back into dataset
"Ensure the imdb_clean does not have empty genre rows either; enrich with extra genre features"
imdb_clean <- imdb_clean %>% 
  filter(!is.na(genres), genres != "")
imdb_enriched <- imdb_clean %>%
  left_join(genre_map, by = "tconst") %>%
  select(tconst, titleType, type, startYear, genres, genre_family,
         averageRating, numVotes)

# OUTPUT (to root-level data/clean)
dir.create("../../data/clean", showWarnings = FALSE, recursive = TRUE)

write_csv(imdb_clean,    "../../data/clean/imdb_clean.csv")
write_rds(imdb_clean,    "../../data/clean/imdb_clean.rds")

write_csv(imdb_enriched, "../../data/clean/imdb_enriched.csv")
write_rds(imdb_enriched, "../../data/clean/imdb_enriched.rds")
print('output added to data/clean')