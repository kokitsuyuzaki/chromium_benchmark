#!/bin/bash

export PATH=./tool/cellranger/cellranger-3.1.0:$PATH

cellranger count \
--id=5k_pbmc \
--transcriptome=./data/refdata-cellranger-GRCh38-3.0.0 \
--fastqs=./data/5k_pbmc_protein_v3_nextgem_fastqs/5k_pbmc_protein_v3_nextgem_gex_fastqs \
--sample=5k_pbmc_protein_v3_nextgem_gex

mv 5k_pbmc output/cellranger/

gunzip -c output/cellranger/5k_pbmc/outs/filtered_feature_bc_matrix/barcodes.tsv.gz | sed -e "s|-1||g" > data/filteredwhitelist.txt
