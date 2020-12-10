; *****************************************************************************
; *****************************************************************************
;
;		Name:		binary2.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Comparison routines
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								Equal/Not equal
;
; *****************************************************************************

Binary_Equal: 	;; [=]
		jsr 	TestEqual
		bcs 	CompTrue
CompFalse:
		jsr 	Int32False
		rts
CompTrue;
		jsr 	Int32True
		rts

Binary_NotEqual: ;; [<>]
		jsr 	TestEqual
		bcc 	CompTrue
		bcs 	CompFalse

; *****************************************************************************
;
;							Greater Equal/Less Than
;
; *****************************************************************************

Binary_Less:	;; [<]
		jsr 	TestLess
		bcs 	CompTrue
		bcc 	CompFalse

Binary_GreaterEqual:	;; [>=]
		jsr 	TestLess
		bcc 	CompTrue
		bcs 	CompFalse

; *****************************************************************************
;
;								Greater/Less Equal
;
; *****************************************************************************

Binary_LessEqual:	;; [<=]
		jsr 	TestLessSwap
		bcc 	CompTrue
		bcs 	CompFalse

Binary_Greater:	;; [>]
		jsr 	TestLessSwap
		bcs 	CompTrue
		bcc 	CompFalse


; *****************************************************************************
;
;								Testers (CS if true)
;
;	= 		equality
;	< 		less than
; 	> 		less than with the parameters swapped
;
; *****************************************************************************

TestEqual:
		jsr 	TypeCheck
		cmp 	#0
		beq 	_TEInteger
		jsr 	StringCompare
		cmp 	#0
		sec
		beq 	_TEZero
		clc
_TEZero		
		rts

_TEInteger:		
		jmp 	Int32Equal

TestLessSwap:
		jsr 	SwapTopStack
TestLess:
		jsr 	TypeCheck
		cmp 	#0
		beq 	_TLInteger
		jsr 	StringCompare
		cmp 	#0
		sec
		bmi 	_TELess
		clc
_TELess:
		rts
		report 	NotImplemented
_TLInteger:		
		jmp 	Int32Less

; *****************************************************************************
;
;		Check types are comparable and return 0 if Integer, #0 if string
;
; *****************************************************************************

TypeCheck:
		jsr 	DerefBoth
		lda 	esType,x
		cmp 	esType+1,x
		bne 	_TCMismatch
		rts
_TCMismatch:
		report 	TypeMismatch		

; *****************************************************************************
;
;								Swap stack top with next
;
; *****************************************************************************

SwapTopStack:
		lda 	#6 			
		sta 	tempShort
		pshx
_TLSLoop:
		lda 	esType,x
		pha
		lda 	esType+1,x
		sta 	esType,x
		pla
		sta 	esType+1,x
		txa
		clc
		adc 	#DataStackSize
		tax
		dec 	tempShort
		bne 	_TLSLoop
		pulx		
		rts
		
; *****************************************************************************
;
;								String Compare
;
; *****************************************************************************

StringCompare:
		lda 	esInt0,x 					; copy addresses.
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1
		lda 	esInt0+1,x
		sta 	temp1
		lda 	esInt1+1,x
		sta 	temp1+1
		sty 	tempShort
		ldy 	#255
_SCLoop:iny
		lda 	(temp0),y 					; check match return +ve/-ve if fail.
		sec
		sbc 	(temp1),y
		bne 	_SCExit
		;
		lda 	(temp0),y 					; matched zero, then exit with zero
		bne 	_SCLoop
_SCExit:		
		ldy 	tempShort
		rts
