#!/bin/sh
# This is a fancy way to rename and copy the log file :-)
if [ $# -lt 1 ]
then
	echo "Usage: $0 <exptid>"
	exit
fi
exptid="$1"
hwlogfile="results-raw/$exptid/hwmetrics-$exptid.log"
rtlogfile="results-raw/$exptid/responsetimes-$exptid.log"
cpulogfile="results-raw/$exptid/mpstat-$exptid.log"
outfile="input/allmetrics-$exptid.csv"

rm -f $outfile
#cat $logfile > $outfile
echo "TimeStamp,CPI,CMR,RPS,RT,CPU,ExptID" > $outfile
#awk -v FS=',' -v OFS=',' -v exid=$exptid '(NR==2){start=$1}; (NR>1){print $1-start,$2,$3,exid}' $hwlogfile >> $outfile

tstamps=`awk -v FS=',' '(NR>1){printf "%d ",$1}' $hwlogfile`

#echo $tstamps

parseUtil()
{
	t=`date -d @${1} '+%r'`
#	echo "t: $t"
	tmp=`grep "$t" $cpulogfile`
#	echo "$tmp"
	if [ "$tmp" != "" ]
        then
		echo -n "$tmp" | awk -v OFS=',' -v FS=' ' '{printf ",%.2f",(100-$12)/100}' >> $outfile
	else
		echo -n "," >> $outfile
	fi
}

parseRT()
{
#	echo "Will parse RT"
	tmp=`grep -A 4 "cts: ${1}" $rtlogfile | grep ee258vm8`
#	grep -A 4 "cts: ${1}" $rtlogfile
#	echo $tmp
        if [ "$tmp" != "" ]
        then
#                echo -n "$exptid,$ts," >> $outfile
                echo -n "$tmp" | awk -v OFS=',' -v FS=' ' '{printf "%d,%d",$8,$12}' >> $outfile
        else
		echo -n "," >> $outfile
	fi
}

for ts in $tstamps
do
	hw=`grep "$ts" $hwlogfile`
	echo -n "${hw}," >> $outfile
	parseRT $ts
	parseUtil $ts
	echo ",$exptid" >> $outfile
done

