library("Seurat")
library("VennDiagram")
library("DropletUtils")
library("ggplot2")

# Loading
load("output/cellranger/cellranger.RData")
load("output/alevin/alevin.RData")
load("output/alevin_10xwhitelist/alevin_10xwhitelist.RData")
load("output/alevin_filteredwhitelist/alevin_filteredwhitelist.RData")
load("output/kb/kb.RData")
load("output/kb_10xwhitelist/kb_10xwhitelist.RData")
load("output/kb_filteredwhitelist/kb_filteredwhitelist.RData")

tmp <- read.csv(
    "output/cellranger/5k_pbmc/outs/analysis/clustering/graphclust/clusters.csv",
    header=TRUE, row.names=1)
celltypes <- unlist(tmp)
names(celltypes) <- gsub("-1", "", rownames(tmp))

# Filtering
br.alevin <- barcodeRanks(res_alevin_10xwhitelist)
br.kb <- barcodeRanks(res_kb_10xwhitelist)
res_alevin_10xwhitelist_filtered <- res_alevin_10xwhitelist[,
    which(br.alevin$total >= metadata(br.alevin)$inflection)]
res_kb_10xwhitelist_filtered <- res_kb_10xwhitelist[,
    which(br.kb$total >= metadata(br.kb)$inflection)]

# Plot (QC by UMI count <Alevin>)
png(file="plot/UMI_Alevin_10X.png", width=700, height=550)
plot(br.alevin$rank, br.alevin$total, log="xy", xlab="Rank", ylab="Total")
o.alevin <- order(br.alevin$rank)
lines(br.alevin$rank[o.alevin], br.alevin$fitted[o.alevin], col="red")
abline(h=metadata(br.alevin)$knee, col="dodgerblue", lty=2)
abline(h=metadata(br.alevin)$inflection, col="forestgreen", lty=2)
legend("bottomleft", lty=2, col=c("dodgerblue", "forestgreen"),
    legend=c("knee", "inflection"))
dev.off()

# Plot (QC by UMI count <Kallisto | Bustools>)
png(file="plot/UMI_KB_10X.png", width=700, height=550)
plot(br.kb$rank, br.kb$total, log="xy", xlab="Rank", ylab="Total")
o.kb <- order(br.kb$rank)
lines(br.kb$rank[o.kb], br.kb$fitted[o.kb], col="red")
abline(h=metadata(br.kb)$knee, col="dodgerblue", lty=2)
abline(h=metadata(br.kb)$inflection, col="forestgreen", lty=2)
legend("bottomleft", lty=2, col=c("dodgerblue", "forestgreen"),
    legend=c("knee", "inflection"))
dev.off()

# Data size
# 33538 5244
cat("##### Digital Expression Matrix of CellRanger #####\n")
print(dim(res_cellranger))

# 20312 6074
cat("##### Digital Expression Matrix of Alevin (w/o whitelist) #####\n")
print(dim(res_alevin))
# 20312 631404
cat("##### Digital Expression Matrix of Alevin (w/ 10x whitelist and filtered) #####\n")
print(dim(res_alevin_10xwhitelist))
# 20312 5316
cat("##### Digital Expression Matrix of Alevin (w/ 10x whitelist) #####\n")
print(dim(res_alevin_10xwhitelist_filtered))
# 20312 5244
cat("##### Digital Expression Matrix of Alevin (w/ filtered whitelist) #####\n")
print(dim(res_alevin_filteredwhitelist))

# 60623 839633
cat("##### Digital Expression Matrix of Kallisto | Bustools #####\n")
print(dim(res_kb))
# 60623 839633
cat("##### Digital Expression Matrix of Kallisto | Bustools (w/ 10x whitelist) #####\n")
print(dim(res_kb_10xwhitelist))
# 60623 5304
cat("##### Digital Expression Matrix of Kallisto | Bustools (w/ 10x whitelist and filtered) #####\n")
print(dim(res_kb_10xwhitelist_filtered))
# 60623 5244
cat("##### Digital Expression Matrix of Kallisto | Bustools (w/ filtered whitelist) #####\n")
print(dim(res_kb_filteredwhitelist))

