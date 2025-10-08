# Makefile for 3-analysis, run in terminal with 'make analysis' from root
# Cross-platform touch command
ifeq ($(OS),Windows_NT)
	TOUCH = type NUL >
else
	TOUCH = touch
endif

# Paths
DATA_DIR = ../../data
CLEAN_DIR = $(DATA_DIR)/clean
OUTPUT_DIR = ../../gen/output

ANALYSIS_INPUT = $(CLEAN_DIR)/imdb_analysis.csv
ANALYSIS_SCRIPT = analysis.R

# Expected outputs
PLOTS = $(OUTPUT_DIR)/model1_2.png \
        $(OUTPUT_DIR)/model3.png \
        $(OUTPUT_DIR)/model4.png

# Default target
all: $(PLOTS)

# Generate plots by running the analysis script
$(PLOTS): $(ANALYSIS_SCRIPT) $(ANALYSIS_INPUT) | $(OUTPUT_DIR)
	Rscript $(ANALYSIS_SCRIPT)

# Ensure output directory exists
$(OUTPUT_DIR):
	Rscript -e "dir.create('$(OUTPUT_DIR)', recursive = TRUE, showWarnings = FALSE)"

# Clean outputs
clean:
	Rscript -e "unlink('$(OUTPUT_DIR)', recursive = TRUE, force = TRUE)"
