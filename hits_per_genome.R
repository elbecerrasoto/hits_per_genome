#!/usr/bin/env Rscript

library(tidyverse)


# input: strain directories
# output: single table with
# colnames: genome strain pfam counts matching_proteins

STRAINS <- list(ecoli="./test_strains/ecoli", cenocepacia="./test_strains/cenocepacia")

SUBSET_PFAMS <- c("PF05593", "PF05488")


read_pfam_tsv <- function(pfam_tsv, strain)
{

  HEADER <- c("protein",
              "md5",
              "lenght",
              "analysis",
              "pfam",
              "pfam_txt",
              "start",
              "end",
              "score",
              "status",
              "date",
              "interpro",
              "interpro_txt",
              "GOs",
              "pathways")

  SUBSET_COLS <- c("protein",
              "pfam",
              "pfam_txt")

  # regex is not robust, path needs at least one /
  genome <- str_replace(pfam_tsv, ".*/(.*?)\\.pfam\\.tsv$", "\\1")

  return(
  read_tsv(pfam_tsv, col_names = HEADER) %>%
    select(all_of(SUBSET_COLS)) %>%
    filter(pfam %in% SUBSET_PFAMS) %>%
    add_column(strain=strain, .before="protein") %>%
    add_column(genome=genome, .before="strain")
  )

}


get_pfam_tsvs_from_strain_dir <- function(strain_dir)
{

  return(
  list.files(strain_dir, full.names = TRUE) %>%
    str_subset("\\.tsv$")
  )
}

# main --------------------------------------------------------------------

get_strain_tables <- function()
{
  strain_tables <- list()

  for(strain in names(STRAINS))
  {

    pfam_tsvs <- get_pfam_tsvs_from_strain_dir(STRAINS[[strain]])

    multiple_tables_per_strain <- map(pfam_tsvs, read_pfam_tsv, strain = strain)

    single_table_per_strain <- reduce(multiple_tables_per_strain, bind_rows)

    strain_tables[[strain]] <- single_table_per_strain
  }

  return(strain_tables)

}


SINGLE_TABLE <- reduce(get_strain_tables(), bind_rows)
print(SINGLE_TABLE)
