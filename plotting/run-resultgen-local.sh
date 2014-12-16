#!/bin/sh
env="local"
basename="OlioDriver.143" #4M - 4V are baseline
rm baselinelist.txt
for c in {I..R}
do
	echo "${basename}$c" >> baselinelist.txt
done

basename="OlioDriver.143"
rm ic2list.txt
for c in {S..Z}
do
        echo "${basename}$c" >> ic2list.txt
done

basename="OlioDriver.144"
for c in {A..B}
do
        echo "${basename}$c" >> ic2list.txt
done


#echo "OlioDriver.6C" > baselinelist.txt
#echo "OlioDriver.6C" > ic2exptlist.txt
java ResultGenerator "baseline" > $env.baseline.intf.summary 
java ResultGenerator "ic2" > $env.ic2.intf.summary
