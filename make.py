#! /usr/bin/env python

'''Who needs a Makefile when you have python...

For compiling AS3 files'''

import sys, os

def isDotAS(f):
	return getFileExt(f) == 'as' and f[0] not in ['.','#']

def getFileExt(f):
	f = f[::-1]
	dot = f.find(".")
	return dot > -1 and f[:dot][::-1] or None


cc = "mxmlc"
swf_dir = "swfs/"
flags = "-verbose-stacktraces -debug=true"
src_file = "to be determined (below)"

# if no arguments were passed, look for a single .as file to compile
if len(sys.argv) == 1:
	as_files = [f for f in os.listdir(".") if isDotAS(f)]
	if len(as_files) == 1:
		src = as_files[0]
	else:
		raise Exception(len(as_files),".as files were found. Please specify one as a command line argument.")
else:
	src = sys.argv[1]

target = swf_dir + src[:-3] + '.swf'
command = ' '.join([cc, flags, '-o ' + target, src])

if __name__ == "__main__":

        # compare last modified times of the swf and source files
        # to determine if recompilation is necessary
	# (checks all .as files in subdirs)
	try:
		swf_time = os.stat(target).st_mtime
		dont_open_swf = keep_looking = 'dont do it'
		for root,dirs,files in os.walk("."):
			root = root != '.' and root+'/' or ''
			for f in [f for f in files if isDotAS(f)]:
	                	if os.stat(root + f).st_mtime > swf_time:
	                                dont_open_swf = os.system(command) > 0 and True or False
					break;
	                if dont_open_swf != keep_looking:
				break
	# run when os.stat(target) fails because target doesn't exist
        except:
		os.system(command)

	dont_open_swf != True and os.system('open ' + target)



