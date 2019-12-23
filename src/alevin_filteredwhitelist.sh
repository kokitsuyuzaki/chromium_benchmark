#!/bin/bash

tool/alevin/salmon-latest_linux_x86_64/bin/salmon \
alevin -l ISR \
--whitelist data/filteredwhitelist.txt \
-1 data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L001_R1_001.fastq.gz \
data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L002_R1_001.fastq.gz \
-2 data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L001_R2_001.fastq.gz \
data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L002_R2_001.fastq.gz \
--chromiumV3 -i data/salmon_index \
-p 4 -o output/alevin_filteredwhitelist --tgMap data/txp2gene.tsv
