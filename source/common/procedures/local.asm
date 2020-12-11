; *****************************************************************************
; *****************************************************************************
;
;		Name:		local.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Return from procedure
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;							Local variable handler
;
; *****************************************************************************

Command_Local: 	;; [local]
		jsr 	GetLocalTerm 				; get a local variable.
		pshy
		ldy 	#0 							; erase the variable.
		tya
_CLClear:		
		sta 	(temp0),y
		iny
		cpy 	#4
		bne 	_CLClear
		puly
		;
		lda 	(codePtr),y					; check comma
		iny
		cmp 	#KWD_COMMA
		beq 	Command_Local
		rts

; *****************************************************************************
;
;		Get a term to level 0, push it on the stack, and return position in
;		temp0.
;
; *****************************************************************************

GetLocalTerm:
		pshx 					
		ldx 	#0 							; start on stack
		lda 	#7  						; get a term
		jsr 	EvaluateLevelAX 			; this is the variable/parameter to localise.
		lda 	esType,x 					; which should be a reference of some sort
		bpl 	_GLTSyntax 					; if not, syntax error.
		;
		pshy
		lda 	#SMLocal 					; create stack frame.
		jsr 	StackOpen

		ldy 	#5
		lda 	esInt0,x 					; copy address to temp0 and to stack+5,stack+6
		sta 	temp0
		sta 	(stackPtr),y		

		lda 	esInt1,x
		sta 	temp0+1
		iny
		sta 	(stackPtr),y

		ldy 	#0 							; now copy data into stack1-4
_GLTCopy:
		lda 	(temp0),y
		iny
		sta 	(stackPtr),y
		cpy 	#4
		bne 	_GLTCopy		

		puly
		pulx
		rts


_GLTSyntax:
		report 	Syntax


