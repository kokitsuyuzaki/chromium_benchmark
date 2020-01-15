from snakemake.utils import min_version

#
# Setting
#
min_version("5.8.1")
configfile: "config.yaml"

rule all:
    input:
        config["FINALPLOT"],
        config["FINALPLOT2"],
        config["TIMEPLOT"],
        config["MEMORYPLOT"]

rule tenxwhitelist:
    output:
        config["TENX_WHITELIST"]
    singularity:
        'docker://sccloud/cellranger:3.1.0'
    benchmark:
        'benchmarks/tenxwhitelist.txt'
    log:
        'logs/tenxwhitelist.log'
    shell:
        'src/tenxwhitelist.sh >& {log}'

rule download_genome:
    output:
        config["GENOME"]
    benchmark:
        'benchmarks/download_genome.txt'
    log:
        'logs/download_genome.log'
    shell:
        'src/download_genome.sh >& {log}'

rule download_transcriptome:
    output:
        config["TRANSCRIPTOME"]
    benchmark:
        'benchmarks/download_transcriptome.txt'
    log:
        'logs/download_transcriptome.log'
    shell:
        'src/download_transcriptome.sh >& {log}'

rule download_geneannotation:
    output:
        config["ANNOTATION"],
        config["T2G_ALEVIN"]
    benchmark:
        'benchmarks/download_geneannotation.txt'
    log:
        'logs/download_geneannotation.log'
    shell:
        'src/download_geneannotation.sh >& {log}'

rule download_fastq:
    output:
        config["FASTQ"]
    benchmark:
        'benchmarks/download_fastq.txt'
    log:
        'logs/download_fastq.log'
    shell:
        'src/download_fastq.sh >& {log}'

#
# Workflow type I: CellRanger → Seurat
#

rule cellranger:
    input:
        config["GENOME"],
        config["FASTQ"]
    output:
        config["OUT_CELLRANGER"],
        'benchmarks/cellranger.txt'
    singularity:
        'docker://sccloud/cellranger:3.1.0'
    benchmark:
        'benchmarks/cellranger.txt'
    log:
        'logs/cellranger.log'
    shell:
        'src/cellranger.sh >& {log}'

rule filtered_whitelist:
    input:
        config["OUT_CELLRANGER"]
    output:
        config["FILTERED_WHITELIST"]
    benchmark:
        'benchmarks/filtered_whitelist.txt'
    log:
        'logs/filtered_whitelist.log'
    shell:
        'src/filtered_whitelist.sh >& {log}'

rule cellranger_seurat:
    input:
        config["OUT_CELLRANGER"]
    output:
        config["ROUT_CELLRANGER"]
    singularity:
        "docker://conda/miniconda3:latest"
    conda:
        'envs/r.yaml'
    benchmark:
        'benchmarks/cellranger_seurat.txt'
    log:
        'logs/cellranger_seurat.log'
    shell:
        'src/cellranger_seurat.sh >& {log}'

#
# Workflow type II: Alevin → Tximport
#

rule salmon_index:
    input:
        config["TRANSCRIPTOME"]
    output:
        config["SALMON_INDEX"],
        'benchmarks/salmon_index.txt'
    singularity:
        'docker://combinelab/salmon:1.1.0'
    benchmark:
        'benchmarks/salmon_index.txt'
    log:
        'logs/salmon_index.log'
    shell:
        'src/salmon_index.sh >& {log}'

rule alevin:
    input:
        config["SALMON_INDEX"],
        config["FASTQ"],
        config["T2G_ALEVIN"]
    output:
        config["OUT_ALEVIN"],
        'benchmarks/alevin.txt'
    singularity:
        'docker://combinelab/salmon:1.1.0'
    benchmark:
        'benchmarks/alevin.txt'
    log:
        'logs/alevin.log'
    shell:
        'src/alevin.sh >& {log}'

rule alevin_10xwhitelist:
    input:
        config["SALMON_INDEX"],
        config["FASTQ"],
        config["T2G_ALEVIN"],
        config["TENX_WHITELIST"]
    output:
        config["OUT_ALEVIN_10X"],
        'benchmarks/alevin_10xwhitelist.txt'
    singularity:
        'docker://combinelab/salmon:1.1.0'
    benchmark:
        'benchmarks/alevin_10xwhitelist.txt'
    log:
        'logs/alevin_10xwhitelist.log'
    shell:
        'src/alevin_10xwhitelist.sh >& {log}'

