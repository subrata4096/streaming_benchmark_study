#!/bin/sh
if [ $# -lt 2 ]
then
	echo "Usage: $0 <sortByColName> <exptName>"
	exit 1
fi
#basedir="plots/sysmetrics-alt"
basedir="plots/sysmetrics"
if [ ! -d "$basedir" ]
then
	mkdir "$basedir"
fi
if [ ! -d "$basedir/$2" ]
then
	mkdir "$basedir/$2"
fi

./plotAllSysMetrics.sh "$1" "$2" "ee258vm8"
mkdir "$basedir/$2/ee258vm8"
mv *.png "$basedir/$2/ee258vm8/"

./plotAllSysMetrics.sh "$1" "$2" "ee258vm15"
mkdir "$basedir/$2/ee258vm15"
mv *.png "$basedir/$2/ee258vm15/"

mv input/*.csv "$basedir/$2/"
