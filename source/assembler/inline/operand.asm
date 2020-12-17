; *****************************************************************************
; *****************************************************************************
;
;		Name:		operand.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		17 Dec 2020
;		Purpose:	Inline assembler identify (possible) modes/parameters
;					Now way messier because of 65C02
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;			Get Operand. (Stack:0 contains value, X the address mode.)
;	 		 Returns : (Does not check zero except (nn),Y mode and Immediate)
;					Implied, Immediate, Absolute, 
;					(Zero),Y, Absolute,X Absolute,Y
;					(Absolute) (Absolute,X) 	
;
; *****************************************************************************

AssemGetOperand:
		;
		;		Check for A and implied e.g. TAX ASL A. We do not allow ASL A
		;
		lda 	(codePtr),y 				; look at next token.
		ldx 	#AM_Implied 				; first check for Implied and Acc, effectively same.
		cmp 	#$80 						; EOL and colon are implied.
		beq 	_AGOExit
		cmp 	#KWD_COLON
		beq 	_AGOExit
		cmp 	#$00 						; indicates 'A' e.g. ASL A , single character letter A
		bne 	_AGONotImplied
		iny 								; consume the A
_AGOExit:
		rts
		;
		;		Immediate check.
		;
_AGONotImplied:
		cmp 	#KWD_HASH 					; is it immediate e.g. #xxx
		bne 	_AGONotImmediate
		iny 								; consume
		ldx 	#AM_Immediate
		jsr 	AssemGetParameter 			; get the parameter value
		lda 	esInt1 						; must be 00-FF
		bne 	AGPError
		rts
		;
		;		Check for indirection.
		;
_AGONotImmediate:
		cmp 	#KWD_LPAREN 				; check if indirect (xxx
		beq 	_AGOIndirect
		;
		;		Absolute or Zero
		;
		jsr 	AssemGetParameter 			; get parameter
		ldx 	#AM_Abs						; return Absolute.
		lda 	(codePtr),y 				; followed by comma
		cmp 	#KWD_COMMA
		bne 	_AGOExit
		iny 								; consume and get and consume next.
		lda 	(codePtr),y
		iny
		ldx 	#AM_ABSX 					; which must be X or Y
		cmp 	#'X'-'A'
		beq 	_AGOExit
		ldx 	#AM_ABSY
		cmp 	#'Y'-'A'
		beq 	_AGOExit
_AGOSyntax: 								; if not, then error.
		report 	Syntax
		;
		;		Indirection checks. Figure out if (n) (n,X) or (n),Y
		;
_AGOIndirect:
		iny 								; consume (
		jsr 	AssemGetParameter 			; get the indirection address.
		lda 	(codePtr),y 				; what follows	
		cmp 	#KWD_RPAREN 				; if right parenthesis then it must be (xxx),y or (xxxx)
		beq 	_AGOIndirectY
		jsr 	CheckComma 					; so must be comma.
		lda 	(codePtr),y 				; followed by X
		cmp 	#'X'-'A'
		bne 	_AGOSyntax
		iny 								; consume
		jsr 	CheckRightParen 			; check closing )
		ldx 	#AMX_IndX 					; return (nnnn,x)
		rts
		;
		;		Indirect, possibly Y X code.
		;
_AGOIndirectY:
		iny 								; consume RParen
		lda 	(codePtr),y 				; if not followed by , then exit with Indirect
		ldx 	#AMX_Ind
		cmp 	#KWD_Comma
		bne 	_AGOExit 
		iny 								; comsume ,
		lda 	(codePtr),y 				; followed by Y
		cmp 	#'Y'-'A'
		bne 	_AGOSyntax
		iny 								; consume Y
		ldx 	#AM_IndY 					; there is no (absolute),Y
		lda 	esInt1 						; check parameter.
		bne 	_AGOExit
		rts		


; *****************************************************************************
;
;					Get Parameter, check in range 0000-FFFF
;
; *****************************************************************************

AssemGetParameter:
		pshx
		jsr 	EvaluateBaseDeref			; work out the operand
		lda 	esInt2 						; check range
		ora 	esInt3 						; e.g. 0000-FFFF
		bne 	AGPError
		pulx
		rts

AGPError:
		report 	Operand




