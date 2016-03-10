
import sys
import struct


maxID = 10
degrees = {}
i = 0
with open(sys.argv[1],'rb') as infile:
    
	for chunk in iter((lambda:infile.read(8)),''):
	        src = struct.unpack('I', chunk[0:4])[0]
		if src < maxID:
		     degrees[src] = struct.unpack('I', chunk[4:8])[0]
	     

print degrees


