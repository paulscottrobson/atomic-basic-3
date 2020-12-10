; *****************************************************************************
; *****************************************************************************
;
;		Name:		event.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		10 Dec 2020
;		Purpose:	Event speed control
;
; *****************************************************************************
; *****************************************************************************
;
;	Event takes two parameters - a tracking variable, and a rate. The function
;	returns TRUE at the 'rate' specified as follows:
;
;	It normally returns FALSE
;
;	When the tracking variable is 0, the variable is reset (see below). You 
; 	can force a reset by setting it to zero.
;
;	When it is non zero , if the variable value is greater/equal to the timer
;	the 'event' fires, and it returns TRUE.
;
;	On firing, the variable is reset to the current time + the firing rate.
;	(If this sum is zero, then it is set to one)
;
;	Note this is a 16 bit value and works on the sign of the difference,
;	limiting the event rate to 32767, which is about 8 minutes.
;
;	boolean EVENT(<variable>,<rate>)
;
; *****************************************************************************
;
;								EVENT command
;
; *****************************************************************************

Event_Function:		;; [event]
		jsr 	CheckLeftParen 				; check for (
		lda 	#4  						; this means ! ? and $ binary operators only work.
		jsr 	EvaluateLevelAX 			; this is the event variable.
		lda 	esType,x 					; which should be a reference of some sort
		bpl 	_EFSyntax 					; if not, syntax error.
		jsr 	CheckComma
		inx
		jsr 	EvaluateTOSDeRef 			; get the rate
		dex
		jsr 	CheckRightParen 			; closing bracket.

		jsr 	XTUpdateClock

		pshy

		lda 	esInt0,x 					; point temp0 to the variable
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1

		ldy 	#0 							; check if zero, if so initialise/return FLASE
		lda 	(temp0),y
		iny 	
		ora 	(temp0),y 
		beq 	_EFInitialise
		;
		;		Check for overflow in timer.
		;
		ldy 	#0 							; calc timer - variable
		lda 	ClockTicks
		cmp 	(temp0),y
		iny
		lda 	ClockTicks+1
		sbc 	(temp0),y		
		bpl 	_EFFire						; if >= reset and return TRUE
		;
		jsr 	Int32False					; otherwise just return FALSE
		jmp 	_EFExit
		;
		;		Return TRUE, reset the timer.
		;
_EFFire:
		jsr 	Int32True
		jmp 	_EFResetTimer
		;
		;		Return FALSE, reset the timer.
		;
_EFInitialise:
		jsr 	Int32False 					; return FALSE
_EFResetTimer:		
		ldy 	#0 							; reset the variable to clock + rate.
		clc
		lda 	ClockTicks
		adc 	esInt0+1,x
		sta 	(temp0),y
		iny
		lda 	ClockTicks+1
		adc 	esInt1+1,x
		sta 	(temp0),y
		dey									; check zero
		ora 	(temp0),y
		bne 	_EFExit
		lda 	#1 							; if so set it to 1.
		sta 	(temp0),y
_EFExit:		
		puly
		rts

_EFSyntax:
		report 	Syntax
