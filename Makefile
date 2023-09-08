SCRIPT="hits_per_genome.R"

.PHONY: run
run:
	Rscript $(SCRIPT) 2> /dev/null

.PHONY: debug
debug:
	Rscript $(SCRIPT)


