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
chars = "abcdefghijklmnopqrstuvwxyz."
random.seed()
seed = random.seed(0,10000)
print("# random seed "+str(seed))
t = Tokens()
count = 700
v = {}
random.seed(seed)
while len(v.keys()) != count:
	key = "".join([ chars[random.randint(0,len(chars)-1)] for x in range(0,random.randint(1,maxSize))])
	if key[0:3] not in t.getTokenLookup() and key[3:] not in t.getTokenLookup() and not key.startswith("."):
		v[key] = random.randint(-0x7FFFFFFF,0x7FFFFFFF)

names = [x for x in v.keys()]
for n in names:
	print("{0} = {1}".format(n,v[n]))
for n in names:
	print("assert {0} = {1}".format(n,v[n]))
print("stop")

