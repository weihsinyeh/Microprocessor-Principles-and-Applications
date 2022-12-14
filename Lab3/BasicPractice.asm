LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
INITIAL:
    MOVLW 0x10
    MOVWF 0x000
    MOVLW 0x11
    MOVWF 0x001
    MOVLW 0x12
    MOVWF 0x002
    MOVLW 0xFF
    MOVWF 0x003
    MOVLW 0x20
    MOVWF 0x010
    MOVLW 0x21
    MOVWF 0x011
    MOVLW 0x22
    MOVWF 0x012
    MOVLW 0xFF
    MOVWF 0x013
    COUNTER EQU 0x30
    MOVLW 0x04
    MOVWF COUNTER
    LFSR 0, 0x003
    LFSR 1, 0x013
    LFSR 2, 0x023
START:
    MOVFF POSTDEC0,WREG
    ADDWF INDF2,F
    MOVFF POSTDEC1,WREG
    ADDWF POSTDEC2,F
    BTFSC STATUS,C
	INCF INDF2
    DECF COUNTER
    BNZ START
ENDBASIC:
    GOTO ENDBASIC
end