cat("##### Whether Kallisto | Bustools w/o whitelist option = Kallisto | Bustools w/ 10xv3_whitelist.txt #####\n")
print(identical(colnames(res_kb),
    colnames(res_kb_10xwhitelist)))

# Plot (Venn diagram)
venn.diagram(
    list(
        CellRanger=colnames(res_cellranger),
        Alevin=colnames(res_alevin),
        Alevin_10X=colnames(res_alevin_10xwhitelist),
        Alevin_10X_filtered=colnames(res_alevin_10xwhitelist_filtered),
        Alevin_filtered=colnames(res_alevin_filteredwhitelist)),
    fill = c("gray", "red", "orange", "pink", "yellow"),
    alpha = rep(0.5, 5),
    filename = "plot/Venn_Alevin_Barcode.png",
    height = 5000, width = 5000, resolution = 500,
    margin = 0.3,
    imagetype = "png"
)

venn.diagram(
    list(
        CellRanger=colnames(res_cellranger),
        KB=colnames(res_kb),
        KB_10X_filtered=colnames(res_kb_10xwhitelist_filtered),
        KB_filtered=colnames(res_kb_filteredwhitelist)),
    fill = c("gray", "blue", "green", "purple"),
    alpha = rep(0.5, 4),
    filename = "plot/Venn_KB_Barcode.png",
    height = 5000, width = 5000, resolution = 500,
    margin = 0.3,
    imagetype = "png"
)

venn.diagram(
    list(
        CellRanger=colnames(res_cellranger),
        Alevin_filtered=colnames(res_alevin_filteredwhitelist),
        Alevin_10X_filtered=colnames(res_alevin_10xwhitelist_filtered),
        KB_filtered=colnames(res_kb_filteredwhitelist),
        KB_10X_filtered=colnames(res_kb_10xwhitelist_filtered)),
    fill = c("gray", "yellow", "pink", "purple",  "green"),
    alpha = rep(0.5, 5),
    filename = "plot/Venn_Filtered_Barcode.png",
    height = 5000, width = 5000, resolution = 500,
    margin = 0.3,
    imagetype = "png"
)

# Remove temp file
system("rm -rf plot/*.log")

# Common Cellular Barcode
common.cb <- intersect(
    intersect(colnames(res_cellranger),
        colnames(res_alevin_filteredwhitelist)),
            colnames(res_kb_10xwhitelist))
celltypes <- celltypes[common.cb]

# Seurat object
so_cellranger <- CreateSeuratObject(counts=res_cellranger)
so_alevin <- CreateSeuratObject(counts=res_alevin)
so_alevin_10xwhitelist_filtered <- CreateSeuratObject(counts=res_alevin_10xwhitelist_filtered)
so_alevin_filteredwhitelist <- CreateSeuratObject(counts=res_alevin_filteredwhitelist)
so_kb_10xwhitelist_filtered <- CreateSeuratObject(counts=res_kb_10xwhitelist_filtered)
so_kb_filteredwhitelist <- CreateSeuratObject(counts=res_kb_filteredwhitelist)
so_cellranger_common <- CreateSeuratObject(counts=res_cellranger[, common.cb])
so_alevin_common <- CreateSeuratObject(counts=res_alevin_filteredwhitelist[, common.cb])
so_kb_common <- CreateSeuratObject(counts=res_kb_10xwhitelist[, common.cb])

# Highly Variable Genes
so_cellranger <- FindVariableFeatures(object=so_cellranger)
so_alevin <- FindVariableFeatures(object=so_alevin)
so_alevin_10xwhitelist_filtered <- FindVariableFeatures(object=so_alevin_10xwhitelist_filtered)
so_alevin_filteredwhitelist <- FindVariableFeatures(object=so_alevin_filteredwhitelist)
so_kb_10xwhitelist_filtered <- FindVariableFeatures(object=so_kb_10xwhitelist_filtered)
so_kb_filteredwhitelist <- FindVariableFeatures(object=so_kb_filteredwhitelist)
so_cellranger_common <- FindVariableFeatures(object=so_cellranger_common)
so_alevin_common <- FindVariableFeatures(object=so_alevin_common)
so_kb_common <- FindVariableFeatures(object=so_kb_common)

