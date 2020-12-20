O = 0
P = &700
SomeCode = &FEDC
[	.loop
;	bmi loop+4
;	beq loop
;	tax
;	php:pha:inx
;	bit #254
;	jsr SomeCode
;	jmp SomeCode
;	jmp (SomeCode)
;	jmp (SomeCode,X)
;	inc:dec:inc a:dec a	
;	jmp loop	
;	ldx 	1,y
;	ldx 	1025,y
;	ldx 	1
;	ldx 	1025
;	ldx 	#42
;	;
;	asl 	1
;	asl
;	asl 	a
;	rol 	1
;	rol 	1025
;	rol 	1,x
;	rol 	1025,x
;	;
;	ldy 	#42
;	ldy 	1
;	ldy 	1025
;	ldy 	1,x
;	ldy 	1025,x
	;
;	bit 	#24
;	bit 	1
;	bit 	1025
	;
;	stz 	1
;	stz 	1025
;	stz 	1,x
;	stz 	1025,x

	lda 	(1,x)
	lda 	1
	lda 	#1
	lda 	1025
	lda 	(1),y
	lda 	1,x
	lda 	1025,y
	lda 	1025,x
	lda 	(1)
	ora 	#89
]
print '"LOOP=",loop,.loop