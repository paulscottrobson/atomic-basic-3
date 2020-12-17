; *****************************************************************************
; *****************************************************************************
;
;		Name:		run.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Run Program
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								Run Program
;
; *****************************************************************************

Command_Run:	;; [run]
		jsr 	CommandClear 				; clear variables, memory pointers, hash table.
		jsr 	BuildProcedureList 			; build procedure cache.
		set16 	codePtr,BasicProgram 		; reset code pointer.
		ldy 	#0 							; check if off end of program.
		lda 	(codePtr),y
		beq 	Command_End
		ldy 	#3 							; start at this offset.
		;
		;		Do next command.
		;
CommandNextCommand:
		lda 	(codePtr),y 				; get first token ... see if it is a token.
		bpl 	CommandTryLet				; if not, try LET as a default.
		iny 								; advance past it.
		jsr 	ExecuteCommand 				; execute the command
		jmp 	CommandNextCommand
		;
		;		Go to next line.
		;
CommandNextLine:	;; [<<END>>]
		ldy 	#0 							; get offset and add
		lda 	(codePtr),y
		clc
		adc 	codePtr
		sta 	codePtr
		bcc 	_CSLExit
		inc 	codePtr+1
_CSLExit:
		lda 	(codePtr),y 				; reached end of code ?		
		beq 	Command_End
		ldy 	#3 							; 3rd position next line.
		rts
		;
		;		Try to do LET.
		;
CommandTryLet:
		jsr 	Command_LET
		jmp 	CommandNextCommand
		;
Command_Colon:	;; [:]
		rts
				
; *****************************************************************************
;
;									Handle END
;
; *****************************************************************************

Command_End:	;; [end]
		jmp 	WarmStart

; *****************************************************************************
;
;									Handle STOP
;
; *****************************************************************************

Command_Stop:	;; [stop]
		report 	Stop

; *****************************************************************************
;
;								  Assembler Link
;
; *****************************************************************************

Command_StartAsm: ;; [[]
		jmp 	Assembler