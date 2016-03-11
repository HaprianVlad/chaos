import sys
import struct

def main(argv):
	outDegreeFile = sys.argv[1]
	outDegreeSumPerPartition = sys.argv[2]
	maxNumberOfEdgesPerPartition = sys.argv[3]

	partitions = {}
	p_id = 0
	v_id = 0
	p_sum = 0
	start = 0
	with open(outDegreeFile,'rb') as infile:
		for chunk in iter((lambda:infile.read(8)),''):			
		        vertex_degree = struct.unpack('L', chunk[0:8])[0]
			p_sum = p_sum + vertex_degree
			if p_sum >= outDegreeSumPerPartition or p_sum >= maxNumberOfEdgesPerPartition:
				end = v_id  
				partitions[pid] = [start, end]
				
				start = v_id + 1 
				p_id +=1
				p_sum = 0

			v_id = v_id + 1

		partitions[pid] = [start, v_id-1]

	print partitions




if __name__ == "__main__":
	if len (sys.argv) != 4 :
		print "Usage: python create_new_partitions.py <vertex out degree file> <max sum of out degrees per partition> <max number of edges per partition> "
	else :
		main(sys.argv[1:])



