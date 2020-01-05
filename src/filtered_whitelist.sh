#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --requeue
#SBATCH -p node03-06

gunzip -c output/cellranger/5k_pbmc/outs/filtered_feature_bc_matrix/barcodes.tsv.gz | sed -e "s|-1||g" > data/filteredwhitelist.txt