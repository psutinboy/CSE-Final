;-----------------------------------------------------
; Matrix Display Support - Displays rows based on ADC input
;-----------------------------------------------------
; Assumes ADC result is in R24:R25 (from 0–1023)
; Lights rows 0 through N on the 8x8 matrix via shift registers
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
	LDI R25, 0           ; Start with all rows OFF
	
	; Create a mask with bits 0 through R22 set
	LDI R16, 1           ; Start with bit 0 set
	LDI R17, 0           ; Counter
create_mask_loop:
	CP R17, R22
	BRGE mask_done       ; If counter >= row number, we're done
	LSL R16              ; Shift left
	ORI R16, 1           ; Set the bottom bit
	INC R17              ; Increment counter
	RJMP create_mask_loop
	
mask_done:
	MOV R25, R16         ; Move mask to R25
	COM R25              ; Invert rows (active LOW)
	CALL write_word
	RET