# Scaling
so_cellranger <- ScaleData(object=so_cellranger)
so_alevin <- ScaleData(object=so_alevin)
so_alevin_10xwhitelist_filtered <- ScaleData(object=so_alevin_10xwhitelist_filtered)
so_alevin_filteredwhitelist <- ScaleData(object=so_alevin_filteredwhitelist)
so_kb_10xwhitelist_filtered <- ScaleData(object=so_kb_10xwhitelist_filtered)
so_kb_filteredwhitelist <- ScaleData(object=so_kb_filteredwhitelist)
so_cellranger_common <- ScaleData(object=so_cellranger_common)
so_alevin_common <- ScaleData(object=so_alevin_common)
so_kb_common <- ScaleData(object=so_kb_common)

# PCA
so_cellranger <- RunPCA(object=so_cellranger, npcs=15,
    verbose=FALSE)
so_alevin <- RunPCA(object=so_alevin, npcs=15,
    verbose=FALSE)
so_alevin_10xwhitelist_filtered <- RunPCA(object=so_alevin_10xwhitelist_filtered,
    npcs=15, verbose=FALSE)
so_alevin_filteredwhitelist <- RunPCA(object=so_alevin_filteredwhitelist, npcs=15,
    verbose=FALSE)
so_kb_10xwhitelist_filtered <- RunPCA(object=so_kb_10xwhitelist_filtered, npcs=15,
    verbose=FALSE)
so_kb_filteredwhitelist <- RunPCA(object=so_kb_filteredwhitelist, npcs=15,
    verbose=FALSE)
so_cellranger_common <- RunPCA(object=so_cellranger_common, npcs=15,
    verbose=FALSE)
so_alevin_common <- RunPCA(object=so_alevin_common, npcs=15,
    verbose=FALSE)
so_kb_common <- RunPCA(object=so_kb_common, npcs=15,
    verbose=FALSE)

# Plot (Explained Variance)
expVar <- function(so){
    eigs <- Stdev(so)^2
    eigs / sum(eigs)
}

png(file="plot/ExpVar_CellRanger.png", width=700, height=700)
plot(expVar(so_cellranger), type="l", xlab="PC", ylab="Explained Variance",
    xlim=c(1, 15), ylim=c(0, 1))
dev.off()

png(file="plot/ExpVar_Alevin.png", width=700, height=700)
plot(expVar(so_alevin), type="l", xlab="PC", ylab="Explained Variance",
    xlim=c(1, 15), ylim=c(0, 1))
dev.off()

png(file="plot/ExpVar_Alevin_10X_Filtered.png", width=700, height=700)
plot(expVar(so_alevin_10xwhitelist_filtered), type="l", xlab="PC", ylab="Explained Variance",
    xlim=c(1, 15), ylim=c(0, 1))
dev.off()

png(file="plot/ExpVar_Alevin_Filtered.png", width=700, height=700)
plot(expVar(so_alevin_filteredwhitelist), type="l", xlab="PC", ylab="Explained Variance",
    xlim=c(1, 15), ylim=c(0, 1))
dev.off()

png(file="plot/ExpVar_KB_10X_Filtered.png", width=700, height=700)
plot(expVar(so_kb_10xwhitelist_filtered), type="l", xlab="PC", ylab="Explained Variance",
    xlim=c(1, 15), ylim=c(0, 1))
dev.off()

png(file="plot/ExpVar_KB_Filtered.png", width=700, height=700)
plot(expVar(so_kb_filteredwhitelist), type="l", xlab="PC", ylab="Explained Variance",
    xlim=c(1, 15), ylim=c(0, 1))
dev.off()

png(file="plot/ExpVar_CellRanger_Common.png", width=700, height=700)
plot(expVar(so_cellranger_common), type="l", xlab="PC", ylab="Explained Variance",
    xlim=c(1, 15), ylim=c(0, 1))
dev.off()

png(file="plot/ExpVar_Alevin_Common.png", width=700, height=700)
plot(expVar(so_alevin_common), type="l", xlab="PC", ylab="Explained Variance",
    xlim=c(1, 15), ylim=c(0, 1))
