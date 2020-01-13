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

kb ref -d human -i data/kallisto_index -g data/transcripts_to_genes.txt

file="data/kallisto_index"
if [ -e $file ]; then
  touch $file
fi

file2="data/transcripts_to_genes.txt"
if [ -e $file2 ]; then
  touch $file2
fi