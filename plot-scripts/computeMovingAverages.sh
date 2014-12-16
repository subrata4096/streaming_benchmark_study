#!/bin/sh
expts=`grep "^[0-9A-Z]\+$" exptlist.txt`
#rm input/*
outfile="input/combined-runningavg-shiftedcpu-allexpt-varllc.csv"
factor=50
rm -f $outfile
echo "TimeStamp,CPI,CMR,RPS,RT,CPU,ExptID,OLDCPU" > $outfile

for expt in $expts
do
	java ComputeRunningAvg "$expt" $factor
	awk -v OFS=',' -v FS=',' -v oldval="NA" '(NR>1){print $0,oldval; oldval=$6}' results-raw/$expt/allmetrics-$expt.metrics.${factor}pc >> $outfile
done
