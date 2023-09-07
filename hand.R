#!/usr/bin/env Rscript

library(tidyverse)
# library(furrr) future_map

# emacs text expansion
# TODO: expand M-- to <- and C-M-m to %>%

# So the approach is the following is:

# Input: target folders with strain name
# Output: plot of number of proteins

TARGETS <- list(ecoli="/run/media/ebecerra/manjaro500/home/ebecerra/2-projects/results/e_coli_255/2-pfams")


HEADER <- c("protein",
            "md5",
            "lenght",
            "analysis",
            "memberDB",
            "memberDB_txt",
            "start",
            "end",
            "score",
            "status",
            "date",
            "interpro",
            "interpro_txt",
            "GOs",
            "pathways")


read_strain_dirs <- function  (list_of_dirs)
{

  expand_into_tables <- function (path)
  {
    list.files(path, full.names = TRUE) %>%
      str_subset("\\.tsv$") %>%
      map(read_tsv, col_names = HEADER)
  }

  map(list_of_dirs, expand_into_tables)

}

x <- suppressMessages(read_strain_dirs(TARGETS))
