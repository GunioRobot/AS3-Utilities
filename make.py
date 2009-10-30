#! /usr/bin/env python

'''Who needs a Makefile when you have python...

For compiling AS3 files'''

import sys, os

cc = "mxmlc"
swf_dir = "swfs/"
flags = "-verbose-stacktraces -debug=true"
src_file = "to be determined (below)"

if len(sys.argv) == 1:
	as_files = []
	for f in os.listdir("."):
		if f[-3:] == '.as'
                	as_files.push(f)
        if len(as_files) == 1:
		src_file = as_files[0]
        else:
		raise Exception("Couldn't find a source file. Please specify one as a command line argument.")
else:
	src = sys.argv[1]

target = '-o ' + swf_dir + src_file
command = ' '.join([cc, flags, target, src_file])


if __name__ == "__main__":
	os.system(
