import sys
import struct

maxID = 10
degrees = {}
offset = 0
f = sys.argv[1]
p = int(sys.argv[2])
vp = int(sys.argv[3])

found=0
with open(f,'rb') as infile:
	for chunk in iter((lambda:infile.read(8)),''):			
		value =  struct.unpack('Q', chunk[0:8])[0]
		v_id = ((offset % vp) *  p) + (offset/vp) 
		if (v_id < maxID):
			print found
			print v_id
			print
			degrees[v_id] = value
			found = found + 1
			if (found >= maxID):
				break;		
			
		offset +=1
print degrees


