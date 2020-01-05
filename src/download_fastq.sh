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
tar xvf data/5k_pbmc_protein_v3_fastqs.tar -C data
