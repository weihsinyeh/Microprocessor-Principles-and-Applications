LIST p=18f4520
    #include<p18f4520.inc>
	CONFIG OSC = INTIO67 ; 1 MHZ
	CONFIG WDT = OFF
	CONFIG LVP = OFF
	
	L1	EQU 0x14
	L2	EQU 0x15
	org 0x00
	
; Total 2 + (2 + 7 * num1 + 2) * num2 cycles = C
; num1 = 200, num2 = 180, C = 252360
; Total delay ~= C/1M = 0.25s
DELAY macro num1, num2 
    local LOOP1 
    local LOOP2
    MOVLW num2
    MOVWF L2
    LOOP2:
	MOVLW num1 ;1
	MOVWF L1   ;1
    LOOP1:
	NOP          ;1
	NOP          ;1
	NOP          ;1
	NOP          ;1
	NOP          ;1
	NOP          ;1
	DECFSZ L1, 1 ;1  == 7
	BRA LOOP1    ;2
	DECFSZ L2, 1  ;1
	BRA LOOP2     ;1
endm

	
start:
int:
; let pin can receive digital signal 
MOVLW 0x0f
MOVWF ADCON1
CLRF PORTB   ;?port B??
BSF TRISB, 0 ;?port B???0
CLRF LATA    ;port A ??0
BCF TRISA, 0 ;?port A?bit 0 ??output???clear
BCF TRISA, 1 ;?port A?bit 1 ??output???clear     
BCF TRISA, 2 ;?port A?bit 2 ??output???clear  
BCF TRISA, 3 ;?port A?bit 3 ??output???clear
BCF PORTB, 0 ;????
CLRF 0x00
; ckeck button
check_process:
   BTFSC PORTB, 0 ;??port B ???0
   BRA check_process
   test0: MOVLW 0x00
   CPFSEQ 0x00 
	GOTO test1
   GOTO check1
   
   test1: MOVLW 0x01 ;0x01 0x02 0x03
   CPFSEQ 0x00
	GOTO test2
   GOTO check2
   
   test2: MOVLW 0x02 ;0x02 0x03
   CPFSEQ 0x00
	GOTO test3
   GOTO check3
   
   test3: MOVLW 0x03
   CPFSEQ 0x00
	GOTO test0
   GOTO check4
lightup:
    check1: 
	   BCF PORTB, 0, 0 ;?port B ????????????????
	   BSF LATA, 0
	   BSF LATA, 1
	   BCF LATA, 2
	   BCF LATA, 3
	   DELAY d'50', d'180' ;delay 0.25s
	   MOVLW 0x01
	   CPFSEQ 0x00
		GOTO check2 ;??? ;0x00 ;0x02 ; ;0x03
	   GOTO nolight ;??
    check2: 
	    BCF PORTB, 0, 0 ;?port B ????????????????
	   BCF LATA, 0
	   BSF LATA, 1
	   BSF LATA, 2
	   BCF LATA, 3
	   DELAY d'50', d'180' ;delay 0.25s
	   MOVLW 0x02
	   CPFSEQ 0x00
		GOTO check3 ; ???
	   GOTO nolight ;??
	    
   check3: 
	    BCF PORTB, 0, 0 ;?port B ????????????????
	   BCF LATA, 0
	   BCF LATA, 1
	   BSF LATA, 2
	   BSF LATA, 3
	   DELAY d'50', d'180' ;delay 0.25s
	   MOVLW 0x03
	   CPFSEQ 0x00
		GOTO check4
	   GOTO nolight
	   
  check4: 
	BCF PORTB, 0, 0 ;?port B ????????????????
	   BSF LATA, 0
	   BCF LATA, 1
	   BCF LATA, 2
	   BSF LATA, 3
	   DELAY d'50', d'180' ;delay 0.25s
	   MOVLW 0x00
	   CPFSEQ 0x00
		GOTO check1 ;???
	   GOTO nolight ;??
   nolight:
	    BCF PORTB, 0, 0 ;?port B ????????????????
            
	    CLRF LATA
	    INCF 0x00
	    BCF PORTB, 0, 0 ;?port B ????????????????
	    MOVLW 0x04
	    CPFSEQ 0x00
		   GOTO check_process
	    CLRF 0x00
	    GOTO check_process
    lastlightup:
	DELAY d'50', d'45' ;delay 0.25s
	BRA check_process
end


