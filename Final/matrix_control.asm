/*************************************************************************************************
***
***  This file matrix_control.asm contains subroutines for controlling the LED matrix
***  using the same shift registers that were previously controlling the 7-segment display.
***
***  Created: 2025
***
*************************************************************************************************/

;------------------------------------------------------------------------------------------------
; Matrix Row and Column patterns (8x8 matrix)
; For row selection, we set the corresponding bit HIGH in the MSB of the shift register
; For column selection, we set the corresponding bits LOW in the LSB of the shift register
;------------------------------------------------------------------------------------------------

matrix_row_patterns:                ; Row selection patterns (MSB of shift register)
.db 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80   ; Rows 0-7

; Reserve memory for storing the current number of rows to light
.dseg
num_rows_to_light: .byte 1          ; Store number of rows to light (0-8)
current_row: .byte 1                ; Store the current row being displayed (0-7)
.cseg

;-------------------------------------------------------------------------------------------------
; This is run at the beginning of the program to initialize LED matrix control
;-------------------------------------------------------------------------------------------------
jmp matrix_init_end

matrix_init:
    ; Initialize LED matrix variables
    LDI R16, 0x00
    STS num_rows_to_light, R16   ; Start with no rows lit
    STS current_row, R16         ; Start at row 0
    RET
    
matrix_init_end:

;-------------------------------------------------------------------------------------------------
jmp update_matrix_rows_end

update_matrix_rows:
    ; This function updates the number of rows to light based on the potentiometer value
    ; The potentiometer value (0-1023) is in R24:R25
    
    ; First, we need to scale the 10-bit ADC value (0-1023) to 0-8 rows
    ; For simplicity, we'll use the high 3 bits of the ADC result (divide by 128)
    LSR R25           ; Shift right to get the value divided by 2
    ROR R24
    LSR R25
    ROR R24
    LSR R25
    ROR R24
    LSR R25
    ROR R24
    LSR R25
    ROR R24
    LSR R25
    ROR R24
    LSR R25
    ROR R24
    
    ; R24 now contains a value between 0-7, add 1 to get 1-8 rows
    INC R24
	LDI R16, 0x08	; Flip value from 1-8 to 8-1
	SUB R16, R24
    
    ; Store the number of rows to light (capped at 8)
    CPI R16, MATRIX_ROWS+1
    BRLO store_num_rows
    LDI R16, MATRIX_ROWS
    
store_num_rows:
    STS num_rows_to_light, R16
    RET
    
update_matrix_rows_end:

;-------------------------------------------------------------------------------------------------
jmp display_matrix_end

display_matrix:
    ; This function displays the LED matrix based on stored row count
    ; It displays one row at a time and cycles through all active rows
    
    ; Get the current row being displayed
    LDS R22, current_row
    
    ; Get number of rows to light
    LDS R23, num_rows_to_light
    
    ; Check if the current row is less than the number of rows to light
    CP R22, R23
    BRLO row_is_not_active
	JMP row_is_active

    
save_current_row:
    STS current_row, R22
    RET
    
row_is_active:
    ; Load the row pattern for current row
    LDI ZL, LOW(matrix_row_patterns<<1)
    LDI ZH, HIGH(matrix_row_patterns<<1)
    
    ; Add the row index to get the correct pattern
    ADD ZL, R22
    CLR R16
    ADC ZH, R16
    
    ; Load the row pattern into R25
    LPM R25, Z
    
    ; Prepare column pattern (all columns lit = 0x00)
    LDI R24, MATRIX_ALL_COLS_ON
    
    ; Send to shift register
    CALL shift_word
    
    ; Increment the current row and wrap around if needed
    INC R22
    CPI R22, MATRIX_ROWS
    BRLO save_current_row
    CLR R22
    JMP save_current_row

row_is_not_active:
    ; Row is not active, turn off all LEDs
    LDI R25, 0x00         ; No row selected
    LDI R24, MATRIX_NO_COLS_ON  ; All columns off
    CALL shift_word

	; Increment the current row and wrap around if needed
    INC R22
    CPI R22, MATRIX_ROWS
    BRLO save_current_row
    CLR R22

display_matrix_end: 