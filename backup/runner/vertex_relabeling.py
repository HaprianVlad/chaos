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
		
			new_src = struct.pack('I', permutation[src])
			new_tgt = struct.pack('I', permutation[tgt])
							
			outfile.write(new_src)
			outfile.write(new_tgt)
			outfile.write(chunk[8:12])

	outfile.close()

			

def readRandomPermutation(scale):
	permutation = {}
	with open("/media/ssd/permutation_rmat"+str(scale)) as f:
		f =  mmap.mmap(f.fileno(), 0, prot=mmap.PROT_READ) 
                data = 1   
   		while data:
			data = f.readline()
			v_id, v_id_new = data.partition("=")[::2]
			print v_id
			print v_id_new
			permutation[long(v_id)] = long(v_id_new)
	return permutation



if __name__ == "__main__":
	if len (sys.argv) != 4:
		print "Usage: python vertex_rellabeling.py <graph in file> <scale> <graph out file>"
	else :
		main(sys.argv[1:])
