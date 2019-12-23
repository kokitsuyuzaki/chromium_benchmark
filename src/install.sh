#!/bin/bash

##################################
# Tools
##################################

# CellRanger
wget -O tool/cellranger/cellranger-3.1.0.tar.gz "http://cf.10xgenomics.com/releases/cell-exp/cellranger-3.1.0.tar.gz?Expires=1576782641&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cDovL2NmLjEweGdlbm9taWNzLmNvbS9yZWxlYXNlcy9jZWxsLWV4cC9jZWxscmFuZ2VyLTMuMS4wLnRhci5neiIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTU3Njc4MjY0MX19fV19&Signature=j5cw~qaALYiixpevV2aksOR8gojSKJGUAVuxv8nrWp2LQiAVaQvfVAplnOLZRFYCM4dFZO5gjWX7YPR0TYHEiEaLWbnkdyzUajPIo7zLveCbkjFmh8JM3TyLbAGwrIeUc1ap~oyqvINVgsdy0l7HRbgQ6TWfb4IqIaIAN2gGZTEoNlHaDvFjWMYGmbLUSpjhMZrEf-ulcQwa4Fqho6l8JxyU3xShtpy04Gtn2r~s48LzKBRANMMGLmyd8o9vAvXpF0BGM6e4JA31QPKhrFneRPZZw4AxXkTtYYbO~UE6YlVVhfl4WuwPcCTB~JU4CU6QFp5mW0MefySSg1uMOe8DhQ__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"
tar zxvf tool/cellranger/cellranger-3.1.0.tar.gz -C tool/cellranger

# Alevin
wget -O tool/alevin/salmon-1.1.0_linux_x86_64.tar.gz https://github.com/COMBINE-lab/salmon/releases/download/v1.1.0/salmon-1.1.0_linux_x86_64.tar.gz
tar zxvf tool/alevin/salmon-1.1.0_linux_x86_64.tar.gz -C tool/alevin

# Kallisto | Bustools
pip3 install kb-python

# R packages
R -e 'install.packages(c("BiocManager", "Seurat"), repos="http://cran.r-project.org");BiocManager::install(c("tximport", "BUSpaRse"), suppressUpdates=TRUE)'

##################################
# Data
##################################

# Reference Genome
wget -P data http://cf.10xgenomics.com/supp/cell-exp/refdata-cellranger-GRCh38-3.0.0.tar.gz
tar zxvf data/refdata-cellranger-GRCh38-3.0.0.tar.gz -C data

# Reference Transcriptome
wget -P data ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_32/gencode.v32.pc_transcripts.fa.gz

# Comprehensive gene annotation
wget -P data ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_32/gencode.v32.primary_assembly.annotation.gtf.gz
gunzip -c data/gencode.v32.primary_assembly.annotation.gtf.gz | grep transcript | awk '{print $12,$10}' | sed -e 's|"||g' -e 's|;||g' | uniq > data/txp2gene.tsv

# PBMCs data on 10X Genomics site
wget -P data http://cf.10xgenomics.com/samples/cell-exp/3.1.0/5k_pbmc_protein_v3/5k_pbmc_protein_v3_fastqs.tar
tar xvf data/5k_pbmc_protein_v3_fastqs.tar -C data

# 10X whitelist
gunzip -c tool/cellranger/cellranger-3.1.0/cellranger-cs//3.1.0/lib/python/cellranger/barcodes/3M-february-2018.txt.gz > data/10xv3_whitelist.txt
