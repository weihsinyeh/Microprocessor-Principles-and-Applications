LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
INITIAL:
    HighByte EQU 0x001
    LowByte EQU 0x002
    HighByteTemp EQU 0x031
    LowByteTemp EQU 0x032
    NN EQU 0x000
    COUNTER EQU 0x003
    COUNTERTEMP EQU 0x004
    MOVLW 0x01
    MOVWF LowByte
    MOVLW 0x02
    MOVWF COUNTER
    CLRF HighByte
    GOTO START
unsigned_16_add macro oper1_H,oper1_L,oper2_H,oper2_L
    MOVFF oper2_H,WREG
    ADDWF oper1_H,F
    MOVFF oper2_L,WREG
    ADDWF oper1_L,F
    BTFSC STATUS,C
	INCF oper1_H
 endm
fac:
    LOOP:
	MOVFF COUNTER,COUNTERTEMP
	MOVFF HighByte,HighByteTemp
	MOVFF LowByte,LowByteTemp
	LOOP2:
	    DECF COUNTERTEMP
	    BZ check
	    unsigned_16_add HighByte,LowByte,HighByteTemp,LowByteTemp
	    GOTO LOOP2  
    check:
	INCF COUNTER
	MOVFF COUNTER,WREG
	SUBWF NN,WREG
	BC LOOP 
	return
START:
    MOVLW 0x07
    MOVWF NN
    rcall fac
    NOP
end


