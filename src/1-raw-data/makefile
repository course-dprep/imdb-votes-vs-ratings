# Makefile for 1-raw-data, run in terminal with 'make raw' from root

# Paths
DATA_DIR = ../../data
STAMP = $(DATA_DIR)/.download.stamp

# Default target
all: $(STAMP)

# Run loading packages first (no file output, just ensures required packages are available)
.PHONY: load-packages
load-packages:
	Rscript loading-packages.R

# Download raw IMDb data and create samples
$(STAMP): download-data.R loading-packages.R | $(DATA_DIR)
	Rscript download-data.R
	touch $(STAMP)

# Ensure data directory exists
$(DATA_DIR):
	mkdir -p $(DATA_DIR)

# Clean up downloaded data
clean:
	rm -f $(STAMP)
	rm -f $(DATA_DIR)/*.tsv.gz
