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
CLRF PORTB   
BSF TRISB, 0 ;set portB bit 0 is input
CLRF LATD    ;clear LED in Port D
;set port D bit 0,1,2,3 to output，and clear
BCF TRISD, 0 
BCF TRISD, 1   
BCF TRISD, 2 
BCF TRISD, 3 
BCF PORTB, 0 ;bottom is not clicked
CLRF 0x00    ;record the the number of click
; ckeck button
check_process:
   BTFSC PORTB, 0  ;if bottom is pushed skip next line
   BRA check_process
   test0: 
	MOVLW 0x00 ;check the number of clicking is 0 (+1)
	CPFSEQ 0x00 
	GOTO test1  ;the number of clicking isn't 0 (+1)
	GOTO check1
   
   test1: 
	MOVLW 0x01 ;check the number of clicking is 1 (+1)
	CPFSEQ 0x00
	GOTO test2  ;the number of clicking isn't 1 (+1)
	GOTO check2
   
   test2: 
	MOVLW 0x02 ;check the number of clicking is 2 (+1)
	CPFSEQ 0x00
	GOTO test3  ;the number of clicking isn't 2 (+1)
	GOTO check3
   
   test3: 
	MOVLW 0x03 ;check the number of clicking is 3 (+1)
	CPFSEQ 0x00
	GOTO test0  ;the number of clicking isn't 3 (+1)
	GOTO check4
lightup:
    check1: 
	BCF PORTB, 0, 0 ; clear portB
	BSF LATD, 0
	BSF LATD, 1
	BCF LATD, 2
	BCF LATD, 3
	DELAY d'200', d'180' ;delay 0.25s
	MOVLW 0x01
	CPFSEQ 0x00
	    GOTO check2    ;the number of clicking isn't 1 (+1)
	GOTO nolight 
    check2: 
	BCF PORTB, 0, 0 ; clear portB
	BCF LATD, 0
	BSF LATD, 1
	BSF LATD, 2
	BCF LATD, 3
	DELAY d'200', d'180' ;delay 0.25s
	MOVLW 0x02
	CPFSEQ 0x00
	    GOTO check3   ;the number of clicking isn't 2 (+1)
	GOTO nolight 
	    
   check3: 
	BCF PORTB, 0, 0 ; clear portB
	BCF LATD, 0
	BCF LATD, 1
	BSF LATD, 2
	BSF LATD, 3
	DELAY d'200', d'180' ;delay 0.25s
	MOVLW 0x03
	CPFSEQ 0x00
	    GOTO check4  ;the number of clicking isn't 3 (+1)
	GOTO nolight
	   
  check4: 
	BCF PORTB, 0, 0 ; clear portB
	BSF LATD, 0
	BCF LATD, 1
	BCF LATD, 2
	BSF LATD, 3
	DELAY d'200', d'180' ;delay 0.25s
	MOVLW 0x00
	CPFSEQ 0x00
	    GOTO check1 ;the number of clicking isn't 0 (+1)
	GOTO nolight 
   nolight:
	BCF PORTB, 0, 0 ; clear portB    
	CLRF LATD
	INCF 0x00
	BCF PORTB, 0, 0 ; clear bottom click for next click event
	MOVLW 0x04
	CPFSEQ 0x00
	   GOTO check_process
	CLRF 0x00       ; if the number of click is up to four than next will be zero
	GOTO check_process
	
    lastlightup:
	DELAY d'200', d'45' ;delay 0.25s
	BRA check_process
end


