#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --requeue
#SBATCH -p node03-06

/home/koki/Software/R-3.6.0/bin/Rscript src/kb_busparse.R

file="output/kb/kb.RData"
if [ -e $file ]; then
  touch $file
fi

file="output/kb_10xwhitelist/kb_10xwhitelist.RData"
if [ -e $file ]; then
  touch $file
fi

file="output/kb_filteredwhitelist/kb_filteredwhitelist.RData"
if [ -e $file ]; then
  touch $file
fi