rule alevin_filteredwhitelist:
    input:
        config["SALMON_INDEX"],
        config["FASTQ"],
        config["T2G_ALEVIN"],
        config["FILTERED_WHITELIST"]
    output:
        config["OUT_ALEVIN_FILTERED"],
        'benchmarks/alevin_filteredwhitelist.txt'
    singularity:
        'docker://combinelab/salmon:1.1.0'
    benchmark:
        'benchmarks/alevin_filteredwhitelist.txt'
    log:
        'logs/alevin_filteredwhitelist.log'
    shell:
        'src/alevin_filteredwhitelist.sh >& {log}'

rule alevin_tximport:
    input:
        config["OUT_ALEVIN"],
        config["OUT_ALEVIN_10X"],
        config["OUT_ALEVIN_FILTERED"]
    output:
        config["ROUT_ALEVIN"],
        config["ROUT_ALEVIN_TENX"],
        config["ROUT_ALEVIN_FILTERED"]
    singularity:
        "docker://conda/miniconda3:latest"
    conda:
        'envs/r.yaml'
    benchmark:
        'benchmarks/alevin_tximport.txt'
    log:
        'logs/alevin_tximport.log'
    shell:
        'src/alevin_tximport.sh >& {log}'


#
# Workflow type III: Kallisto | Bustools → BUSpaRse
#

rule kallisto_index:
    output:
        config["KALLISTO_INDEX"],
        config["T2G_KALLISTO"],
        'benchmarks/kallisto_index.txt'
    singularity:
        'docker://koki/kb_python:0.24.4'
    benchmark:
        'benchmarks/kallisto_index.txt'
    log:
        'logs/kallisto_index.log'
    shell:
        'src/kallisto_index.sh >& {log}'

rule kb:
    input:
        config["KALLISTO_INDEX"],
        config["T2G_KALLISTO"],
        config["FASTQ"]
    output:
        config["OUT_KALLISTO"],
        'benchmarks/kb.txt'
    singularity:
        'docker://koki/kb_python:0.24.4'
    benchmark:
        'benchmarks/kb.txt'
    log:
        'logs/kb.log'
    shell:
        'src/kb.sh >& {log}'

rule kb_10xwhitelist:
    input:
        config["KALLISTO_INDEX"],
        config["T2G_KALLISTO"],
        config["FASTQ"],
        config["TENX_WHITELIST"]
    output:
        config["OUT_KALLISTO_TENX"],
        'benchmarks/kb_10xwhitelist.txt'
    singularity:
        'docker://koki/kb_python:0.24.4'
    benchmark:
        'benchmarks/kb_10xwhitelist.txt'
    log:
        'logs/kb_10xwhitelist.log'
    shell:
        'src/kb_10xwhitelist.sh >& {log}'

rule kb_filteredwhitelist:
    input:
        config["KALLISTO_INDEX"],
        config["T2G_KALLISTO"],
        config["FASTQ"],
        config["FILTERED_WHITELIST"]
    output:
        config["OUT_KALLISTO_FILTERED"],
        'benchmarks/kb_filteredwhitelist.txt'
    singularity:
        'docker://koki/kb_python:0.24.4'
    benchmark:
        'benchmarks/kb_filteredwhitelist.txt'
    log:
        'logs/kb_filteredwhitelist.log'
    shell:
        'src/kb_filteredwhitelist.sh >& {log}'

rule kb_busparse:
    input:
        config["OUT_KALLISTO"],
        config["OUT_KALLISTO_TENX"],
        config["OUT_KALLISTO_FILTERED"]
    output:
        config["ROUT_KALLISTO"],
        config["ROUT_KALLISTO_TENX"],
        config["ROUT_KALLISTO_FILTERED"]
    singularity:
        "docker://conda/miniconda3:latest"
    conda:
        'envs/r.yaml'
    benchmark:
        'benchmarks/kb_busparse.txt'
    log:
        'logs/kb_busparse.log'
    shell:
        'src/kb_busparse.sh >& {log}'


