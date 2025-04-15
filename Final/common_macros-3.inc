/*************************************************************************************************
***
***
***    Common Macros
***
***    Bobby Winters, bwinters@pittstate.edu, 4/3/2025
***
***
**************************************************************************************************/
;;;
;;;  This includes macros that are designed to do manipulations at the base level.
;;;  They are intended to be potentially useful for any application.
;-------------------------------------------------------------------------------------------------
.MACRO SETBIT
	;@0 port
	;@1 pin number
	;This will set the @1 bit of port @0 to 1
	;Uses R16, R17
	IN R16, @0
	LDI R17, (1<<@1)
	OR R16, R17
	OUT @0, R16
.ENDMACRO
;---------------------------------------------------------------------------------------------------
.MACRO CLEARBIT
	;@0 port
	;@1 pin number
	;This will set the @1 bit of port @0 to 1
	;Uses R16, R17
	IN R16, @0
	LDI R17, (1<<@1)
	COM R17
	AND R16, R17
	OUT @0, R16
.ENDMACRO
;---------------------------------------------------------------------------------------------------
.macro TOGGLE_PORT_BIT 
	;This toggles the @1 on port @0
	;Uses R16, R17
	IN R16, @0
	LDI R17, (1<<@1)
	EOR R16, R17
	OUT @0, R16
.endmacro
;----------------------------------------------------------------------------------------------------
.MACRO REGISTER_TO_RAMD
	;This will store the contents of register @0 in the ram 
	;addressed by @1 + contents of @2
	;@0 gpr holding value
	;@1 address of base of indexed memory
	;@2 register holding index of value to be stored
	;Uses R16, R17, R26, R27
	LDI XL, LOW(@1)
	LDI XH, HIGH(@1)
	MOV R16, @2
	CLR R17
	ADD XL, R16
	ADC XH, R17
	ST X, @0
.ENDMACRO 
;----------------------------------------------------------------------------------------------------
.MACRO REGISTER_TO_RAM
	;This will store the contents of register @0 in the ram 
	;addressed by  @1 + @2
	;@0 gpr holding value
	;@1 address of base of indexed memory
	;@2 index of value to be stored
	;Uses R16, R17, R26, R27
	LDI XL, LOW(@1)
	LDI XH, HIGH(@1)
	LDI R16, @2
	CLR R17
	ADD XL, R16
	ADC XH, R17
	ST X, @0
.ENDMACRO 
;----------------------------------------------------------------------------------------------------
.MACRO RAM_TO_REGISTER
	;This will move the contents of the memory location @0 + contents of @1
	;to the register @2
	;@0 address of base of indexed memory
	;@1 gpr holding value of index
	;@2 register where value is to be stored
	;Uses R16, R17, R26, R27
	LDI XL, LOW(@0)
	LDI XH, HIGH(@0)
	MOV R16, @1
	CLR R17
	ADD XL, R16
	ADC XH, R17
	LD @2, X
.ENDMACRO
;----------------------------------------------------------------------------------------------------
 