dev.off()

png(file="plot/ExpVar_KB_Common.png", width=700, height=700)
plot(expVar(so_kb_common), type="l", xlab="PC", ylab="Explained Variance",
    xlim=c(1, 15), ylim=c(0, 1))
dev.off()

# FindNeighbors
so_cellranger <- FindNeighbors(object=so_cellranger)
so_alevin <- FindNeighbors(object=so_alevin)
so_alevin_10xwhitelist_filtered <- FindNeighbors(object=so_alevin_10xwhitelist_filtered)
so_alevin_filteredwhitelist <- FindNeighbors(object=so_alevin_filteredwhitelist)
so_kb_10xwhitelist_filtered <- FindNeighbors(object=so_kb_10xwhitelist_filtered)
so_kb_filteredwhitelist <- FindNeighbors(object=so_kb_filteredwhitelist)
so_cellranger_common <- FindNeighbors(object=so_cellranger_common)
so_alevin_common <- FindNeighbors(object=so_alevin_common)
so_kb_common <- FindNeighbors(object=so_kb_common)

# Clustering
so_cellranger <- FindClusters(object=so_cellranger)
so_alevin <- FindClusters(object=so_alevin)
so_alevin_10xwhitelist_filtered <- FindClusters(object=so_alevin_10xwhitelist_filtered)
so_alevin_filteredwhitelist <- FindClusters(object=so_alevin_filteredwhitelist)
so_kb_10xwhitelist_filtered <- FindClusters(object=so_kb_10xwhitelist_filtered)
so_kb_filteredwhitelist <- FindClusters(object=so_kb_filteredwhitelist)
so_cellranger_common <- FindClusters(object=so_cellranger_common)
so_alevin_common <- FindClusters(object=so_alevin_common)
so_kb_common <- FindClusters(object=so_kb_common)

# t-SNE
so_cellranger <- RunTSNE(object=so_cellranger, check_duplicates=FALSE,
    do.fast=TRUE)
so_alevin <- RunTSNE(object=so_alevin, check_duplicates=FALSE,
    do.fast=TRUE)
so_alevin_10xwhitelist_filtered <- RunTSNE(object=so_alevin_10xwhitelist_filtered, check_duplicates=FALSE,
    do.fast=TRUE)
so_alevin_filteredwhitelist <- RunTSNE(object=so_alevin_filteredwhitelist, check_duplicates=FALSE,
    do.fast=TRUE)
so_kb_10xwhitelist_filtered <- RunTSNE(object=so_kb_10xwhitelist_filtered, check_duplicates=FALSE,
    do.fast=TRUE)
so_kb_filteredwhitelist <- RunTSNE(object=so_kb_filteredwhitelist, check_duplicates=FALSE,
    do.fast=TRUE)
so_cellranger_common <- RunTSNE(object=so_cellranger_common, check_duplicates=FALSE,
    do.fast=TRUE)
so_alevin_common <- RunTSNE(object=so_alevin_common, check_duplicates=FALSE,
    do.fast=TRUE)
so_kb_common <- RunTSNE(object=so_kb_common, check_duplicates=FALSE,
    do.fast=TRUE)

# UMAP
so_cellranger <- RunUMAP(object=so_cellranger,
     reduction="pca", dims=1:5)
so_alevin <- RunUMAP(object=so_alevin,
     reduction="pca", dims=1:5)
so_alevin_10xwhitelist_filtered <- RunUMAP(object=so_alevin_10xwhitelist_filtered,
     reduction="pca", dims=1:5)
so_alevin_filteredwhitelist <- RunUMAP(object=so_alevin_filteredwhitelist,
     reduction="pca", dims=1:5)
so_kb_10xwhitelist_filtered <- RunUMAP(object=so_kb_10xwhitelist_filtered,
     reduction="pca", dims=1:5)
so_kb_filteredwhitelist <- RunUMAP(object=so_kb_filteredwhitelist,
     reduction="pca", dims=1:5)
so_cellranger_common <- RunUMAP(object=so_cellranger_common,
     reduction="pca", dims=1:5)
so_alevin_common <- RunUMAP(object=so_alevin_common,
     reduction="pca", dims=1:5)
so_kb_common <- RunUMAP(object=so_kb_common,
     reduction="pca", dims=1:5)


# Plot (PCA)
png(file="plot/PCA_CellRanger.png", width=700, height=700)
DimPlot(so_cellranger, reduction="pca", dims=c(1,2))
dev.off()

png(file="plot/PCA_Alevin.png", width=700, height=700)
DimPlot(so_alevin, reduction="pca", dims=c(1,2))
dev.off()

png(file="plot/PCA_Alevin_10X_Filtered.png", width=700, height=700)
DimPlot(so_alevin_10xwhitelist_filtered, reduction="pca", dims=c(1,2))
dev.off()

png(file="plot/PCA_Alevin_Filtered.png", width=700, height=700)
DimPlot(so_alevin_filteredwhitelist, reduction="pca", dims=c(1,2))
dev.off()

png(file="plot/PCA_KB_10X_Filtered.png", width=700, height=700)
DimPlot(so_kb_10xwhitelist_filtered, reduction="pca", dims=c(1,2))
dev.off()

png(file="plot/PCA_KB_Filtered.png", width=700, height=700)
DimPlot(so_kb_filteredwhitelist, reduction="pca", dims=c(1,2))
dev.off()

png(file="plot/PCA_CellRanger_Common.png", width=700, height=700)
DimPlot(so_cellranger_common, reduction="pca", dims=c(1,2))
dev.off()

png(file="plot/PCA_Alevin_Common.png", width=700, height=700)
DimPlot(so_alevin_common, reduction="pca", dims=c(1,2))
dev.off()

png(file="plot/PCA_KB_Common.png", width=700, height=700)
DimPlot(so_kb_common, reduction="pca", dims=c(1,2))
dev.off()


# Plot (t-SNE)
png(file="plot/tSNE_CellRanger.png", width=700, height=700)
DimPlot(so_cellranger, reduction="tsne")
dev.off()

png(file="plot/tSNE_Alevin.png", width=700, height=700)
DimPlot(so_alevin, reduction="tsne")
dev.off()

png(file="plot/tSNE_Alevin_10X_Filtered.png", width=700, height=700)
DimPlot(so_alevin_10xwhitelist_filtered, reduction="tsne")
dev.off()

png(file="plot/tSNE_Alevin_Filtered.png", width=700, height=700)
DimPlot(so_alevin_filteredwhitelist, reduction="tsne")
dev.off()

png(file="plot/tSNE_KB_10X_Filtered.png", width=700, height=700)
DimPlot(so_kb_10xwhitelist_filtered, reduction="tsne")
dev.off()

png(file="plot/tSNE_KB_Filtered.png", width=700, height=700)
DimPlot(so_kb_filteredwhitelist, reduction="tsne")
dev.off()

png(file="plot/tSNE_CellRanger_Common.png", width=700, height=700)
DimPlot(so_cellranger_common, reduction="tsne")
dev.off()

png(file="plot/tSNE_Alevin_Common.png", width=700, height=700)
DimPlot(so_alevin_common, reduction="tsne")
dev.off()

png(file="plot/tSNE_KB_Common.png", width=700, height=700)
DimPlot(so_kb_common, reduction="tsne")
dev.off()


# Plot (UMAP)
png(file="plot/UMAP_CellRanger.png", width=700, height=700)
DimPlot(so_cellranger, reduction="umap")
dev.off()

png(file="plot/UMAP_Alevin.png", width=700, height=700)
DimPlot(so_alevin, reduction="umap")
dev.off()

png(file="plot/UMAP_Alevin_10X_Filtered.png", width=700, height=700)
DimPlot(so_alevin_10xwhitelist_filtered, reduction="umap")
dev.off()

png(file="plot/UMAP_Alevin_Filtered.png", width=700, height=700)
DimPlot(so_alevin_filteredwhitelist, reduction="umap")
dev.off()

png(file="plot/UMAP_KB_10X_Filtered.png", width=700, height=700)
DimPlot(so_kb_10xwhitelist_filtered, reduction="umap")
dev.off()

