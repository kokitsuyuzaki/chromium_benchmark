library("BUSpaRse")

# Data loading
res_kb <- read_count_output(
    "./output/kb/counts_unfiltered",
    name = "cells_x_genes", tcc = FALSE)
res_kb_10xwhitelist <- read_count_output(
    "./output/kb_10xwhitelist/counts_unfiltered",
    name = "cells_x_genes", tcc = FALSE)
res_kb_filteredlist <- read_count_output(
    "./output/kb_filteredlist/counts_unfiltered",
    name = "cells_x_genes", tcc = FALSE)


# Filtering
# ...


# Data saving
save(res_kb, file="output/kb/kb.RData")
save(res_kb_10xwhitelist,
   file="output/kb_10xwhitelist/kb_10xwhitelist.RData")
save(res_kb_filteredwhitelist,
   file="output/kb_filteredwhitelist/kb_filteredwhitelist.RData")
