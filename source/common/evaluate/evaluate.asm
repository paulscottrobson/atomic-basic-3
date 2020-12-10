; *****************************************************************************
; *****************************************************************************
;
;		Name:		evaluate.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Expression Evaluation
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;						Various entry points for evaluation
;
; *****************************************************************************

EvaluateTerm:								; term value
		lda 	#15
		jsr 	EvaluateLevelAX
		jmp 	DeRefTop

EvaluateBaseDeRef: 							; evaluate value with X = 0
		jsr 	EvaluateBase
		stop
		jmp 	DeRefTop

EvaluateTOSDeRef:							; evaluate value on TOS.
		jsr 	EvaluateTOS
		jmp 	DeRefTop
		
; *****************************************************************************
;
;						Evaluate expression bottom of stack
;
; *****************************************************************************

EvaluateBase:
		ldx 	#0 							; reset Stack index
EvaluateTOS:
		lda 	#0 							; start from lowest level.
		;
		;		Get stack X level A
		;
EvaluateLevelAX:
		pha 								; save level on stack

		lda 	#0 							; erase the current stack level
		sta 	esInt0,x
		sta 	esInt1,x
		sta 	esInt2,x
		sta 	esInt3,x
		sta 	esType,x 					; default to integer.

		lda 	(codePtr),y 				; get the next token/element.
		bmi 	EBNotVariable 				; if $80-$FF it is a token.
		cmp 	#$70 						; if $70-$7F it is a constant
		bcc 	_EBNotConstant
		;
		;		Get constant.
		;		
_EBConstant:
		jsr 	ExtractConstant
		jmp 	EBHaveTerm
		;
		;		Not a constant.
		;
_EBNotConstant:
		cmp 	#$60 						; 60 is a string.
		beq 	_EBHaveString
		;
		;		Variable, Array.
		;
		jsr 	VariableAccess
		jmp 	EBHaveTerm
		;
		;		Have a string.
		;
_EBHaveString:		
		tya 								; put codePtr + 2 in the address, it's a string.
		clc
		adc 	#2
		adc 	codePtr
		sta 	esInt0,x
		lda 	codePtr+1
		adc 	#0
		sta 	esInt1,x
		inc 	esType,x 					; make the type a string.
		;
		tya 								; position in A
		iny 								; point to offset and add it
		clc
		adc 	(codePtr),y
		tay
		jmp 	EBHaveTerm 				; do the term code.
		;
		;		Have term. Current level on stack.
		;
EBHaveTerm:
		lda 	(codePtr),y 				; get the next element.
		bpl 	_EBPopExit 					; needs to be a token to continue.
		sty 	tempShort
		tay 
		lda 	KeywordTypes-$80,y 			; get the type of the keyword.
		ldy 	tempShort
		;
		cmp 	#16 						; not a binary operator.
		bcs 	_EBPopExit
		;
		;		Have a binary operator. Level of operator is in A.
		;
		sta 	tempShort 					; save level of new operator.
		pla 								; restore current level.
		cmp 	tempShort 					; if current >= operator then exit
		bcs 	_EBExit
		;
		pha 								; push level on stack.
		lda		(codePtr),y					; get the token ID and skip
		iny
		pha 								; put that on the stack.
		;
		inx 								; do the term in the next stack level.
		lda 	tempShort 					; get the level of the operator.
		jsr 	EvaluateLevelAX
		dex 				
		;
		pla 								; get token ID
		jsr 	ExecuteCommand 				; execute command A.
		jmp 	EBHaveTerm 					; keep going round
		;
_EBPopExit:	
		pla		
_EBExit:		
		rts
		;
		;		Not a string, constant or variable. Might be unary keyword, EOL, - $ ! or ?
		;		(codePtr),y points to keyword, level is pushed on stack.
		;
EBNotVariable:
		sty 	tempShort 					; get the type
		lda 	(codePtr),y 				; get function keyword.
		tay
		lda 	KeywordTypes-$80,y
		ldy 	tempShort
		and 	#$40 						; check unary function
		bne 	_EBExecUnaryFunction

		lda 	(codePtr),y 				; get function keyword.
		iny
		cmp 	#KWD_MINUS
		beq 	_EBNegate
		cmp 	#KWD_PLING
		beq 	_EBUnaryReference
		cmp 	#KWD_QUESTION
		beq 	_EBUnaryReference
		cmp 	#KWD_DOLLAR
		beq 	_EBUnaryReference
