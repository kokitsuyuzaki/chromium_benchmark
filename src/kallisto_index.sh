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

touch -c data/kallisto_index
touch -c data/transcripts_to_genes.txt
