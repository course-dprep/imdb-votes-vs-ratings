library(readr)
library(tidyverse)

# Define data directory for reproducability
data_dir <- "../data"

# Read and safe basics datatable 
basics <- read_tsv(
  "https://datasets.imdbws.com/title.basics.tsv.gz",
  na = "\\N",
  col_select = c(tconst, titleType, startYear, genres),
  n_max = 200000
)

write_csv(basics, file.path(data_dir, "TitleBasics.csv"))

# Read and safe ratings datatable 
ratings <- read_tsv(
  "https://datasets.imdbws.com/title.ratings.tsv.gz",
  na = "\\N",
  col_select = c(tconst, averageRating, numVotes),
  n_max = 200000
)

write_csv(ratings, file.path(data_dir, "TitleRatings.csv"))

