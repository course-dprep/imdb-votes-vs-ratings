# Top-level Makefile (placed in project root), run in terminal with 'make' from root

.PHONY: all raw prep analysis report clean

# Full pipeline
all: raw prep analysis report

# Step 1: raw data
raw:
	$(MAKE) -C src/1-raw-data

# Step 2: data preparation (cleaning + preparation)
prep: raw
	$(MAKE) -C src/2-data-preparation

# Step 3: analysis
analysis: prep
	$(MAKE) -C src/3-analysis

# Step 4: reporting
report: analysis
	$(MAKE) -C src/4-reporting

# Clean everything
clean:
	$(MAKE) -C src/1-raw-data clean
	$(MAKE) -C src/2-data-preparation clean
	$(MAKE) -C src/3-analysis clean
	$(MAKE) -C src/4-reporting clean
