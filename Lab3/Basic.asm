LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
initial:
    CLRF 0x00
    CLRF 0x01
    CLRF 0x02
    CLRF 0x03
    CLRF 0x10
    CLRF 0x11
    CLRF 0x12
    CLRF 0x13
    CLRF 0x20
    CLRF 0x21
    CLRF 0x22
    CLRF 0x23
    CLRF 0x24 ; ??
    
start:
    MOVLW 0x10  ;?0x10??WREG?
    MOVWF 0x00  ;?WREG?????0x000?
    MOVLW 0x11  ;?0x11??WREG?
    MOVWF 0x01  ;?WREG?????0x001?
    MOVLW 0x12  ;?0x12??WREG?
    MOVWF 0x02  ;?WREG?????0x002?
    MOVLW 0xFF  ;?0xFF??WREG?
    MOVWF 0x03  ;?WREG?????0x003?
    
    MOVLW 0x20  ;?0x20??WREG?
    MOVWF 0x10  ;?WREG?????0x010?
    MOVLW 0x21  ;?0x21??WREG?
    MOVWF 0x11  ;?WREG?????0x011?
    MOVLW 0x22  ;?0x22??WREG?
    MOVWF 0x12  ;?WREG?????0x012?
    MOVLW 0xFF  ;?0xFF??WREG?
    MOVWF 0x13  ;?WREG?????0x013?
    
    LFSR 0, 0x003 ; pointer 0??[0x003]
    LFSR 1, 0x013 ; pointer 1??[0x013]
    LFSR 2, 0x023 ; pointer 2??[0x023]
add:
    loop:
	MOVF POSTDEC0,0,0
	ADDWF INDF2
	MOVF POSTDEC1,0,0
	ADDWF POSTDEC2
	BTFSC STATUS,C
	    INCF INDF2   ;???carry pointer 2??????????
	INCF 0x24;
	MOVLW 0x04;    ;??4?????32bits????8bits???4?
	CPFSLT 0x24      
	    GOTO endbasic
	GOTO loop
endbasic:    
end
;??? (70%):
;????:????? 32bits ?????
;?????: ??????????
;101112FF??????? 202122FF???????????
;???
;????:
;???????? 32bits ???????? 0X000~0X003
;? 0X010~0X013 ??????? 0X020~0X023?
;?????????
;???? ADDWFC ????????????
