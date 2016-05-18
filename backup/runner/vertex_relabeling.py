import sys
import struct
import mmap

def main(argv):
	in_graph = sys.argv[1]
	scale = int(sys.argv[2])
	out_graph = sys.argv[3]

	permutation = readRandomPermutation(scale)

	outfile = open(out_graph,'ab')

	with open(in_graph,'rb') as infile:
		for chunk in iter((lambda:infile.read(12)),''):
			src = struct.unpack('I', chunk[0:4])[0]
		       	tgt = struct.unpack('I', chunk[4:8])[0]
		
			new_src = struct.pack('I', bit_permutation(src, permutation,scale))
			new_tgt = struct.pack('I', bit_permutation(tgt, permutation,scale))
							
			outfile.write(new_src)
			outfile.write(new_tgt)
			outfile.write(chunk[8:12])

	outfile.close()

			

def readRandomPermutation(scale):
	permutation = {}
	with open("/media/ssd/permutation_rmat"+str(scale)) as f:
		for line in f:
			v_id, v_id_new = line.partition("=")[::2]
			permutation[long(v_id)] = long(v_id_new)
	
	return permutation

def bit_permutation(x, permutation, scale):
	result=0
	for i in range(scale):
		bitToInsert = get_bit(x, permutation[i]) 
		result = result | (bitToInsert << i)
	
	return result

def get_bit(x, i):
	return (x >> i) & 0x01

if __name__ == "__main__":
	if len (sys.argv) != 4:
		print "Usage: python vertex_rellabeling.py <graph in file> <scale> <graph out file>"
	else :
		main(sys.argv[1:])
