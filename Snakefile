from snakemake.utils import min_version

#
# Setting
#
min_version("5.8.1")
configfile: "config.yaml"

rule all:
    input:
        config["FINALPLOT"],
        config["TIMEPLOT"],
        config["MEMORYPLOT"]

rule install_cellranger:
    output:
        config["CELLRANGER"]
    log:
        'logs/install_cellranger.log'
    shell:
        '/usr/bin/time -v src/install_cellranger.sh >& {log}'

rule tenxwhitelist:
    input:
        config["CELLRANGER"]
    output:
        config["TENX_WHITELIST"]
    log:
        'logs/tenxwhitelist.log'
    shell:
        '/usr/bin/time -v src/tenxwhitelist.sh >& {log}'

rule install_alevin:
    output:
        config["SALMON"]
    log:
        'logs/install_alevin.log'
    shell:
        '/usr/bin/time -v src/install_alevin.sh >& {log}'

rule install_kb:
    output:
        config["KB"]
    log:
        'logs/install_kb.log'
    shell:
        '/usr/bin/time -v src/install_kb.sh >& {log}'

rule install_Rpkg:
    output:
        config["RPKG1"],
        config["RPKG2"],
        config["RPKG3"],
        config["RPKG4"],
        config["RPKG5"],
        config["RPKG6"],
        config["RPKG7"],
        config["RPKG8"]
    log:
        'logs/install_Rpkg.log'
    shell:
        '/usr/bin/time -v src/install_Rpkg.sh >& {log}'

rule download_genome:
    output:
        config["GENOME"]
    log:
        'logs/download_genome.log'
    shell:
        '/usr/bin/time -v src/download_genome.sh >& {log}'

rule download_transcriptome:
    output:
        config["TRANSCRIPTOME"]
    log:
        'logs/download_transcriptome.log'
    shell:
        '/usr/bin/time -v src/download_transcriptome.sh >& {log}'

rule download_geneannotation:
    output:
        config["ANNOTATION"],
        config["T2G_ALEVIN"]
    log:
        'logs/download_geneannotation.log'
    shell:
        '/usr/bin/time -v src/download_geneannotation.sh >& {log}'

rule download_fastq:
    output:
        config["FASTQ"]
    log:
        'logs/download_fastq.log'
    shell:
        '/usr/bin/time -v src/download_fastq.sh >& {log}'

#
# Workflow type I: CellRanger → Seurat
#

rule cellranger:
    input:
        config["CELLRANGER"],
        config["GENOME"],
        config["FASTQ"]
    output:
        config["OUT_CELLRANGER"],
        'logs/cellranger.log'
    log:
        'logs/cellranger.log'
    shell:
        '/usr/bin/time -v src/cellranger.sh >& {log}'

rule filtered_whitelist:
    input:
        config["OUT_CELLRANGER"]
    output:
        config["FILTERED_WHITELIST"]
    log:
        'logs/filtered_whitelist.log'
    shell:
        '/usr/bin/time -v src/filtered_whitelist.sh >& {log}'

rule cellranger_seurat:
    input:
        config["OUT_CELLRANGER"]
    output:
        config["ROUT_CELLRANGER"]
    log:
        'logs/cellranger_seurat.log'
    shell:
        '/usr/bin/time -v src/cellranger_seurat.sh >& {log}'


#
# Workflow type II: Alevin → Tximport
#

rule salmon_index:
    input:
        config["SALMON"],
        config["TRANSCRIPTOME"]
    output:
        config["SALMON_INDEX"],
        'logs/salmon_index.log'
    log:
        'logs/salmon_index.log'
    shell:
        '/usr/bin/time -v src/salmon_index.sh >& {log}'

rule alevin:
    input:
        config["SALMON"],
        config["SALMON_INDEX"],
        config["FASTQ"],
        config["T2G_ALEVIN"]
    output:
        config["OUT_ALEVIN"],
        'logs/alevin.log'
    log:
        'logs/alevin.log'
    shell:
        '/usr/bin/time -v src/alevin.sh >& {log}'

rule alevin_10xwhitelist:
    input:
        config["SALMON"],
        config["SALMON_INDEX"],
        config["FASTQ"],
        config["T2G_ALEVIN"],
        config["TENX_WHITELIST"]
    output:
        config["OUT_ALEVIN_10X"],
        'logs/alevin_10xwhitelist.log'
    log:
        'logs/alevin_10xwhitelist.log'
    shell:
        '/usr/bin/time -v src/alevin_10xwhitelist.sh >& {log}'

rule alevin_filteredwhitelist:
    input:
        config["SALMON"],
        config["SALMON_INDEX"],
        config["FASTQ"],
        config["T2G_ALEVIN"],
        config["FILTERED_WHITELIST"]
    output:
        config["OUT_ALEVIN_FILTERED"],
        'logs/alevin_filteredwhitelist.log'
    log:
        'logs/alevin_filteredwhitelist.log'
    shell:
        '/usr/bin/time -v src/alevin_filteredwhitelist.sh >& {log}'

