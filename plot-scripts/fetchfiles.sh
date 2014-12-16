#!/bin/sh
expts=`grep -o "^[0-9A-Z]\+$" exptlist.txt`
echo $expts

files=""

for expt in $expts
do
	if [ "$expt" != "" ]
	then
		files="*$expt.log,$files"
	fi 
done

files=${files%?}
echo "files are ${files}"

#mkdir results-raw/$expt
#scp root@ee258vm6.ecn.purdue.edu:/root/logs/\{$files\} results-raw/
#scp root@ee258lnx01.ecn.purdue.edu:/root/amiya-scripts/ICE/opdata/\{$files\} results-raw/
scp root@ee258vm8.ecn.purdue.edu:/root/logs/\{$files\} results-raw/

cd results-raw
./sort-results.sh
