;
;	Automatically generated.
;
TokenVectorLow:
	.byte CommandNextLine & $FF            ; <<end>>
	.byte BinaryAnd & $FF                  ; and
	.byte BinaryOr & $FF                   ; or
	.byte BinaryXor & $FF                  ; xor
	.byte Binary_Greater & $FF             ; >
	.byte Binary_Less & $FF                ; <
	.byte Binary_GreaterEqual & $FF        ; >=
	.byte Binary_LessEqual & $FF           ; <=
	.byte Binary_NotEqual & $FF            ; <>
	.byte Binary_Equal & $FF               ; =
	.byte BinaryAdd & $FF                  ; +
	.byte BinarySub & $FF                  ; -
	.byte BinaryMult & $FF                 ; *
	.byte BinaryDivide & $FF               ; /
	.byte BinaryModulus & $FF              ; %
	.byte BinaryShiftRight & $FF           ; >>
	.byte BinaryShiftLeft & $FF            ; <<
	.byte IndirectWord & $FF               ; !
	.byte IndirectByte & $FF               ; ?
	.byte IndirectString & $FF             ; $
	.byte UnaryNot & $FF                   ; ~
	.byte UnaryParenthesis & $FF           ; (
	.byte UnaryHexMarker & $FF             ; &
	.byte UnaryRefToValue & $FF            ; @
	.byte UnaryLen & $FF                   ; len
	.byte UnarySgn1 & $FF                  ; sgn
	.byte UnaryAbs & $FF                   ; abs
	.byte UnaryRandom & $FF                ; random
	.byte UnaryPage & $FF                  ; page
	.byte UnaryTrue & $FF                  ; true
	.byte UnaryFalse & $FF                 ; false
	.byte UnaryMin & $FF                   ; min
	.byte UnaryMax & $FF                   ; max
	.byte UnarySys & $FF                   ; sys
	.byte InstructionUndefined & $FF       ; code
	.byte Unary_Timer & $FF                ; timer
	.byte Event_Function & $FF             ; event
	.byte Unary_Get & $FF                  ; get
	.byte InstructionUndefined & $FF       ; joy.x
	.byte InstructionUndefined & $FF       ; joy.y
	.byte InstructionUndefined & $FF       ; joy.btn
	.byte Unary_Inkey & $FF                ; inkey
	.byte Unary_Alloc & $FF                ; alloc
	.byte UnaryChr & $FF                   ; chr
	.byte NoOp1 & $FF                      ; ,
	.byte NoOp2 & $FF                      ; ;
	.byte NoOp3 & $FF                      ; )
	.byte InstructionUndefined & $FF       ; #
	.byte InstructionUndefined & $FF       ; ++
	.byte InstructionUndefined & $FF       ; --
	.byte InstructionUndefined & $FF       ; ]
	.byte InstructionUndefined & $FF       ; ->
	.byte Command_IF & $FF                 ; if
	.byte Command_FOR & $FF                ; for
	.byte Command_Repeat & $FF             ; repeat
	.byte NoOp6 & $FF                      ; proc
	.byte Command_While & $FF              ; while
	.byte Command_ENDIF & $FF              ; endif
	.byte Command_NEXT & $FF               ; next
	.byte Command_Until & $FF              ; until
	.byte Command_EndProc & $FF            ; endproc
	.byte Command_Wend & $FF               ; wend
	.byte Command_Rem & $FF                ; rem
	.byte Command_LET & $FF                ; let
	.byte Command_Rem2 & $FF               ; '
	.byte Command_Colon & $FF              ; :
	.byte InstructionUndefined & $FF       ; [
	.byte NoOp7 & $FF                      ; then
	.byte Command_ELSE & $FF               ; else
	.byte NoOp8 & $FF                      ; to
	.byte NoOp9 & $FF                      ; step
	.byte Command_Vdu & $FF                ; vdu
	.byte Command_Print & $FF              ; print
	.byte Command_Call & $FF               ; call
	.byte Command_Local & $FF              ; local
	.byte Command_Goto & $FF               ; goto
	.byte Command_Gosub & $FF              ; gosub
	.byte Command_Return & $FF             ; return
	.byte Command_Assert & $FF             ; assert
	.byte Command_Stop & $FF               ; stop
	.byte Command_End & $FF                ; end
	.byte Command_Dim & $FF                ; dim
	.byte CommandClear & $FF               ; clear
	.byte InstructionUndefined & $FF       ; load
	.byte InstructionUndefined & $FF       ; save
	.byte InstructionUndefined & $FF       ; list
	.byte Command_New & $FF                ; new
	.byte Command_Run & $FF                ; run
TokenVectorHigh:
	.byte CommandNextLine >> 8             ; <<end>>
	.byte BinaryAnd >> 8                   ; and
	.byte BinaryOr >> 8                    ; or
	.byte BinaryXor >> 8                   ; xor
	.byte Binary_Greater >> 8              ; >
	.byte Binary_Less >> 8                 ; <
	.byte Binary_GreaterEqual >> 8         ; >=
	.byte Binary_LessEqual >> 8            ; <=
	.byte Binary_NotEqual >> 8             ; <>
	.byte Binary_Equal >> 8                ; =
	.byte BinaryAdd >> 8                   ; +
	.byte BinarySub >> 8                   ; -
	.byte BinaryMult >> 8                  ; *
	.byte BinaryDivide >> 8                ; /
	.byte BinaryModulus >> 8               ; %
	.byte BinaryShiftRight >> 8            ; >>
	.byte BinaryShiftLeft >> 8             ; <<
	.byte IndirectWord >> 8                ; !
	.byte IndirectByte >> 8                ; ?
	.byte IndirectString >> 8              ; $
	.byte UnaryNot >> 8                    ; ~
	.byte UnaryParenthesis >> 8            ; (
	.byte UnaryHexMarker >> 8              ; &
	.byte UnaryRefToValue >> 8             ; @
	.byte UnaryLen >> 8                    ; len
	.byte UnarySgn1 >> 8                   ; sgn
	.byte UnaryAbs >> 8                    ; abs
	.byte UnaryRandom >> 8                 ; random
	.byte UnaryPage >> 8                   ; page
	.byte UnaryTrue >> 8                   ; true
	.byte UnaryFalse >> 8                  ; false
	.byte UnaryMin >> 8                    ; min
	.byte UnaryMax >> 8                    ; max
	.byte UnarySys >> 8                    ; sys
	.byte InstructionUndefined >> 8        ; code
	.byte Unary_Timer >> 8                 ; timer
	.byte Event_Function >> 8              ; event
	.byte Unary_Get >> 8                   ; get
	.byte InstructionUndefined >> 8        ; joy.x
	.byte InstructionUndefined >> 8        ; joy.y
	.byte InstructionUndefined >> 8        ; joy.btn
	.byte Unary_Inkey >> 8                 ; inkey
	.byte Unary_Alloc >> 8                 ; alloc
	.byte UnaryChr >> 8                    ; chr
	.byte NoOp1 >> 8                       ; ,
	.byte NoOp2 >> 8                       ; ;
	.byte NoOp3 >> 8                       ; )
	.byte InstructionUndefined >> 8        ; #
	.byte InstructionUndefined >> 8        ; ++
	.byte InstructionUndefined >> 8        ; --
	.byte InstructionUndefined >> 8        ; ]
	.byte InstructionUndefined >> 8        ; ->
	.byte Command_IF >> 8                  ; if
	.byte Command_FOR >> 8                 ; for
	.byte Command_Repeat >> 8              ; repeat
	.byte NoOp6 >> 8                       ; proc
	.byte Command_While >> 8               ; while
	.byte Command_ENDIF >> 8               ; endif
	.byte Command_NEXT >> 8                ; next
	.byte Command_Until >> 8               ; until
	.byte Command_EndProc >> 8             ; endproc
	.byte Command_Wend >> 8                ; wend
	.byte Command_Rem >> 8                 ; rem
	.byte Command_LET >> 8                 ; let
	.byte Command_Rem2 >> 8                ; '
	.byte Command_Colon >> 8               ; :
	.byte InstructionUndefined >> 8        ; [
	.byte NoOp7 >> 8                       ; then
	.byte Command_ELSE >> 8                ; else
	.byte NoOp8 >> 8                       ; to
	.byte NoOp9 >> 8                       ; step
	.byte Command_Vdu >> 8                 ; vdu
	.byte Command_Print >> 8               ; print
	.byte Command_Call >> 8                ; call
	.byte Command_Local >> 8               ; local
	.byte Command_Goto >> 8                ; goto
	.byte Command_Gosub >> 8               ; gosub
	.byte Command_Return >> 8              ; return
	.byte Command_Assert >> 8              ; assert
	.byte Command_Stop >> 8                ; stop
	.byte Command_End >> 8                 ; end
	.byte Command_Dim >> 8                 ; dim
	.byte CommandClear >> 8                ; clear
	.byte InstructionUndefined >> 8        ; load
	.byte InstructionUndefined >> 8        ; save
	.byte InstructionUndefined >> 8        ; list
	.byte Command_New >> 8                 ; new
	.byte Command_Run >> 8                 ; run
