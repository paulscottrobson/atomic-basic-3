O = 0
P = &700
SomeCode = &FEDC
[	.loop
	bmi loop+4
	beq loop
	tax
	php:pha:inx
	bit #254
	jsr SomeCode
	jmp SomeCode
	jmp (SomeCode)
	jmp (SomeCode,X)
	inc:dec:inc a:dec a	
	jmp loop
]
print '"LOOP=",loop,.loop