; *****************************************************************************
; *****************************************************************************
;
;		Name:		asmtoken.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		17 Dec 2020
;		Purpose:	Inline assembler token builder
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;				Build 16 bit token from ch1 + ch2 << 10 + ch3 << 5
;
; *****************************************************************************

AssemBuildToken:
		lda 	(codePtr),y 				; get first token.
		sec 	 							; we know it is in range, store in LSB
		sbc 	#$30
		sta 	AsmToken
		;
		iny
		lda 	(codePtr),y 				; get second token.
		sec
		sbc 	#$30
		bcc 	_ABSyntax 					; check it is in the range, e.g. a continuing token.
		cmp 	#$30
		bcs 	_ABSyntax 			
		sta 	AsmToken+1 					; we'll shift it into position
		;
		iny 								; get and skip third token
		lda 	(codePtr),y
		iny
		cmp 	#$30 						; this should be last.
		bcs 	_ABSyntax
		;
		;		x 32. First three shifts do not carry out, the last 2 shift into the LSB
		;
		asl 	a
		asl 	a
		asl 	a
		asl 	a
		rol 	AsmToken+1
		asl 	a
		rol 	AsmToken+1		
		;
		ora 	AsmToken 					; or into LSB
		sta 	AsmToken
		rts

_ABSyntax:
		report 	Syntax