jmp decimal_conversion_end

convert_to_decimal:
	;Uses R4, R5, R6, R7, R8, R22, R23,R24, R25
	;Outputs to R4, R5, R6, R7, R8
	DECIMAL_CONVERSION R22
RET



div_two_byte:
	;r23:r22 contains the numerator
	;r25:r24 contains the denominator
	;r1:r0 will contain the quotient
	;r3:r2 will contain the remainder
	CLR r0
	CLR r1
	MOVW R2, R22
	CP R22, R24
	CPC R23, R25
	BRCS div_end
	LDI R16, 1
	CLR R17
	repeat_subtraction:
		ADD r0, R16
		ADC r1, r17
		SUB R22, R24
		SBC R23, R25
		MOVW R2, R22
		CP R22, R24
		CPC R23, R25
		BRCS div_end
		rjmp repeat_subtraction
	div_end:

RET

decimal_conversion_end: