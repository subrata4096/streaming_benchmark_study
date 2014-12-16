#!/bin/sh
if [ $# -lt 2 ] 
then
	echo "Usage: $0 <exptname> <stat>"
	exit 1
fi

exptname="$1"
stat="$2"
if [ "$stat" = "hastats" ]
then 
	metrics="sesscur"
	sortby="srvname"
elif [ "$stat" = "hwcounters" ]
then
	metrics="CPI CMR"
	sortby="exptid"
else
	metrics="resp"
	sortby="exptid"
fi

xdata="ts"
#exptid,ts,srvname,qcur,sesscur,qtime,conntime,resptime,totaltime

#set -x
##function getresults()
##{
##	rm input/ic2Results.csv
	#files="`ls input/*.metrics`"
##	files="`cat exptlist.txt`"
##	for file in $files
##	do
##		exptid=`echo $file | cut -d\. -f3`
		#awk -v FS=',' -v OFS=',' -v xid="$exptid" '(NR>1){$1=xid","$1; print}' $file >> input/ic2Results.csv
##	done
##}


function genPlotInput()
{
	fn="ic2.input"
	titletxt="$1"
        fname="$1"
        ytitle="$1"
	echo -e "Key            \"Value\"" > $fn
	echo -e "datafile       \"input/$stat-$exptname.csv\"" >> $fn
	echo -e "charttitle     \"$titletxt vs $xdata\"" >> $fn
        echo -e "xtitle         \"$xdata\"" >> $fn
        echo -e "xdata          \"$xdata\"" >> $fn
	#fi
	echo -e "ytitle         \"$ytitle\"" >> $fn
	echo -e "ydata          \"$1\"" >> $fn
	echo -e "sortby         \"$2\"" >> $fn
	echo -e "outfile        \"$fname-$exptname\"" >> $fn
	#echo -e "paramlog	\"na\"" >> $fn
}

	RSource="ggplot-timeline.R"
	for metric in $metrics
	do
		# update the csv file to convert numeric sortby cloumn value to strings
		genPlotInput $metric "$sortby" $exptname

		R -s -q -e "source(\"$RSource\")"
	done

