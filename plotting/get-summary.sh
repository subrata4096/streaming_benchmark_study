#!/bin/sh
environs="ec2 local"
expts="ic2 baseline"
benchmarks="llc dcopyhigh dcopylow"

echo "environ,expt,benchmark,mean,median,sdev" > master-results.csv

for env in $environs
do

for bm in $benchmarks
do

for expt in $expts
do
	echo "environment: $env expt: $expt benchmark: $bm "
	grep "$bm" $env.$expt.intf.summary | awk -v FS=, '{print $3}' > temp.data
	output=`R -s -q -e "x <- read.csv('temp.data', header = F); summary(x); sd(x[ , 1])"`
#	Min.   :0.6863  
# 1st Qu.:1.3722  
# Median :1.7987  
# Mean   :1.8346  
# 3rd Qu.:2.3707  
# Max.   :3.2498  
#[1] 0.7429871

	mean=`echo "$output" | grep Mean | cut -d\: -f2`
	median=`echo "$output" | grep Median | cut -d\: -f2`
	sd=`echo "$output" | grep "\[1\]" | cut -d\  -f2`

	echo "$env,$expt,$bm,$mean,$median,$sd" >> master-results.csv
	echo "$output"

	echo "$env,$expt,$bm,$mean,$median,$sd"
	
done
done
done
