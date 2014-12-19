#!/usr/bin/python
import os
import time
filename="/root/network_status.txt"
command = "rm " + filename
os.system(command)

while(1):
        #command  = "netstat -i >> " + filename
        command  = "netstat -s -t >> " + filename
        os.system(command)
        time.sleep(10)
