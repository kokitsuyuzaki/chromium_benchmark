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

# Reference Genome
wget -P data http://cf.10xgenomics.com/supp/cell-exp/refdata-cellranger-GRCh38-3.0.0.tar.gz
touch -c data/refdata-cellranger-GRCh38-3.0.0.tar.gz

tar zxvf data/refdata-cellranger-GRCh38-3.0.0.tar.gz -C data
touch -c data/refdata-cellranger-GRCh38-3.0.0/fasta/genome.fa
