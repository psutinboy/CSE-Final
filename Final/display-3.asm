
/*************************************************************************************************
***
***  This file display.asm contains subroutines that are used in running a 4-digit display of 
***  7-segment LEDs.
***
***  Bobby Winters, bwinters@pittstate.edu, 4/3/2025
***
*************************************************************************************************/

;------------------------------------------------------------------------------------------------
; These are the codes for the particular characters.  The characters are assumed to correspond to 
; numbers.  These particular characters are 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F
;------------------------------------------------------------------------------------------------
segment_codes:
.db 0xc0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x98, 0x88, 0x83, 0xC6, 0xA1, 0x86, 0x8E

;-------------------------------------------------------------------------------------------------
; This is meant to be run at the beginning of the program.  It will move the segment_codes to a position
; in RAM starting at segment_base.
;-------------------------------------------------------------------------------------------------
;store segment codes
LDI R16, character_number
LDI ZL, LOW(segment_codes<<1)
LDI ZH, HIGH(segment_codes<<1)
LDI XL, LOW(segment_base)
LDI XH, HIGH(segment_base)
load_segment_codes_loop:
	LPM R24, Z+
	ST X+, R24
	DEC R16
	BRNE load_segment_codes_loop
;-------------------------------------------------------------------------------------------------
jmp data_to_digit_buffer_end

data_to_digit_buffer:
	;We move data from the general purpose registers R24:R25 to a RAM location that begins at digit buffer.
	;Uses R16, R17, R20, R24, R25, R26, R27
	LDI R20, 0x0F
	AND R20, R24
	REGISTER_TO_RAM R20, digit_buffer_base, 0
	LDI R20, 0xF0
	AND R20, R24
	SWAP R20
	REGISTER_TO_RAM R20, digit_buffer_base, 1
	LDI R20, 0x0F
	AND R20, R25
	REGISTER_TO_RAM R20, digit_buffer_base, 2
	LDI R20, 0xF0
	AND R20, R25
	SWAP R20
	REGISTER_TO_RAM R20, digit_buffer_base, 3
	RET
data_to_digit_buffer_end:
;--------------------------------------------------------------------------------------------------
jmp digit_to_code_buffer_end

digit_to_code_buffer:
	;We take the digit from its indexed position in RAM, and, using the numerical value of that digit itself as an index, look up the
	;code that will activate the appropriate segments on the LED.  We then save that code in a segment
	;of memory that begins at digit_buffer_base.  This is done one digit at a time.  At each step
	;R20 will hold the index of the digit to be encoded.
	;
	;It accesses the stack.
	;
	;Uses R16, R17, R20, R24, R26, R27
	
	;save this value for later
	PUSH R20
	;load the digit whose code we are going to look up
	RAM_TO_REGISTER digit_buffer_base, R20, R24

	;retrieve the code of the digit
	MOV R20, R24
	RAM_TO_REGISTER segment_base, R20, R24

	;store the code in the digit_code_buffer
	POP R20
	REGISTER_TO_RAMD R24, digit_code_buffer_base, R20

	RET
digit_to_code_buffer_end:
;------------------------------------------------------------------------------------------------
jmp encode_digits_end
encode_digits:
	;This will encode each of the digits stored in the digit buffer and store the codes
	;in the digit code buffer.
	;
	;Uses R16, R17, R20, R24, R26, R27

	LDI R20, 0
	CALL digit_to_code_buffer
	LDI R20, 1
	CALL digit_to_code_buffer
	LDI R20, 2
	CALL digit_to_code_buffer
	LDI R20, 3
	CALL digit_to_code_buffer

	RET
encode_digits_end:
;------------------------------------------------------------------------
jmp encode_data_end
encode_data:
	;This takes each nimble of the word R25:r24, and stores the code of that
	;nibble in the appropriate position in the digit_code_buffer
	;
	;Uses R16, R17, R20, R24, R26, R27
	CALL data_to_digit_buffer
	CALL encode_digits
	RET
encode_data_end:
;--------------------------------------------------------------------
jmp display_digits_end
display_digits:
	;This displays the digits whose codes are in the digit_code_buffer
	;
	;Uses R2, R16, R17, R20, R24, R25, R26, R27

	LDI R25, DIGIT0
	LDI R20, 0
	RAM_TO_REGISTER digit_code_buffer_base, R20, R24
	CALL shift_word
	LDI R25, DIGIT1
	LDI R20, 1
	RAM_TO_REGISTER digit_code_buffer_base, R20, R24
	CALL shift_word
	LDI R25, DIGIT2
	LDI R20, 2
	RAM_TO_REGISTER digit_code_buffer_base, R20, R24
	CALL shift_word
	LDI R25, DIGIT3
	LDI R20, 3
	RAM_TO_REGISTER digit_code_buffer_base, R20, R24
	CALL shift_word

	RET

display_digits_end:
;---------------------------------------------------------------------

;The default display will be 0000

CLR R24
CLR R25
CALL encode_data