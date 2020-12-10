; *****************************************************************************
; *****************************************************************************
;
;		Name:		for.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	For/Next
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								FOR Command
;
; *****************************************************************************

Command_FOR:		;; [for]
		lda 	#SMFor 						; allocate the space.
		jsr 	StackOpen
		jsr 	Command_LET 				; do the same as LET.
		jsr 	CheckTO 					; check TO something.

		ldx 	#1 							; keep the variable address in stack 0
		jsr 	EvaluateTOSDeRef			; get terminal value in stack 1
		;
		;		Set up the FOR stack frame.
		;
		pshy 								; copy things into the area with the default STEP
		ldy 	#4
		lda		esInt0 						; the address of the index into 4 and 5
		sta 	(StackPtr),y
		iny
		lda		esInt1
		sta 	(StackPtr),y
		iny
		;
		lda 	#1  						; the default step in 6
		sta 	(StackPtr),y
		iny
		;
		lda		esInt0+1 					; terminal value in 7 to 11.
		sta 	(StackPtr),y
		iny
		lda		esInt1+1 					
		sta 	(StackPtr),y
		iny
		lda		esInt2+1 					
		sta 	(StackPtr),y
		iny
		lda		esInt3+1 					
		sta 	(StackPtr),y
		puly
		;
		;		Check for STEP
		;
		lda 	(codePtr),y 				; followed by STEP.
		cmp 	#KWD_STEP
		bne 	_CFDone
		;
		;		Calculate STEP
		;
		iny									; skip over step.
		jsr 	EvaluateTOSDeref 			; get step
		pshy
		lda 	esInt0,x 					; copy it into step (bit lazy here)
		ldy 	#6
		sta 	(StackPtr),y
		puly
_CFDone:
		jsr 	StackSavePosition 			; save position.
		rts

; *****************************************************************************
;
;								NEXT Command
;
; *****************************************************************************

Command_NEXT:		;; [next]
		lda 	#SMFor 						; check NEXT
		jsr 	StackCheck
		;
		lda 	(codePtr),y 				; is it NEXT <index>
		bmi 	_CNNoIndex
		cmp 	#$60
		bcs 	_CNNoIndex
		;
		;		Check NEXT <something> is right.
		;
		ldx 	#0 							; start on stack
		lda 	#7  						; get a term
		jsr 	EvaluateLevelAX 			; this is the variable/parameter to localise.
		;
		pshy
		ldy 	#4 							; check same variable
		lda 	(StackPtr),y
		cmp 	esInt0,x
		bne 	_CNBadIndex
		iny
		lda 	(StackPtr),y
		cmp 	esInt1,x
		bne 	_CNBadIndex
		puly
		;
		;		Main NEXT code.
		;
_CNNoIndex:		
		pshy 								; don't need this now.
		;
		;		Adjust the variable by the STEP
		;
		ldy 	#4 							; make temp0 point to the index
		lda 	(StackPtr),y
		sta 	temp0
		iny
		lda 	(StackPtr),y
		sta 	temp0+1
		;
		iny
		ldx 	#0 							; X is the sign of the step.
		lda 	(StackPtr),y 				; get the step.
		sta 	temp2+1 					; save for later.
		bpl 	_CNSignX
		dex 
_CNSignX:
		clc 								; add to the LSB
		ldy 	#0
		adc 	(temp0),y
		sta 	(temp0),y
_CNPropogate:
		iny  								; add the sign extended in X to the rest.
		txa
		adc 	(temp0),y
		sta 	(temp0),y
		iny  
		txa
		adc 	(temp0),y
		sta 	(temp0),y
		iny  
		txa
		adc 	(temp0),y
		sta 	(temp0),y
		;
		clc 								; point temp1 to the terminal value.
		lda 	StackPtr 
		adc 	#7
		sta 	temp1
		lda 	#0
		sta 	temp2 						; clear temp2, which is the OR of all the subtractions.
		tay 								; and clear the Y register again.
		adc 	StackPtr+1
		sta 	temp1+1
		;
		sec 								; calculate current - limit oring interim values.
		jsr 	_CNCompare
		jsr 	_CNCompare
		jsr 	_CNCompare
		jsr 	_CNCompare
		;
		;		At this point temp2 zero if the same, and CS if current >= limit.
		;
		bvc 	_CNNoOverflow 				; converts to a signed comparison on the sign bit.
		eor 	#$80
_CNNoOverflow:		
		ldy 	temp2+1						; get step back
		bmi 	_CNCheckDownto
		;
		;		Test for positive steps
		;
		cmp 	#0
		bmi 	_CNLoopRound 				; loop round if < = 
		lda 	temp2
		beq 	_CNLoopRound
		;
		;		Exit the loop as complete
		;
_CNLoopExit:
		puly		
		jsr		StackClose 					; delete from stack and continue
		rts
		;
		;		Loop back 
		;		
_CNLoopRound:
		puly		
		jsr 	StackLoadPosition			; go back to the loop top
		rts			

_CNBadIndex:
		report 	BadIndex

		;
		;		Test for negative steps
		;
_CNCheckDownto:
		cmp 	#0
		bpl 	_CNLoopRound
		jmp 	_CNLoopExit

_CNCompare:
		lda 	(temp0),y 					; do the subtraction - compare don't care about answer
		sbc 	(temp1),y
		ora 	temp2 						; Or into temp2 (does not affect carry)
		sta 	temp2
		iny
		rts

; *****************************************************************************
;								For/Next usage.
; *****************************************************************************
;
;		+7..+10	 	Terminal value
;		+6			Step (-128..127 maximum)
;		+4..+5 		Address of index.
;		+1..+3 		Loop position (end of the command)
;		+0			Marker (consumes 11 bytes)
;
; *****************************************************************************
