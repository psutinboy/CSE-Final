;setup timer1

;initial value for timer/counter
LDI R16, LOW(initial_timer_value)   
STS TCNT1L, R16
LDI R16, HIGH(initial_timer_value)	
STS TCNT1H, R16
;set mode
LDI R16, normal_timer_mode
STS TCCR1A, R16
;set internal clock/prescaler
LDI R16, very_fast_timer			;can be adjusted; very_slow_timer, slow_timer, medium_timer, fast_timer, very_fast_timer
STS TCCR1B, R16
;enable overflow interrupt
LDI R16, enable_timer_interrupt
STS TIMSK1, R16
SEI								;set the global interrupt flag 
;---------------------------------------------------------------------------