#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --requeue
#SBATCH -p node03-06

salmon alevin -l ISR \
-1 data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L001_R1_001.fastq.gz \
data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L002_R1_001.fastq.gz \
-2 data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L001_R2_001.fastq.gz \
data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L002_R2_001.fastq.gz \
--chromiumV3 -i data/salmon_index \
-p 4 -o output/alevin --tgMap data/txp2gene.tsv

file="output/alevin/alevin/quants_mat.gz"
if [ -e $file ]; then
  touch $file
fi