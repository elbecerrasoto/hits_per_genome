#!/usr/bin/env Rscript

library(tidyverse)

PAAR_ID <- "PF05593"
RHS_ID <- "PF05488"

hits <- read_tsv("hits_per_genome.tsv", col_names = TRUE)

# to protein table
hits |> select(-start, -end) |> distinct() -> y
# collapse genomes and pfams
y |> add_count(genome, pfam) |> select(-protein) |> distinct() -> z


z |>
    ggplot(aes(x = strain, y = n))+
    geom_boxplot()+geom_jitter(alpha=1/2, size=0.8, shape=1)+facet_grid(~pfam_txt) -> p


ggsave("paar_rhs.svg", p, width = 18, height = 12, units = "cm")
ggsave("paar_rhs.png", p, width = 18, height = 12, units = "cm")
