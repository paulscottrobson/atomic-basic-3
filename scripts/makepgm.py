# *****************************************************************************
# *****************************************************************************
#
#		Name:		makepgm.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		10 Dec 2020
#		Purpose:	Create program.
#
# *****************************************************************************
# *****************************************************************************

from tokenworker import *
import re,sys

# *****************************************************************************
#
#									Program class
#
# *****************************************************************************

class BasicProgram(object):
	def __init__(self):
		self.nextLine = 1000
		self.tokeniser = TokeniserWorker()
		self.code = []
	#
	def addLine(self,lineText):
		m = re.match("^(\\d+)(.*)$",lineText)
		if m is not None:
			self.nextLine = int(m.group(1))
			lineText = m.group(2).strip()
		code = [self.nextLine & 0xFF,self.nextLine >> 8] + self.tokeniser.tokenise(lineText) + [0x80]
		if False:	
			print("{0:4} ${0:04x} {1}".format(self.nextLine,lineText.strip()))
		self.code += [len(code)+1] + code	
		assert len(self.code)+0x1000 < 0x9800,"Too long"
		self.nextLine += 10
	#
	def write(self,outputFile):
		h = open(outputFile,"w")
		h.write("\t.align 256\nBasicProgram:\n")
		for b in self.code+[0]:
			h.write("\t.byte ${0:02x}\n".format(b))
		h.close()


if __name__ == "__main__":
	bp = BasicProgram()
	for f in sys.argv[1:]:
		for l in open(f).readlines():
			if not l.startswith("#"):
				bp.addLine(l)
	bp.write("../source/testing/code/99program.asm")
