; *****************************************************************************
; *****************************************************************************
;
;		Name:		dim.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Array Dimensioning command.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								DIM Command
;
; *****************************************************************************

Command_Dim:	;; [dim]
		lda 	#0 							; stops the term decoding array dim a(5) would return ref
		sta 	ArrayEnabled 				; to A(5) otherwise :)
		lda 	#7							; get a term
		tax
		jsr 	EvaluateLevelAX 				
		lda 	esType,x 					; get type
		cmp 	#$80 						; it must be an integer reference.
		bne 	_CDSyntax
		sta 	ArrayEnabled 				; reenable normal array behaviour.
		;

		lda 	esInt0,x 					; get variable addr -> temp0
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1
		;
		pshy 								; copy low memory address into that variable.
		ldy 	#0
		lda 	LowMemory 
		sta 	(temp0),y
		iny
		lda 	LowMemory+1
		sta 	(temp0),y
		iny 
		lda 	#0
		sta 	(temp0),y
		iny
		sta 	(temp0),y		
		puly
		;
		jsr 	CheckLeftParen 				; get left bracket
		jsr 	EvaluateTOSDeref 			; get the size to dimension
		jsr 	CheckRightParen 			; do the right hand parenthesis
		;
		lda 	esInt3,x 					; if -ve do not process.
		bmi 	_CDNoSizeCalc
		inc 	esInt0,x 					; increment size by 1 (zero base so dim a(10) is 11 elements)
		bne 	_CDNoBump
		inc 	esInt1,x
_CDNoBump:		
		jsr 	Int32ShiftLeft 				; x 4 (count => bytes)
		jsr 	Int32ShiftLeft
_CDNoSizeCalc:		
		;
		jsr 	AllocMemStackCount 			; allocate that many bytes as per TOS.
		lda 	(codePtr),y
		iny
		cmp 	#KWD_COMMA 					; check if comma follows.
		beq 	Command_DIM 				; if so do more DIM.
		dey
_CDExit:
		rts		
_CDSyntax:
		report 	Syntax		

; *****************************************************************************
;
;		  Allocate TOS bytes from Low Memory. -ve does not advance
;
; *****************************************************************************

AllocMemStackCount:			
		lda 	esInt3,x 					; if -ve do not advance lowmem pointer
		bmi 	_AMSCExit 		
		bne 	AllocError 					; otherwise 2 MSB must be zero, 64k RAM space.
		lda 	esInt2,x
		bne 	AllocError	
		clc
		lda 	esInt0,x 					; add size to pos.
		adc 	LowMemory
		sta 	LowMemory
		lda 	esInt1,x
		adc 	LowMemory+1
		sta 	LowMemory+1
		bcs 	AllocError 					; overflow.
		cmp 	StackPtr+1 					; got into SP page.
		bcs 	AllocError
_AMSCExit:		
		rts		

AllocError:
		report 	Memory
