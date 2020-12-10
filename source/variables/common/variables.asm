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
		iny
		;
		;		A-Z variable.
		;
		asl 	a 							; x 4
		asl 	a
		sta 	esInt0,x 					; set up address
		lda 	#RootVariables >> 8 		
		sta 	esInt1,x
		jmp 	_VACheckModifier
		;
		;		not a standard variable, so check/create in hash list.
		;
_VANotBasic:		


		report 	NotImplemented
_VACheckModifier:

_VAExit:		
		lda 	#0 							; clear the upper two bytes of variable/element address.
		sta 	esInt2,x
		sta 	esInt3,x
		lda 	#$80 						; it's a reference to an integer.
		sta 	esType,x
		rts
