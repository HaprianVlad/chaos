import sys
import struct

maxID = 10
degrees = {}
src = 0
with open(f,'rb') as infile:
	for chunk in iter((lambda:infile.read(8)),''):			
	        degrees[src] = struct.unpack('L', chunk[0:8])[0]
		src = src + 1
		if src >= maxID:
			break;
print degrees


