;SETUP ADC

;initialize ADCSRA

CLR R16
SBR R16, (1<<ADIE)|(pre128)		;interrupt enable and set the prescaler
STS ADCSRA, R16

;initialize ADMUX
CLR R16
SBR R16,(int1_1)|(adc1)			;voltage and input port
STS ADMUX, R16
;set pinc for input
IN R16, DDRC
LDI R17, (1<<(adc1 - 1))					;the amount of the shift matches the port pin
COM R17
AND R16, R17
OUT DDRC, R16

;justification of ADC

;justify right by default
CLEAR_SPECIAL ADMUX, ADLAR
LDI R16,adc_right_justified
CPI R16, adc_justification
BREQ justification_set
SET_SPECIAL ADMUX, ADLAR
justification_set:

JMP read_converter_end
;-------------------------------------------------
read_converter:
	LDI R16, (1<<ADEN)|(1<<ADSC)|(pre128)
	STS ADCSRA, R16
	keep_polling:
		LDS R16, ADCSRA
		SBRS R16, ADIF
		RJMP keep_polling
		LDI R16, (1<<ADIF)
		STS ADCSRA, R16
		LDS R16, ADCL
		MOV R24, R16
		LDS R16, ADCH
		MOV R25, R16
		RET
;-------------------------------------------------
read_converter_end: