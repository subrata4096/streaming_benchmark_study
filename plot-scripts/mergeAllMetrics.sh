#!/bin/sh
expts=`grep "^[0-9A-Z]\+$" exptlist.txt`
#rm input/*
outfile="input/combined-metrics-allexpt-varllc.csv"
rm -f $outfile
echo "TimeStamp,CPI,CMR,RPS,RT,CPU,ExptID" > $outfile


for expt in $expts
do
	echo $expt
	./mergeMetrics.sh $expt
	infile="input/allmetrics-$expt.csv"
	awk '(NR>1){print $0}' $infile >> $outfile
done
