.PHONY: run
run:
	Rscript hand.R

.PHONY: clean-run
clean-run:
	Rscript hand.R 2> /dev/null

