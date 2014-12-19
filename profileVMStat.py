#!/usr/bin/python
import os
import time
filename="/root/vmstat_status.txt"
command = "rm " + filename
os.system(command)

while(1):
        #command  = "netstat -i >> " + filename
        command  = "date >> " + filename
        os.system(command)
        command  = "vmstat >> " + filename
        os.system(command)
        time.sleep(10)
