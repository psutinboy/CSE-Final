/*************************************************************************************************
***
***    Matrix Control Macros
***
***    Created: 2025
***
************************************************************************************************/
;;;
;;; matrix_control_macros.inc contains macros and values that will be used for controlling
;;; the LED matrix on the freenove fnk0059 project board.
;;;
;-------------------------------------------------------------------------------------------------
;;; LED Matrix Configuration
.equ MATRIX_ROWS = 8          ; Number of rows in the LED matrix
.equ MATRIX_COLS = 8          ; Number of columns in the LED matrix
.equ MATRIX_START_ROW = 7     ; Row to start on

;;; Matrix Control Constants
.equ MATRIX_ALL_COLS_ON = 0x00  ; Value to light all columns (active LOW)
.equ MATRIX_NO_COLS_ON = 0xFF   ; Value to turn off all columns

;;; Scaling Constants for potentiometer to rows mapping
.equ POT_MAX = 1023           ; Maximum potentiometer value (10-bit ADC)
.equ POT_SCALE = 128          ; Scaling factor to map 0-1023 to 0-8 rows 