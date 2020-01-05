#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH -p node03-06

# Kallisto | Bustools
~/.pyenv/bin/pyenv local 3.6.4
~/.pyenv/shims/pip3 install kb-python
