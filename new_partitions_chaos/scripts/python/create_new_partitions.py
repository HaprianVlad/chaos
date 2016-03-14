import sys
import struct

def main(argv):
	outDegreeFile = sys.argv[1]
	outDegreeSumPerPartition = int(sys.argv[2])
	maxNumberOfEdgesPerPartition = int(sys.argv[3])
	resultFile = sys.argv[4]

	partitions = {}
	results = [0]
	p_id = 0
	v_id = 0
	p_sum = 0
	start = 0
	edges = 0
	max_out_degree = 0
	max_difference = 0
	with open(outDegreeFile,'rb') as infile:
		for chunk in iter((lambda:infile.read(8)),''):			
		        vertex_degree = struct.unpack('L', chunk[0:8])[0]
			
			max_out_degree = max(vertex_degree, max_out_degree)

			edges += int(vertex_degree)
			p_sum = p_sum + int(vertex_degree)

			if (p_sum >= outDegreeSumPerPartition) or (p_sum >= maxNumberOfEdgesPerPartition):
				end = v_id  
				partitions[p_id] = [start, end, p_sum]
				start = v_id + 1 
				p_id = p_id + 1
				max_difference = max3(max_difference, p_sum - outDegreeSumPerPartition, p_sum - maxNumberOfEdgesPerPartition)
				p_sum = 0
				results.append(start)

			v_id = v_id + 1
			
		partitions[p_id] = [start, v_id-1, p_sum]

	printPartitionDetails(partitions)
	print "Total number of vertices: " + str(v_id)
	print "Total number of edges: " + str(edges)
	print "Max out degree: " + str(max_out_degree)
	print "Max partition overhead: " + str(max_difference)
	printResults(results, resultFile, outDegreeSumPerPartition, maxNumberOfEdgesPerPartition)

def max(a, b):
	if a > b:
		return a
	return b

def max3(a,b,c):
	if a > max(b,c):
	 	return a
	return max(b,c)

def printPartitionDetails(partitions):
	for p_id in partitions.keys():
		print "Partition " + str(p_id) 
		print "    start vertex: " + str(partitions[p_id][0])
		print "    end vertex: " + str(partitions[p_id][1])
		print "    vertices: " + str(partitions[p_id][1] - partitions[p_id][0])
		print "    edges: " + str(partitions[p_id][2])


def printResults(results, fileName, c1, c2):
	with open(fileName, 'w') as f:
		f.write("[Partitions]" + '\n')
		f.write("sum_out_degrees_for_new_super_partition=" + str(c1))
 		f.write("max_edges_per_new_super_partition=" + str(c1))
		f.write("number_of_new_super_partitions=" + str(len(results)) + '\n')
   		for v in range(len(results)):
			f.write("P" + v + "=" + str(resulst[v]) + '\n') 
		

if __name__ == "__main__":
	if len (sys.argv) != 5 :
		print "Usage: python create_new_partitions.py <vertex out degree file> <max sum of out degrees per partition> <max number of edges per partition> <result file> "
	else :
		main(sys.argv[1:])



