#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --requeue
#SBATCH -p node03-06

ti=`cat logs/cellranger.log | grep "Maximum" | sed -e "s|Maximum resident set size (kbytes):||g"`
echo "CellRanger "$ti > output/memory.txt

ti=`cat logs/salmon_index.log | grep "Maximum" | sed -e "s|Maximum resident set size (kbytes):||g"`
echo "Salmon_index "$ti >> output/memory.txt

ti=`cat logs/alevin.log | grep "Maximum" | sed -e "s|Maximum resident set size (kbytes):||g"`
echo "Alevin "$ti >> output/memory.txt

ti=`cat logs/alevin_10xwhitelist.log | grep "Maximum" | sed -e "s|Maximum resident set size (kbytes):||g"`
echo "Alevin_10X_whitelist "$ti >> output/memory.txt

ti=`cat logs/alevin_filteredwhitelist.log | grep "Maximum" | sed -e "s|Maximum resident set size (kbytes):||g"`
echo "Alevin_filtered_whitelist "$ti >> output/memory.txt

ti=`cat logs/kallisto_index.log | grep "Maximum" | sed -e "s|Maximum resident set size (kbytes):||g"`
echo "Kallisto_index "$ti >> output/memory.txt

ti=`cat logs/kb.log | grep "Maximum" | sed -e "s|Maximum resident set size (kbytes):||g"`
echo "Kallisto_Bustools "$ti >> output/memory.txt

ti=`cat logs/kb_10xwhitelist.log | grep "Maximum" | sed -e "s|Maximum resident set size (kbytes):||g"`
echo "Kallisto_Bustools_10X_whitelist "$ti >> output/memory.txt

ti=`cat logs/kb_filteredwhitelist.log | grep "Maximum" | sed -e "s|Maximum resident set size (kbytes):||g"`
echo "Kallisto_filtered_whitelist "$ti >> output/memory.txt
