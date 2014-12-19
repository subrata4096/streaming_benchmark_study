#!/usr/bin/python
import sys
from datetime import *
import numpy as np
from scipy.stats import *
import matplotlib.pyplot as plt

#experiment_start_time = 0
#experiment_rampup_time = 150
experiment_rampup_time = 0
experiment_steadystate_time = experiment_rampup_time + 400
#experiment_steadystate_time = experiment_rampup_time + 600
experiment_rampdown_time = experiment_steadystate_time + 30

#target_RTSP_conn = 4200
#target_RTSP_conn = 3000
#target_RTSP_conn = 2000
#target_RTSP_conn = 2800
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


def plotWithTime(timeValueMap):
        xvals = timeValueMap.keys()
        yvals = []
        for k in xvals:
                cpi,cmr = timeValueMap[k]
                yvals.append(cmr)
        #print timeValueMap
        #ax.plot(xvals, yvals)
	plt.scatter(xvals,yvals, c='r')
        #plt.xlabel('avg delay in sec')
        #plt.ylabel('cdf')

def plotWithTimeTwoScale(timeValueMap):
	xvals = timeValueMap.keys()
        yvals1 = []
        yvals2 = []
        for k in xvals:
                cpi,cmr = timeValueMap[k]
                yvals1.append(cpi)
                yvals2.append(cmr)
	
	#plt.scatter(xvals,yvals1, c='b', marker="+")
	fig, ax1 = plt.subplots()
	ax1.plot(xvals,yvals2, c='b', linestyle='.')
	ax1.set_xlabel('time (s)')
	# Make the y-axis label and tick labels match the line color.
	ax1.set_ylabel('CMR', color='b')
	for tl in ax1.get_yticklabels():
    		tl.set_color('b')
	
	ax2 = ax1.twinx()
	#plt.scatter(xvals,yvals2, c='r', marker="o")
	ax2.plot(xvals,yvals2, c='r', linestyle='--')
	#ax2.set_ylabel('CMR', color='r')
	#for tl in ax2.get_yticklabels():
    	#	tl.set_color('r')

def parseFile(logFile, avg_or_max_delay):
	lines = logFile.readlines()
	server_started = False
	header_found = False
	bm_start_time = datetime(1970, 1, 1)
	startTimeFound = False
	avgDelayList = {}
        percent_with_zero_delay = 0
        totalcount = 0
        i = 0
	for line in lines:
		#print line
                i = i + 1
		line = line.strip()
		
		if(-1 != line.find("TimeStamp")):
			continue
		
		fields = line.split(',')

		readTime = float(fields[0].strip())
		cpi = float(fields[1].strip())
		cmr = float(fields[2].strip())

 		if(i == 2):
                       bm_start_time = readTime

                print readTime, bm_start_time
		expDuration = (readTime - bm_start_time)
			
		avgDelayList[expDuration] = (cpi,cmr)
		
	return avgDelayList	

num_of_logs = 1
if __name__ == "__main__":
	logFileName = sys.argv[1]
	#logFileName2 = sys.argv[2]
	#logFileName3 = sys.argv[3]
	#logFileName4 = sys.argv[4]
	#logFileName5 = sys.argv[5]
	#logFileName6 = sys.argv[6]
	#logFileName7 = sys.argv[7]
	option = "a"
	#option = sys.argv[5]
	avg_or_max_delay = "avg"
	#avg_or_max_delay = "max"
	if(option == "m"):
		avg_or_max_delay = "max"
	
  	#fig, ax = plt.subplots()	

	for i in range(num_of_logs):
		logFileName = sys.argv[i+1]
		print "logFile: " , logFileName , "\n"
		logFile = open(logFileName, 'r')
        	avgDelayList = parseFile(logFile,avg_or_max_delay)	
		print "numOfPoints" , len(avgDelayList)
		#print avgDelayList
                #calcPercentageOfTimeDelay(avgDelayList, i)
		#arr = np.array(avgDelayList)
		#mean = np.mean(arr)
		#avg = np.average(arr)
		#print mean, avg
		#rv_discrete.cdf(arr)
		#hist, bin_edges = np.histogram(np.random.randint(0,10,100))
		#cdf = np.cumsum(hist)
		#print cdf
		#if(i == 0):	
		#	plotCDF(ax, arr, '10', 'blue')
                #elif(i == 1):
                #        plotCDF(ax, arr, '20', 'yellow')
		#elif(i == 2):
		#	plotCDF(ax, arr, '50', 'red')
		#elif(i == 3):
		#	plotCDF(ax, arr, '100', 'green')
		#elif(i == 4):
		#	plotCDF(ax, arr, '200', 'black')
		#elif(i == 5):
		#	plotCDF(ax, arr, '500', 'brown')
		#elif(i == 6):
		#	plotCDF(ax, arr, '1000', 'cyan')
                #elif(i == 6):
                 #       plotCDF(ax, arr, '500', 'yellow')

        #print percentageOfTimeStreamsWithDelay
	# Now add the legend with some customizations.
       
        #plotWithTime(ax,avgDelayList)
        #plotWithTime(avgDelayList)
        plotWithTimeTwoScale(avgDelayList)
 
	#legend = ax.legend(loc='upper right', shadow=False)	
	#ax.legend().set_visible(True)
	plt.show()

