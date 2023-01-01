LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
INTIAL:
    FIRST EQU 0x010
    FIRSTTEMP EQU 0x020
    SECOND EQU 0x011
    SECONDTEMP EQU 0x021
    MOVLW 0xF5
    MOVWF FIRST
    MOVWF FIRSTTEMP
    MOVLW 0x5A
    MOVWF SECOND
    MOVWF SECONDTEMP
    GOTO START
; Find GDC
SWAP:
    MOVFF FIRSTTEMP,WREG
    MOVFF SECONDTEMP,FIRSTTEMP
    MOVFF WREG,SECONDTEMP
    GOTO LOOP
GDC:
    MOVFF SECONDTEMP,WREG 
    SUBWF FIRSTTEMP,WREG
    BNC SWAP
LOOP:
    MOVFF SECONDTEMP,WREG
    SUBWF FIRSTTEMP,WREG
    BNC CHECK
    MOVFF WREG,FIRSTTEMP
    GOTO LOOP
CHECK:
    MOVFF FIRSTTEMP,WREG
    MOVFF SECONDTEMP,FIRSTTEMP
    MOVFF WREG,SECONDTEMP
    MOVF SECONDTEMP
    BZ CONTINUE
    GOTO GDC
; Find GDC
DIVIDE:
    MOVFF FIRSTTEMP,WREG
    SUBWF SECOND
    INCF 0x012
    MOVF SECOND
    BNZ DIVIDE
    MOVFF 0x012,0x011
    GOTO MUL
START:
    GOTO GDC
CONTINUE:
    GOTO DIVIDE
MUL:
    MOVF SECOND
    BZ ENDBOUNUS
    DECF SECOND
    MOVFF FIRST,WREG
    ADDWF 0x01
    BNC MUL
    INCF 0x00
    GOTO MUL
ENDBOUNUS:
    GOTO ENDBOUNUS
end


