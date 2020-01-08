#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --requeue
#SBATCH -p node03-06

/home/koki/Software/R-3.6.0/bin/Rscript src/summary_samegenes.R

file="plot/CommonGenes/DetectedGenes_Common_CCB.png"
if [ -e $file ]; then
  touch $file
fi
