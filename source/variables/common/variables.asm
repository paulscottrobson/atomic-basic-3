; *****************************************************************************
; *****************************************************************************
;
;		Name:		variables.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Check for various syntactic elements
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;						Get a variable or array reference
;
; *****************************************************************************

VariableAccess:	
		lda 	(codePtr),y 				; check 20xx where x is 1..1A representing A-Z.
		cmp 	#$1A 						; is this A-Z ?
		bcs 	_VANotBasic
		;
		;		A-Z variable.
		;
		asl 	a 							; x 4
		asl 	a
		sta 	esInt0,x 					; set up address
		lda 	#RootVariables >> 8 		
		sta 	esInt1,x
		jmp 	VACheckModifier
		;
		;		not a standard variable, so check/create in hash list. First set up
		;		hash value, hash address, address of variable information in zp.
		;
_VANotBasic:		
		asl 	a 							; calculate hash as 2 x first byte + second byte
		iny
		clc
		adc 	(codePtr),y
		dey
		sta 	temp2 						; 8 bit hash in temp2.
		;
		and 	#HashTableSize-1 			; force into hash range
		asl 	a 							; double, word addresses in table and CLC
		adc 	#HashTable & $FF 			; make temp1 point to the hash table first link.
		sta 	temp1
		lda 	#HashTable >> 8
		sta 	temp1+1
		;
		sty 	temp2+1 					; Y is the offset of the first character.
		;
		tya
		clc
		adc 	codePtr 					; temp3 is the address of that variable name.
		sta 	temp3
		lda		codePtr+1
		adc 	#0
		sta 	temp3+1
		;
		pshx 								; save XY
		pshy 
		jsr 	VariableSearch 				; does it exist already ?
		bcs 	_VAExists	
		jsr 	VariableCreate 				; no, create it.
_VAExists:
		puly 								; restore XY.
		pulx		
		clc
		lda 	temp0 						; add 5 to temp0, which is the offset in the record
		adc 	#5 							; of the actual variable data and copy into the stack 
		sta 	esInt0,x
		lda 	temp0+1
		adc 	#0
		sta 	esInt1,x
		;
		;		Have the variable, first advance Y past the identifier, then check for arrays.
		;
VACheckModifier:
		lda 	(codePtr),y
		iny
		cmp 	#$30
		bcs 	VACheckModifier
		;
		lda 	arrayEnabled 				; arrays in operation
		beq 	_VAExit
		;
		;		TODO: Check for arrays.
		;
_VAExit:		
		lda 	#0 							; clear the upper two bytes of variable/element address.
		sta 	esInt2,x
		sta 	esInt3,x
		lda 	#$80 						; it's a reference to an integer.
		sta 	esType,x
		rts