png(file="plot/UMAP_KB_Filtered.png", width=700, height=700)
DimPlot(so_kb_filteredwhitelist, reduction="umap")
dev.off()

png(file="plot/UMAP_CellRanger_Common.png", width=700, height=700)
DimPlot(so_cellranger_common, reduction="umap")
dev.off()

png(file="plot/UMAP_Alevin_Common.png", width=700, height=700)
DimPlot(so_alevin_common, reduction="umap")
dev.off()

png(file="plot/UMAP_KB_Common.png", width=700, height=700)
DimPlot(so_kb_common, reduction="umap")
dev.off()



# Detected genes in each cluster (n=9)
detGenesPlot <- function(mat, label, ymax){
    uniq.label <- unique(label)
    count <- unlist(sapply(uniq.label, function(x){
        apply(mat[, which(label == x)], 2, function(y){
            length(which(y > 0))
        })
    }))
    label.position <- unlist(sapply(uniq.label, function(x){
        which(label == x)
    }))
    cluster.median <- round(unlist(sapply(uniq.label, function(x){
        median(apply(mat[, which(label == x)], 2, function(y){
            length(which(y > 0))
        }))
    })), 0)
    cluster.order <- unlist(sapply(seq(cluster.median), function(x, y){
        uniq.label <- y$uniq.label
        label <- y$label
        cluster.rank <- length(cluster.median) - rank(cluster.median)[x]
        cluster.members <- length(which(label == uniq.label[x]))
        rep(cluster.rank, cluster.members)
    }, y=list(uniq.label=uniq.label, label=label)))

    dg <- data.frame(detected.genes=count, cluster=label[label.position], order=cluster.order)
    g <- ggplot(dg,
        aes(x=reorder(cluster, order), y=detected.genes,
        fill=reorder(cluster, order)))
    g <- g + geom_violin()
    g <- g + ylim(0, ymax)
    g <- g + xlab("Cluster label") + ylab("Detected genes (>0)")
    g <- g + theme(legend.position = 'none')
    g
}

g <- detGenesPlot(res_cellranger,
    Idents(so_cellranger), ymax=10000)
ggsave(file="plot/DetectedGenes_CellRanger.png", plot=g)

g <- detGenesPlot(res_alevin,
    Idents(so_alevin), ymax=10000)
ggsave(file="plot/DetectedGenes_Alevin.png", plot=g)

g <- detGenesPlot(res_alevin_10xwhitelist_filtered,
    Idents(so_alevin_10xwhitelist_filtered), ymax=10000)
ggsave(file="plot/DetectedGenes_Alevin_10X_Filtered.png", plot=g)

g <- detGenesPlot(res_alevin_filteredwhitelist,
    Idents(so_alevin_filteredwhitelist), ymax=10000)
ggsave(file="plot/DetectedGenes_Alevin_Filtered.png", plot=g)

g <- detGenesPlot(res_kb_10xwhitelist_filtered,
    Idents(so_kb_10xwhitelist_filtered), ymax=10000)
ggsave(file="plot/DetectedGenes_KB_10X_Filtered.png", plot=g)

g <- detGenesPlot(res_kb_filteredwhitelist,
    Idents(so_kb_filteredwhitelist), ymax=10000)
ggsave(file="plot/DetectedGenes_KB_Filtered.png", plot=g)


# Common Cellular Barcode
Idents(so_cellranger_common) <- celltypes
Idents(so_alevin_common) <- celltypes
Idents(so_kb_common) <- celltypes

png(file="plot/PCA_CellRanger_Common_CCB.png", width=700, height=700)
DimPlot(so_cellranger_common, reduction="pca", dims=c(1,2))
dev.off()

png(file="plot/PCA_Alevin_Common_CCB.png", width=700, height=700)
DimPlot(so_alevin_common, reduction="pca", dims=c(1,2))
dev.off()

png(file="plot/PCA_KB_Common_CCB.png", width=700, height=700)
DimPlot(so_kb_common, reduction="pca", dims=c(1,2))
dev.off()


