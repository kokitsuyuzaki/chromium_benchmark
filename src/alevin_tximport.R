library("tximport")

# Data loading
res_alevin <- tximport("output/alevin/alevin/quants_mat.gz",
    type="alevin")$counts
res_alevin_10xwhitelist <- tximport(
    "output/alevin_10xwhitelist/alevin/quants_mat.gz",
    type="alevin")$counts
res_alevin_filteredwhitelist <- tximport(
    "output/alevin_filteredwhitelist/alevin/quants_mat.gz",
    type="alevin")$counts

# Data saving
save(res_alevin, file="output/alevin/alevin.RData")
save(res_alevin_10xwhitelist,
    file="output/alevin_10xwhitelist/alevin_10xwhitelist.RData")
save(res_alevin_filteredwhitelist,
    file="output/alevin_filteredwhitelist/alevin_filteredwhitelist.RData")
