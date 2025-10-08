# Makefile for 1-raw-data, run in terminal with 'make raw' from project root

# Paths
DATA_DIR = ../../data
STAMP = $(DATA_DIR)/.download.stamp

# Default target
all: $(STAMP)

# Run loading packages first (ensures required packages are available)
.PHONY: load-packages
load-packages:
	Rscript loading-packages.R

# Ensure data directory exists
$(DATA_DIR):
	R -e "dir.create('$(DATA_DIR)', recursive = TRUE, showWarnings = FALSE)"

# Download raw IMDb data and create samples
$(STAMP): download-data.R loading-packages.R | $(DATA_DIR)
	Rscript download-data.R
	R -e "file.create('$(STAMP)')"

# Clean up downloaded data (optional: only run manually)
clean:
	R -e "if (file.exists('$(STAMP)')) file.remove('$(STAMP)')"
	R -e "files <- list.files('$(DATA_DIR)', pattern='\\.tsv\\.gz$$', full.names=TRUE); if (length(files)>0) file.remove(files)"
