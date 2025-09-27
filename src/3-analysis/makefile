RSCRIPT = Rscript --vanilla
CLEAN   = ../../data/clean
TEMP    = ../../gen/temp
OUT     = ../../gen/output

PIVOT = $(TEMP)/pivot_table.csv
PLOT1 = $(OUT)/plot_votes_vs_ratings.pdf
STAMP = $(OUT)/.analysis.stamp

.PHONY: all clean
all: $(PIVOT) $(PLOT1)

$(STAMP): analysis.R $(CLEAN)/imdb_enriched.csv | $(TEMP) $(OUT)
	$(RSCRIPT) analysis.R
	touch $@

$(PIVOT) $(PLOT1): $(STAMP)
	@true

$(TEMP):
	$(RSCRIPT) -e "dir.create('$(TEMP)', recursive=TRUE, showWarnings=FALSE)"
$(OUT):
	$(RSCRIPT) -e "dir.create('$(OUT)', recursive=TRUE, showWarnings=FALSE)"

clean:
	R -e "unlink('$(TEMP)', recursive=TRUE); unlink('$(OUT)', recursive=TRUE)"
