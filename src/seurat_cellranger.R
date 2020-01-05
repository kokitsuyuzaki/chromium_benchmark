library("Seurat")

# Data loading
res_cellranger <- Read10X("output/cellranger/5k_pbmc/outs/filtered_feature_bc_matrix")

# Data saving
save(res_cellranger, file="output/cellranger/cellranger.RData")
