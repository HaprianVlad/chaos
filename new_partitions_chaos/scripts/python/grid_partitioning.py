import sys
import struct



def main(argv):

	graph = sys.argv[1]
	partition_file = sys.argv[2]
	# read partitioning file	
	partitions = get_partitions_offsets(partition_file)

	with open(graph,'rb') as infile:	    
		for chunk in iter((lambda:infile.read(12)),''):
			src = struct.unpack('I', chunk[0:4])[0]
	       	        dst = struct.unpack('I', chunk[4:8])[0]

			[src_part, dst_part]= get_grid_partition(src, dst, partitions)

			outfile = "stream.2." + str(src_part) + "." + str(dst_part)
			with open(outfile,'wb') as output: 
				new_src = struct.pack('I', src)[0]
				new_dst = struct.pack('I', dst)[0]
				output.write(new_src)
				output.write(new_dst)
				output.write(chunk[9:12])
					
	

	print partitions

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

