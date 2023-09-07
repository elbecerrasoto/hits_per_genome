#!/usr/bin/env Rscript

library(tidyverse)

# emacs text expansion
# TODO: expand M-- to <- and C-M-m to %>%

# So the approach is the following is:

# Input: target folders with strain name
# Output: plot of number of proteins

TARGETS <- list(ecoli="/run/media/ebecerra/manjaro500/home/ebecerra/2-projects/results/e_coli_255/2-pfams")


read_strain_dirs <- function  (list_of_dirs)
{
  map(list_of_dirs, list.files, full.names = TRUE)
}

print(read_strain_dirs(TARGETS))
