O = 0
P = &700
SomeCode = &FEDC
[
	stz &4253,x
	stz &42
	stz &4253
	stz &42,x
	tax
	php:pha:inx
	bit #254
	jsr SomeCode
	jmp SomeCode
	jmp (SomeCode)
	jmp (SomeCode,X)
	inc:dec:inc a:dec a	
]
