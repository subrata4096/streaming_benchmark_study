#!/bin/sh
env="ec2"
basename="OlioDriver.4" #4M - 4V are baseline
rm baselinelist.txt
for c in {M..V}
do
	echo "${basename}$c" >> baselinelist.txt
done

basename="OlioDriver.5"
rm ic2list.txt
echo "OlioDriver.5T" >> ic2list.txt
for c in {V..Z}
do
        echo "${basename}$c" >> ic2list.txt
done

basename="OlioDriver.6"
for c in {A..D}
do
        echo "${basename}$c" >> ic2list.txt
done


#echo "OlioDriver.6C" > baselinelist.txt
#echo "OlioDriver.6C" > ic2exptlist.txt
java ResultGenerator "baseline" > $env.baseline.intf.summary 
java ResultGenerator "ic2" > $env.ic2.intf.summary
