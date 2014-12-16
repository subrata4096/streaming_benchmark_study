#library(data.table)
library(ggplot2)
library(reshape)
plotinfo <- read.table("plot.input", header=T, row.names=1, col.names = c('Key', 'Value'), stringsAsFactors=FALSE)
alldata <- read.csv(plotinfo["datafile",], header=T, sep=",")
charttitle <- plotinfo["charttitle",]
sortby <- plotinfo["sortby",]
xtitle <- plotinfo["xtitle",]
ytitle <- plotinfo["ytitle",]
xdata <- plotinfo["xdata",]
ydata <- plotinfo["ydata",]
outfile <- plotinfo["outfile",]

p <- ggplot(alldata, aes_string(x = xdata, y = ydata, group=sortby, col=sortby, shape=sortby, linetype=sortby), size=5.5) + geom_point(size=6) + geom_line(size=1) #stat_summary(fun.y="mean", geom="point", size=3, color="blue") #+ geom_line(aes(y=mean)) # + geom_point(aes(size=2), show_guide = FALSE) #aes_string(shape=sortby)) #+ scale_shape_identity()
p <- p + ggtitle(charttitle) + xlab(xtitle) + ylab(ytitle) + theme(axis.text.x = element_text(colour = 'black', size=22), axis.text.y = element_text(colour = 'black', size=22))  + theme(axis.title.x = element_text(size=22), axis.title.y = element_text(size=22))
p <- p + theme(legend.title = element_text(size=20, face="bold"))
p <- p + theme(legend.text = element_text(size=12)) #+ theme(legend.justification=c(0.4,0.4), legend.position=c(0.4,0.4))
p <- p + theme(plot.title = element_text(face="bold", size=22)) + scale_colour_hue(l=40)
p <- p + theme(panel.border = element_rect(fill=NA, colour="black"), panel.grid.major = element_line(colour="grey85", size=0.05), panel.background = element_rect(fill="transparent", colour=NA))

ggsave(paste(outfile,".png",sep=""), width=9, height=6, dpi=200)
print(p)
