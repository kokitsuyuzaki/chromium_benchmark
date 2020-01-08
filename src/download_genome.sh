#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --requeue
#SBATCH -p node03-06

# Reference Genome
wget -P data http://cf.10xgenomics.com/supp/cell-exp/refdata-cellranger-GRCh38-3.0.0.tar.gz

file="data/refdata-cellranger-GRCh38-3.0.0.tar.gz"
if [ -e $file ]; then
  touch $file
fi

tar zxvf data/refdata-cellranger-GRCh38-3.0.0.tar.gz -C data

file2="data/refdata-cellranger-GRCh38-3.0.0/fasta/genome.fa"
if [ -e $file2 ]; then
  touch $file2
fi
