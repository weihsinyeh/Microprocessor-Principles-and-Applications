LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
INITIAL:
    ANS EQU 0x000
    COUNTER EQU 0x001
    GOTO START
Hanoitower:
    MOVLW 0x01
    CPFSGT COUNTER
	INCF ANS
    MOVLW 0x01
    CPFSGT COUNTER
	return

    DECF COUNTER
	rcall Hanoitower
    INCF ANS
	rcall Hanoitower
    INCF COUNTER
    return
START:
    MOVLW 4
    MOVWF COUNTER
    rcall Hanoitower
    NOP
	end


