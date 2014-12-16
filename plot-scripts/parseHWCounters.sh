#!/bin/sh
# This is a fancy way to rename and copy the log file :-)
if [ $# -lt 1 ]
then
	echo "Usage: $0 <exptid>"
	exit
fi
exptid="$1"
logfile="results-raw/$exptid/hwmetrics-$exptid.log"
outfile="input/hwcounters-$exptid.csv"

#cat $logfile > $outfile
echo "ts,CPI,CMR,exptid" > $outfile
awk -v FS=',' -v OFS=',' -v exid=$exptid '(NR==2){start=$1}; (NR>1){print $1-start,$2,$3,exid}' $logfile >> $outfile


