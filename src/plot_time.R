library("ggplot2")

time <- read.table("output/time.txt", header=FALSE, stringsAsFactor=FALSE)
time <- cbind(time, seq(nrow(time)))
colnames(time) <- c("Command", "Hour", "order")

time$Hour <- sapply(time$Hour, function(x){
		# 時間:分:秒 スタイル
		if(length(grep("\\d*:\\d*:\\d", x)) != 0){
			Hour = as.numeric(strsplit(x, ":")[[1]][1])
			Min = as.numeric(strsplit(x, ":")[[1]][2])
			Sec = as.numeric(strsplit(x, ":")[[1]][3])
			Hour + Min / 60 + Sec / 60 / 60
		}else{
		# 分:秒.センチ秒 スタイル
		as.numeric(as.POSIXct(paste0("1970-01-01 ", x),
			format="%Y-%m-%d %M:%S", tz="UTC")) / 60 / 60
		}
	})

g <- ggplot(time, aes(x=reorder(Command, order), y=Hour, fill=reorder(Command, order)))
g <- g + geom_bar(stat="identity")
g <- g + theme(legend.position="none")
g <- g + theme(axis.text.x = element_text(angle=45, hjust=1))
g <- g + theme(axis.text=element_text(size=14))
g <- g + theme(axis.title=element_text(size=16, face="bold"))
g <- g + xlab("Commands") + ylab("Hours")
ggsave(file="plot/Time.png", plot=g, dpi=120, width=15, height=10)
