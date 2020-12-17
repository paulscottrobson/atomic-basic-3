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

Assembler: 
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
		jsr 	AssemBuildToken 			; make 16 bit token
AssemblerHaveToken:
		jsr 	AssemGetOperand				; figure out operand and addresing mode.
		stx 	AsmMode
		stop	

AssemblerSyntax:
		report 	Syntax		
