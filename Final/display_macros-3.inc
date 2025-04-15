/*************************************************************************************************
***
***    Display Macros and Display
***
***    Bobby Winters, bwinters@pittstate.edu, 4/3/2025
***
************************************************************************************************/
;;;
;;; display_macros contains macros and values that will be used in its partner asm file diplay.
;;; Together these files run a 4-digit display consisting of 7-segment LEDs.  The display in question
;;; is run by a pair of 8-bit shift registers.  The most significant 8 bits selects the digit to be displayed
;;; by setting the V++ on the particular digit HIGH.  The least significant 8-bits selects the segments
;;; to be lit by writing the bits assocated with the lit segments LOW.
;;;
;;; The codes for the particular characters are initially in program memory but upon startup, they
;;; are moved to RAM. A portion of RAM has been set aside for them which begins at the location segment_base
;;; and continues for character_number bytes.
;;;
;;; The values of the 4 digits that are to be displayed are stored in a buffer that begins at the address
;;; digit_buffer_base and continues for digit_number bytes.  These are the actual values of the digits 
;;; to be displayed, not the codes that will actually be sent to the shift register. 
;;;
;;; The values for the codes of the digits to be displayed are stored in a buffer than begins at address
;;; digit_code_buffer_base and continues for digit_number bytes.  These are the codes for the digit values.
;;; These codes will be sent to the shift register.
;-------------------------------------------------------------------------------------------------
;;; These values provide a memory map that will be used to display.
.equ segment_base=0x0100							            ;the codes for the segments begin here
.equ character_number=0x10							            ;the number of characters
.equ digit_buffer_base= segment_base + character_number			;the digit buffer begins here
.equ digit_number=0x04											;number of digits
.equ digit_code_buffer_base =digit_buffer_base + digit_number	;the digit code buffer begings here
;-------------------------------------------------------------------------------------------------
;digit codes
;needed for selecting digit on display
.equ DIGIT0=0X08				;selects the right most digits, digit 0
.equ DIGIT1=0X04				;selects digit1
.equ DIGIT2=0X02				;selects digit2
.equ DIGIT3=0X01				;selects digit3
;----------------------------------------------------------------------------