#!/bin/sh
if [ $# -lt 1 ] 
then
	echo "Usage: $0 <exptname>"
	exit 1
fi

declare -A sortbylist
sortbylist["varDcopyMxc"]="Interference"
sortbylist["varDcopyKat"]="Interference"
sortbylist["varDcopyPhp"]="Interference"
sortbylist["MxcDepKatLLC"]="KeepaliveTimeout"
sortbylist["MxcDepKatBL"]="KeepaliveTimeout"
sortbylist["varKat2GB"]="Interference"
sortbylist["varPhp2GB"]="Interference"
sortbylist["varPhpWithOprof"]="Interference"
sortbylist["varDcopyMxcSmall"]="Interference"
sortbylist["varDcopyKatSmall"]="Interference"
sortbylist["varDcopyPhpSmall"]="Interference"
sortbylist["varDcopyWld"]="Interference"

declare -A xname
xname["varDcopyMxc"]="MaxClients"
xname["varDcopyKat"]="KeepaliveTimeout"
xname["varDcopyPhp"]="PhpMaxChildren"
xname["MxcDepKatLLC"]="MaxClients"
xname["MxcDepKatBL"]="MaxClients"
xname["varKat2GB"]="KeepaliveTimeout"
xname["varPhp2GB"]="PhpMaxChildren"
xname["varPhpWithOprof"]="PhpMaxChildren"
xname["varDcopyMxcSmall"]="MaxClients"
xname["varDcopyKatSmall"]="KeepaliveTimeout"
xname["varDcopyPhpSmall"]="PhpMaxChildren"
xname["varDcopyWld"]="Workload"

exptname="$1"
metrics="resp_avg" # thpt_avg" #frac_failed"
sortby=${sortbylist[$exptname]}
xdata=${xname[$exptname]}

#this is redundant. not used elsewhere
function genwldmetrics()
{
	ssh root@ee258vm4.ecn.purdue.edu "cd /root/olioresults/scripts; ./generate-and-transfer-files.sh $exptname wld"
        rm /home/amaji/store/amiya/R-scripts/input/*
        scp root@ee258vm4.ecn.purdue.edu:/tmp/*.csv /home/amaji/store/amiya/R-scripts/input/
}

function getfilename()
{
	filename="plots/wldmetrics/$exptname/wldmetrics-$exptname.csv"
	echo "input $filename"
}

function genPlotInput()
{
	fn="$exptname.resp.plot.input"
	if [ "$1" = "resp_avg" ]
	then
		titletxt="Response Time"
		fname="resp"
		ytitle="Response Time(s)"
	elif [ "$1" = "thpt_avg" ]
	then
		titletxt="Throughput"
		fname="thpt"
		ytitle="Ops/sec"
	elif [ "$1" = "frac_failed" ]
	then
		titletxt="Failed Operations"
                fname="failops"
                ytitle="Fraction of Failed Ops"
	fi
	echo -e "Key            \"Value\"" > $fn
	echo -e "datafile       \"$filename\"" >> $fn
	#else
		echo -e "charttitle     \"$titletxt vs $xdata\"" >> $fn
                echo -e "xtitle         \"$xdata\"" >> $fn
                echo -e "xdata          \"$xdata\"" >> $fn
	#fi
	echo -e "ytitle         \"$ytitle\"" >> $fn
	echo -e "ydata          \"$metric\"" >> $fn
	echo -e "sortby         \"$2\"" >> $fn
	echo -e "outfile        \"$fname-$3$load\"" >> $fn
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

function plotmetrics()
{
	getfilename
	idx=`getindex "$sortby"`
	echo "Index is $idx"
#	awk -F"," -v OFS=',' -v idx=$idx -v sortcol="$sortby" '(NR>1){$3=($3*8*4)/(1024*1024)"MB"; $idx=sortcol" "$idx; print}' input/$filename > $filename  #add 'NR>1' in the beginning of awk command if header is there
#	header=`head -1 input/$filename`
#	sed -i "1i $header" $filename 		#**********omitted for eps plot generation***************

	for metric in $metrics
	do
		# update the csv file to convert numeric sortby cloumn value to strings
		genPlotInput $metric $sortby $exptname

#		R -s -q -e 'source("ggplot.R")'
	done
}


load=""
#genwldmetrics  # already taken care of in plotForAllExpts.sh

basedir="plots/wldmetrics"
if [ ! -d "$basedir/$exptname" ]
then
        mkdir "$basedir/$exptname"
fi

plotmetrics
#mv input/*.csv *.png "$basedir/$exptname/"

