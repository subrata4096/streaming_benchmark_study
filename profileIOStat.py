#!/usr/bin/python
import os
import time
filename="/root/iostat_status.txt"
command = "rm " + filename
os.system(command)

while(1):
        #command  = "netstat -i >> " + filename
        command  = "iostat -t >> " + filename
        os.system(command)
        time.sleep(10)
