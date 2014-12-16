#!/bin/sh
if [ $# -lt 1 ] 
then
	echo "Usage: $0 <exptname> <local|ec2>"
	exit 1
fi

exptname="$1"
metrics="ResponseTime Throughput" # CacheMissRate IdleCPU"
sortby="ExptId"
xdata="Time"
header="ExptId,Time,ResponseTime,Throughput,IdleCPU,TotalMem,UsedMem,Swapped,CacheMissRate,W,X,Y,Z"

fabanmaster="ee258vm2.ecn.purdue.edu:9980"
if [ "$2" = "ec2" ]
then
fabanmaster="http://ec2-54-200-122-30.us-west-2.compute.amazonaws.com:9980"
fi

declare -A exptdesc
exptdesc["128F"]="noconf"
exptdesc["110V"]="mxconly"
exptdesc["110W"]="katonly"
exptdesc["110X"]="phponly"
exptdesc["4R"]="EC2-Baseline"
exptdesc["6A"]="IC2-on-EC2"

#set -x
function getresults()
{
#	rm /home/amaji/store/amiya/R-scripts/input/*		#moved to driver script
#	scp root@ee258vm2.ecn.purdue.edu:/root/run-codes/ic2.OlioDriver.* /home/amaji/store/amiya/R-scripts/input/
	rm input/ic2Results.csv
	#files="`ls input/*.metrics`"
	files="`cat exptlist.txt`"
	for file in $files
	do
		exptid=`echo $file | cut -d\. -f3`
		if [ "${exptdesc[$exptid]}" != "" ]
		then
			exptid=${exptdesc[$exptid]}
		fi
	#	paramlog=`echo $file | sed s/"metrics"/"paramlog"/`
	#	params=`awk -v FS=',' '(NR==2){print $2"-"$3"-"$4}' $paramlog`
	#	desc="`lynx -dump http://$fabanmaster/controller/results/get_run_info?runId=OlioDriver.$exptid | head -3 | tail -1 | tr -d ' '`"
	#	exptid="$exptid.$desc"
		awk -v FS=',' -v OFS=',' -v xid="$exptid" '(NR>1){$1=xid","$1; print}' $file >> input/ic2Results.csv
	done
	sed -i "1i $header" input/ic2Results.csv
}


function genPlotInput()
{
	fn="ic2.input"
	titletxt="$1"
        fname="$1"
        ytitle="$1"
	echo -e "Key            \"Value\"" > $fn
	echo -e "datafile       \"input/ic2Results.csv\"" >> $fn
	echo -e "charttitle     \"$titletxt vs $xdata\"" >> $fn
        echo -e "xtitle         \"$xdata\"" >> $fn
        echo -e "xdata          \"$xdata\"" >> $fn
	#fi
	echo -e "ytitle         \"$ytitle\"" >> $fn
	echo -e "ydata          \"$1\"" >> $fn
	echo -e "sortby         \"$2\"" >> $fn
	echo -e "outfile        \"ic2-$fname-$exptname\"" >> $fn
	echo -e "paramlog	\"input/ic2.$exptname.paramlog\"" >> $fn
}

function getindex()
#gets the column index of a column name in input file
{
	str=`head -1 $filename | tr -d "," `	#edit filename back to input/filename
	i=1
	for s in $str
	do
		if [ "$s" = "$1" ]
		then
			echo "$i"
			break
		else
			i=`expr $i + 1`
		fi
	done
}

	getresults
#	awk -F"," -v OFS=',' -v idx=$idx -v sortcol="$sortby" '(NR>1){$3=($3*8*4)/(1024*1024)"MB"; $idx=sortcol" "$idx; print}' input/$filename > $filename  #add 'NR>1' in the beginning of awk command if header is there
#	header=`head -1 input/$filename`
#	sed -i "1i $header" $filename 		#**********omitted for eps plot generation***************

	RSource="ggplot.R"
	for metric in $metrics
	do
		# update the csv file to convert numeric sortby cloumn value to strings
		genPlotInput $metric "ExptId" $exptname

		if [ "$metric" = "ResponseTime" ]
		then
			RSource="ic2-ggplot.R"
		else
			RSource="ggplot-timeline.R"
		fi
		R -s -q -e "source(\"$RSource\")"
	done





