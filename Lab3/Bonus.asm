LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00

initial:
    CLRF 0x000
    CLRF 0x001  
    
    CLRF 0x010          ;?????????
    CLRF 0x011          ;?????????
    CLRF 0x012          ;?????????
    CLRF 0x013          ;?????????
    CLRF 0x014          ;????
    CLRF 0x015          ;???
    CLRF 0x016          ;????
start:
    MOVLW 0xF5        ;245
    MOVWF 0x010       ;?245??[0x010]
    MOVWF 0x012       ;?245??[0x012]
    MOVLW 0x5A        ;90
    MOVWF 0x011       ;?90 ??[0x011]
    MOVWF 0x013       ;?90 ??[0x013]
    GOTO Operate
Divisor:
    Loop:
	MOVF 0x015,W  ;??????
	SUBWF 0x014,F ;???????
	CPFSLT 0x14    ;file[0x014] < wreg[0x015] ????? ?31????
	    GOTO Loop  
	;??????????????0x015 ??????0x014
	MOVF 0x015,W  ;[0X016] = TEMP = [0X015]
	MOVWF 0x016
	MOVF 0x014,W  ;[0X015] = [0X014]
	MOVWF 0x015
	MOVF 0x016,W  ;[0X014] = TEMP = [0x016]
	MOVWF 0x014 
	MOVLW 0x00   ;????0x00???
	CPFSEQ 0x015
	    GOTO Loop
	GOTO Next
Calculate: ;???????
    CLRF 0x016             ;?[0x013]?[0x014]??????????????[0x012]??????????
    DividGCF:               ;[0x02]???????
	MOVF 0x014,W      ;???????[0x014]??WREG
	SUBWF 0x013,F     ;?[0x013] - ?????
	INCF 0x016         ;???
	MOVLW 0x00       ;????
	CPFSEQ 0x013
	    GOTO DividGCF ;???????????
        MOVF 0x012,W      ;?[0x012] ??? 245 ??[0x013] ???0x001
	MOVWF 0x013
	MOVWF 0x001      ;?????????F5?????????
	DECF 0x016         
	GOTO Multiply     ;????????????
    Carry:                  ;??????????bit????
	INCF 0x000        
	DECF 0x016        ;????????[0x016]???
	MOVLW 0x00
	CPFSEQ 0x016
	    GOTO Multiply
	GOTO EndBonus    ;??????71?????
    Multiply:
	MOVF 0x013,W   ;[0x013]??WREG??????245
	ADDWF 0x001,F  ;??[0x001]? 
	BC Carry         ; branch if carry ???
	DECF 0x016       ;????????[0x016]???
	MOVLW 0x00      
	CPFSEQ 0x016     ;??????????
	    GOTO Multiply
	GOTO EndBonus    ;??????71?????
    
	
Operate:
;????????????
    MOVF 0x012,W  ;???[0x012]?245?????WREG
    CPFSGT 0x013   ;?????[0x013]?90???
	GOTO Bigb ;?? file < WREG 
    Biga ;0x013 > 0x012 ?? file > WREG 
	MOVF 0x013,W 
	MOVWF 0x014 
	MOVF 0x012,W
	MOVWF 0x015
	GOTO Divisor
    Bigb ;0x012 > 0x013 ?? file <= WREG 
	MOVF 0x012,W ;???(245)?????[0X014]
	MOVWF 0x014 
	MOVF 0x013,W ;???(90)?????[0X013]
	MOVWF 0x015
	GOTO Divisor ;??????
Next: ;[0x014]??????
    GOTO Calculate   ;??????????[0x014]
EndBonus:
end
;??? (20%):
;????:???? unsigned 8-bit ???? A, B?????
;? 0X010 ? 0X011??????????????????
;8bits ?? 16bits ??????? 0X000 ? 0X001?
;?????: 0XF5 ? 0X5A ??????? 0X113A???
;0X11 ?? 0X000?0X3A ?? 0X001?
;????:????????
;??:????????????????????????
;?????
;??
;????????
;?????????????????
;?????????????????????????????