#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --requeue
#SBATCH -p node03-06

/home/koki/Software/R-3.6.0/bin/Rscript src/alevin_tximport.R

file="output/alevin/alevin.RData"
if [ -e $file ]; then
  touch $file
fi

file2="output/alevin_10xwhitelist/alevin_10xwhitelist.RData"
if [ -e $file2 ]; then
  touch $file2
fi

file3="output/alevin_filteredwhitelist/alevin_filteredwhitelist.RData"
if [ -e $file3 ]; then
  touch $file3
fi