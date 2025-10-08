# Makefile for 2-data-preparation, run in terminal with 'make prep' from root

# Paths
DATA_DIR = ../../data
CLEAN_DIR = $(DATA_DIR)/clean

CLEAN_FILES = $(CLEAN_DIR)/imdb_clean.csv \
              $(CLEAN_DIR)/imdb_clean.rds \
              $(CLEAN_DIR)/imdb_enriched.csv \
              $(CLEAN_DIR)/imdb_enriched.rds

ANALYSIS_FILES = $(CLEAN_DIR)/imdb_analysis.csv \
                 $(CLEAN_DIR)/imdb_analysis.rds

RAW_STAMP = $(DATA_DIR)/.download.stamp

# Default target: run cleaning and preparation
all: $(CLEAN_FILES) $(ANALYSIS_FILES)

# Step 1: Run data cleaning (requires raw download stamp)
$(CLEAN_FILES): Data-cleaning.R $(RAW_STAMP) | $(CLEAN_DIR)
	Rscript Data-cleaning.R

# Step 2: Run data preparation (requires enriched data from cleaning)
$(ANALYSIS_FILES): Data-preparation.R $(CLEAN_DIR)/imdb_enriched.csv | $(CLEAN_DIR)
	Rscript Data-preparation.R

# Ensure clean directory exists
$(CLEAN_DIR):
	R -e "dir.create('$(CLEAN_DIR)', recursive = TRUE, showWarnings = FALSE)"

# Clean outputs
clean:
	rm -f $(CLEAN_FILES) $(ANALYSIS_FILES)
