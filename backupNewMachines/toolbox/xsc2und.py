# Converts X-Stream type 1 input into type 2
import sys
import struct

print 'Converting from ' + sys.argv[1] + ' to ' + sys.argv[2]

with open(sys.argv[1],'rb') as infile:
    with open(sys.argv[2],'wb') as outfile:
       for chunk in iter((lambda:infile.read(8)),''):
           outfile.write(chunk[0:8])
           outfile.write(chunk[4:8] + chunk[0:4])

print 'Done!'

