#!/bin/sh
expts=`grep "^[0-9A-Z]\+$" exptlist.txt`

for expt in $expts
do
	echo $expt
	./hap-plotresults.sh $expt "resp"
	./hap-plotresults.sh $expt "hastats"
	./hap-plotresults.sh $expt "hwcounters"
done
