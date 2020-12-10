; *****************************************************************************
; *****************************************************************************
;
;		Name:		binary1.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Simple binary handlers.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;						Five basic arithmetic operations
;
; *****************************************************************************

BinaryAdd:				;; [+]
		jsr		DeRefBoth
		jsr 	Int32Add
		makeinteger
		rts

BinarySub:				;; [-]
		jsr		DeRefBoth
		jsr 	Int32Sub
		makeinteger
		rts
		

BinaryMult:				;; [*]
		jsr		DeRefBoth
		jsr 	Int32Multiply
		makeinteger
		rts

BinaryDivide:			;; [/]
		jsr		DeRefBoth
		jsr		CheckDivisorNonZero
		jsr 	Int32SDivide
		makeinteger
		rts

BinaryModulus:			;; [%]
		jsr		DeRefBoth
		jsr 	CheckDivisorNonZero
		jsr		Int32Modulus
		makeinteger
		rts

; *****************************************************************************
;
;			Checks divisor (2nd on stack) is non zero for divide/modulus
;
; *****************************************************************************

CheckDivisorNonZero:
		inx
		jsr 	Int32Zero
		beq 	_BDivZero
		dex
		rts
_BDivZero:
		report 	DivideZero 					
		
; *****************************************************************************
;
;								 Binary Operations
;
; *****************************************************************************

BinaryXor:			;; [xor]
		jsr		DeRefBoth
		jsr 	Int32Xor
		makeinteger
		rts

BinaryOr:			;; [or]
		jsr		DeRefBoth
		jsr 	Int32Or
		makeinteger
		rts

BinaryAnd:			;; [and]
		jsr		DeRefBoth
		jsr 	Int32And
		makeinteger
		rts

; *****************************************************************************
;
;								Shift Operations
;
; *****************************************************************************

BinaryShiftLeft:	;; [<<]
		jsr		DeRefBoth
		jsr 	CheckShiftParam2
		bne 	BinaryShiftZero
BSLLoop:
		dec 	esInt0+1,x
		bmi 	BinaryShiftExit
		jsr 	Int32ShiftLeft
		jmp 	BSLLoop

BinaryShiftRight:	;; [>>]
		jsr		DeRefBoth
		jsr 	CheckShiftParam2
		bne 	BinaryShiftZero
BSRLoop:
		dec 	esInt0+1,x
		bmi 	BinaryShiftExit
		jsr 	Int32ShiftRight
		jmp 	BSRLoop

BinaryShiftExit:
		makeinteger
		rts
BinaryShiftZero:
		jsr 	Int32False
		rts

CheckShiftParam2:
		lda 	esInt0+1,x 					; if value >= 32 then result is zero
		and 	#$E0
		ora 	esInt1+1,x
		ora 	esInt2+1,x
		ora 	esInt3+1,x
		rts

; *****************************************************************************
;
;							Indirection Operators
;
; *****************************************************************************

IndirectWord:	;; [!]
		jsr		DeRefBoth
		jsr 	Int32Add
		lda 	#$80 						; make it a reference 
		sta 	esType,x  					
		rts

IndirectByte:	;; [?]
		jsr		DeRefBoth
		jsr 	Int32Add
		lda 	#$C0 						; type is set to byte reference.
		sta 	esType,x
		rts
		
IndirectString:	;; [$]
		jsr		DeRefBoth
		jsr 	Int32Add
		lda 	#$81 						; type is set to string reference.
		sta 	esType,x
		rts
