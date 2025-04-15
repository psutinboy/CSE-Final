.EQU TEN_THOUSAND = 0X2710
.EQU ONE_THOUSAND = 0X03E8
.EQU ONE_HUNDRED = 0X0064
.EQU TEN = 0X000A
;------------------------------------------------
.MACRO PLACE_VALUE 
	;@0	place value
	;@1 digit position register
	;Uses R22, R23,R24, R25
	;Outputs to R22, R23
	LDI R24, low(@0)
	LDI R25, HIGH(@0)
	CALL div_two_byte
	mov @1, R0
	MOVW R22, R2
.ENDMACRO
;------------------------------------------------
.MACRO DECIMAL_CONVERSION
	;@0 THE LEAST SIGNIFICANT BYTE OF THE TWO-BYTE INTEGER
	;Uses R4, R5, R6, R7, R8, R22, R23,R24, R25
	;Outputs to R4, R5, R6, R7, R8
	MOVW R22, @0
	PLACE_VALUE TEN_THOUSAND, R8
	PLACE_VALUE ONE_THOUSAND, R7
	PLACE_VALUE ONE_HUNDRED, R6
	PLACE_VALUE TEN, R5
	MOV R4, R2
.ENDMACRO
;------------------------------------------------
