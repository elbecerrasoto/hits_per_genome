#!/usr/bin/env Rscript

library(tidyverse)

PAAR_ID <- "PF05593"
RHS_ID <- "PF05488"

ECOLI_POPULATION <- 255
CENOCEPACIA_POPULATION <- 539

hits <- read_tsv("hits_per_genome.tsv", col_names = TRUE)


# to protein table
hits |> select(-start, -end) |> distinct() -> y

# collapse genomes and pfams
y |> add_count(genome, pfam) |> select(-protein) |> distinct() |> rename(protein_hits = n) -> z


z |>
    ggplot(aes(x = strain, y = protein_hits))+
    geom_boxplot()+geom_jitter(alpha=1/8, size=0.4, shape=1)+facet_grid(~pfam_txt) -> p1


ggsave("paar_rhs.svg", p1, width = 18, height = 12, units = "cm")
ggsave("paar_rhs.png", p1, width = 18, height = 12, units = "cm")

combined <- hits |>
  select(-pfam, -pfam_txt, -start, -end) |>
  distinct() |>
  add_count(genome)|>
  rename(PAAR_RHS_hits = n)

p2 <- ggplot(combined, aes(x = strain, y = PAAR_RHS_hits))+
    geom_boxplot()+geom_jitter(alpha=1/8, size=0.4, shape=1)



ggsave("combined_paar_rhs.svg", p2, width = 18, height = 12, units = "cm")
ggsave("combined_paar_rhs.png", p2, width = 18, height = 12, units = "cm")

write_tsv(combined, "combined_paar_rhs_hits.tsv")


hits |> select(genome, strain)  |> distinct() |> count(strain) -> genomes_with_hits
genomes_with_hits$total <- c(CENOCEPACIA_POPULATION, ECOLI_POPULATION)
write_tsv(genomes_with_hits, "genomes_with_hits.tsv")
