#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --requeue
#SBATCH -p node03-06

ti=`cat logs/cellranger.log | grep "Elapsed" | sed -e "s|Elapsed (wall clock) time (h:mm:ss or m:ss): ||g"`
echo "CellRanger "$ti > output/time.txt

ti=`cat logs/salmon_index.log | grep "Elapsed" | sed -e "s|Elapsed (wall clock) time (h:mm:ss or m:ss): ||g"`
echo "Salmon_index "$ti >> output/time.txt

ti=`cat logs/alevin.log | grep "Elapsed" | sed -e "s|Elapsed (wall clock) time (h:mm:ss or m:ss): ||g"`
echo "Alevin "$ti >> output/time.txt

ti=`cat logs/alevin_10xwhitelist.log | grep "Elapsed" | sed -e "s|Elapsed (wall clock) time (h:mm:ss or m:ss): ||g"`
echo "Alevin_10X_whitelist "$ti >> output/time.txt

ti=`cat logs/alevin_filteredwhitelist.log | grep "Elapsed" | sed -e "s|Elapsed (wall clock) time (h:mm:ss or m:ss): ||g"`
echo "Alevin_filtered_whitelist "$ti >> output/time.txt

ti=`cat logs/kallisto_index.log | grep "Elapsed" | sed -e "s|Elapsed (wall clock) time (h:mm:ss or m:ss): ||g"`
echo "Kallisto_index "$ti >> output/time.txt

ti=`cat logs/kb.log | grep "Elapsed" | sed -e "s|Elapsed (wall clock) time (h:mm:ss or m:ss): ||g"`
echo "Kallisto_Bustools "$ti >> output/time.txt

ti=`cat logs/kb_10xwhitelist.log | grep "Elapsed" | sed -e "s|Elapsed (wall clock) time (h:mm:ss or m:ss): ||g"`
echo "Kallisto_Bustools_10X_whitelist "$ti >> output/time.txt

ti=`cat logs/kb_filteredwhitelist.log | grep "Elapsed" | sed -e "s|Elapsed (wall clock) time (h:mm:ss or m:ss): ||g"`
echo "Kallisto_filtered_whitelist "$ti >> output/time.txt
