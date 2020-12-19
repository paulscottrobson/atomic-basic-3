; *****************************************************************************
; *****************************************************************************
;
;		Name:		asmgroup.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		19 Dec 2020
;		Purpose:	Try to do a group assembly.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;		Try a group assembler :
;
;			ASMOpcode :		the base opcode.
;			ASMType : 		Type byte <MaskID>|<Group> Group is m1m2m3
;			ASMMode : 		the mode to try
;			ESInt0,ESInt1 : the operand
;
; *****************************************************************************

AssembleGroup:
		;
		;		Group 1 is handled seperately.
		;
		lda 	ASMType
		and 	#$0F
		cmp 	#$01
		beq 	_AGGroup1
		;
		;		Fixes for LDX and STX Z,Y and A,Y which use the Z,X and A,X opcodes.
		;
		lda 	ASMOpcode 					; look at the base Opcode.
		cmp 	#$82 						; if it is $82 (stx) or $A2 (ldx) do the index,Y translate.
		beq 	_AGTranslateX
		cmp 	#$A2
		bne 	_AGNoTranslate
_AGTranslateX:
		lda 	AsmMode 					; did we provide ,X to LDX or STX ?
		cmp 	#AM_ZeroX
		beq 	_AGOperand 					; if so, it's a bad operand
		cmp 	#AM_AbsX
		beq 	_AGOperand
		;
		ldx 	#AM_ZeroX 					; if it is Z,Y actually do Z,X
		cmp 	#AMX_ZeroY
		beq 	_AGUpdateMode
		ldx 	#AM_AbsX 					; if it is A,Y actually do A,X
		cmp 	#AM_AbsY
		beq 	_AGUpdateMode
		bne 	_AGNoTranslate
_AGOperand:
		report 	Operand

_AGUpdateMode:								; use this mode yourself.
		stx 	AsmMode
_AGNoTranslate:
		;
		;		Now access the mask for this instruction, to check if it is supported.
		;
		lda 	AsmType 					; get the mask number
		lsr 	a
		lsr 	a
		lsr 	a
		lsr 	a
		tax
		lda 	MaskTable,x 				; get the mask table value into X (LSB = Entry#0)
		ldx 	AsmMode 					; get the mode #
		cpx 	#8 							; if >= 8 then it isn't valid.
		bcs 	_AGFail
_AGShift: 									; put the enabling bit in the carry.
		asl 	a
		dex	
		bpl 	_AGShift		
		bcc 	_AGFail 					; it is not supported, e.g. the mask bit is clear.
		;
		;		We are okay ! So substiture Type << 2 in the addressing mode bits.
		;
_AGConstruct:		
		lda 	ASMMode 					; put the type in X for outputting.
_AGConstructX:		
		cmp 	#8 							; check range
		bcs 	_AGFail
		;
		asl 	a 							; shift left twice.
		asl 	a
		sta 	temp2
		;
		lda 	ASMOpcode 					; put into the opcode.
		cmp 	#$F2 						; handle STZ as a special case.
		beq	 	_AGSTZHandler
		and 	#$E3
		ora 	temp2
		;
_AGWriteExit:		
		ldx 	AsmMode
		jsr 	AssemblerWrite 				; instruction A mode X.
		sec 								; and return with CS.
		rts
;
;		Come here if we fail.
;
_AGFail:
		clc
		rts
;
;		Handle STZ which is simply bunged anywhere it fits in the 65C02 hence the LUT
;
_AGSTZHandler:
		lda 	_AGSTZTable,x  				; get the opcode.
		jmp 	_AGWriteExit 				; write and exit.			

_AGSTZTable:
		.byte 	0,$64,0,$9C,0,$74,0,$9E 	; opcodes are z a z,x a,x

; *****************************************************************************
;
;		Handle Group 1 which has some variations.
;
;		All instructions are allowed (except STA #)
;		AM_Implied is not allowed (operand error)
;		AM_Immediate is mapped onto AM_Implied 
; 		AMX_ZeroIndX is mapped onto AM_Immediate
;
;		AMX_ZeroInd is handled seperately ; the opcode is base + $12
;
; *****************************************************************************

_AGGroup1:
		ldx 	ASMMode 					; the type we have.
		cpx 	#AM_Immediate 				; check not immediate
		bne 	_AG1NotSTI		
		lda 	ASMOpcode 					; check base not STA
		cmp 	#$81
		bne 	_AG1NotSTI		
		report 	Operand 					; no STA#
_AG1NotSTI:		
		cpx 	#AM_Implied
		beq 	_AGFail 					; we do not do implied
		cpx 	#AMX_ZeroInd 				; (z) is special case.
		beq 	_AG1ZeroInd
		;
		lda 	#AM_Implied
		cpx 	#AM_Immediate
		beq 	_AGConstructX
		;
		lda 	#AM_Immediate
		cpx 	#AMX_ZeroIndX
		beq 	_AGConstructX
		jmp 	_AGConstruct 				; and do it.
		;
		;		Handle (z)
		;
_AG1ZeroInd:
		lda 	ASMOpcode 					; get base
		clc  
		eor 	#$13 						; $A1 -> $B2
		bne 	_AGWriteExit