# Paths
CLEAN_DIR = ../../data/clean
OUTPUT_DIR = ../../gen/output
REPORT = $(OUTPUT_DIR)/report.html

# Rule to knit Rmd to HTML
$(REPORT):
	Rscript -e "rmarkdown::render('report.Rmd', output_format = 'html_document', output_file = 'report.html', output_dir = '$(OUTPUT_DIR)')"

# Clean up generated files
clean:
	rm -f $(REPORT)