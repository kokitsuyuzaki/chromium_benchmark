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

time <- c()
for(i in 1:length(filenames)){
	time <- c(time, read.table(filenames[i], header=TRUE, stringsAsFactor=FALSE)[,2])
}
time <- data.frame(
	Command=commandnames,
	Hour=time,
	order=seq(time)
)
time$Hour <- as.character(time$Hour)

time$Hour <- sapply(time$Hour, function(x){
	Hour = as.numeric(strsplit(x, ":")[[1]][1])
	Min = as.numeric(strsplit(x, ":")[[1]][2])
	Sec = as.numeric(strsplit(x, ":")[[1]][3])
	Hour + Min / 60 + Sec / 60 / 60
})

g <- ggplot(time, aes(x=reorder(Command, order), y=Hour, fill=reorder(Command, order)))
g <- g + geom_bar(stat="identity")
g <- g + theme(legend.position="none")
g <- g + theme(axis.text.x = element_text(angle=45, hjust=1))
g <- g + theme(axis.text=element_text(size=14))
g <- g + theme(axis.title=element_text(size=16, face="bold"))
g <- g + xlab("Commands") + ylab("Hours")
ggsave(file="plot/Time.png", plot=g, dpi=120, width=15, height=10)
