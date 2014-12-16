#!/bin/sh
rm input/* exptlist.txt
#scp root@ee258vm2.ecn.purdue.edu:/root/run-codes/ic2.OlioDriver.* /home/amaji/store/amiya/R-scripts/input/
#cp ic2-results/* input/
fabanmaster="ee258vm2.ecn.purdue.edu:9980"
#echo -e "input/ic2.OlioDriver.111G.metrics\ninput/ic2.OlioDriver.111H.metrics" > exptlist.txt
#./ic2-plotresults.sh allparams

#expts="OlioDriver.128Q" # OlioDriver.128G OlioDriver.128H OlioDriver.128I OlioDriver.128J OlioDriver.128K OlioDriver.128L OlioDriver.128M OlioDriver.128N OlioDriver.128O OlioDriver.128P"
#expts="OlioDriver.128R OlioDriver.128S OlioDriver.128T OlioDriver.128U OlioDriver.128V OlioDriver.128W"

plot()
{
	expt="$1"
	intval="$2"	
#	echo "intval: $intval baselineex: ${blexlist['$intval']}"
#	echo -e "input/ic2.$expt.metrics \ninput/ic2.OlioDriver.${blexlist["$intval"]}.metrics \ninput/ic2.OlioDriver.${blexlist2["$intval"]}.metrics" > exptlist.txt
	cp ic2-results/$expt/* ic2-results/$ec2baseline/* ic2-results/$localbaseline/* input/ 
#	echo -e "input/ic2.$expt.metrics" >>  exptlist.txt
	echo -e "input/ic2.$expt.metrics \ninput/ic2.${ec2baseline}.metrics" >  exptlist.txt	
#	echo -e "input/ic2.$expt.metrics \ninput/ic2.${localbaseline}.metrics" >  exptlist.txt
	./ic2-plotresults.sh "$expt"
#	if [ ! -d plots/ic2plots/$expt ]
#	then
#		mkdir plots/ic2plots/$expt
#	fi
#	mv *.png plots/ic2plots/$expt
}

declare -A blexlist
blexlist["5"]="131O"
blexlist["10"]="131P"
blexlist["20"]="131Q"
blexlist["30"]="131R"
declare -A blexlist2
blexlist2["5"]="132S"
blexlist2["10"]="132T"
blexlist2["20"]="132U"
blexlist2["30"]="132V"
intervals=(5 10 20 30)

ec2baseline="OlioDriver.4R"
#localbaseline="OlioDriver.143K"
localbaseline="OlioDriver.143M"

#basename="OlioDriver.143"
basename="OlioDriver.6"
idx=0
#lst=""
for i in {A..A}
do
	plot "${basename}${i}" #"${intervals[$idx]}"
        idx=`expr $idx + 1`
done

#basename="OlioDriver.144"
#idx=0
#for i in {A..B}
#do
#	plot "${basename}${i}" #"${intervals[$idx]}"
#	idx=`expr $idx + 1`
#done

#plot "${basename}B"
#plot "${basename}F"
