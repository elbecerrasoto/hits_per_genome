#!/usr/bin/env Rscript

# how to run it
# Rscript bending.R 2> /dev/null

# /Any/ approach
# The PEP 8 code style
# Add 4 spaces (an extra level of indentation)
# The 4-space rule is optional for continuation lines

# options(warn=0) # With warnings
options(warn=-1) # Without warnings

library(tidyverse)

ANNOTATIONS_PATHS <- c( 'data/GCF_000194745.1.tsv',
                        'data/GCF_004723625.1.tsv',
                        'data/GCF_009741325.1.tsv',
                        'data/GCF_012275575.1.tsv')

HEADER <- c('protein',
            'md5',
            'lenght',
            'analysis',
            'memberDB',
            'memberDB_txt',
            'start',
            'end',
            'score',
            'status',
            'date',
            'interpro',
            'interpro_txt')


# Remove leading path & trailing extension
GENOMES <- str_replace(ANNOTATIONS_PATHS, 'data/', '') %>%
           str_replace('.tsv', '')


# read the genome, add the genome column
read_add_genome <- function(path, genome)
{
    return(
            read_tsv(path, col_names=HEADER) %>%
            add_column(genome=genome, .before='protein')
          )
}


INTERESTING_PFAMS <- c("IPR006531", "IPR001826", "IPR025425", "IPR032724", "IPR008514")

annotations <- map(1:length(GENOMES),
                   function (idx)
                   { read_add_genome( ANNOTATIONS_PATHS[idx],
                                   GENOMES[idx]) } ) %>%
               bind_rows()


# Important Columns
library(magrittr)
annotations %<>% select(protein, genome, lenght, start, end, interpro, interpro_txt)

# Any approach
hits <- annotations %>%
        filter(interpro %in% INTERESTING_PFAMS) %>%
        arrange(desc(lenght))


counts <- hits %>%
          group_by(genome) %>%
          summarise(counts=n())


single_domain <- hits %>%
                 group_by(genome, protein) %>%
                 summarise(counts=n()) %>%
                 filter(counts == 1)


multi_domain <- hits %>%
                group_by(genome, protein) %>%
                summarise(counts=n()) %>%
                filter(counts != 1)


# Show 24 hits, maybe sort by lenght
# trows <- sample(1:nrow(hits))[1:24]
# print(hits[trows,])
cat('\n', 'Hits on all genomes header', '\n', sep='')
print(hits)

cat('\n', 'Genome Domains Hit Counts', '\n', sep='')
print(counts)

cat('\n', 'Single Domains Proteins: ', nrow(single_domain), '\n', sep='')
cat('Multi  Domains Proteins: ', nrow(multi_domain), '\n', sep='')

#!/usr/bin/env Rscript

suppressMessages(library(seqinr))
suppressMessages(library(tidyverse))
library(argparse)


parser <- ArgumentParser(description="Print cmd to extract proteins from a FASTA\n
                                      the filteriing is done\n
                                      using IntreproScan 5 TSV and a TXT of Interpro IDs")

parser$add_argument("--tsv", type="character", nargs=1,
                    help="File containing the annotation from InterProScan 5 on TSV")

parser$add_argument("--ids", type="character", nargs=1,
                    help="File of the interpro IDs to filter,\n
                    one interpro ID per line, use '#' to comment\n ")

parser$add_argument("--out", "-o", type="character", nargs=1,
                    help="Output, filtered fasta")

parser$add_argument("faa", type="character", nargs=1,
                    help="FASTA amino acid to filter")

ARGS <- parser$parse_args()


TSV <- ARGS$tsv
IDS <- ARGS$ids
FAA <- ARGS$faa
OUT <- ARGS$out


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


parse_ids <- function (path2ids)
{
  read_tsv(IDS, comment = "#", col_names = "interpro", col_types = "c")[[1]]
}

# problems(annotation) some rows with 13 rows, expected 15
annotation <- suppressWarnings(read_tsv(TSV, col_names=HEADER, show_col_types = FALSE))
ids <- parse_ids(IDS)


hits <-
annotation %>%
  filter(interpro %in% ids) %>%
  distinct(protein)

hits <- hits[[1]]

faa <- read.fasta(FAA, seqtype="AA", forceDNAtolower = FALSE, strip.desc = TRUE)
faa_hits <- faa[hits]

faa_hits_headers <- map(faa_hits, attr, which = "Annot") %>%
  str_c(paste0(" ", "source=", basename(FAA)))

# nbchar = 80 to make it equal to ncbi source
write.fasta(faa_hits, names = faa_hits_headers, nbchar = 80, file.out = OUT)
