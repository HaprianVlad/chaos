import sys
import struct

maxID = 10
degrees = {}
offset = 0
f = sys.argv[1]
p = sys.argv[2]
vp = sys.argv[3]
 (i % vp) * p + i / vp
with open(f,'rb') as infile:
	for chunk in iter((lambda:infile.read(8)),''):			
	        degrees[src] = struct.unpack('L', chunk[0:8])[0]
		offset = offset + 1
		if src >= maxID:
			break;
print degrees


