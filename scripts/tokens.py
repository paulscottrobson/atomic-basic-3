# *****************************************************************************
# *****************************************************************************
#
#		Name:		tokens.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		10 Dec 2020
#		Purpose:	Create base keyword data class
#
# *****************************************************************************
# *****************************************************************************

# *****************************************************************************
#
#									Token class
#
# *****************************************************************************

class Tokens(object):
	def __init__(self):
		currentType = None
		nextID = 0x80
		self.tokenHash = {}
		self.idHash = {}
		self.tokenList = []
		src = [x for x in self.getRaw() if not x.startswith("#")]
		src = (" ".join(src)).split()
		for s in src:
			if s.startswith("[") and s.endswith("]"):
				if s == "[func]":
					currentType = 0x40
				elif s == "[kwd]" or s == "[syn]":
					currentType = 0x81
				elif s == "[kwd+]":
					currentType = 0x82
				elif s == "[kwd-]":
					currentType = 0x80
				else:
					currentType = int(s[1:-1])
			else:
				assert s not in self.tokenHash,"Duplicate "+s
				assert currentType is not None
				self.tokenHash[s] = { "id":nextID,"token":s,"type":currentType }
				self.idHash[nextID] = self.tokenHash[s]
				self.tokenList.append(s)
				nextID += 1
	#
	#		Accessors
	#
	def getTokenLookup(self):
		return self.tokenHash
	def getIDLookup(self):
		return self.idHash
	def getTokenList(self):
		return self.tokenList
	#
	#		Raw source data for tokens class.
	#
	def getRaw(self):
		return """
#
#		End of line marker
#
[syn]
	<<end>>
#
#		Arithmetic operators (binary)
#
[1]
	and 	or 		xor
[2]
	>		<		>= 		<= 		<> 		=		
[3]
	+ 		-
[4]
	* 		/ 		%		>>		<<
[5]
	! 		?		$
#
#		Functions. Note that - ! ? $ are also unary operators (type 15)
#
[func]
	~		(		&		@
	len 	sgn 	abs 	random	page	
	true	false	min 	max 	sys
	code	timer	event	get 	joy.x
	joy.y 	joy.btn	inkey	alloc 	chr
#
#		Syntax (type 0)
#
[syn]
	,		;		)				

	++		--		[ 		]		
#
#		Keywords which open (10) close (8)
#
[kwd+]
	if 		for 	repeat 	proc 	while
[kwd-]
	endif	next 	until 	endproc 	wend
#
#		Keywords (type 9)
#
[kwd]
	rem 	let 	'		:
	then 	else	to 		step 	vdu 	print
	call	local	goto 	gosub 	return 	
	assert 	stop 	end 	dim
	clear 	load	save 	list 	new 	run 	

""".lower().replace("\t"," ").split("\n")

if __name__ == "__main__":
	t = Tokens()
	print(t.getTokenLookup())
	print(t.getIDLookup())
	print(t.getTokenList())
	print(len(t.getTokenList()))