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

Rscript src/alevin_tximport.R

touch -c output/alevin/alevin.RData
touch -c output/alevin_10xwhitelist/alevin_10xwhitelist.RData
touch -c output/alevin_filteredwhitelist/alevin_filteredwhitelist.RData
