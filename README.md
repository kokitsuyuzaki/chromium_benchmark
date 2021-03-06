# chromium_benchmark
Comparison of 10X Chromium, Alevin, and Kallisto | Bustools

# Requirements
- Python (>= 3.6.4)
- Snakemake (>= 5.8.1)
- Graphviz (>= 2.30.1)
- R/Rscript (>= 3.6.0)
- GNU wget (>= 1.14)
- GNU tar (>= 1.26)
- GNU gunzip (>= 1.5)
- GNU time (>=1.7)
- Singularity (>= 2.6.1)
- Docker (>= 17.09.0)

# How to reproduce this workflow

In local machine environment, type as follows:

```
snakemake --use-conda --use-singularity --latency-wait 60
```

In Grid Engine environment, type as follows:

```
snakemake --use-conda --use-singularity --latency-wait 60 -j 32 --cluster qsub
```

In Slurm environment, type as follows:

```
snakemake --use-conda --use-singularity --latency-wait 60 -j 32 --cluster sbatch
```

To reproduce the DAG figure file, type as follows:

```
snakemake --dag | dot -Tpng > dag.png
```

To reproduce the HTML report, type as follows:

```
snakemake --report report.html
```

# Reference
- PBMC_5k (v3): https://support.10xgenomics.com/single-cell-gene-expression/datasets/3.0.2/5k_pbmc_v3
- Whitelist :
  - What is barcodelist? : https://kb.10xgenomics.com/hc/en-us/articles/115004506263-What-is-a-barcode-whitelist-
  - 10xv3_whitelist.txt : https://github.com/BUStools/getting_started/releases/tag/species_mixing
- GENCODE : https://www.gencodegenes.org/human/#
- CellRanger : https://support.10xgenomics.com/single-cell-gene-expression/software/downloads/latest?
- Alevin
  - Document : https://salmon.readthedocs.io/en/latest/alevin.html
  - Alevin-Tutorial : https://combine-lab.github.io/alevin-tutorial/#blog
  - txp2gene.tsv : https://github.com/COMBINE-lab/salmon/issues/336
- Kallisto | Bustools
  - Getting Started : https://www.kallistobus.tools/getting_started
  - Getting Started Explained : https://www.kallistobus.tools/getting_started_explained.html
  - Tutorials : https://www.kallistobus.tools/tutorials
  - Processing Multiple Lanes at Once : https://www.kallistobus.tools/multiple_files_tutorial.html
  - Notebooks : https://github.com/pachterlab/kallistobustools/tree/master/notebooks
- Seurat : https://satijalab.org/seurat/essential_commands.html
- tximport : https://bioconductor.org/packages/devel/bioc/vignettes/tximport/inst/doc/tximport.html
- BUSpaRse : https://www.bioconductor.org/packages/release/bioc/html/BUSpaRse.html
- DropletUtils : https://bioconductor.org/packages/release/bioc/html/DropletUtils.html
- Snakemake : https://snakemake.readthedocs.io/en/stable/index.html
- r.yaml : https://github.com/kokitsuyuzaki/Dockerfiles/blob/master/chromium_benchmark_r/Dockerfile