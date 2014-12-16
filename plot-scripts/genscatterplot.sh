#!/bin/sh

infile="input/combined-runningavg-allexpt-varllc.csv"
ydata="CPU"
xmetrics="CPI RPS"
rinput="scatterplot.input"

genInputFile()
{
echo "Key            \"Value\"" > $rinput
echo "datafile       \"$infile\"" >> $rinput
echo "charttitle     \"$ydata vs $xdata\"" >> $rinput
echo "xtitle         \"$xdata\"" >> $rinput
echo "xdata          \"$xdata\"" >> $rinput
echo "ytitle         \"$ydata\"" >> $rinput
echo "ydata          \"$ydata\"" >> $rinput
#echo "sortby         \"exptid\"" >> $rinput
echo "outfile        \"runningavg-varllc-scatter-$ydata-vs-$xdata\"" >> $rinput
}

for xdata in $xmetrics
do
	echo "$ydata vs $xdata"
	genInputFile
	R -s -q -e "source(\"scatterplot.R\")"
done
