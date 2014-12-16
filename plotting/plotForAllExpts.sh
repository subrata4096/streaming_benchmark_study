#!/bin/sh
if [ $# -lt 1 ] 
then
	echo "Usage: $0 <whichmetrics>, whichmetrics can be {wld, sys, hwcounters, domain}"
	exit 1
fi

expts="varDcopyWld MxcDepKatLLC MxcDepKatBL varDcopyKat varDcopyPhp varDcopyMxc" #varDcopyMxcSmall" #varDcopyKatSmall varDcopyPhpSmall" #varDcopyMxcSmall" #"varPhpWithOprof" #varPhp2GB" #varKat2GB" #"MxcDepKatLLC MxcDepKatBL" #"varDcopyKat varDcopyPhp varDcopyMxc" #phpDepMxc" #varKat2GB" #varDcopyPhp varDcopyKat varPhp2GB varDcopyFine varKatNoDcopy varPhp2GB varDcopy-high varDcopy-med varKat varPhp varTpc"
declare -A sortby
sortby["varDcopyMxc"]="Interference"
sortby["varDcopyKat"]="Interference"
sortby["varDcopyPhp"]="Interference"
sortby["MxcDepKatLLC"]="KeepaliveTimeout"
sortby["MxcDepKatBL"]="KeepaliveTimeout"
sortby["varKat2GB"]="Interference"
sortby["varPhp2GB"]="Interference"
sortby["varPhpWithOprof"]="Interference"
sortby["varDcopyMxcSmall"]="Interference"
sortby["varDcopyKatSmall"]="Interference"
sortby["varDcopyPhpSmall"]="Interference"
sortby["varDcopyWld"]="Interference"

#rm -rf plots/sysmetrics/*

for expt in $expts
do
#	rm -rf plots/sysmetrics/$expt
#	ssh root@ee258vm4.ecn.purdue.edu "cd /root/olioresults/scripts; ./generate-and-transfer-files.sh $expt $1"
#	rm /home/amaji/store/amiya/R-scripts-cpi/input/*
#	scp root@ee258vm4.ecn.purdue.edu:/tmp/*.csv /home/amaji/store/amiya/R-scripts-cpi/input/

	if [ "$1" = "sys" ]
	then
		./plotForAllVMs.sh "${sortby[$expt]}" "$expt"
	elif [ "$1" = "wld" ]
	then
		./plotWldMetrics.sh $expt
	elif [ "$1" = "hwcounters" ]
	then
		./plotAllHwCounters.sh $expt
	fi
done
