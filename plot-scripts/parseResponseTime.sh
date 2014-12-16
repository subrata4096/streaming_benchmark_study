#!/bin/sh
if [ $# -lt 1 ]
then
	echo "Usage: $0 <exptid>"
	exit
fi
exptid="$1"
logfile="results-raw/$exptid/responsetimes-$exptid.log"
outfile="input/resp-$exptid.csv"

echo "exptid,ts,req_in,req_out,resp" > $outfile

s=`grep "TIME:" $logfile | head -1 | cut -d\  -f2`
i=$s
e=`grep "TIME:" $logfile | tail -1 | cut -d\  -f2`

for ts in `seq $s $i $e`
do
#	echo -n "$ts," >> $outfile
	tmp="`grep -A 7 "TIME: ${ts}\$" $logfile | grep ee258vm8`"
	if [ "$tmp" != "" ]
	then
		echo -n "$exptid,$ts," >> $outfile
		echo "$tmp" | awk -v OFS=',' -v FS=' ' '{print $8,$9,$12}' >> $outfile
	fi
done