rule alevin_tximport:
    input:
        config["OUT_ALEVIN"],
        config["OUT_ALEVIN_10X"],
        config["OUT_ALEVIN_FILTERED"],
        config["RPKG1"],
        config["RPKG2"],
        config["RPKG3"],
        config["RPKG4"],
        config["RPKG5"],
        config["RPKG6"],
        config["RPKG7"],
        config["RPKG8"]
    output:
        config["ROUT_ALEVIN"],
        config["ROUT_ALEVIN_TENX"],
        config["ROUT_ALEVIN_FILTERED"]
    log:
        'logs/alevin_tximport.log'
    shell:
        '/usr/bin/time -v src/alevin_tximport.sh >& {log}'


#
# Workflow type III: Kallisto | Bustools → BUSpaRse
#

rule kallisto_index:
    input:
        config["KB"]
    output:
        config["KALLISTO_INDEX"],
        config["T2G_KALLISTO"],
        'logs/kallisto_index.log'
    log:
        'logs/kallisto_index.log'
    shell:
        '/usr/bin/time -v src/kallisto_index.sh >& {log}'

rule kb:
    input:
        config["KALLISTO_INDEX"],
        config["T2G_KALLISTO"],
        config["FASTQ"]
    output:
        config["OUT_KALLISTO"],
        'logs/kb.log'
    log:
        'logs/kb.log'
    shell:
        '/usr/bin/time -v src/kb.sh >& {log}'

rule kb_10xwhitelist:
    input:
        config["KALLISTO_INDEX"],
        config["T2G_KALLISTO"],
        config["FASTQ"],
        config["TENX_WHITELIST"]
    output:
        config["OUT_KALLISTO_TENX"],
        'logs/kb_10xwhitelist.log'
    log:
        'logs/kb_10xwhitelist.log'
    shell:
        '/usr/bin/time -v src/kb_10xwhitelist.sh >& {log}'

rule kb_filteredwhitelist:
    input:
        config["KALLISTO_INDEX"],
        config["T2G_KALLISTO"],
        config["FASTQ"],
        config["FILTERED_WHITELIST"]
    output:
        config["OUT_KALLISTO_FILTERED"],
        'logs/kb_filteredwhitelist.log'
    log:
        'logs/kb_filteredwhitelist.log'
    shell:
        '/usr/bin/time -v src/kb_filteredwhitelist.sh >& {log}'

rule kb_busparse:
    input:
        config["OUT_KALLISTO"],
        config["OUT_KALLISTO_TENX"],
        config["OUT_KALLISTO_FILTERED"],
        config["RPKG1"],
        config["RPKG2"],
        config["RPKG3"],
        config["RPKG4"],
        config["RPKG5"],
        config["RPKG6"],
        config["RPKG7"],
        config["RPKG8"]
    output:
        config["ROUT_KALLISTO"],
        config["ROUT_KALLISTO_TENX"],
        config["ROUT_KALLISTO_FILTERED"]
    log:
        'logs/kb_busparse.log'
    shell:
        '/usr/bin/time -v src/kb_busparse.sh >& {log}'


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
        config["ROUT_KALLISTO_FILTERED"],
        config["RPKG1"],
        config["RPKG2"],
        config["RPKG3"],
        config["RPKG4"],
        config["RPKG5"],
        config["RPKG6"],
        config["RPKG7"],
        config["RPKG8"]
    output:
        config["FINALPLOT"]
    log:
        'logs/summary.log'
    shell:
        '/usr/bin/time -v src/summary.sh >& {log}'

#
# Time
#
rule summary_time:
    input:
        'logs/cellranger.log',
        'logs/salmon_index.log',
        'logs/alevin.log',
        'logs/alevin_10xwhitelist.log',
        'logs/alevin_filteredwhitelist.log',
        'logs/kallisto_index.log',
        'logs/kb.log',
        'logs/kb_10xwhitelist.log',
        'logs/kb_filteredwhitelist.log'
    output:
        config["OUT_TIME"]
    log:
        'logs/summary_time.log'
    shell:
        '/usr/bin/time -v src/summary_time.sh >& {log}'

rule plot_time:
    input:
        config["OUT_TIME"]
    output:
        config["TIMEPLOT"]
    log:
        'logs/plot_time.log'
    shell:
        '/usr/bin/time -v src/plot_time.sh >& {log}'

#
# Memory
#
rule summary_memory:
    input:
        'logs/cellranger.log',
        'logs/salmon_index.log',
        'logs/alevin.log',
        'logs/alevin_10xwhitelist.log',
        'logs/alevin_filteredwhitelist.log',
        'logs/kallisto_index.log',
        'logs/kb.log',
        'logs/kb_10xwhitelist.log',
        'logs/kb_filteredwhitelist.log'
    output:
        config["OUT_MEMORY"]
    log:
        'logs/summary_memory.log'
    shell:
        '/usr/bin/time -v src/summary_memory.sh >& {log}'

rule plot_memory:
    input:
        config["OUT_MEMORY"]
    output:
        config["MEMORYPLOT"]
    log:
        'logs/plot_memory.log'
    shell:
        '/usr/bin/time -v src/plot_memory.sh >& {log}'
