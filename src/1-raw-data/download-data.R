print('starting download')
# Load required packages (subfolder-relative; we run from src/1-raw-data/)
source("loading-packages.R")

# Data directory is the sibling folder ../data
data_dir <- "../data"
dir.create(data_dir, recursive = TRUE, showWarnings = FALSE)

basics_path  <- file.path(data_dir, "title.basics.tsv.gz")
ratings_path <- file.path(data_dir, "title.ratings.tsv.gz")

#Define source Urls (IMDb datasets)
"title.basics: contains title-level information (e.g., type, year, genres)"
"title.ratings: contains IMDb user ratings and vote counts."
basics_url  <- "https://datasets.imdbws.com/title.basics.tsv.gz"
ratings_url <- "https://datasets.imdbws.com/title.ratings.tsv.gz"

#Download datasets to local "data" directory
download.file(basics_url, basics_path, mode = "wb", quiet = TRUE)
download.file(ratings_url, ratings_path, mode = "wb", quiet = TRUE)

#Create a random sample with reproducibility
"Seed set at 123 ensures the same data used if the analysis is re-run. Set n = 200,000 to limit computation power required for the analysis."
set.seed(123)
sample_basics <- vroom(basics_path, delim = "\t") %>%
  slice_sample(n = 200000)

set.seed(123)
sample_ratings <- vroom(ratings_path, delim = "\t") %>%
  slice_sample(n = 200000)

# Output
message("Random samples created:")
message("Sample basics rows: ", nrow(sample_basics))
message("Sample ratings rows: ", nrow(sample_ratings))
print('download complete')