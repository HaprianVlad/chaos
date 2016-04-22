# Converts X-Stream input into Pegasus-compatible input
import sys
import struct

print 'Converting from ' + sys.argv[1] + ' to ' + sys.argv[2]

with open(sys.argv[1],'r') as infile:
    with open(sys.argv[2],'wb') as outfile:
       for line in infile.xreadlines():
	   (source, target) = map(lambda x: int(x), line.strip().replace('\t', ' ').split())
           outfile.write(struct.pack('II', source, target))

print 'Done!'

