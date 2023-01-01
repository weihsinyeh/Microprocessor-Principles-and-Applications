LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
INITIAL:
    MOVLB 1
    MOVLW 0xa1
    MOVWF 0x00,1
    MOVLW 0xb2
    MOVWF 0x01,1
    MOVLW 0xc3
    MOVWF 0x02,1
    MOVLW 0xd4
    MOVWF 0x03,1
    MOVLW 0xe5 
    MOVWF 0x04,1
    MOVLW 0xa7
    MOVWF 0x10,1
    MOVLW 0xb3
    MOVWF 0x11,1
    MOVLW 0xc9
    MOVWF 0x12,1
    MOVLW 0xf6
    MOVWF 0x13,1
    LFSR 0, 0x100
    LFSR 1, 0x110
    LFSR 2, 0x120
    COUNTER EQU 0x130
    COUNTER1 EQU 0x131
    COUNTER2 EQU 0x132
    MOVLW 0x09
    MOVWF COUNTER,1
    MOVLW 0x05
    MOVWF COUNTER1,1
    MOVLW 0x04
    MOVWF COUNTER2,1
    GOTO START
MOVEFIRST:
    DECF COUNTER1
    DECF COUNTER
    MOVFF POSTINC0,POSTINC2
    GOTO START
MOVESECOND:
    DECF COUNTER2
    DECF COUNTER
    MOVFF POSTINC1,POSTINC2
    GOTO START
START:
    MOVF COUNTER
    BZ ENDBONUS
    
    MOVF COUNTER1
    BZ MOVESECOND
    
    MOVF COUNTER2
    BZ MOVEFIRST
    
    MOVF INDF0,0,0
    SUBWFB INDF1,WREG
    BN MOVESECOND
    GOTO MOVEFIRST
    
   ENDBONUS:
    GOTO ENDBONUS
   end
    
    


