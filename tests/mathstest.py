# *****************************************************************************
# *****************************************************************************
#
#		Name:		mathstest.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		10 Dec 2020
#		Purpose:	Maths test generator.
#
# *****************************************************************************
# *****************************************************************************

import random

# *****************************************************************************
#
#									Base class
#
# *****************************************************************************

class Test(object):
	def __init__(self,seed = None):
		if seed is None:
			random.seed()
			seed = random.randint(0,999999)
			print("rem \"Using {0}\"".format(seed))
			random.seed(seed)
		random.seed(seed)
		for i in range(0,self.getCount()):
			self.create()
		print("Stop")

	def rnd(self,small = False):
		#return random.randint(-2,2)
		if small:
			return random.randint(-0xFFFFF,0xFFFFF)
		return random.randint(-0xFFFFFFF,0xFFFFFFF)

	def rsd(self):
		return "".join([self._randomChar() for n in range(0,random.randint(0,9))])
	def _randomChar(self):
		return Test.CHARLIST[random.randint(0,len(Test.CHARLIST)-1)]

	def getCount(self):
		return 1000

Test.CHARLIST = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

# *****************************************************************************
#
#								Binary test class
#
# *****************************************************************************

class Arithmetic(Test):
	def create(self):
		op = "+-*/&|^"
		op = op[random.randint(0,len(op)-1)]
		reject = True
		while reject:		
			reject = False	
			r1 = self.rnd(op == "*")
			r2 = self.rnd(op == "*")
			if op == "*" and abs(r1*r2) > 0x7FFFFFFF:
				reject = True
		op2 = op
		if op == "&":
			op2 = " and "
		if op == "|":
			op2 = " or "
		if op == "^":
			op2 = " xor "
		print("assert ({0} {3} {1}) = {2}".format(r1,r2,self.calc(r1,op,r2),op2))

	def calc(self,n1,op,n2):
		if op == "+":
			return n1+n2
		if op == "-":
			return n1-n2
		if op == "*":
			return n1*n2
		if op == "/":
			return int(n1/n2)
		if op == "&":
			return n1&n2
		if op == "|":
			return n1|n2
		if op == "^":
			return n1^n2

# *****************************************************************************
#
#								Binary test class
#
# *****************************************************************************

class Comparison(Test):
	def create(self):
		op = [ "=","<>",">","<",">=","<="]
		useStr = (random.randint(0,1) == 0)
		op = op[random.randint(0,len(op)-1)]
		r1 = self.rsd() if useStr else self.rnd()
		r2 = self.rsd() if useStr else self.rnd()
		if random.randint(0,8) == 0:
			r2 = r1
		flip = "" if self.calc(r1,op,r2) else "~"
		print("assert {2}({4}{0}{4} {3} {4}{1}{4}) ".format(r1,r2,flip,op,'"' if useStr else ""))

	def calc(self,n1,op,n2):
		if op == "=":
			return n1 == n2
		if op == "<":
			return n1 < n2
		if op == ">":
			return n1 > n2
		if op == "<>":
			return n1 != n2
		if op == "<=":
			return n1 <= n2
		if op == ">=":
			return n1 >= n2

#Arithmetic()		
Comparison()