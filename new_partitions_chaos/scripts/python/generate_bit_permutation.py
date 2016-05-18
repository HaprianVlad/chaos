import sys
import struct
import random

def main(argv):
	scale = int(sys.argv[1])
	
	permutation = getRandomPermutation(scale)

	outfile = open("permutation_rmat"+sys.argv[1],'a')

	for key in permutation.keys():
		outfile.write(str(key) + "=" + str(permutation[key]) + "\n")
		

	outfile.close()

			

def getRandomPermutation(scale):
	array = range(scale)	
	random.shuffle(array)
	permutation = {}
	for i in range(scale):
		permutation[i] = array[i-1]
	
	return permutation



if __name__ == "__main__":
	if len (sys.argv) != 2:
		print "Usage: python vertex_rellabeling.py <scale> "
	else :
		main(sys.argv[1:])