_EBError:	
		report 	Syntax
		; 									; negate
_EBNegate:
		jsr 	EvaluateTerm
		jsr 	Int32Negate
		jmp 	EBHaveTerm
		; 									; $ ! or ?
_EBUnaryReference:
		pha 								; save keyword
		jsr 	EvaluateTerm 				; get the address to case.
		pla
		eor 	#KWD_PLING 					; is it pling, then will now be zero.
		beq 	_EBSetType
		eor 	#KWD_DOLLAR^KWD_PLING 		; if was dollar will now be zero
		beq 	_EBSetString
		lda 	#$41 						; will end up as $C0
_EBSetString:
		eor 	#$01 						; will end up as $81
_EBSetType:
		ora 	#$80 						; make it a reference.
		sta 	esType,x
		jmp 	EBHaveTerm
		;
		;		General unary function.
		;		
_EBExecUnaryFunction:
		lda 	(codePtr),y 				; get the function token.
		iny
		jsr 	ExecuteCommand 				; and do it.
		jmp 	EBHaveTerm

; *****************************************************************************
;
;					Dereference top 2 stack values
;
; *****************************************************************************

DeRefBoth:
		inx
		jsr 	DeRefTop
		dex

; *****************************************************************************
;
;							Dereference top value
;
; *****************************************************************************

DeRefTop:
		lda 	esType,x 					; is it a reference ?
		bpl 	_DRTExit
		and 	#$7F 						; clear the reference bit and write back.
		sta 	esType,x
		lsr 	a 							; if string, exit. Strings are always references
		bcs 	_DRTExit

		lda 	esInt0,x 					; copy address over.
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1
		pshy 								; and the first byte.
		ldy 	#0		
		lda 	(temp0),y
		sta 	esInt0,x
		;
		lda 	esType,x 					; is it now zero, e.g. it's a !
		beq 	_DRTPling

		tya 								; clear upper 3 bytes
		sta 	esInt1,x
		sta 	esInt2,x
		sta 	esInt3,x
		sta 	esType,x
		jmp	 	_DRTExit2

_DRTPling:
		sty 	esType,x 					; make it an integer
		iny
		lda 	(temp0),y 					; copy 4 bytes.
		sta 	esInt1,x
		iny
		lda 	(temp0),y
		sta 	esInt2,x
		iny
		lda 	(temp0),y
		sta 	esInt3,x
_DRTExit2:
		puly
_DRTExit:
		rts		

; *****************************************************************************
;
;							Extract constant from tokens
;
; *****************************************************************************

ExtractConstant:
		lda 	#0 							; count of number of hex digits read.
		sta 	tempShort 					; use tempShort for that
		pshx 								; save X.
_EBConstLoop:
		inc 	tempShort 					; bump the hex digit count.
		;
		lda 	(codePtr),y 				; get next character.
		and 	#$F0 						; check it is 70-7F
		cmp 	#$70 				
		bne 	_EBConstEnd
		;
		lda 	tempShort 					; check LSB of digit count
		lsr 	a
		lda 	(codePtr),y 				; get the digit and bump
		iny
		bcc		_EBConstHigh 				; goes in upper byte.
		;
		and 	#$0F 
		sta 	esInt0,x 					; and write it out.
		bpl 	_EBConstLoop 				; try next one.
		;
_EBConstHigh:
		asl 	a
		asl 	a
		asl 	a
		asl 	a
		ora 	esInt0,x 					; put into upper 4 bits
		sta 	esInt0,x
		;
		txa 								; move to next slot in data stack.
		clc
		adc 	#DataStackSize
		tax
		jmp 	_EBConstLoop
;		
_EBConstEnd:
		pulx 								; restore X and continue.
		rts

; *****************************************************************************
;
;						Execute command A preserving XY
;
; *****************************************************************************

ExecuteCommand:
		sta 	tempShort  					; needs making 65C02 specific.
		pshx					
		ldx 	tempShort
		lda 	TokenVectorLow-$80,x
		sta 	temp0
		lda 	TokenVectorHigh-$80,x
		sta 	temp0+1
		pulx
		jmp 	(temp0)