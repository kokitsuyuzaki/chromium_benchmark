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

Rscript src/seurat_cellranger.R

file="output/cellranger/cellranger.RData"
if [ -e $file ]; then
  touch $file
fi