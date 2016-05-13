import sys
import struct



def main(argv):

	graph = sys.argv[1]
	partition_file = sys.argv[2]


	partitions = get_partitions_offsets(partition_file)
	vertices = {}
	for i in range(0, len(partitions)):
		for j in range(0, len(partitions)):
			outfile = "stream.2." + str(i) + "." + str(j)
			vertices[outfile] = 0
	chunks = 0
	with open(graph,'rb') as infile:	    
		for chunk in iter((lambda:infile.read(12)),''):
			chunks = chunks + 1
			src = struct.unpack('I', chunk[0:4])[0]
	       	        dst = struct.unpack('I', chunk[4:8])[0]

			[src_part, dst_part]= get_grid_partition(src, dst, partitions)

			outfile = "stream.2." + str(src_part) + "." + str(dst_part)
			vertices[outfile] += 1

		

	print vertices
	printGridDetails(vertices)

def printGridDetails(vertices):
	with open("gridDetails", 'w') as f:
		for key in vertices.keys():
			f.write(str(key) + "=" + str(vertices[key]) + '\n')

def get_partitions_offsets(partition_file):
	partitions = {}
	with open(partition_file) as myfile:
   		for line in myfile:
			p_id, var = line.partition("=")[::2]
			if (p_id[0] == "P"):
				partitions[int(p_id[1])] = int(var)
	return partitions

def get_grid_partition(src, dst, partitions):
	return [get_partition(src, partitions, 0, len(partitions)-1), get_partition(dst, partitions, 0, len(partitions)-1)]

def get_partition(key, array, start, end):
	if (start >= end):
        	return end
            
        mid = (start + end) / 2;

        if (key >= array[mid] and key < array[mid+1]):
        	return mid
           
        if (key >= array[mid+1]):
        	return get_partition(key, array, mid+1, end)
        else: 
        	return  get_partition(key, array, start, mid-1)
            
	



if __name__ == "__main__":
	if len (sys.argv) != 3:
		print "Usage: python grid_partitioning.py <graph file> <partition file>"
	else :
		main(sys.argv[1:])

