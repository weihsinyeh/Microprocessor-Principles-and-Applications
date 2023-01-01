LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
INTIAL:
    COUNTER EQU 0x20
    MOVLW 0x01
    MOVWF COUNTER
    TOTAL EQU 0x21
    MOVLW 0x08
    MOVWF TOTAL
    LFSR 0,0x10
    LFSR 1,0x01
    LFSR 2,0x02
    GOTO START
ADD:
    MOVFF POSTINC1,WREG
    ADDWF INDF0,F
    MOVFF POSTINC2,WREG
    ADDWF POSTINC0,F
    return
CALCULATE:
    GOTO LOOP
    one:
	LFSR 1,0x00
	GOTO LOOP
    two:
	LFSR 2,0x00
	GOTO LOOP
    LOOP:
	rcall ADD
	INCF COUNTER
	MOVFF COUNTER,WREG
	SUBWF TOTAL,WREG
	BNC FINAL
	MOVLW 0x07
	SUBWF COUNTER,WREG
	BZ two
	MOVLW 0x08
	SUBWF COUNTER,WREG
	BZ one
	GOTO LOOP
    FINAL:
	return
START:
    MOVLW 0x05 
    MOVWF 0x00
    MOVLW 0x04
    MOVWF 0x01
    MOVLW 0x02
    MOVWF 0x02
    MOVLW 0x07
    MOVWF 0x03
    MOVLW 0x08
    MOVWF 0x04
    MOVLW 0x01
    MOVWF 0x05
    MOVLW 0x02
    MOVWF 0x06
    MOVLW 0x01
    MOVWF 0x07
    rcall CALCULATE
    NOP
end

