; *****************************************************************************
; *****************************************************************************
;
;		Name:		let.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Assignment command.
;
; *****************************************************************************
; *****************************************************************************

Command_LET:	;; [let]
		ldx 	#0 							; start on stack
		lda 	#4  						; this means ! ? and $ binary operators only work.
		jsr 	EvaluateLevelAX 			; this is the LHS
		lda 	esType,x 					; which should be a reference of some sort
		bpl 	_CLSyntax 					; if not, syntax error.
		jsr 	CheckEquals 				; check equals follows.
		inx 								; get the right hand side.
		jsr 	EvaluateTOSDeRef 			
		dex
		;
		lda 	esInt0,x 					; copy target address to temp0
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1
		;
		lda 	esType,x 					; what sort of reference ?
		asl 	a 							; will now be $00 integer $80 byte $02 string.
		beq 	_CLIntCopy
		bmi 	_CLByteCopy
		;
		;		String assign
		;
		lda 	esInt0+1,x 					; source -> temp1
		sta 	temp1
		lda 	esInt1+1,x
		sta 	temp1+1

		pshy
		ldy 	#0
_CLStringCopy:
		lda 	(temp1),y
		sta 	(temp0),y
		beq 	_CLCopyExit 				; copied trailing NULL
		iny
		bne 	_CLStringCopy 				; it could run riot.		
_CLCopyExit:
		puly
		rts		
		;
_CLSyntax:
		report 	Syntax				
		;
		;		Byte assign (e.g. ?x = 42)
		;
_CLByteCopy:
		lda 	esInt0+1,x 					; get the byte to write.
		sta 	(temp0,x)					; write, taking advantage of X = 0
		rts
		;
		;		Int assign (e.g. !x = 42 or x = 42)
		;
_CLIntCopy:
		inx
		jsr 	CopyTOSToTemp0
		rts

; *****************************************************************************
;
;							Copy TOS to (temp0)
;
; *****************************************************************************

CopyTOSToTemp0:
		pshy
		ldy 	#0
		lda 	esInt0,x
		sta 	(temp0),y
		iny
		lda 	esInt1,x
		sta 	(temp0),y
		iny
		lda 	esInt2,x
		sta 	(temp0),y
		iny
		lda 	esInt3,x
		sta 	(temp0),y
		puly
		rts
