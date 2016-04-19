import sys
import struct

#alpha = 1 => partition for edge balancing
#alpha = 0 => partition for vertex balancing
def main(argv):
	outDegreeFile = sys.argv[1]
	vertex_state_size = long(sys.argv[2])
	edge_state_size = long(sys.argv[3])
	scale = long(sys.argv[4])
	alpha = float(sys.argv[5])
	undirected = long(sys.argv[6])
	number_of_partitions = long(sys.argv[7])
	resultFile = sys.argv[8]
	p = long(sys.argv[9])
	vp = long(sys.argv[10])

	maxPartitionSize = getMaxPartitionSize(scale, undirected, alpha, vertex_state_size, edge_state_size, number_of_partitions)

	degrees = readDegrees(outDegreeFile, vp, p)

	r = createNewPartitions(degrees, maxPartitionSize, alpha, edge_state_size, vertex_state_size)
	partitions = r[0]	
	results = r[1]
	edges = r[2]
	max_out_degree = r[3]
	

	printPartitionDetails(partitions, degrees, edges, max_out_degree)
	printResults(results, resultFile, partitions)



def createNewPartitions(degrees, maxPartitionSize, alpha, edge_state_size, vertex_state_size):
	partitions = {}
	results = [0]
	p_id = 0
	p_sum = 0
	start = 0
	edges = 0
	edges_in_partition = 0
	max_out_degree = 0
	for v_id in range(len(degrees)):		
		vertex_degree = degrees[v_id]
		max_out_degree = max(vertex_degree, max_out_degree)

		edges += vertex_degree
		edges_in_partition += vertex_degree	
		p_sum = p_sum + alpha * vertex_degree * edge_state_size + vertex_state_size * (1 - alpha)
		if (p_sum >= maxPartitionSize):
			end = v_id  
			partitions[p_id] = [start, end, edges_in_partition, p_sum]
			start = v_id + 1 
			p_id = p_id + 1
			p_sum = 0
			edges_in_partition = 0
			results.append(start)

	partitions[p_id] = [start, v_id, edges_in_partition, p_sum]
	
	return [partitions, results, edges, max_out_degree]

def readDegrees(outDegreeFile, vp, p):
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
	return degrees

def getMaxPartitionSize(scale, undirected, alpha, vertex_state_size, edge_state_size, number_of_partitions):
	v = pow(2,scale)
	if undirected == 0:
		e = v *16
	else:
		e = v * 32

	return (v * vertex_state_size  * (1 - alpha) + e * edge_state_size * alpha) / number_of_partitions
	

def max(a, b):
	if a > b:
		return a
	return b


def printPartitionDetails(partitions, degrees, edges, max_out_degree):
	for p_id in partitions.keys():
		print "Partition " + str(p_id) 
		print "    start vertex: " + str(partitions[p_id][0])
		print "    end vertex: " + str(partitions[p_id][1])
		print "    vertices: " + str(partitions[p_id][1] - partitions[p_id][0] + 1)
		print "    edges: " + str(partitions[p_id][2])
		print "    constraint size: " + str(partitions[p_id][3])
		
	print "Total number of vertices: " + str(len(degrees))
	print "Total number of edges: " + str(edges)
	print "Max out degree: " + str(max_out_degree)



def printResults(results, fileName, partitions):
	with open(fileName, 'w') as f:
		f.write("[partitions_offsets_file]" + '\n')
		f.write("same_size_edge_sets_per_partition=0"  + '\n')
		f.write("optimize_state_store_load=0" + '\n')
		f.write("sum_out_degrees_for_new_super_partition=0"+ '\n')
 		f.write("max_edges_per_new_super_partition=0"  + '\n')
		f.write("number_of_new_super_partitions=" + str(len(results)) + '\n')
   		for p_id in range(len(results)):
			f.write("P" + str(p_id) + "=" + str(results[p_id]) + '\n')
				



if __name__ == "__main__":
	if len (sys.argv) != 11:
		print "Usage: python create_new_partitions_tradeofff.py <vertex out degree file> <vertex_state_size> <edge_state_size> <scale> <alpha> <undirected> <number of partitions> <result file> <partitions> <vertices/partition>"
	else :
		main(sys.argv[1:])



