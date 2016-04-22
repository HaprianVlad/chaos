# Converts X-Stream input into Pegasus-compatible input
import sys
import random

#print 'Generating graph with n=' + sys.argv[1] + ' to ' + sys.argv[2]

n=int(sys.argv[1])
m=16

with open(sys.argv[2],'w') as outfile:
	for i in range(0,n):
		tmp=""
		for j in range(0,m):
			tmp = tmp + "[" + str(random.randrange(0,n)) + "," + str(random.randrange(0,m))  + "]"
			if j < m - 1:
				tmp = tmp + ","
	        print "[" + str(i) + ",0,[" + tmp + "]]"   
	#outfile.write(str(source) + '\t' + str(target) + '\n')

#print 'Done!'

