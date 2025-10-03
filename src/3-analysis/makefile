# Makefile for 3-analysis, run in terminal with 'make analysis' from root

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
	mkdir -p $(OUTPUT_DIR)

# Clean outputs
clean:
	rm -rf $(OUTPUT_DIR)
