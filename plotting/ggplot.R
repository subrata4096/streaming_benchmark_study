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

p <- ggplot(alldata, aes_string(x = xdata, y = ydata, group=sortby, col=sortby, linetype=sortby, shape=sortby), size=2) + geom_line(size=0.5) + geom_point(size=2, show_guide = TRUE) #aes_string(shape=sortby)) #+ scale_shape_identity()
p <- p + ggtitle(charttitle) + xlab(xtitle) + ylab(ytitle) + theme(axis.text.x = element_text(colour = 'black', size=22), axis.text.y = element_text(colour = 'black', size=22)) + theme(axis.title.x = element_text(size=22), axis.title.y = element_text(size=22))
p <- p + theme(legend.title = element_text(size=11, face="bold")) + theme(legend.text = element_text(size=12)) 
p <- p + theme(legend.justification=c(0,0.6), legend.position=c(0,0.6))
p <- p + theme(plot.title = element_text(face="bold", size=22)) + scale_colour_hue(l=40)
p <- p + theme(panel.border = element_rect(fill=NA, colour="black"), panel.grid.major = element_line(colour="grey85", size=0.05), panel.background = element_rect(fill="transparent", colour=NA))
#p <- p + scale_x_continuous(breaks=seq(0, 2100, 100))

#theme_update(plot.background = element_rect(fill="transparent", colour=NA))
#p <- p + opts(legend.size = "none")

ggsave(paste(outfile,".png",sep=""), width=8, height=6, dpi=200)
print(p)
