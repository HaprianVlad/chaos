# Converts X-Stream type 1 input into type 2
import sys
import struct

print 'Converting from ' + sys.argv[1]

with open(sys.argv[1],'rb') as infile:
    max=0
    for chunk in iter((lambda:infile.read(8)),''):
       src = struct.unpack('I', chunk[0:4])[0]
       tgt = struct.unpack('I', chunk[4:8])[0]
       if src > max:
           max=src
       if tgt > max:
           max=tgt

print "max=" + str(max)

