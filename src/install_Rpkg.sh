#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --requeue
#SBATCH -p node03-06

# R packages
/home/koki/Software/R-3.6.0/bin/R -e 'install.packages(c("ggplot2","BiocManager","Seurat","VennDiagram"),repos="http://cran.r-project.org");BiocManager::install(c("tximport","BUSpaRse","fishpond","DropletUtils","Homo.sapiens"),suppressUpdates=TRUE)'
