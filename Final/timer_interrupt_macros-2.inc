;timer parameters
;needed for timer interrupt
.equ initial_timer_value=0xF000
.equ very_fast_timer=0x01
.equ fast_timer=0x02
.equ medium_timer=0x03
.equ slow_timer=0x04
.equ very_slow_timer=0x05
.equ normal_timer_mode=0x00
.equ enable_timer_interrupt=0x01
