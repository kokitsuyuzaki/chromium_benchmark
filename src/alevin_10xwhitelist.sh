#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --requeue
#SBATCH -p node03-06

tools/alevin/salmon-latest_linux_x86_64/bin/salmon \
alevin -l ISR \
--whitelist data/10xv3_whitelist.txt \
-1 data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L001_R1_001.fastq.gz \
data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L002_R1_001.fastq.gz \
-2 data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L001_R2_001.fastq.gz \
data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L002_R2_001.fastq.gz \
--chromiumV3 -i data/salmon_index \
-p 4 -o output/alevin_10xwhitelist --tgMap data/txp2gene.tsv
