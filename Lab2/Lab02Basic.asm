LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
initial:
    CLRF 0xFF
    MOVLB 1
    CLRF 0x101
    CLRF 0x102
    CLRF 0x103
    CLRF 0x104
    CLRF 0x105
    CLRF 0x106
    CLRF 0x107
    CLRF 0x108
start:
    MOVLB 1      ; select bank 1
    MOVLW 0x01  ; WREG = 0x01
    MOVWF 0x100 ; [0x100] = 0x01
    MOVLW 0x01  ; WREG = 0x01
    MOVWF 0x101 ; [0x100] = 0x01
    LFSR 0, 0x100 ; pointer 0??[0x100]
    LFSR 1, 0x101 ; pointer 1??[0x101]
    LFSR 2, 0x102 ; pointer 2??[0x102]
    GOTO loop
loop:
    MOVLB 1
    MOVF POSTINC0,0,0  ;?pointer 0 ???????WREG????pointer 0 ???????????
    MOVWF INDF2       ;?working register ???? pointer2?????
    MOVF POSTINC1,0,0  ;?pointer 1 ???????WREG????pointer 1 ???????????
    ADDWF POSTINC2     ;?working register ???? pointer2????????pointer2???????????
    
    MOVLB 0
    INCF 0xFF            ;??????????
    MOVLW 0x07
    CPFSEQ 0xFF          ;?????????7?????????loop
	GOTO loop
    GOTO endbasic       ;??????7
endbasic
end 

;? ? ? ? ?
;?? Data Memory ?? 0x100 ?? 0x01??? Data Memory ?? 0x101
;?? 0x01??????????? indirect addressing register?? Data 
;Memory ?? 0x102~0x108 ??????????????
    
;Data Memory ?? 0x100~0x108 ?????? 0x01, 0x01, 0x02, 0x03, 
;0x05, 0x08, 0x0D, 0x15, 0x22?
;2. ?????? indirect addressing register?
