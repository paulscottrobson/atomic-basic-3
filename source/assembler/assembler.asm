; *****************************************************************************
; *****************************************************************************
;
;		Name:		assembler.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		17 Dec 2020
;		Purpose:	Inline assembler main
;
; *****************************************************************************
; *****************************************************************************

Assembler: 	;; [[]
		lda 	(codePtr),y 				; look at next
		cmp 	#$30 						; single char identifier not allowed
		bcc 	AssemblerSyntax
		;
		cmp 	#$30+$24 					; is it a label ?
		beq 	AssemblerLabel
		cmp 	#$60 						; is it a character (e.g $00-$5F)
		bcc 	AssemblerOpcode
		;
		iny 								; consume it.
		cmp 	#KWD_RSQPAREN 				; if ]
		beq 	AssemblerExit
		cmp 	#KWD_AND 					; tokenised assembler.
		beq 	AssemblerAnd 				; AND only at present.
		cmp 	#KWD_COLON 					; ignore colons
		beq 	Assembler 					
		cmp 	#KWD_SEMICOLON 				; semicolon is a comment 
		beq 	AssemblerNextLine
		cmp 	#$80 						; if not EOL
		bne 	AssemblerSyntax
		;
		;		Advance to next line (does END if off END)
		;
AssemblerNextLine:		
		jsr 	CommandNextLine 			; go to next line
		jmp 	Assembler
		;
		;		Handle ] (return to BASIC interpreter)
		;
AssemblerExit:
		rts
		;
		; 		.Label
		;
AssemblerLabel:
		lda 	#15 						; get a single term
		ldx 	#0
		jsr 	EvaluateLevelAX
		lda 	esType,x 					; check it is a reference
		bpl 	AssemblerSyntax
		;
		lda 	esInt0,x 					; copy label address to temp0
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1
		;
		pshy
		ldy 	#0
		lda 	pVariable 					; copy the value of P in
		sta 	(temp0),y
		iny
		lda 	pVariable+1
		sta 	(temp0),y
		iny
		lda 	#0
		sta 	(temp0),y
		iny
		sta 	(temp0),y
		puly
		jmp 	Assembler 					; go round again.
		;	
		; 		AND is tokenised, so copy the correct value into the asmtoken variable.
		;
AssemblerAND:
		lda 	AndMnemonic
		sta 	AsmToken
		lda 	AndMnemonic+1
		sta 	AsmToken+1
		jmp 	AssemblerHaveToken
		;
		;		Standard opcode.
		;
AssemblerOpcode:
		jsr 	AssemBuildToken
AssemblerHaveToken:
		stop	

AssemblerSyntax:
		report 	Syntax		

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
		bcc 	AssemblerSyntax 			; check it is in the range, e.g. a continuing token.
		cmp 	#$30
		bcs 	AssemblerSyntax 			
		sta 	AsmToken+1 					; we'll shift it into position
		;
		iny 								; get and skip third token
		lda 	(codePtr),y
		iny
		cmp 	#$30 						; this should be last.
		bcs 	AssemblerSyntax
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
