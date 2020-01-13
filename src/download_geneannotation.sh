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

# Comprehensive gene annotation
wget -P data ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_32/gencode.v32.primary_assembly.annotation.gtf.gz

file="data/gencode.v32.primary_assembly.annotation.gtf.gz"
if [ -e $file ]; then
  touch $file
fi

gunzip -c data/gencode.v32.primary_assembly.annotation.gtf.gz | grep transcript | awk '{print $12,$10}' | sed -e 's|"||g' -e 's|;||g' | uniq > data/txp2gene.tsv

file2="data/txp2gene.tsv"
if [ -e $file2 ]; then
  touch $file2
fi