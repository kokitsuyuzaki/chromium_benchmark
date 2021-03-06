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

cellranger count \
--id=5k_pbmc \
--transcriptome=./data/refdata-cellranger-GRCh38-3.0.0 \
--fastqs=./data/5k_pbmc_protein_v3_fastqs/5k_pbmc_protein_v3_gex_fastqs/ \
--sample=5k_pbmc_protein_v3_gex

rm -rf output/cellranger/*
if [ -e 5k_pbmc ]; then
	echo "5k_pbmc is generated by cellranger"
    mv 5k_pbmc output/cellranger/
    touch -c output/cellranger/5k_pbmc
else
	echo "5k_pbmc is not found..."
    sleep 60
    if [ -e 5k_pbmc ]; then
        echo "5k_pbmc is generated by cellranger"
        mv 5k_pbmc output/cellranger/
        touch -c output/cellranger/5k_pbmc
    fi
fi
