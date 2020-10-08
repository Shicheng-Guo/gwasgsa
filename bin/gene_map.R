#!/usr/bin/env Rscript

library(tidyverse)

#res_file <- "results_test_plink_new/magma/magma_out.gsa.out.sorted.csv"
#anot_file <- "results_test_plink_new/magma/magma_out.genes.annot"
#geneset_file <- "testdata/all_computational_gene_sets.c4.all.v7.1.entrez.gmt"
#geneloc_file <- "testdata/NCBI37.3/NCBI37.3.gene.loc"

args <- commandArgs(trailingOnly = TRUE)
res_file <- args[1]
anot_file <- args[2]
geneset_file <- args[3]
geneloc_file <- args[4]

# Function copied from qusage package - https://github.com/arcolombo/qusage
##Simple function to read in a .gmt file and return a list of pathways
read.gmt = function(file){
  if(!grepl("\\.gmt$",file)[1]){stop("Pathway information must be a .gmt file")}
  geneSetDB = readLines(file)                                ##read in the gmt file as a vector of lines
  geneSetDB = strsplit(geneSetDB,"\t")                       ##convert from vector of strings to a list
  names(geneSetDB) = sapply(geneSetDB,"[",1)                 ##move the names column as the names of the list
  geneSetDB = lapply(geneSetDB, "[",-1:-2)                   ##remove name and description columns
  geneSetDB = lapply(geneSetDB, function(x){x[which(x!="")]})##remove empty strings
  return(geneSetDB)
}

# read geneset file
geneset <- read.gmt(geneset_file)
# read results file
res <- read.csv(res_file,header = T)
# read gene location file for gene ID to name conversion
gene_loc <- read.table(geneloc_file, header = F, sep = "\t", row.names = 1)
gene_id_name <- gene_loc %>% dplyr::select(V6)
names(gene_id_name) <- "GENE_NAME"

# read gene names from annotation file
anot <- readr::read_lines(anot_file, skip = 2)
input_gene_names <- vapply(strsplit(anot,"\t"), `[`, 1, FUN.VALUE=character(1))

# create a new res object to hold updated dataframe with additional colum GENE_NAME
res_new <- res
res_new$GENE_NAMES <- ""

# add the last column 
for(row in 1:nrow(res)){
  # sometimeas FULL_NAME not present depending upon geneset_name length
  if ("FULL_NAME" %in% colnames(res)){
    geneset_name <- res[row,]$FULL_NAME
  }else{
    geneset_name <- res[row,]$VARIABLE
  }
  
  genes_in_geneset <- geneset[[geneset_name]]
  genes_in_res_geneset <- intersect(genes_in_geneset,input_gene_names) # get common genes in input genes and gene-sets
  genenames_in_res_geneset <- vector()
  for(gene in genes_in_res_geneset){ # convert gene id to gene names and make into a string
    genenames_in_res_geneset <- paste(genenames_in_res_geneset, gene_id_name[gene,], sep = ",")
  }
  res_new$GENE_NAMES[row] <- sub("^,","", genenames_in_res_geneset) # add the string to last column
}

# write into a file
out_file_name <- paste0(sub(".csv","",basename(res_file)), ".genenames.tsv")
write.table(res_new, file=out_file_name, quote = F, sep = "\t", row.names = F)

