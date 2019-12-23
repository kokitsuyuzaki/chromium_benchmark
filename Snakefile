HOME = '/home/koki/Dev/chromium_benchmark/'

rule install:
    shell: HOME + 'src/install.sh'

#
# Workflow type I: CellRanger → Seurat
#
rule cellranger:
    shell: HOME + 'src/cellranger.sh'

rule cellranger_seurat:
    shell: HOME + 'src/cellranger_seurat.sh'

#
# Workflow type II: Alevin → Tximport
#
rule salmon_index:
    shell: HOME + 'src/salmon_index.sh'

rule alevin:
    shell: HOME + 'src/alevin.sh'

rule alevin_10xwhitelist:
    shell: HOME + 'src/alevin_10xwhitelist.sh'

rule alevin_filteredwhitelist:
    shell: HOME + 'src/alevin_filteredwhitelist.sh'

rule alevin_tximport:
    shell: HOME + 'src/alevin_tximport.sh'

#
# Workflow type III: Kallisto | Bustools → BUSpaRse
#
rule kallisto_index:
    shell: HOME + 'src/kallisto_index.sh'

rule kb:
    shell: HOME + 'src/kb.sh'

rule kb_10xwhitelist:
    shell: HOME + 'src/kb_10xwhitelist.sh'

rule kb_filteredwhitelist:
    shell: HOME + 'src/kb_filteredwhitelist.sh'

rule kb_busparse:
    shell: HOME + 'src/kb_busparse.sh'

#
# Plot
#
rule plot:
    shell: HOME + 'src/plot.sh'
