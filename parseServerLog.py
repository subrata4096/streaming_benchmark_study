#!/usr/bin/python
import sys
from datetime import *
import numpy as np
from scipy.stats import *
import matplotlib.pyplot as plt

experiment_rampup_time = 160
experiment_steadystate_time = experiment_rampup_time + 180
experiment_rampdown_time = experiment_steadystate_time + 30

def plotCDF(dataArr):
	#dataArr = [0,0,0,0,1,1,1,2,2,3]
	#data = np.loadtxt('Filename.txt')
	dataArr = np.sort(dataArr)
	# Choose how many bins you want here
	num_bins = 300

	# Use the histogram function to bin the data
	counts, bin_edges = np.histogram(dataArr, bins=num_bins)
	#counts, bin_edges = np.histogram(dataArr, bins=num_bins, normed=True)
	counts = counts/float(len(dataArr))
	#print counts
	#print bin_edges

	# Now find the cdf
	cdf = np.cumsum(counts)

	# And finally plot the cdf
	plt.plot(bin_edges[1:], cdf)


def parseFile(logFile):
	lines = logFile.readlines()
	server_started = False
	header_found = False
	bm_start_time = datetime(1970, 1, 1)
	startTimeFound = False
	avgDelayList = []
	for line in lines:
		line = line.strip()
		
		if(-1 != line.find("Streaming Server done starting up")):
			server_started = True
			continue
		
		#print server_started
		if(server_started == False):
			continue

		if(-1 != line.find("AvgDelay")):
			header_found = True
			continue

		if(header_found == False):
			continue
		
		fields = line.split()
		
		avgDelay_Str = fields[6].strip()
		avgDelay = int(avgDelay_Str)
		timeStamp = fields[11] + " " + fields[12]
		#print avgDelay, timeStamp

		if((startTimeFound == False) and (avgDelay != 0)): 
			bm_start_time = datetime.strptime(timeStamp, '%Y-%m-%d %H:%M:%S')
			startTimeFound = True
			continue
		#dt = datetime.fromtimestamp(timeStamp)
		if(startTimeFound == False):
			continue
		dt = datetime.strptime(timeStamp, '%Y-%m-%d %H:%M:%S')
		
		#print bm_start_time, dt		
		expDuration = (dt - bm_start_time).total_seconds()
		#print dt, expDuration
		if((expDuration >= experiment_rampup_time) and (expDuration <= experiment_steadystate_time)):	
			if(avgDelay < 0):
				avgDelay = 0	
			avgDelayList.append(avgDelay)
		
	return avgDelayList	

if __name__ == "__main__":
	logFileName = sys.argv[1]
	print "logFile: " , logFileName , "\n"
	logFile = open(logFileName, 'r')
        avgDelayList = parseFile(logFile)	
	print len(avgDelayList)
	print avgDelayList
	arr = np.array(avgDelayList)
	mean = np.mean(arr)
	avg = np.average(arr)
	print mean, avg
	#rv_discrete.cdf(arr)
	#hist, bin_edges = np.histogram(np.random.randint(0,10,100))
	#cdf = np.cumsum(hist)
	#print cdf
  	plotCDF(arr)
	
	plt.show()

