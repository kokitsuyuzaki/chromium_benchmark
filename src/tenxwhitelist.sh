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

# 10X whitelist
gunzip -c /software/cellranger-3.1.0/cellranger-cs//3.1.0/lib/python/cellranger/barcodes/3M-february-2018.txt.gz > data/10xv3_whitelist.txt

touch -c data/10xv3_whitelist.txt
