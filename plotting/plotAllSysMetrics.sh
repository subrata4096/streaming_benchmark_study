#!/bin/sh
if [ $# -lt 3 ] 
then
	echo "Usage: $0 <sortByColName> <exptname> <vmname>"
	exit 1
fi

sortby="$1"
exptname="$2"
vmname="$3"
metrics="ActiveMem FreeMem Swapped SysCPU UserCPU IdleCPU IOWait MajorFaults PageFaults ContextSwitch Interrupts NormPageFaults NormContextSwitch NormInterrupts"
#metrics="NormPageFaults NormContextSwitch NormInterrupts"

#generate the csv files remotely and transfer them to local machine"

for metric in $metrics
do
#	./gen-plot-input-alt.sh $metric $1 $2
	./gen-plot-input.sh $metric $sortby $exptname $vmname
	# update the csv file to convert numeric sortby cloumn value to strings
	filename="$metric-$vmname.csv"

	header="MaxClients,$1,VMName,Metric,$metric"
	if [ "$exptname" = "varDcopyKat" -o "$exptname" = "varKat2GB" -o "$exptname" = "varDcopyKatSmall" ]
	then
		header="KeepaliveTimeout,$1,VMName,Metric,$metric"
	elif [ "$exptname" = "varDcopyPhp" -o "$exptname" = "varPhp2GB" -o "$exptname" = "varPhpWithOprof" -o "$exptname" = "varDcopyPhpSmall" ]
        then
                header="PhpMaxChildren,$1,VMName,Metric,$metric"
        elif [ "$exptname" = "varDcopyWld" ]
	then
		header="Workload,$1,VMName,Metric,$metric"
	else
		header="MaxClients,$1,VMName,Metric,$metric"
	fi

#	awk -F"," -v OFS=',' -v sortby="$1" '{$2=sortby"-"$2; print}' input/$filename > $metric.csv  #add 'NR>1' in the beginning of awk command if header is there
#	awk -F"," -v OFS=',' -v sortby="$1" '{$1="MaxClients-"$1; print}' input/$filename > $metric.csv # this is for alternate sysmetrics plot where x-axis is NOT MaxClients
#	awk -F"," -v OFS=',' -v sortby="$1" '{$3="PhpMaxChildren-"$3; print}' input/$filename > $metric.csv # this is for alternate sysmetrics plot where x-axis is NOT MaxClients. This is for varKatPhp experiments
	sed -i "1i $header" input/$filename

	R -s -q -e 'source("ggplot-sys.R")'
done

