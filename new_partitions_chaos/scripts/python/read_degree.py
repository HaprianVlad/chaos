import sys
import struct

maxID = 10
degrees = {}
offset = 0
f = sys.argv[1]
p = int(sys.argv[2])
vp = int(sys.argv[3])

def getVertexId(offset, p, vp):
        i=0
	while (True):
		if (((i % vp) * p + i / vp) == offset):
                	return [True, i]
		i+=1
		if (i >= maxID):
			break;

        return [False]

found=0
with open(f,'rb') as infile:
	for chunk in iter((lambda:infile.read(8)),''):			
		res = getVertexId(offset, p, vp)
		value =  struct.unpack('L', chunk[0:8])[0]
		print value
		if (res[0]):
			v_id = res[1]
			degrees[v_id] = value
			found = found + 1
			if (found >= maxID):
				break;		
			
		offset +=1
print degrees


