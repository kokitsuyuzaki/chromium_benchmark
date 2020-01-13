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

Rscript src/summary.R

file="plot/DetectedGenes_Common_CCB.png"
if [ -e $file ]; then
  touch $file
fi
