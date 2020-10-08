#!/usr/bin/env Rscript

library(stringr)

magma_annot_log_file <- "results_test_vcf/magma/magma_out.genes.annot.log"
magma_annot_log <- readLines(magma_annot_log_file)
total_input_snp <- magma_annot_log[grep("SNP locations read from file", magma_annot_log)]
total_input_snp <- total_input_snp %>%
  stringr::str_replace("\t","") %>% 
  stringr::str_replace(" SNP locations read from file","") %>% 
  as.numeric()

magma_annot_file <- "results_test_vcf/magma/magma_out.genes.annot"
magma_annot <- readLines(magma_annot_file)
gene_snp_num <- matrix(nrow = length(magma_annot), ncol = 2)

for(l in 3:length(magma_annot)){
  row_value = stringr::str_split(magma_annot[l], pattern = "\t")
  gene_name = row_value[1][[1]][1]
  gene_snp_num[l, ] <- c(gene_name, str_count(magma_annot[l], "rs"))
}

gene_snp_num_df <- as.data.frame(gene_snp_num)
gene_snp_num_df <- na.omit(gene_snp_num_df)
names(gene_snp_num_df) <- c("Gene", "Mapped_SNP")

mapped_snp_number <- sum(as.numeric(gene_snp_num_df$Mapped_SNP))
mapped_snp_percent <- round((mapped_snp_number/total_input_snp)*100, 2)

hist(as.numeric(gene_snp_num_df$Mapped_SNP), 
     main = paste("Frequency of", nrow(gene_snp_num_df),"Genes",
                  "in", mapped_snp_number, "(", mapped_snp_percent, "% of Input) SNPs"),
     ylab = "Frequency of Genes",
     xlab = "Number of NSPs")


