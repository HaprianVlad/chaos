import sys
import struct

def main(argv):
	outDegreeFile = sys.argv[1]
	vertex_state_size = long(sys.argv[2])
	edge_state_size = long(sys.argv[3])
	maxPartitionSize = long(sys.argv[4])
	resultFile = sys.argv[5]
	p = long(sys.argv[6])
	vp = long(sys.argv[7])
	

	partitions = {}
	results = [0]
	p_id = 0

	p_sum = 0
	start = 0
	edges = 0
	edges_in_partition = 0
	max_out_degree = 0
	offset = 0
	degrees = {}
	toAdd = 0
	toSub = 0
	with open(outDegreeFile,'rb') as infile:
		for chunk in iter((lambda:infile.read(8)),''):
			v_id = ((offset % vp) *  p) + (offset/vp) + toAdd - toSub
			if v_id in degrees:		
				toAdd = offset
				v_id = toAdd 
				toSub += p
				 	
			degrees[v_id] = long(struct.unpack('Q', chunk[0:8])[0])
			offset += 1

	for v_id in range(len(degrees)):
			
		vertex_degree = degrees[v_id]
		max_out_degree = max(vertex_degree, max_out_degree)

		edges += vertex_degree
		edges_in_partition += vertex_degree	
		p_sum = p_sum + vertex_degree * edge_state_size + vertex_state_size
		if (p_sum >= maxPartitionSize):
			end = v_id  
			partitions[p_id] = [start, end, edges_in_partition, p_sum]
			start = v_id + 1 
			p_id = p_id + 1
			p_sum = 0
			edges_in_partition = 0
			results.append(start)

		
		
	partitions[p_id] = [start, v_id, edges_in_partition, p_sum]

	

	printPartitionDetails(partitions)
	print "Total number of vertices: " + str(len(degrees))
	print "Total number of edges: " + str(edges)
	print "Max out degree: " + str(max_out_degree)
	printResults(results, resultFile, partitions, degrees)


def max(a, b):
	if a > b:
		return a
	return b


def printPartitionDetails(partitions):
	for p_id in partitions.keys():
		print "Partition " + str(p_id) 
		print "    start vertex: " + str(partitions[p_id][0])
		print "    end vertex: " + str(partitions[p_id][1])
		print "    vertices: " + str(partitions[p_id][1] - partitions[p_id][0] + 1)
		print "    edges: " + str(partitions[p_id][2])
		print "    partition_size: " + str(partitions[p_id][3])



def printResults(results, fileName, partitions, outDegrees):
	with open(fileName, 'w') as f:
		f.write("[partitions_offsets_file]" + '\n')
		f.write("same_size_edge_sets_per_partition=0" + str(0) + '\n')
		f.write("sum_out_degrees_for_new_super_partition=0" + str(c1) + '\n')
 		f.write("max_edges_per_new_super_partition=0" + str(c2) + '\n')
		f.write("number_of_new_super_partitions=" + str(len(results)) + '\n')
   		for p_id in range(len(results)):
			f.write("P" + str(p_id) + "=" + str(results[p_id]) + '\n')
				



if __name__ == "__main__":
	if len (sys.argv) != 8:
		print "Usage: python create_new_partitions_tradeofff.py <vertex out degree file> <vertex_state_size> <edge_state_size> <max_partition_size> <result file> <partitions> <vertices/partition>"
	else :
		main(sys.argv[1:])



