;-----------------------------------------------------------
;ADMUX msn parameters
.equ aref=0x00
.equ avcc=0x40
.equ int1_1=0xC0
;------------------------------------------------------------
;ADMUX LSN parameters
.equ adc0=0x00
.equ adc1=0x01
.equ adc2=0x02
.equ adc3=0x03
.equ adc4=0x04
.equ adc5=0x05
.equ adc6=0x06
.equ adc7=0x07
.equ adc8=0x08	;for temperature sensor
;-------------------------------------------------------------
;ADCSRA
.equ pre2=0x01
.equ pre4=0x02
.equ pre8=0x03
.equ pre16=0x04
.equ pre32=0x05
.equ pre64=0x06
.equ pre128=0x07
;justification of ADC
.equ adc_left_justified=0
.equ adc_right_justified=1
.equ adc_justification = adc_right_justified
;----------------------------------------------------------------------------------------------------
 .MACRO SET_SPECIAL
	;@0 special register
	;@1 bit to be set 
	LDS R16, @0
	LDI R17, (1<<@1)
	OR R16, R17
	STS @0, R16
 .ENDMACRO
 ;----------------------------------------------------------------------------------------------------
 .MACRO CLEAR_SPECIAL
	;@0 special register
	;@1 bit to be set 
	LDS R16, @0
	LDI R17, (1<<@1)
	COM R17
	AND R16, R17
	STS @0, R16
 .ENDMACRO
 ;----------------------------------------------------------------------------------------------------