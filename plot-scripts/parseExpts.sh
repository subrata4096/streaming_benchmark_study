#!/bin/sh
expts=`grep "^[0-9A-Z]\+$" exptlist.txt`
rm input/*

for expt in $expts
do
	echo $expt
	./parseHAStats.sh $expt
	./parseResponseTime.sh $expt
	./parseHWCounters.sh $expt
done
