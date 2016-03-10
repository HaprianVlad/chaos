import sys
import struct

global maxID = 10

def main(argv):
	rmatFile = sys.argv[1]
	outDegreeResultsFile = sys.argv[2]
	inDegreeResultsFile = sys.argv[3]

	expected = computeDegreesOnRmatGraph(rmatFile)

	outDegreesExpected = expected[1]
	inDegreesExpected = expected[2]

	outDegreesComputed = readDegrees(outDegreeResultsFile)
	inDegreesComputed = readDegrees(inDegreeResultsFile)
	
	print "OUT DEGREES EXPECTED"
	print outDegreesEXPECTED
	print "OUT DEGREES COMPUTED"
	print outDegreesComputed

	print "IN DEGREES EXPECTED"
	print inDegreesEXPECTED
	print "OUT DEGREES COMPUTED"
	print inDegreesComputed
	
	if verify(outDegreesExpected, outDegreesComputed):
		print "OUT DEGREE TEST PASSED"
	else 
		print "OUT DEGREE TEST FAILED"

	if verify(inDegreesExpected, inDegreesComputed):
		print "IN DEGREE TEST PASSED"
	else 
		print "IN DEGREE TEST FAILED"




def verify(d1, d2):
	if len(d1.keys()) != len(d2.keys()):
		return False
	for k1 in d1.keys():
		if d1[k1] != d2[k1]:
			return False
	return True


def readDegrees(f):
	degrees = {}
	with open(f,'rb') as infile:
	for chunk in iter((lambda:infile.read(8)),''):
	        src = struct.unpack('I', chunk[0:4])[0]
		if src < maxID:
		     degrees[src] = struct.unpack('I', chunk[4:8])[0]
	return degrees

def computeDegreesOnRmatGraph(f):
	outDegrees = {}
	inDegrees = {}
	for i in range(maxID):
		outDegrees[i] = 0
		inDegrees[i] = 0		
	with open(f,'rb') as infile:	    
		for chunk in iter((lambda:infile.read(8)),''):
			src = struct.unpack('I', chunk[0:4])[0]
	       	        tgt = struct.unpack('I', chunk[4:8])[0]
			if src < maxID:
				outDegrees[src] = outDegrees[src] + 1
			if tgt < maxID:
		   		inDegrees[tgt] = inDegrees[tgt] + 1
	return [outDegrees, inDegrees]

if __name__ == "__main__":
	if len (sys.argv) != 3 :
		print "Usage: python test_degree.py <rmatGraph file path> <outDegreeResults file path> <inDegreeResults file path> "
	main(sys.argv[1:])
		



