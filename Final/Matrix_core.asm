;-----------------------------------------------------
; Matrix Core – shift out R24:R25 using shift registers
;-----------------------------------------------------

write_word:
	LDI R16, 0x10
	MOV R2, R16

	CLEARBIT PORTB, LATCH

	CLR R16
	PUSH R16

	CLEARBIT PORTB, DATA
matrix_shift_loop:
	POP R16
	OUT SREG, R16
	ROL R24
	ROL R25
	IN R16, SREG
	PUSH R16
	BRCC matrix_finish_shift_loop
	SETBIT PORTB, DATA
matrix_finish_shift_loop:
	SETBIT PORTB, CLOCK
	CLEARBIT PORTB, CLOCK
	CLEARBIT PORTB, DATA
	DEC R2
	BRNE matrix_shift_loop
	POP R16

	SETBIT PORTB, LATCH
	RET
