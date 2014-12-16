#!/bin/sh
if [ $# -lt 4 ]
then
	echo "Usage: $0 <metricName> <sortBy> <exptName> <vmname>"
	exit 1
fi
fn="plot.input"
declare -A xname
xname["varDcopyKat"]="KeepaliveTimeout"
xname["varDcopyPhp"]="PhpMaxChildren"
xname["varDcopyMxc"]="MaxClients"
xname["MxcDepKatLLC"]="MaxClients"
xname["MxcDepKatBL"]="MaxClients"
xname["varKat2GB"]="KeepaliveTimeout"
xname["varPhp2GB"]="PhpMaxChildren"
xname["varPhpWithOprof"]="PhpMaxChildren"
xname["varDcopyKatSmall"]="KeepaliveTimeout"
xname["varDcopyPhpSmall"]="PhpMaxChildren"
xname["varDcopyMxcSmall"]="MaxClients"
xname["varDcopyWld"]="Workload"

xaxis=${xname["$3"]}

if [ "$1" = "SysCPU" ]
then
	ytitle="SysCPU (%)"
elif [ "$1" = "UserCPU" ]
then
        ytitle="UserCPU (%)"
elif [ "$1" = "IdleCPU" ]
then
        ytitle="IdleCPU (%)"
elif [ "$1" = "IOWait" ]
then
        ytitle="IO Wait (%)"
elif [ "$1" = "ActiveMem" ]
then
        ytitle="Active Memory (KB)"
elif [ "$1" = "FreeMem" ]
then
        ytitle="Free Memory (KB)"
elif [ "$1" = "Swapped" ]
then
        ytitle="Swapped (KB)"
elif [ "$1" = "Interrupts" ]
then
        ytitle="Interrupts/s"
elif [ "$1" = "ContextSwitch" ]
then
        ytitle="Context Switches/s"
elif [ "$1" = "MajorFaults" ]
then
        ytitle="Major Faults"
elif [ "$1" = "NormPageFaults" ]
then
        ytitle="Pagefaults/operation" 
elif [ "$1" = "NormContextSwitch" ]
then
        ytitle="ContextSwitches/operation"
elif [ "$1" = "NormInterrupts" ]
then
        ytitle="Interrupts/operation"
else
	ytitle="$1"
fi

echo -e "Key		\"Value\"" > $fn
#echo -e "datafile	\"./plots/sysmetrics/$3/ee258vm8/$1.csv\"" >> $fn  #change this after eps plot is done
echo -e "datafile      \"input/$1-$4.csv\"" >> $fn
echo -e "charttitle	\"$1 vs $xaxis\"" >> $fn
echo -e "xtitle		\"$xaxis\"" >> $fn
echo -e "ytitle		\"$ytitle\"" >> $fn
echo -e "xdata		\"$xaxis\"" >> $fn
echo -e "ydata		\"$1\"" >> $fn
echo -e "sortby		\"$2\"" >> $fn
echo -e "outfile        \"$1-$3\"" >> $fn