#
# Summary
#
rule summary:
    input:
        config["ROUT_CELLRANGER"],
        config["ROUT_ALEVIN"],
        config["ROUT_ALEVIN_TENX"],
        config["ROUT_ALEVIN_FILTERED"],
        config["ROUT_KALLISTO"],
        config["ROUT_KALLISTO_TENX"],
        config["ROUT_KALLISTO_FILTERED"]
    output:
        config["FINALPLOT"]
    singularity:
        "docker://conda/miniconda3:latest"
    conda:
        'envs/r.yaml'
    benchmark:
        'benchmarks/summary.txt'
    log:
        'logs/summary.log'
    shell:
        'src/summary.sh >& {log}'

rule summary_samegenes:
    input:
        config["ROUT_CELLRANGER"],
        config["ROUT_ALEVIN"],
        config["ROUT_ALEVIN_TENX"],
        config["ROUT_ALEVIN_FILTERED"],
        config["ROUT_KALLISTO"],
        config["ROUT_KALLISTO_TENX"],
        config["ROUT_KALLISTO_FILTERED"]
    output:
        config["FINALPLOT2"]
    singularity:
        "docker://conda/miniconda3:latest"
    conda:
        'envs/r.yaml'
    benchmark:
        'benchmarks/summary_samegenes.txt'
    log:
        'logs/summary_samegenes.log'
    shell:
        'src/summary_samegenes.sh >& {log}'

#
# Time
#
rule plot_time:
    input:
        config["ROUT_CELLRANGER"],
        config["ROUT_ALEVIN"],
        config["ROUT_ALEVIN_TENX"],
        config["ROUT_ALEVIN_FILTERED"],
        config["ROUT_KALLISTO"],
        config["ROUT_KALLISTO_TENX"],
        config["ROUT_KALLISTO_FILTERED"],
        'benchmarks/cellranger.txt',
        'benchmarks/salmon_index.txt',
        'benchmarks/alevin.txt',
        'benchmarks/alevin_10xwhitelist.txt',
        'benchmarks/alevin_filteredwhitelist.txt',
        'benchmarks/kallisto_index.txt',
        'benchmarks/kb.txt',
        'benchmarks/kb_10xwhitelist.txt',
        'benchmarks/kb_filteredwhitelist.txt'
    output:
        config["TIMEPLOT"]
    singularity:
        "docker://conda/miniconda3:latest"
    conda:
        'envs/r.yaml'
    benchmark:
        'benchmarks/plot_time.txt'
    log:
        'logs/plot_time.log'
    shell:
        'src/plot_time.sh >& {log}'

#
# Memory
#
rule plot_memory:
    input:
        config["ROUT_CELLRANGER"],
        config["ROUT_ALEVIN"],
        config["ROUT_ALEVIN_TENX"],
        config["ROUT_ALEVIN_FILTERED"],
        config["ROUT_KALLISTO"],
        config["ROUT_KALLISTO_TENX"],
        config["ROUT_KALLISTO_FILTERED"],
        'benchmarks/cellranger.txt',
        'benchmarks/salmon_index.txt',
        'benchmarks/alevin.txt',
        'benchmarks/alevin_10xwhitelist.txt',
        'benchmarks/alevin_filteredwhitelist.txt',
        'benchmarks/kallisto_index.txt',
        'benchmarks/kb.txt',
        'benchmarks/kb_10xwhitelist.txt',
        'benchmarks/kb_filteredwhitelist.txt'
    output:
        config["MEMORYPLOT"]
    singularity:
        "docker://conda/miniconda3:latest"
    conda:
        'envs/r.yaml'
    benchmark:
        'benchmarks/plot_memory.txt'
    log:
        'logs/plot_memory.log'
    shell:
        'src/plot_memory.sh >& {log}'

rule clean:
    shell:
        'rm -rf data && '
        'rm -rf output && '
        'rm -rf plot && '
        'rm -rf logs && '
        'rm -rf benchmarks && '
        'rm -rf tools && '
        'rm -rf tmp && '
        'rm -rf *.sh.* && '
        'rm -rf *.out && '
        'rm -rf core.* && '
        'rm -rf *.simg && '
        'rm -rf ._* && '
        'rm -rf .conda && '
        'rm -rf *.sif'
