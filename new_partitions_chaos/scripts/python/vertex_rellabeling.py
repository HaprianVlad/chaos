import sys
import struct
from numpy import np

def main(argv):
	in_graph = sys.argv[1]
	scale = sys.argv[2]
	out_graph = sys.argv[3]

	permutation = getRandomPermutation(scale)

	outfile = open(out_graph,'ab')

	with open(in_graph,'rb') as infile:
		for chunk in iter((lambda:infile.read(12)),''):
			src = struct.unpack('I', chunk[0:4])[0]
	        	tgt = struct.unpack('I', chunk[4:8])[0]
		
			new_src = struct.pack('I', permutation[src])[0]
			new_tgt = struct.pack('I', permutation[tgt])[0]
							
			outfile.write(new_src)
			outfile.write(new_tgt)
			outfile.write(chunk[9:12])

	outfile.close()

			

def getRandomPermutation(scale):
	return np.random.permutation(scale)



if __name__ == "__main__":
	if len (sys.argv) != 4:
		print "Usage: python vertex_rellabeling.py <graph in file> <scale> <graph out file>"
	else :
		main(sys.argv[1:])
