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

def plotWithTime(ax,timeValueMap):
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
	ax.plot(xvals, yvals)
	#plt.scatter(xvals, yvals)

def parseFile(logFile, avg_or_max_delay,avgDelayList):
	lines = logFile.readlines()
	server_started = False
	header_found = False
	bm_start_time = datetime(1970, 1, 1)
	startTimeFound = False
	#avgDelayList = {}
        percent_with_zero_delay = 0
        totalcount = 0
	for line in lines:
		#print line
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

		rtsp_conns_str = fields[0].strip()
		rtsp_conns = int(rtsp_conns_str)
                d = target_RTSP_conn - rtsp_conns
		#print "here,", rtsp_conns, target_RTSP_conn, d
		#if(d == 0):
		if(rtsp_conns < target_RTSP_conn):
			continue

		#print "passed"	
		avgDelay_Str = ""
		#avgDelay_Str = fields[6].strip()
		if(avg_or_max_delay == "avg"):
			avgDelay_Str = fields[6].strip()
		elif(avg_or_max_delay == "max"):
			avgDelay_Str = fields[7].strip()

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
		expDuration = float((dt - bm_start_time).total_seconds())
		print dt, expDuration, bm_start_time, " => " , avgDelay
		if((expDuration >= experiment_rampup_time) and (expDuration <= experiment_steadystate_time)):	
			#print "entering:"
			if(avgDelay < 0):
				avgDelay = 0
                        #if(avgDelay > 200):
			#	continue
			#avgDelayList.append(avgDelay)
			if(expDuration not in avgDelayList):
				avgDelayList[expDuration] = []

			#avgDelayList[expDuration] = avgDelay
			avgDelayList[expDuration].append(avgDelay)
		
	return avgDelayList	

def calcPercentageOfTimeDelay(delayList,index):
	total_zero = 0
	for d in delayList:
		if(d <= 0):
			total_zero += 1

        percentage = total_zero/float(len(delayList))
        percentageOfTimeStreamsWithDelay[index] = percentage

def getTimeWiseAvg(avgDelayList):
	newAvgList = {}
	for k in avgDelayList.keys():
		delayList = avgDelayList[k]
		arr = np.array(delayList)
		delayAvg = np.array(arr)
		newAvgList[k] = delayAvg
		print "delays:", arr, "  avg: " , delayAvg
	return newAvgList

def outputToCSVFile(fname,avgDelayList):
	od = collections.OrderedDict(sorted(avgDelayList.items()))
	f = open(fname, "w")
	#for k in avgDelayList.keys():
	for k, v in od.iteritems():
		delayList = avgDelayList[k]
                avgVal = delayList[0]
		line = str(k) + "," + str(avgVal) + "\n"
		f.write(line)
	f.close()

num_of_logs = 3
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
	
  	fig, ax = plt.subplots()	
	avgDelayList = {}
	for i in range(num_of_logs):
		logFileName= sys.argv[i+1]
		print "logFile: " , logFileName , "\n"
		logFile = open(logFileName, 'r')
        	#avgDelayList = parseFile(logFile,avg_or_max_delay)	
        	parseFile(logFile,avg_or_max_delay,avgDelayList)	
		print "numOfPoints" , len(avgDelayList)
		#print avgDelayList
                #calcPercentageOfTimeDelay(avgDelayList, i)
		#arr = np.array(avgDelayList)
		#mean = np.mean(arr)
		#avg = np.average(arr)
		#print mean, avg
		##rv_discrete.cdf(arr)
		##hist, bin_edges = np.histogram(np.random.randint(0,10,100))
		##cdf = np.cumsum(hist)
		##print cdf
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
		##elif(i == 6):
		##	plotCDF(ax, arr, '1000', 'cyan')
                ##elif(i == 6):
                # #       plotCDF(ax, arr, '500', 'yellow')

        #print percentageOfTimeStreamsWithDelay
	# Now add the legend with some customizations.

	avgDelayList = getTimeWiseAvg(avgDelayList)
	fname = sys.argv[num_of_logs+1]
	outputToCSVFile(fname,avgDelayList) 
        plotWithTime(ax,avgDelayList)        
        plt.xlabel('time in sec')
	plt.ylabel('avg delay values (in ms)') 
	plt.title('weights: 7:10  server threads: 100')
	#legend = ax.legend(loc='upper right', shadow=False)	
	#ax.legend().set_visible(True)
	plt.show()

