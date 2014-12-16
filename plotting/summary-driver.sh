#!/bin/sh
if [ $# -lt 1 ]
then 
	echo "Specify which half"
	exit 1
fi

./run-resultgen-local.sh
./run-resultgen-ec2.sh

./get-summary.sh
mv master-results.csv $1-master-result.csv
