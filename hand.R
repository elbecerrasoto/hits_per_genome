#!/usr/bin/env Rscript

library(tidyverse)

# emacs text expansion
# TODO: expand M-- to <- and C-M-m to %>%

STRAINS <- list(ecoli="./test_strains/ecoli", cenocepacia="./test_strains/cenocepacia")


read_pfam_tsv <- function(pfam_tsv, strain)
{

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

  SUBSET <- c("protein",
              "memberDB",
              "memberDB_txt")

  # regex is not robust, path needs at least one /
  genome <- str_replace(pfam_tsv, ".*/(.*?)\\.pfam\\.tsv$", "\\1")

  read_tsv(pfam_tsv, col_names = HEADER) %>%
    select(all_of(SUBSET)) %>%
    add_column(strain=strain, .before="protein") %>%
    add_column(genome=genome, .before="strain")

}


get_pfam_tsvs_from_strain_dir <- function(strain_dir)
{
    list.files(strain_dir, full.names = TRUE) %>%
      str_subset("\\.tsv$")
}

TSVS <- get_pfam_tsvs_from_strain_dir(STRAINS[["ecoli"]])

# main --------------------------------------------------------------------

main <- function()
{
  strain_tables <- list()

  for(strain in names(STRAINS))
  {

    pfam_tsvs <- get_pfam_tsvs_from_strain_dir(STRAINS[[strain]])
    print(pfam_tsvs)
    strain_tables[[strain]] <- map(pfam_tsvs, read_pfam_tsv, strain = strain)
  }

  return(strain_tables)

}


STRAIN_TABLES <- main()
print(STRAIN_TABLES)
