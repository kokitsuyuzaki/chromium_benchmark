#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --requeue
#SBATCH -p node03-06

# CellRanger
wget -O tools/cellranger/cellranger-3.1.0.tar.gz "http://cf.10xgenomics.com/releases/cell-exp/cellranger-3.1.0.tar.gz?Expires=1577648130&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cDovL2NmLjEweGdlbm9taWNzLmNvbS9yZWxlYXNlcy9jZWxsLWV4cC9jZWxscmFuZ2VyLTMuMS4wLnRhci5neiIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTU3NzY0ODEzMH19fV19&Signature=C0OV0XOdhw0QbDE~IZFY-nb1dBCQRfZDhSABF4klF-Tnd3iCyhGgDG1Dz0mRI5x-E70SnoxOfs8cPilkbUis8Sd4hRb~nOR5fsf2eOY4~Y4jhNL~4pjqw1kIDPwp0H1fnswsuyEVyMDUZgMb43gRAh-wSI9BGRmm3dhKJGG7lbg8IJrYynRIBj6i1hh5MBYh8WghHicq0oBB4zpZUvRvCqvb81T29NcLPyAUfoO~ITBYz8i3t-1AW2U7fkNCxsfqqnk8SVcO-qiQeb3S1BEfZ8hwq3U6AEkeAL2P7N5s8blTrVSHQgrRYv7n83xJ2ref762XaZINqjpCzi2NdKC9Fg__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"
tar zxvf tools/cellranger/cellranger-3.1.0.tar.gz -C tools/cellranger
