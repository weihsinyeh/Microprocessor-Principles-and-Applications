LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67
	CONFIG WDT = OFF
	org 0x00
    rcall main

;?literal ?? file register
MOVLF macro literal , F 
    MOVLW literal
    MOVWF F
endm

;?WREG ???? File register ??????
NEGLF macro  F
    MOVWF F
    NEGF F
endm
;?(x1-x2)^2 ? (y1-y2)^2?? ?high byte ? low byte ???? address 0x00 0x01 
SQRT macro address
    MOVF 0x03,WREG   ;?file register 0x03 ??(?????????)?? working register
    NEGLF 0x20         ;? (?????????)???????0x20 
    NEGLF 0x21         ;? (?????????)???????0x21 ????????????????
    
    ;??sign?????
    MOVF 0x21, WREG  ;?0x21?????WREG
    MULWF 0x20, WREG ;?0x21???0x20??????WREG
    
    ;????????????
    MOVF 0x21, WREG  ;?0x21??(op2)??WREG? WREG = [0x21]
    BTFSC 0x20, 7     ;??op1 < 0
	SUBWF PRODH  ;? PRODH - [0x21]
	
    MOVF 0x20, WREG  ;?0x20??(op1)??WREG? WREG = [0x20]
    BTFSC 0x21, 7     ;??op2 < 0
	SUBWF PRODH   ;? PRODH - [0x20]

    ;??????????? 0x00 ? 0x01
    MOVF PRODL,W
    ADDWF 0x01
    BTFSC STATUS,C ;??(x1-x2)^2 + (y1-y2)^2?????? 0x00
	INCF 0x00
    MOVF PRODH,W
    ADDWF 0x00
endm
    
DIST macro x1,y1,x2,y2,F1,F2
    MOVLF x1,0x03  ;?x1 ???? file register 0x03
    MOVLW x2    ;?x2??WREG
    SUBWF 0x03   ;?0x03 - WREG == 0x05 - 0x02 (?????????)
    SQRT 0x03      ; (0x05 - 0x02) ^ 2
    MOVLF y1,0x03  ;?y1 ???? file register 0x03
    MOVLW y2    ;?y2??WREG
    SUBWF 0x03   ;?0x03 - WREG == 0x07 - 0x03
    SQRT 0x03      ; (0x07 - 0x03) ^ 2
endm
 
;?????file register ?0x00 ? 0x01
main:
    CLRF 0x00 ;??
    CLRF 0x01 ;??
    DIST 0x12, 0x15, 0x02, 0x05, 0x00, 0x01 ;? macro
end


