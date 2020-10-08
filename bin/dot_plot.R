#!/usr/bin/env Rscript

# This script generates a dot plot for gene set analysis
# Input - MAGMA tools .gsa.out file
# Usage - Rscript dot_plot .gsa.out_file pvalue_cutoff top_n_value 

library(dplyr)
library(ggplot2)

#gsa_file <- "results_test_vcf/magma/magma_out.gsa.out"
#pvalue_cutoff <- 0.05
#top_n_value <- 10

args <- commandArgs(trailingOnly = TRUE)
gsa_file <- args[1]
pvalue_cutoff <- as.numeric(args[2])
top_n_value <- as.numeric(args[3])

# read the gsa file
gsa <- read.table(gsa_file, header = T)
gsa_filt <- gsa %>% filter(P < pvalue_cutoff)

gsa_filt_sort <- gsa_filt %>% dplyr::arrange(P)

top_n <- head(gsa_filt_sort, top_n_value)

plot <- ggplot(top_n) +
   geom_point(aes(x = NGENES, y = VARIABLE, color = P, size = NGENES)) +
   labs(title="Gene-Set Analysis",
        x="Number of Genes", y="Gene-Set Names") +
  labs(color="P-value", size="Number of Genes" ) +
  scale_color_gradient(low="blue", high="red") + 
  theme_bw()
  
#plot

out_png <- paste0(basename(gsa_file), ".top_", top_n_value, ".plot.png")
ggsave(out_png, plot, width = 7, height = 5)

# export results for which plot is made
top_n_file_name <- paste0(basename(gsa_file), ".top_", top_n_value, ".plot.csv")
write.table(top_n, file=top_n_file_name, quote = F, sep = ",", row.names = F)

## save the sorted gsa file as csv
gsa_sort <- gsa %>% dplyr::arrange(P)
#gsa_sort <- gsa_sort %>% tibble::rownames_to_column("VARIABLE")
csv_file_name <- paste0(basename(gsa_file), ".sorted.csv")
write.table(gsa_sort, file=csv_file_name, quote = F, sep = ",", row.names = F)

