LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
INITIAL:
    FIRST EQU 0x00
    FACTOR EQU 0x01
    SUM EQU 0x02
    COUNTER EQU 0x10
    CURRENT_INDEX EQU 0x11
    CLRF SUM
    GOTO START
GP:
    LOOP:
    MOVFF CURRENT_INDEX,WREG
    ADDWF SUM,F
    MOVFF FACTOR,WREG
    MULWF CURRENT_INDEX
    MOVFF PRODL, CURRENT_INDEX
    DECF COUNTER
    MOVLW 0x00
    CPFSEQ COUNTER
	GOTO LOOP
    return
    
START:
    MOVLW 0x02
    MOVWF FIRST
    MOVWF CURRENT_INDEX
    MOVLW 0x03
    MOVWF FACTOR
    MOVLW 0x03
    MOVWF COUNTER
    
    rcall GP
    NOP
end