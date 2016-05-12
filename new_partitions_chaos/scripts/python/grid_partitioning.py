import sys
import struct



def main(argv):

	graph = sys.argv[1]
	partition_file = sys.argv[2]
	graph_name = sys.argv[3]
	row_partitioning = int(sys.argv[4])
	
	if row_partitioning == 1:
		out_path = "/media/ssd/grid/grid_partitions_" + graph_name + "_row/"
	else: 
		out_path = "/media/ssd/grid/grid_partitions_" + graph_name + "_column/"
	partitions = get_partitions_offsets(partition_file)
	
	files = {}
	for i in range(0, len(partitions)):
		for j in range(0, len(partitions)):
			outfile = out_path + "stream.2." + str(i) + "." + str(j)
			files[outfile] = open(outfile,'ab')
	chunks = 0
	with open(graph,'rb') as infile:	    
		for chunk in iter((lambda:infile.read(12)),''):
			chunks = chunks + 1
			src = struct.unpack('I', chunk[0:4])[0]
	       	        dst = struct.unpack('I', chunk[4:8])[0]

			[src_part, dst_part]= get_grid_partition(src, dst, partitions)

			outfile = out_path + "stream.2." + str(src_part) + "." + str(dst_part)
			
			new_src = struct.pack('I', src)
			new_dst = struct.pack('I', dst)
			if row_partitioning == 0:			
				files[outfile].write(new_src)
				files[outfile].write(new_dst)
			else:
				files[outfile].write(new_dst)
				files[outfile].write(new_src)

			files[outfile].write(chunk[8:12])
			print "Edge " + str(chunk)
			print "src: " + str(src)
			print "dst: " + str (dst)
			print "src_part :" + str(src_part)
			print "dst_part : " + str(dst_part)
			

			if chunks > 10:
				break

	for i in range(0, len(partitions)):
		for j in range(0, len(partitions)):
			outfile = out_path + "stream.2." + str(i) + "." + str(j)
			files[outfile].close()
	

	print partitions
	print chunks

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
	if len (sys.argv) != 5:
		print "Usage: python grid_partitioning.py <graph file> <partition file> <graph name> <row partitioning>"
	else :
		main(sys.argv[1:])

