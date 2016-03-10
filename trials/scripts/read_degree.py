
import sys
import struct


maxID = 10
degrees = {}
i = 0
with open(sys.argv[1],'rb') as infile:
    
	for chunk in iter((lambda:infile.read(8)),''):
	        src = struct.unpack('I', chunk[0:4])[0]
       	        degree_value = struct.unpack('I', chunk[4:8])[0]
		degrees[src] = degree_value
		i = i + 1
		if i >= maxID:
			break;	
	     

print degrees


