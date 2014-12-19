#!/usr/bin/python
import sys
import collections
from datetime import *
import numpy as np
from scipy.stats import *
import matplotlib.pyplot as plt

#experiment_start_time = 0
#experiment_rampup_time = 150
#experiment_rampup_time = 600
#experiment_rampup_time = 800
#experiment_rampup_time = 240
experiment_rampup_time = 20
experiment_steadystate_time = experiment_rampup_time + 800
#experiment_steadystate_time = experiment_rampup_time + 420
#experiment_steadystate_time = experiment_rampup_time + 1200
experiment_rampdown_time = experiment_steadystate_time + 30

#target_RTSP_conn = 4200
#target_RTSP_conn = 3000
#target_RTSP_conn = 2000
#target_RTSP_conn = 2800
#target_RTSP_conn = 100
target_RTSP_conn = 10
#target_RTSP_conn = 3500
percentageOfTimeStreamsWithDelay = {}
def plotCDF(ax, dataArr, label, color):
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
	#plt.plot(bin_edges[1:], cdf, label=label, color=color)
	ax.plot(bin_edges[1:], cdf, label=label, color=color)

def plotWithTime(ax,timeValueMap,gColor):
	#xvals = timeValueMap.keys()
	#yvals = []
	#for k in xvals:
	#	yvals.append(timeValueMap[k])
        #print timeValueMap
      	od = collections.OrderedDict(sorted(timeValueMap.items()))
        print od
	xvals = []
	yvals = []
        for k, v in od.iteritems():
		xvals.append(k)
		yvals.append(v)
	ax.plot(xvals, yvals,c=gColor)
	#plt.scatter(xvals, yvals)

def parseFile(logFile, avg_or_max_delay):
	lines = logFile.readlines()
	bm_start_time = datetime(1970, 1, 1)
	avgDelayList = {}
        percent_with_zero_delay = 0
        totalcount = 0
	lastDelay = -999
	for line in lines:
		#print line
		line = line.strip()
             	if(line == ""):
			continue		
		fields = line.split(',')

		expDuration = float(fields[0].strip())
		if(expDuration < 200):
			continue 

		avgDelay_Str = ""
		#avgDelay_Str = fields[6].strip()
		if(avg_or_max_delay == "avg"):
			avgDelay_Str = fields[1].strip()
		elif(avg_or_max_delay == "max"):
			avgDelay_Str = fields[2].strip()

		avgDelay = float(avgDelay_Str)
		#print avgDelay, timeStamp


 		#smoothing. Low pass filter
		if(lastDelay < -900):
			print "here", lastDelay
			lastDelay = avgDelay
			continue
		else:
			newavgDelay = (avgDelay + 0.5*lastDelay)/float(1.5)
			#newavgDelay = avgDelay 
			print avgDelay, lastDelay, "=> " , newavgDelay
			lastDelay = avgDelay
		avgDelayList[expDuration] = newavgDelay
		
	return avgDelayList	

def calcPercentageOfTimeDelay(delayList,index):
	total_zero = 0
	for d in delayList:
		if(d <= 0):
			total_zero += 1

        percentage = total_zero/float(len(delayList))
        percentageOfTimeStreamsWithDelay[index] = percentage


num_of_logs = 2
if __name__ == "__main__":
	logFileName = sys.argv[1]
	option = "a"
	#option = sys.argv[5]
	avg_or_max_delay = "avg"
	#avg_or_max_delay = "max"
	if(option == "m"):
		avg_or_max_delay = "max"
	
  	fig, ax = plt.subplots()	
	avgDelayList = {}
	for i in range(num_of_logs):
		logFileName = sys.argv[i+1]
		print "logFile: " , logFileName , "\n"
		logFile = open(logFileName, 'r')
        	avgDelayList = parseFile(logFile,avg_or_max_delay)	
		print "numOfPoints" , len(avgDelayList)
		if(i==0):
        		plotWithTime(ax,avgDelayList,'r')        
		if(i==1):
        		plotWithTime(ax,avgDelayList,'b')        

        #print percentageOfTimeStreamsWithDelay
	# Now add the legend with some customizations.
        #plotWithTime(ax,avgDelayList)        
        plt.xlabel('time in sec')
	plt.ylabel('avg delay values (in ms)') 
	#plt.title('weights: 7:10  server threads: 100')
	#legend = ax.legend(loc='upper right', shadow=False)	
	#ax.legend().set_visible(True)
	plt.show()

