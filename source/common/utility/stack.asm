; *****************************************************************************
; *****************************************************************************
;
;		Name:		stack.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Basic stack routines.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;					Allocate space using the given marker
;
; *****************************************************************************

StackOpen:
		sta 	tempShort 					; save it
		and 	#StackSizeMask 				; bytes to subtract.
		eor 	#$FF 						; add to stack pointer, 2's complement
		sec
		adc 	StackPtr
		sta 	StackPtr
		lda 	StackPtr+1
		adc 	#$FF
		sta 	StackPtr+1
		;		
		pshy 								; save Y
		ldy 	#0 							; write marker at offset 0
		lda 	tempShort
		sta 	(StackPtr),y
		puly

		lda 	LowMemory+1 				; check memory available
		cmp 	StackPtr+1
		bcs		_SOMemory
		rts
_SOMemory:
		report 	Memory

; *****************************************************************************
;
;						Check Stack type matches (NZ fail)
;
; *****************************************************************************

StackCheck:
		sty 	tempShort
		ldy 	#0 							; eor with marker
		eor 	(StackPtr),y
		ldy 	tempShort
		cmp 	#0 							; set Z flag
		rts

; *****************************************************************************
;
;								Close stack frame
;
; *****************************************************************************

StackClose:
		pshy
		ldy 	#0
		lda 	(StackPtr),y 				; get type back
		and 	#StackSizeMask 				; bytes to add
		clc
		adc 	StackPtr
		sta 	StackPtr
		bcc 	_SCSkip
		inc 	StackPtr+1
_SCSkip:puly	
		rts

; *****************************************************************************
;
;						Load position (always at offset 1)
;
; *****************************************************************************

StackLoadPosition:
		ldy 	#3 							; read in codePtr from 3,2
		lda 	(stackPtr),y
		sta 	codePtr+1
		dey
		lda 	(stackPtr),y
		sta 	codePtr
		dey
		lda 	(stackPtr),y 				; restore offset in line
		tay
		rts
		
; *****************************************************************************
;
;						Save position (always at offset 1)
;
; *****************************************************************************

StackSavePosition:
		tya 								; get position in A
		ldy 	#1 
		sta 	(stackPtr),y 				; write it out.
		pha 								; save to stack
		iny 								; write line position
		lda 	codePtr 
		sta 	(stackPtr),y
		iny
		lda 	codePtr+1
		sta 	(stackPtr),y
		puly 								; restore Y 
		rts

; *****************************************************************************
;
;							Pop Locals off the stack
;
; *****************************************************************************

StackPopLocals:
		ldy 	#0 							; check if TOS is a local record
		lda 	(stackPtr),y
		cmp 	#SMLocal
		bne 	_SPLExit
		;
		ldy 	#5 							; copy local address to temp0
		lda 	(stackPtr),y
		sta 	temp0
		iny
		lda 	(stackPtr),y
		sta 	temp0+1

		ldy 	#4 							; start copying back
_SPLLoop:
		lda 	(stackPtr),y
		dey
		sta 	(temp0),y
		cpy 	#0
		bne 	_SPLLoop		

		jsr 	StackClose 					; drop frame and try again
		jmp 	StackPopLocals

_SPLExit:
		rts		

