LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
Start:
    CLRF 0x00  
    CLRF 0x01
    CLRF 0x02
    CLRF 0x03
    CLRF 0x04
    
    ;??0x00 ? 0x01
    MOVLW b'00001111'   
    MOVWF 0x00          ;?b'00001111'??0x00
    MOVLW b'00110011'
    MOVWF 0x01          ;?b'00110011'??0x01
    
    ; A inclusive or B
    MOVF 0x00,0,W        ;?b'00001111'?0x00??WREG
    IORWF 0x01,W         ;?0x01 ? 00110011 ??inclusive or ?? 00111111 
    MOVWF 0x03          ;?WREG? 00111111 ??register 0x003
    
    ; A and B
    MOVF 0x00,0,0        ;??b'00001111'?0x00??WREG
    ANDWF 0x01,0,W      ;?0x01 ? 00110011 ??and ?? 00000011 
    MOVWF 0x04          ;?WREG? 00000011  ??register 0x004
    
    ; ! (A and B)
    COMF 0x04,w          ;?WREG? 00000011  1?? 11111100
    
    ; (A inclusive or B) AND !(A AND B)  = A XOR B
    ANDWF 0x03,0,W      ;?WREG? 11111100  ??? 0x003 ?00111111 and ??WREG
    MOVWF 0x02          ;?WREG????0x02
    end
    
    
    ; ????? ???ANDWF?IORWF?COMF?????????
    ;[0x000]?[0x001]?????XOR(exclusive or)???????
    ;??????[0x002]???????????XORWF???
    
    ; A | B | A inclusive or B        A | B | A AND B      A | B | ! (A AND B)     A | B | (A inclusive or B) AND !(A AND B)  
    ; 0 | 0 | 0                       0 | 0 | 0            0 | 0 | 1               0 | 0 | 0
    ; 0 | 1 | 1                       0 | 1 | 0            0 | 1 | 1               0 | 1 | 1
    ; 1 | 0 | 1                       1 | 0 | 0            1 | 0 | 1               1 | 0 | 1
    ; 1 | 1 | 1                       1 | 1 | 1            1 | 1 | 0               1 | 1 | 0
    
    ; A | B | A XOR B
    ; 0 | 0 | 0
    ; 0 | 1 | 1
    ; 1 | 0 | 1
    ; 1 | 1 | 0
    
 
    
    


