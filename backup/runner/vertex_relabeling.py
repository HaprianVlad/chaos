import sys
import struct
import mmap

def main(argv):
	in_graph = sys.argv[1]
	scale = sys.argv[2]
	out_graph = sys.argv[3]

	permutation = readRandomPermutation(scale)

	print permutation
	outfile = open(out_graph,'ab')

	with open(in_graph,'rb') as infile:
		for chunk in iter((lambda:infile.read(12)),''):
			src = struct.unpack('I', chunk[0:4])[0]
		       	tgt = struct.unpack('I', chunk[4:8])[0]
		
			new_src = struct.pack('I', bit_permutation(src, permutation))
			new_tgt = struct.pack('I', bit_permutation(tgt, permutation))
							
			outfile.write(new_src)
			outfile.write(new_tgt)
			outfile.write(chunk[8:12])

	outfile.close()

			

def readRandomPermutation(scale):
	permutation = {}
	v_id = 0
	v_id_new = 0
	
	with open("/media/ssd/permutation_rmat"+str(scale)) as f:
		f =  mmap.mmap(f.fileno(), 0, prot=mmap.PROT_READ) 
		data = 1   
	   	while data:
			data = f.readline()
			v_id, v_id_new = data.partition("=")[::2]
			permutation[long(v_id)] = long(v_id_new)
	
	return permutation

def bit_permutation(value, permutation):

	return value


if __name__ == "__main__":
	if len (sys.argv) != 4:
		print "Usage: python vertex_rellabeling.py <graph in file> <scale> <graph out file>"
	else :
		main(sys.argv[1:])
