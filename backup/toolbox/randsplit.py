# Split file in n different chunks while assigning edges randomly
import sys
import os
import random
import math

print 'Splitting ' + sys.argv[1] + ' in ' + sys.argv[2]

fsize = os.stat(sys.argv[1]).st_size / 8
csize = int(math.ceil(float(fsize) / float(sys.argv[2])))
last_csize = -(fsize - csize * int(sys.argv[2]))

print "Total number of edges: " + str(fsize)
print "Edges per chunk: " + str(csize)
print "Last chunk will have " + str(last_csize) + " edges less"

if not fsize == (csize * int(sys.argv[2]) - last_csize):
	raise AssertionError("Breakdown appears to be inconsistent")

with open(sys.argv[1],'rb') as infile:
	l = []
	n = []
	for i in range(0, int(sys.argv[2])):
		l.append(open(sys.argv[1] + "_s" + sys.argv[2] + "_" + str(i), 'wb'))
		if i == int(sys.argv[2]) - 1:
			n.append(last_csize)
		else:
			n.append(0)

	li = range(0, int(sys.argv[2]))
	k = 0
	m = 1
	for chunk in iter((lambda:infile.read(8)),''):
		k = k + 1
		if k == m * fsize / 100:
			print str(m) + "% done..."
			m = m + 1
		i = random.choice(li)
		l[i].write(chunk)
		n[i] = n[i] + 1
		if n[i] == csize:
			li.remove(i)
		
	for f in l:
		f.close()

print 'Done!'

