import sys
import struct


def main(argv):
	in_graph = sys.argv[1]
	scale = sys.argv[2]
	out_graph = sys.argv[3]

	permutation = readRandomPermutation(scale)

	print permutation
	#outfile = open(out_graph,'ab')

	#with open(in_graph,'rb') as infile:
	#	for chunk in iter((lambda:infile.read(12)),''):
	#		src = struct.unpack('I', chunk[0:4])[0]
	 #       	tgt = struct.unpack('I', chunk[4:8])[0]
	#	
	#		new_src = struct.pack('I', permutation[src])
	#		new_tgt = struct.pack('I', permutation[tgt])
							
	#		outfile.write(new_src)
	#		outfile.write(new_tgt)
	#		outfile.write(chunk[8:12])

	#outfile.close()

			

def readRandomPermutation(scale):
	permutation = {}
	with open("permutation"+str(scale)) as myfile:
   		for line in myfile:
			v_id, v_id_new = line.partition("=")[::2]
			permutation[int(v_id)] = int(v_id_new)
	return permutation



if __name__ == "__main__":
	if len (sys.argv) != 4:
		print "Usage: python vertex_rellabeling.py <graph in file> <scale> <graph out file>"
	else :
		main(sys.argv[1:])
