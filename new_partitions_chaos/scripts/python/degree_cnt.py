
import sys
import struct

maxID = 10
outDegrees = {}
inDegrees = {}
for i in range(maxID):
	outDegrees[i] = 0
	inDegrees[i] = 0
f = sys.argv[1]		
with open(f,'rb') as infile:	    
	for chunk in iter((lambda:infile.read(12)),''):
		src = struct.unpack('I', chunk[0:4])[0]
       	        tgt = struct.unpack('I', chunk[4:8])[0]
		if src < maxID:
			outDegrees[src] = outDegrees[src] + 1
		if tgt < maxID:
	   		inDegrees[tgt] = inDegrees[tgt] + 1

print "OUT DEGREES EXPECTED"
print outDegrees
print "IN DEGREES EXPECTED"
print inDegrees

