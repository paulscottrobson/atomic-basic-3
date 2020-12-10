; *****************************************************************************
; *****************************************************************************
;
;		Name:		rem.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Comment handler.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								Rem Command
;
; *****************************************************************************

Command_Rem:	;; [rem]
Command_Rem2:	;; [']
		lda 	(codePtr),y
		cmp 	#$80 						; end of line.
		beq 	_RemExit
		;
		cmp 	#KWD_COLON
		beq 	_RemExit
		jsr 	AdvancePointer
		jmp 	Command_Rem		
_RemExit:				
		rts

; *****************************************************************************
;
;							Advance to next token.
;
; *****************************************************************************

AdvancePointer:
		lda 	(codePtr),y 				; look at token
		cmp 	#$01 						; quoted string
		beq 	_APString
		iny 								; advance and return.
		rts
_APString:
		tya 								; and length to position
		iny
		clc
		adc 	(codePtr),y
		tay
		rts
