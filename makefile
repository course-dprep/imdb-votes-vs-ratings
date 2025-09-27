# This makefile will be used to automate the
# different steps in your project.
.PHONY: all raw-data clean help

# Run only the raw-data stage by default
all: raw-data

# Delegate to the sub-makefile in src/1-raw-data
raw-data:
	$(MAKE) -C src/1-raw-data

# Clean (optional: calls the stage's clean if you have it)
clean:
	-$(MAKE) -C src/1-raw-data clean

help:
	@echo "Targets:"
	@echo "  make         -> run raw-data stage"
	@echo "  make raw-data"
	@echo "  make clean   -> clean raw-data outputs (if stage has a clean rule)"
