# *****************************************************************************
# *****************************************************************************
#
#		Name:		tokentables.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		10 Dec 2020
#		Purpose:	Generate token tables, vector tables, keyword lookups.
#
# *****************************************************************************
# *****************************************************************************

from tokens import *
import os,re,sys

t = Tokens()
idHash = t.getIDLookup()
tokenHash = t.getTokenLookup()
#
#		Constants.
#
h = open("../source/common/generated/keywords.inc","w")
ids = [x for x in idHash.keys()]
ids.sort(key = lambda x:x & 0xFF)
h.write(";\n;\tAutomatically generated.\n;\n")
for i in ids:
	s = idHash[i]["token"].upper()
	s = s.replace(">","GREATER").replace("=","EQUAL").replace("<","LESS").replace(",","COMMA")
	s = s.replace(".","PERIOD").replace("+","PLUS").replace("-","MINUS").replace("*","ASTERISK")
	s = s.replace("/","SLASH").replace("%","PERCENT").replace("$","DOLLAR").replace("@","AT")
	s = s.replace("!","PLING").replace("?","QUESTION").replace("~","TILDE").replace("(","LPAREN")
	s = s.replace(")","RPAREN").replace("&","AMPERSAND").replace(";","SEMICOLON").replace(":","COLON")
	s = s.replace("#","HASH").replace("[","LSQPAREN").replace("]","RSQPAREN").replace("'","SQUOTE")
	s = s.replace("","").replace("","").replace("","").replace("","")
	assert re.match("^([A-Z]+)$",s) is not None,"Bad character "+s
	h.write("KWD_{0:32} = ${1:02x} ; {2} \n".format(s,i,idHash[i]["id"]))
h.close()
#
#		Keyword type table.
#
h = open("../source/common/generated/keytypes.asm","w")
ids = [x for x in idHash.keys()]
ids.sort(key = lambda x:x & 0xFF)
h.write(";\n;\tAutomatically generated.\n;\n")
h.write("KeywordTypes:\n")
for i in ids:
	s = idHash[i]
	h.write("\t.byte ${0:02x} ; ${1:02x} {2}\n".format(s["type"],s["id"],s["token"]))
h.close()	

#
#		Keyword vectors.
#
handlers = {}
for root,dirs,files in os.walk(".."):
	for f in [x for x in files if x.endswith(".asm")]:
		for l in open(root+os.sep+f).readlines():
			if l.find(";;") >= 0:
				m = re.match("^([A-Za-z0-9\\_]+)\\:\\s*\\;\\;\\s*\\[(.*?)\\]\\s*$",l)
				assert m is not None,l
				keyword = m.group(2).strip().lower()
				label = m.group(1)
				assert keyword not in handlers,"Duplicate "+keyword
				assert keyword in tokenHash,"Unknown "+keyword
				handlers[keyword] = label
h = open("../source/common/generated/vectors.asm","w")
h.write(";\n;\tAutomatically generated.\n;\n")
tokenList = t.getTokenList()
for p in range(0,2):
	h.write("TokenVector{0}:\n".format("Low" if p == 0 else "High"))
	for l in tokenList:
		vector = handlers[l] if l in handlers else "InstructionUndefined"
		part = ("{0} & $FF" if p == 0 else "{0} >> 8").format(vector)
		h.write("\t.byte {0:32} ; {1}\n".format(part,l))
h.close()	

