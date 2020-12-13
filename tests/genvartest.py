# *****************************************************************************
# *****************************************************************************
#
#		Name:		genvartest.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		10 Dec 2020
#		Purpose:	Variable test builder.
#
# *****************************************************************************
# *****************************************************************************

import random
from tokens import *

maxSize = 6
chars = "abcdefghijklmnopqrstuvwxyz.0123456789"
random.seed()
seed = random.seed(0,10000)
print("# random seed "+str(seed))
t = Tokens()
count = 500
v = {}
random.seed(seed)
while len(v.keys()) != count:
	key = "".join([ chars[random.randint(0,len(chars)-1)] for x in range(0,random.randint(1,maxSize))])
	if key not in t.getTokenLookup():
		if key[0] >= 'a' and key[0] <= 'z':
			v[key] = random.randint(-0x7FFFFFFF,0x7FFFFFFF)

names = [x for x in v.keys()]
for n in names:
	print("{0} = {1}".format(n,v[n]))
print("rem")
for n in range(1,count>>3):
	cv = names[random.randint(0,len(names)-1)]
	cn = random.randint(-0x7FFFFFFF,0x7FFFFFFF)
	print("{0} = {1}".format(cv,cn))
	v[cv] = cn
print("rem ")
for n in names:
	print("assert {0} = {1}".format(n,v[n]))
print("stop")

