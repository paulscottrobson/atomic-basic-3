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

; *****************************************************************************
;
;						Inline assembler - [ comes here
;
; *****************************************************************************

Assembler: ;; [[] 
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
		iny 								; skip over the .
		lda 	(codePtr),y 				; which means we can't have single letter labels
		cmp 	#$30
		bcc 	AssemblerSyntax
		;
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
AssemblerSyntax:
		report 	Syntax		
		;
		;		Standard opcode.
		;
AssemblerOpcode:
		jsr 	AssemBuildToken 			; make 16 bit token
AssemblerHaveToken:
		jsr 	AssemGetOperand				; figure out operand and addresing mode.
		;
		;		Now find the table entry.
		;
		set16 	temp0,OpcodeTable
		pshy		
_AHTSearch:
		ldy 	#1 							; search table for token.
		lda 	(temp0),y
		cmp 	#$FF
		beq 	AssemblerSyntax 			; end of table.
		cmp 	AsmToken+1
		bne 	_AHTNext
		dey
		lda 	(temp0),y
		cmp 	AsmToken
		beq 	_AHTFound
		;
_AHTNext:		
		lda 	temp0 						; go to next record
		clc
		adc 	#4
		sta 	temp0
		bcc 	_AHTSearch
		inc 	temp0+1
		jmp 	_AHTSearch
_AHTFound:
		ldy 	#2 							; copy base opcode / type
		lda 	(temp0),y
		sta 	AsmOpcode
		iny
		lda 	(temp0),y
		sta 	AsmType
		;
		cmp 	#$F0 						; is it a single type opcode ?
		bcc 	_AHTAllowed
		and 	#$0F
		cmp 	AsmMode						; does it match what we found ?
		beq 	_AHTAllowed 				; if so, carry on.
		;
		cmp 	#AMX_RELATIVE 				; is it relative ?	
		bne 	_AHTNext
		jsr 	CalculateBranch 			; do the branch calculation.

_AHTAllowed:
		puly
		;
		lda 	AsmType
		cmp 	#$F0 						; if type is F0-FF go do standalone.
		bcc 	_AHTIsGroup
		;
		;		Stand alone.
		;
		lda 	AsmType 					; set up AX and write out
		and 	#$0F
		tax
		lda 	AsmOpcode 					
		jsr 	AssemblerWrite
		jmp 	Assembler 					; go round again.
		;
		;		It's a group.
		;		
_AHTIsGroup:
		lda 	esInt1 						; is it a long address/value ?
		bne 	_AHTNoShrink 				; no, don't shrink
		;
		lda 	AsmMode 					; save the current address mode
		pha
		jsr 	GetShortMode 				; convert short
		sta 	AsmMode 					; and try that
		jsr 	AssembleGroup 				; do a group assembly on the short 
		pla 								; restore mode.
		sta 	AsmMode 					
		bcs 	_AHTGDone 					; if okay, then done.		
_AHTNoShrink:		
		jsr 	AssembleGroup 				; try a group assembly on the original (long)
		bcc 	_AHTGOperand 				; syntax error if no.
_AHTGDone:
		jmp 	Assembler		
_AHTGOperand:
		report 	Operand		

; *****************************************************************************
;
;						Calculate Relative Branch
;
; *****************************************************************************

CalculateBranch:
		lda 	asmMode 					; must be ABS 
		cmp 	#AM_ABS
		beq 	_CBOkay
		report 	Syntax
_CBOkay:		
		lda 	pVariable 					; temp1 = pVariable+2 (start address)
		clc
		adc 	#2
		sta 	temp1
		lda 	pVariable+1
		adc 	#0
		sta 	temp1+1
		;	
		sec 								; subtract from the target address
		lda 	esInt0
		sbc 	temp1
		sta 	esInt0
		lda		esInt1
		sbc 	temp1+1
		sta 	esInt1
		;
		beq 	_CBRangeOk 					; MSB must be $FF or $00
		cmp 	#$FF
		beq 	_CBRangeOk
_CBRangeError:
		report 	BranchSize
		;
_CBRangeOk:
		eor 	esInt0						; signs must be the same.
		bmi 	_CBRangeError
		lda 	#0 							; force into range.
		sta 	esInt1
		rts

; *****************************************************************************
;
;				Get the equivalent 'short' mode for a given mode.
;
; *****************************************************************************

GetShortMode:
		ldx 	esInt1 						; can we actually use the short mode.
		bne 	_GSMExit
		tax
		lda 	_GSMTable,x
_GSMExit:		
		rts

_GSMTable:
		.byte 	AM_Immediate 
		.byte 	AM_Zero 
		.byte 	AM_Implied 
		.byte 	AM_Zero 					; was AM_ABS
		.byte 	AM_ZeroIndY 
		.byte 	AM_ZeroX 
		.byte	AMX_ZeroY 					; was AM_ABSY
		.byte 	AM_ZeroX  					; was AM_ABSX
		.byte 	AMX_ZeroIndX				; was AM_ABSINDX
		.byte 	AMX_ZeroInd  				; was AM_ABSIND
		.byte 	AMX_Relative 
		.byte 	AMX_ZeroY 
		.byte 	AMX_ZeroIndX
		.byte 	AMX_ZeroInd 