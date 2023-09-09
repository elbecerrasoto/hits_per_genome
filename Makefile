SCRIPT=hits_per_genome.R
TAB=hits_per_genome.tsv

$(TAB): $(SCRIPT)
	Rscript $(SCRIPT) 2> /dev/null

.PHONY: debug
debug:
	Rscript $(SCRIPT)

.PHONY: style
style:
	Rscript - <<< 'styler::style_dir("./")'
