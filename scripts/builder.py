# *****************************************************************************
# *****************************************************************************
#
#		Name:		builder.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		10 Dec 2020
#		Purpose:	Basic.Asm builder.
#
# *****************************************************************************
# *****************************************************************************

import re,os,sys

h = open("basic.asm","w")
h.write(";\n;\tAutomatically generated\n;\n")
for base in sys.argv[1:]:
	includes = []
	sources = []
	for root,dirs,files in os.walk(base.replace(".",os.sep)):
		for f in files:
			source = root+os.sep+f
			if source.endswith(".inc"):
				includes.append(source)
			if source.endswith(".asm"):
				sources.append(source)
	includes.sort()
	sources.sort()
	for f in includes+sources:
		h.write("\t.include \"{0}\"\n".format(f.replace(os.sep,"/")))
h.close()