#!/usr/bin/env Rscript

library(tidyverse)

PAAR_ID <- "PF05593"
RHS_ID <- "PF05488"

hits <- read_tsv("hits_per_genome.tsv", col_names = TRUE)

# to protein table
x |> select(-start, -end) |> distinct() -> y
# collapse genomes and pfams
y |> add_count(genome, pfam) |> select(-protein) |> distinct() -> z


z |>
    ggplot(aes(x = strain, y = n))+
    geom_boxplot()+geom_jitter(alpha=1/2, size=0.8, shape=1)+facet_grid(~pfam_txt)
