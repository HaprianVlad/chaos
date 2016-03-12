import sys
import struct

print 'Statistics on degree count ' + sys.argv[1]

degree0_10 = 0
degree10_100 = 0
degree100_500 = 0
degree500_1000 = 0
degree1000_5000 = 0 
degree5000_10000 = 0
degree10000 = 0

with open(sys.argv[1],'rb') as infile:
    
	for chunk in iter((lambda:infile.read(8)),''):
	        degree = struct.unpack('I', chunk[0:4])[0]

		if (degree < 10):
			degree0_10 = degree0_10 + 1
			continue
		if (degree < 100):
			degree10_100 = degree10_100 + 1
			continue
		if (degree < 500):
			degree100_500 = degree100_500 + 1
			continue
		if (degree < 1000):
			degree500_1000 = degree500_1000 + 1
			continue
		if (degree < 5000):
			degree1000_5000 = degree1000_5000 + 1
			continue
		if (degree < 10000):
			degree5000_10000 = degree5000_10000 + 1
			continue
		degree10000 = degree10000 + 1

	         

print "[0, 10] : " + degree0_10
print "[10, 100] : " + degree10_100
print "[100, 500] : " + degree100_500
print "[500, 1000] : " + degree500_1000
print "[1000, 5000] : " + degree1000_5000
print "[5000, 10000] : " + degree5000_10000
print "[10000, inf] : " + degree10000
