LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00	
	GOTO main

Hanoitower:
    MOVLW 0x01  ;?0x01??WREG
    CPFSGT 0x10  ;?WREG???[0x10]??? ??????????
       INCF 0x00  ;???????????????????????????
    CPFSGT 0x10  ;???????????
       return       ;???return?????????????????
    DECF 0x10     ;?[0x10]??????????????????????????????
	rcall Hanoitower ;
    INCF 0x00     ;????????????????????
	rcall Hanoitower ;?????????????????????????
    INCF 0x10     ;???????????????
    return
main:
    CLRF 0x00  ;????
    CLRF 0x10  ;????N???
    MOVLW 0x05 ;?????N
    MOVWF 0x10 ;?????N???
    rcall Hanoitower 
    NOP
end