# Makefile for 3-analysis, run in terminal with 'make analysis' from root

# Paths
CLEAN_DIR = ../../data/clean
OUTPUT_DIR = ../../gen/output

ANALYSIS_INPUT = $(CLEAN_DIR)/imdb_analysis.csv

# Expected outputs
PLOTS = $(OUTPUT_DIR)/model1_2.png \
        $(OUTPUT_DIR)/model3.png \
        $(OUTPUT_DIR)/model4.png

# Default target
all: $(PLOTS)

# Generate plots by running the analysis script
$(PLOTS): analysis.R $(ANALYSIS_INPUT)
	Rscript analysis.R

# Clean outputs
# clean:
#	Rscript -e "unlink('$(OUTPUT_DIR)', recursive = TRUE, force = TRUE)"