png(file="plot/tSNE_CellRanger_Common_CCB.png", width=700, height=700)
DimPlot(so_cellranger_common, reduction="tsne")
dev.off()

png(file="plot/tSNE_Alevin_Common_CCB.png", width=700, height=700)
DimPlot(so_alevin_common, reduction="tsne")
dev.off()

png(file="plot/tSNE_KB_Common_CCB.png", width=700, height=700)
DimPlot(so_kb_common, reduction="tsne")
dev.off()


png(file="plot/UMAP_CellRanger_Common_CCB.png", width=700, height=700)
DimPlot(so_cellranger_common, reduction="umap")
dev.off()

png(file="plot/UMAP_Alevin_Common_CCB.png", width=700, height=700)
DimPlot(so_alevin_common, reduction="umap")
dev.off()

png(file="plot/UMAP_KB_Common_CCB.png", width=700, height=700)
DimPlot(so_kb_common, reduction="umap")
dev.off()

# Deteceted geness in each celltypes (n=3, merged)
mat.cellranger_common <- as.matrix(so_cellranger_common@assays$RNA@counts)
mat.alevin_common <- as.matrix(so_alevin_common@assays$RNA@counts)
mat.kb_common <- as.matrix(so_kb_common@assays$RNA@counts)

uniq.celltypes <- unique(celltypes)
count.cellranger_common <- unlist(sapply(uniq.celltypes, function(x){
    apply(mat.cellranger_common[, which(celltypes == x)], 2, function(y){
        length(which(y > 0))
    })
}))
count.alevin_common <- unlist(sapply(uniq.celltypes, function(x){
    apply(mat.alevin_common[, which(celltypes == x)], 2, function(y){
        length(which(y > 0))
    })
}))
count.kb_common <- unlist(sapply(uniq.celltypes, function(x){
    apply(mat.kb_common[, which(celltypes == x)], 2, function(y){
        length(which(y > 0))
    })
}))

celltypes.position <- unlist(sapply(uniq.celltypes, function(x){
    which(celltypes == x)
}))
celltypes.median.cellranger_common <- round(unlist(sapply(uniq.celltypes, function(x){
    median(apply(mat.cellranger_common[, which(celltypes == x)], 2, function(y){
        length(which(y > 0))
    }))
})), 0)
celltypes.median.alevin_common <- round(unlist(sapply(uniq.celltypes, function(x){
    median(apply(mat.alevin_common[, which(celltypes == x)], 2, function(y){
        length(which(y > 0))
    }))
})), 0)
celltypes.median.kb_common <- round(unlist(sapply(uniq.celltypes, function(x){
    median(apply(mat.kb_common[, which(celltypes == x)], 2, function(y){
        length(which(y > 0))
    }))
})), 0)

celltype.order <- unlist(sapply(seq(celltypes.median.cellranger_common), function(x, y){
    uniq.celltypes <- y$uniq.celltypes
    celltypes <- y$celltypes
    cluster.rank <- length(celltypes.median.cellranger_common) - rank(celltypes.median.cellranger_common)[x]
    cluster.members <- length(which(celltypes == uniq.celltypes[x]))
    rep(cluster.rank, cluster.members)
}, y=list(uniq.celltypes=uniq.celltypes, celltypes=celltypes)))

dg <- data.frame(
    quantifier=c(rep("CellRanger", length(celltypes)),
        rep("Alevin", length(celltypes)),
        rep("Kallisto | Bustools", length(celltypes))),
    detected.genes=c(count.cellranger_common,
        count.alevin_common,
        count.kb_common),
    cluster=rep(celltypes[celltypes.position], 3),
    order=rep(celltype.order, 3),
    order2=c(rep(1, length(celltypes)), rep(2, length(celltypes)),
        rep(3, length(celltypes))))

g <- ggplot(dg,
    aes(x=reorder(cluster, order), y=detected.genes,
    fill=reorder(quantifier, order2)))
g <- g + geom_violin()
g <- g + ylim(0, 10000)
g <- g + xlab("Cluster label") + ylab("Detected genes (>0)")
g <- g + theme(legend.title=element_blank())

ggsave(file="plot/DetectedGenes_Common_CCB.png", plot=g)
