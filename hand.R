#!/usr/bin/env Rscript

# emacs text expansion
# TODO: expand M-- to <- and C-M-m to %>%

# So the approach is the following is:

# Input: target folders with strain name
# Output: plot of number of proteins

TARGETS <- list(list(ecoli="/run/media/ebecerra/manjaro500/home/ebecerra/2-projects/results/e_coli_255/2-pfams
"))


function read_strain_dirs(list_of_dirs)
{
  function magic_fun(path)
  {
    list.file(path, full.names=TRUE)
  }
  map(list_of_dirs, magic_fun)
}

