;-----------------------------------------------------
; Matrix Display Support - Displays 1 row based on ADC input
;-----------------------------------------------------
; Assumes ADC result is in R24:R25 (from 0–1023)
; Lights a single row on the 8x8 matrix via shift registers
;-----------------------------------------------------

display_row_from_adc:
	; Map ADC to 0–7 row index
	CLR R18
	MOV R20, R24
	MOV R21, R25

	LDI R22, 0
	LDI R23, 128
adc_row_loop:
	CP R20, R23
	CPC R21, R18
	BRLO adc_row_done
	INC R22
	LDI R17, 128
	ADD R23, R17
	CLR R17
	ADC R18, R17
	RJMP adc_row_loop

adc_row_done:
	LDI R24, 0x00        ; All columns ON (active LOW)
	LDI R25, 1
	CLR R16
display_shift_loop:
	CP R16, R22
	BREQ display_shift_done
	LSL R25
	INC R16
	RJMP display_shift_loop
display_shift_done:
	COM R25              ; Invert row (make only 1 LOW)
	CALL write_word
	RET
