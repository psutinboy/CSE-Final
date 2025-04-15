;
; Final.asm
;
; Created: 4/8/2025 9:31:51 AM
; Author : Grant Ledbetter,  Jonas Garibay, Bobby Winters
;

.ORG 0x0							;location for reset
	JMP MAIN
.ORG 0x1A							;timer1 overflow service request
	JMP timer1_overflow_service
;----------------------------------------------------------------------------
MAIN:

.include "common_macros-3.inc"
.include "shift_to_register_macros-2.inc"
.include "shift_to_register-4.asm"
.include "timer_interrupt_macros-2.inc"
.include "timer_interrupt-2.asm"

.include "adc_macros-1.inc"
.include "adc-1.asm"

.include "matrix_control_macros.inc"
.include "matrix_control.asm"

; Initialize components
CLR R0                      ; Clear R0 for use in matrix control
CALL matrix_init            ; Initialize LED matrix control variables

main_loop:
	CALL display_matrix     ; Display the LED matrix based on pot value
	jmp main_loop

end: rjmp end

timer1_overflow_service:
	CALL read_converter     ; Read the potentiometer value into R24:R25
	CALL update_matrix_rows ; Update the number of rows to light based on pot value
	RETI