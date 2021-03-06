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

salmon index -i data/salmon_index -k 31 --gencode -p 4 \
-t data/gencode.v32.pc_transcripts.fa.gz

touch -c data/salmon_index/mphf.bin
