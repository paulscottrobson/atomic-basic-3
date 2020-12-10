; *****************************************************************************
; *****************************************************************************
;
;		Name:		testing.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		4 Dec 2020
;		Purpose:	General testing code, not normally included.
;
; *****************************************************************************
; *****************************************************************************

TestProgram:		
		set16 	codePtr,BasicProgram
		ldy 	#0 
		ldx 	#1
		jsr 	EvaluateTOS
		stop
;		jsr 	DerefTop
		stop
w1:		jmp 	w1
