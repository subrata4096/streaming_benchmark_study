#!/usr/bin/python

import sys
from datetime import *
import numpy as np
from scipy.stats import *
import matplotlib.pyplot as plt


#percentageWithZeroDelay = [0.38961038961038963,0.5654761904761905,0.851063829787234,0.8458149779735683,0.6861313868613139,0.1449814126394052]
percentageWithZeroDelay = [0.15789473684210525, 0.946236559139785, 0.8349056603773585, 0.8529411764705882, 0.9208333333333333, 0.9490445859872612,0.8709677419354839,0.9380952380952381,0.9742388758782201,0.9488054607508533]
#numThreads = [10,20,50,100,200,500]
numThreads = [1,5,10,20,30,40,50,100,200,500]
xaxis = [1,2,3,4,5,6,7,8,9,10]
percentageWithDelay = []
for zd in percentageWithZeroDelay:
	d = 1 - zd
	percentageWithDelay.append(d)
	
fig, ax = plt.subplots()
#ax.plot(numThreads, percentageWithDelay)
ax.bar(xaxis, percentageWithDelay)
ax.set_xticklabels(numThreads)
plt.xlabel('num of threads')
plt.ylabel('percentage of time under delay')
#legend = ax.legend(loc='upper right', shadow=False)
#ax.legend().set_visible(True)
plt.show()
