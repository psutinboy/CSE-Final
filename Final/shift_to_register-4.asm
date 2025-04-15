
/******************************************************************************
***
***  shift_to_register.asm
***
***  Bobby Winters, bwinters@pittstate.edu, 4/4/2025
***
******************************************************************************/
;;;
;;;  This is used to use shift registers.
;;;
;;;----------------------------------------------------------------------------
;;;
;;; This is where we setup portb for output.  It must be run before the shift register
;;; will operate correctly.
;;;
;;;-----------------------------------------------------------------------------
;setup portb for output
SETBIT DDRB, DATA
SETBIT DDRB, LATCH
SETBIT DDRB, CLOCK
;--------------------------------------------------------------------------------
jmp shift_word_end
shift_word:
	;we will write the word contained in R24 and R25 to the shift registers
	;INITIALIZE COUNTER
	;Uses R2, R16, R17, R24, R25

	LDI R16, word_length
	MOV R2, R16

	;CLOSE LATCH
	CLEARBIT PORTB, LATCH

	;CLEAR Carry in SREG
	CLC
	;CLEAR DATA BIT
	CLEARBIT PORTB, DATA
	shift_loop:
		LSL R24
		ROL R25
		BRCC finish_shift_loop
		SETBIT PORTB, DATA
		finish_shift_loop:
		SETBIT PORTB, CLOCK			;SEND THE DATA BIT
		CLEARBIT PORTB, CLOCK
		CLEARBIT PORTB, DATA		;RESET DATA BIT
		DEC R2
		BRNE shift_loop
	;open latch
	SETBIT PORTB, LATCH
	RET
shift_word_end:
;----------------------------------------------------------------