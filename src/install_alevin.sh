#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --requeue
#SBATCH -p node03-06

# Alevin
wget -O tools/alevin/salmon-1.1.0_linux_x86_64.tar.gz https://github.com/COMBINE-lab/salmon/releases/download/v1.1.0/salmon-1.1.0_linux_x86_64.tar.gz
tar zxvf tools/alevin/salmon-1.1.0_linux_x86_64.tar.gz -C tools/alevin
