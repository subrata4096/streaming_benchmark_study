#!/bin/sh
expts=`ls *.png | grep -o "[0-9]\+[A-Z]\+" | sort -u`
echo $expts

for expt in $expts
do
	if [ "$expt" != "" ]
	then
		mkdir plots-raw/$expt
		mv *$expt.png plots-raw/$expt/
	fi
done

