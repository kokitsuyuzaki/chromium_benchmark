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

cd output/kb_10xwhitelist
kb count -i ../../data/kallisto_index \
-g ../../data/transcripts_to_genes.txt \
-x 10XV3 -o ./ \
-w ../../data/10xv3_whitelist.txt \
../../data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L001_R1_001.fastq.gz \
../../data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L001_R2_001.fastq.gz \
../../data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L002_R1_001.fastq.gz \
../../data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L002_R2_001.fastq.gz

touch -c counts_unfiltered/cells_x_genes.mtx
