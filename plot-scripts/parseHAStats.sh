#!/bin/sh
if [ $# -lt 1 ]
then
	echo "Usage: $0 <exptid>"
	exit
fi
exptid="$1"
logfile="results-raw/$exptid/hastats-$exptid.log"
outfile="input/hastats-$exptid.csv"

#ts,# pxname,svname,qcur,qmax,scur,smax,slim,stot,bin,bout,dreq,dresp,ereq,econ,eresp,wretr,wredis,status,weight,act,bck,chkfail,chkdown,lastchg,downtime,qlimit,pid,iid,sid,throttle,lbtot,tracked,type,rate,rate_lim,rate_max,check_status,check_code,check_duration,hrsp_1xx,hrsp_2xx,hrsp_3xx,hrsp_4xx,hrsp_5xx,hrsp_other,hanafail,req_rate,req_rate_max,req_tot,cli_abrt,srv_abrt,comp_in,comp_out,comp_byp,comp_rsp,lastsess,last_chk,last_agt,qtime,ctime,rtime,ttime,

echo "exptid,ts,srvname,qcur,sesscur,qtime,conntime,resptime,totaltime" > $outfile

awk -f printcols.awk FS=',' OFS=',' ex="$exptid" c1="ts" c2="svname" c3="qcur" c4="scur" c5="qtime" c6="ctime" c7="rtime" c8="ttime" < $logfile >> $outfile
