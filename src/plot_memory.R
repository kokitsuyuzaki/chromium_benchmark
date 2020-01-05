library("ggplot2")

memory <- read.table("output/memory.txt", header=FALSE, stringsAsFactor=FALSE)
memory <- cbind(memory, seq(nrow(memory)))
colnames(memory) <- c("Command", "GB", "order")
memory$GB <- memory$GB / 10^6

g <- ggplot(memory, aes(x=reorder(Command, order), y=GB, fill=reorder(Command, order)))
g <- g + geom_bar(stat="identity")
g <- g + theme(legend.position="none")
g <- g + theme(axis.text.x = element_text(angle=45, hjust=1))
g <- g + theme(axis.text=element_text(size=14))
g <- g + theme(axis.title=element_text(size=16, face="bold"))
g <- g + xlab("Commands") + ylab("GBs")
ggsave(file="plot/Memory.png", plot=g, dpi=120, width=15, height=10)
