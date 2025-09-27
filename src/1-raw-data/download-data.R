# packages (root-relative)
source("loading-packages.R")

# raw files (root-relative)
data_dir <- "src/data"
dir.create(data_dir, recursive = TRUE, showWarnings = FALSE)

# Define data directory for reproducibility
basics_path  <- file.path(data_dir, "title.basics.tsv.gz")
ratings_path <- file.path(data_dir, "title.ratings.tsv.gz")

# Define sources (IMDb datasets)
basics_url  <- "https://datasets.imdbws.com/title.basics.tsv.gz"
ratings_url <- "https://datasets.imdbws.com/title.ratings.tsv.gz"

# Download datasets
download.file(basics_url, basics_path, mode = "wb", quiet = TRUE)
download.file(ratings_url, ratings_path, mode = "wb", quiet = TRUE)

# Transformation
# Random sample with reproducibility
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
