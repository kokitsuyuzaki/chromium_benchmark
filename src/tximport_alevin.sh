#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -q node.q

#SBATCH -n 4
#SBATCH -p node03-06

/home/koki/Software/R-3.6.0/bin/Rscript src/alevin_tximport.R
