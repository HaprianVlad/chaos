import sys
import struct

maxID = 10
degrees = {}
offset = 0
f = sys.argv[1]
p = sys.argv[2]
vp = sys.argv[3]


with open(f,'rb') as infile:
	for chunk in iter((lambda:infile.read(8)),''):			
		offset = offset + 1
		v_id = getVertexId(offset, p, vp)
		degrees[v_id] = struct.unpack('L', chunk[0:8])[0]
		if v_id >= maxID:
			break;
print degrees

def getVertexId(offset, p, vp): 
	i=0
	while (((i % vp) * p + i / vp) != i):
		i+=1
	return i 
