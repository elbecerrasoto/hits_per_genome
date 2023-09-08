#!/usr/bin/env Rscript

library(tidyverse)

PAAR_ID <- "PF05593"
RHS_ID <- "PF05488"
  
hits <- read_tsv("hits_per_genome.tsv", col_names = TRUE)

paar <- hits |> filter(pfam == PAAR_ID)
rhs <- hits |> filter(pfam == RHS_ID)

paar |> 
  add_count(protein)


paar |> 
  ggplot()+
  geom_jitter(aes(x=strain, y=n))


View(hits)
