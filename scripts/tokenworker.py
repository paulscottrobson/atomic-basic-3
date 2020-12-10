# *****************************************************************************
# *****************************************************************************
#
#		Name:		tokenworker.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		10 Dec 2020
#		Purpose:	Tokeniser class
#
# *****************************************************************************
# *****************************************************************************

from tokens import *
import re

# *****************************************************************************
#
#						Tokeniser Worker class
#
# *****************************************************************************

class TokeniserWorker(object):
	def __init__(self):
		t = Tokens()
		self.tokenToID = t.getTokenLookup()
	#
	#		Tokenise a BASIC instruction
	#		
	def tokenise(self,s):
		self.tokens = []
		while s.strip() != "":
			s = self.tokeniseOne(s)
		return self.tokens
	#
	def tokeniseOne(self,s):
		s = s.strip()
		c = s[0].lower()
		#
		if (c >= 'a' and c <= 'z') or c == '.':							# token or variable.
			m = re.match("^([A-Za-z]+)(.*)$",s)							# try text token first
			kwd = m.group(1).lower()
			if kwd in self.tokenToID:									# is a text token.
				self.tokens.append(self.tokenToID[kwd]["id"])
				return m.group(2).strip()
			m = re.match("^([A-Za-z\\.0-9]+)(.*)$",s)					# variable next
			assert m is not None
			cList = [self.encodeVarChar(c) for c in m.group(1)]
			cList[-1] -= 0x30 										# end marker.
			self.tokens += cList
			return m.group(2).strip()
		#
		if c >= '0' and c <= '9':										# int constant.
			m = re.match("^(\\d+)(.*)$",s)
			assert m is not None
			self.encodeNumber(int(m.group(1)))
			return m.group(2).strip()
		#
		m = re.match("^\\&([0-9A-Fa-f]+)(.*)$",s)
		if m is not None:												# hex constant.
			self.tokens.append(self.tokenToID["&"]["id"])					# hex marker.
			self.encodeNumber(int(m.group(1),16))
			return m.group(2).strip()
		#
		if c == '"':													# string constant.
			m = re.match('^\"(.*?)\"(.*)$',s)
			assert m is not None,"Bad String"
			self.tokens.append(0x60)
			self.tokens.append(len(m.group(1))+3)
			for c in m.group(1):
				self.tokens.append(ord(c))
			self.tokens.append(0)
			return m.group(2).strip()
		#
		p = s[:2]														# punctuation, check 2 char
		if p not in self.tokenToID:
			p = s[0]
		assert p in self.tokenToID,"Unknown syntax "+s+"["+p+"]"
		self.tokens.append(self.tokenToID[p]["id"])
		return s[len(p):].strip()
	#
	#		Encode a variable character (continuer).
	#
	def encodeVarChar(self,c):
		c = c.lower()
		if c >= 'a' and c <= 'z':
			return ord(c)-ord('a')+0x30
		if c >= '0' and c <= '9':
			return ord(c)-ord('0')+0x30+26
		if c == '.':
			return 0x30+36
		assert False," Varchar "+c
	#
	#		Encode a number.
	#
	def encodeNumber(self,n):
		done = False
		while not done:
			self.tokens.append((n & 0x0F)|0x70)
			n = n >> 4
			done = (n == 0)
	#
	#		Simple test
	#
	def test(self,s,decVar = False):
		t = self.tokenise(s)
		print("{0}\n\t{1}".format(s,",".join(["${0:02x}".format(n) for n in t])))
		print("")

if __name__ == "__main__":
	tw = TokeniserWorker()	
	if False:	
		tw.test("gosub if goto GOTO ")
		tw.test("prc.name")
		tw.test("az09..")
		tw.test("a ab zzz ZZZ")
		tw.test("yaz aa. ba ")
		tw.test("yazaa.ba")
		tw.test("0 42 65536 65538")
		tw.test("&2a &fffffffe")
		tw.test("> >= @")
		tw.test('"0123" "" "12345"')
	else:
		src = 'sgn-5-1'
		tokens = tw.tokenise(src)
		tokens += [0x80]
		h = open("../source/testing/simple/02testcode.asm","w")
		h.write(";\n;\tAutomatically generated.\n;\n")
		h.write("\t.align 256\nBasicProgram:\n\t.byte {0}\n".format(",".join(["${0:02x}".format(c) for c in tokens])))
		h.close()