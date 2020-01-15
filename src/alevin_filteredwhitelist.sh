#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --nice 50
#SBATCH --requeue
#SBATCH -p node03-06
SLURM_RESTART_COUNT=2

salmon alevin -l ISR \
--whitelist data/filteredwhitelist.txt \
-1 data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L001_R1_001.fastq.gz \
data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L002_R1_001.fastq.gz \
-2 data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L001_R2_001.fastq.gz \
data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L002_R2_001.fastq.gz \
--chromiumV3 -i data/salmon_index \
-p 4 -o output/alevin_filteredwhitelist --tgMap data/txp2gene.tsv

touch -c output/alevin_filteredwhitelist/alevin/quants_mat.gz
