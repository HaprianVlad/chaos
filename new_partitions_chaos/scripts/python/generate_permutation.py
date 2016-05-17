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
	print array
	random.shuffle(array)
	print array
	permutation = {}
	for i in range(1,scale):
		print i
		permutation[i] = array[i]
	permutation[0] = 0
	return permutation



if __name__ == "__main__":
	if len (sys.argv) != 2:
		print "Usage: python vertex_rellabeling.py <scale> "
	else :
		main(sys.argv[1:])
