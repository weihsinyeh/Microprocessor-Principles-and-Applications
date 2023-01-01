LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
INITIAL:
    FirstAdrress EQU 0x00
    SecondAddress EQU 0x10
    AnsAddress EQU 0x20
    FirstCounter EQU 0x05
    SecondCounter EQU 0x15
    AnsCounter EQU 0x2A
    MOVLW 0x05
    MOVWF FirstCounter
    MOVWF SecondCounter
    MOVLW 0x0A
    MOVWF AnsCounter
    GOTO START
    
LIST_INIT macro addr,n1,n2,n3,n4,n5
    LFSR 0,addr
    MOVLW n1
    MOVWF POSTINC0
    MOVLW n2
    MOVWF POSTINC0
    MOVLW n3
    MOVWF POSTINC0
    MOVLW n4
    MOVWF POSTINC0
    MOVLW n5
    MOVWF POSTINC0
    endm

MERGE_LIST:
    LFSR 0,FirstAdrress
    LFSR 1,SecondAddress
    LFSR 2,AnsAddress
    GOTO LOOP
    MOVEFIRST:
	MOVFF POSTINC0,POSTINC2
	DECF FirstCounter
	GOTO LOOP
    MOVESECOND:
	MOVFF POSTINC1,POSTINC2
	 DECF SecondCounter
	GOTO LOOP
    return
    LOOP:
	MOVF AnsCounter
	BTFSC STATUS,Z
	    return
	MOVF FirstCounter
	BTFSC STATUS,Z
	    rcall MOVESECOND
	MOVF SecondCounter
	BTFSC STATUS,Z
	    rcall MOVEFIRST

	MOVFF INDF0,WREG
	SUBWF INDF1,WREG
	BTFSS STATUS,C ;File > WREG
	    GOTO MOVESECOND
	MOVF WREG
	BTFSC STATUS,C
	    GOTO MOVEFIRST
    return
START:
    LIST_INIT FirstAdrress,0x1, 0x3, 0x6, 0xB, 0xF
    LIST_INIT SecondAddress,0x3, 0x5, 0xC, 0x10,0xBA
    rcall MERGE_LIST
    NOP
end


