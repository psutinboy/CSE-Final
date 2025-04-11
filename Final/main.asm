;
; Final.asm
;
; Created: 4/8/2025 9:31:51 AM
; Author : Grant Ledbetter,  Jonas Garibay, Bobby Winters
;

.ORG 0x00
	JMP MAIN

.ORG 0x1A
	JMP timer1_overflow_service


.ORG 0x40
;-----------------------------------------------------
MAIN:

.include "common_macros.inc"
.include "adc_macros.inc"
.include "adc.asm"
.include "shift_to_register_macros.inc"
.include "shift_to_register.asm"
.include "timer_interrupt_macros.inc"
.include "timer_interrupt.asm"
.include "matrix_core.asm"
.include "matrix_display.asm"

; Setup complete—loop forever
main_loop:
	rjmp main_loop

;-----------------------------------------------------
; Timer1 Overflow ISR
;-----------------------------------------------------
timer1_overflow_service:
	CALL read_converter				; Result in R24:R25
	CALL display_row_from_adc		; Convert ADC to row and display
	RETI

;-----------------------------------------------------
end: rjmp end