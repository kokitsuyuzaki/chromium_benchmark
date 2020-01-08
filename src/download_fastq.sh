#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --requeue
#SBATCH -p node03-06

# PBMCs data on 10X Genomics site
wget -P data http://cf.10xgenomics.com/samples/cell-exp/3.1.0/5k_pbmc_protein_v3/5k_pbmc_protein_v3_fastqs.tar

file="data/5k_pbmc_protein_v3_fastqs.tar"
if [ -e $file ]; then
  touch $file
fi

tar xvf data/5k_pbmc_protein_v3_fastqs.tar -C data

file2="data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/5k_pbmc_protein_v3_gex_S1_L001_R1_001.fastq.gz"
if [ -e $file2 ]; then
  touch $file2
fi