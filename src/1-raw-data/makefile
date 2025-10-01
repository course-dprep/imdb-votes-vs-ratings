RSCRIPT   = Rscript --vanilla
RAW_DIR   = ../../src/data
CLEAN_DIR = ../../data/clean

RAW   = $(RAW_DIR)/title.basics.tsv.gz $(RAW_DIR)/title.ratings.tsv.gz
CLEAN = $(CLEAN_DIR)/imdb_clean.csv \
        $(CLEAN_DIR)/imdb_clean.rds \
        $(CLEAN_DIR)/imdb_enriched.csv \
        $(CLEAN_DIR)/imdb_enriched.rds

.PHONY: all clean
all: $(CLEAN)

$(RAW_DIR)/.download.stamp: download-data.R | $(RAW_DIR)
	$(RSCRIPT) download-data.R
	touch $@

$(RAW): $(RAW_DIR)/.download.stamp
	@true

$(CLEAN_DIR)/.clean.stamp: data-cleaning.R $(RAW) | $(CLEAN_DIR)
	$(RSCRIPT) data-cleaning.R
	touch $@

$(CLEAN): $(CLEAN_DIR)/.clean.stamp
	@true

$(RAW_DIR):
	$(RSCRIPT) -e "dir.create('$(RAW_DIR)',  recursive=TRUE, showWarnings=FALSE)"
$(CLEAN_DIR):
	$(RSCRIPT) -e "dir.create('$(CLEAN_DIR)', recursive=TRUE, showWarnings=FALSE)"

clean:
	R -e "unlink('$(RAW_DIR)', recursive=TRUE); unlink('$(CLEAN_DIR)', recursive=TRUE)"
