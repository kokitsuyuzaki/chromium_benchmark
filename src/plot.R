library("Seurat")

# Loading
load("output/cellranger/cellranger.RData")
load("output/alevin/alevin.RData")
load("output/kb/kb.RData")

tmp <- read.csv(
    "output/cellranger/5k_pbmc/outs/analysis/clustering/graphclust/clusters.csv",
    header=TRUE, row.names=1)
celltypes <- unlist(tmp)
names(celltypes) <- rownames(tmp)

# Data size
cat("##### Digital Expression Matrix of CellRanger #####\n")
# 33538  5527
print(dim(res_cellranger))
cat("##### Digital Expression Matrix of Alevin #####\n")
# 20312  6074 (w/o Whitelist of CellRanger)
# ?????  ????? (w Whitelist of CellRanger)
print(dim(res_alevin))
cat("##### Digital Expression Matrix of Kallisto|Bustools #####\n")
 # 60623 839633 (w/o Whitelist of CellRanger)
 # ?????  ????? (w Whitelist of CellRanger)
print(dim(res_kb))

# kbがでかすぎる、alevinとcellranger間に重複がなさすぎる
length(intersect(colnames(res_cellranger), colnames(res_alevin)))
length(intersect(colnames(res_alevin), colnames(res_kb)))
length(intersect(colnames(res_kb), colnames(res_cellranger)))


# Quantile
cat("##### Quantile of CellRanger #####\n")
print(quantile(res_cellranger))
cat("##### Quantile of Alevin #####\n")
print(quantile(res_alevin))
cat("##### Quantile of Kallisto|Bustools #####\n")
print(quantile(res_kb))

# Seurat object
so_cellranger <- CreateSeuratObject(counts = res_cellranger)
so_alevin <- CreateSeuratObject(counts = res_alevin)
so_kb <- CreateSeuratObject(counts = res_kb)

# 累積UMIカウント曲線


# 検出遺伝子（細胞型ごと）


# Highly Variable Genes
# pbmc <- FindVariableFeatures(object = pbmc,
#     mean.function = ExpMean, dispersion.function = LogVMR,
#     x.low.cutoff = 0.0125, x.high.cutoff = 3,
#     y.cutoff = 0.5, nfeatures = 2000)

# PCA
so_cellranger <- RunPCA(object=so_cellranger, npcs=30, verbose=FALSE)
so_alevin <- RunPCA(object=so_alevin, npcs=30, verbose=FALSE)
so_kb <- RunPCA(
    object=so_kb, npcs=30, verbose=FALSE)

# t-SNE
so_cellranger <- RunTSNE(object=so_cellranger, dims.use=1:10, do.fast=TRUE)
so_alevin <- RunTSNE(object=so_alevin, dims.use=1:10, do.fast=TRUE)
so_kb <- RunTSNE(
    object=so_kb, dims.use=1:10, do.fast=TRUE)

# UMAP
so_cellranger <- RunUMAP(object=so_cellranger, reduction="pca", dims=1:20)
so_alevin <- RunUMAP(object=so_alevin, reduction="pca", dims=1:20)
so_kb <- RunUMAP(
    object=so_kb, reduction="pca", dims=1:20)

# Plot

DimPlot(object = pbmc, reduction = "pca")

DimPlot(object = pbmc, reduction = "tsne")

DimPlot(pbmc, reduction = "umap")

