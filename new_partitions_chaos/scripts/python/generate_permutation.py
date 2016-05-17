import sys
import struct
import random

def main(argv):
	scale = int(sys.argv[1])
	
	permutation = getRandomPermutation(scale)

	outfile = open("permutation"+str(scale),'a')

	for key in perumtation.keys():
		outfile.write(str(key) + "=" + str(permutation[key]))
		

	outfile.close()

			

def getRandomPermutation(scale):
	array = range(1,scale)
	random.shuffle(array)
	permutation = {}
	for i in range(1,scale):
		permutation[i] = array[i]	
	return permutation



if __name__ == "__main__":
	if len (sys.argv) != 2:
		print "Usage: python vertex_rellabeling.py <scale> "
	else :
		main(sys.argv[1:])
