library("ggplot2")

commandnames <- c(
	"CellRanger",
	"Salmon_index",
	"Alevin",
	"alevin_10X_whitelist",
	"Alevin_filtered_whitelist",
	"Kallisto_index",
	"Kallisto_Bustools",
	"Kallisto_Bustools_10X_whitelist",
	"Kallisto_Bustools_filtered_whitelist")

filenames <- c(
	"benchmarks/cellranger.txt",
	"benchmarks/salmon_index.txt",
	"benchmarks/alevin.txt",
	"benchmarks/alevin_10xwhitelist.txt",
	"benchmarks/alevin_filteredwhitelist.txt",
	"benchmarks/kallisto_index.txt",
	"benchmarks/kb.txt",
	"benchmarks/kb_10xwhitelist.txt",
	"benchmarks/kb_filteredwhitelist.txt")

memory <- c()
for(i in 1:length(filenames)){
	memory <- c(memory, read.table(filenames[i], header=TRUE, stringsAsFactor=FALSE)[,3])
}
memory <- data.frame(
	Command=commandnames,
	GB=memory,
	order=seq(memory)
)
memory$GB <- memory$GB / 10^3

g <- ggplot(memory, aes(x=reorder(Command, order), y=GB, fill=reorder(Command, order)))
g <- g + geom_bar(stat="identity")
g <- g + theme(legend.position="none")
g <- g + theme(axis.text.x = element_text(angle=45, hjust=1))
g <- g + theme(axis.text=element_text(size=14))
g <- g + theme(axis.title=element_text(size=16, face="bold"))
g <- g + xlab("Commands") + ylab("GBs")
ggsave(file="plot/Memory.png", plot=g, dpi=120, width=15, height=10)
