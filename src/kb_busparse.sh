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

Rscript src/kb_busparse.R

touch -c output/kb/kb.RData
touch -c output/kb_10xwhitelist/kb_10xwhitelist.RData
touch -c output/kb_filteredwhitelist/kb_filteredwhitelist.RData
