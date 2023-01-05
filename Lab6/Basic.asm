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
	MOVLW num1
	MOVWF L1
    LOOP1:
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1, 1
	BRA LOOP1
	DECFSZ L2, 1
	BRA LOOP2
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
; ckeck botton
check_process:
   BTFSC PORTB, 0          ;if bottom is pushed skip next line
   BRA check_process
lightup:
    check1: MOVLW 0x00     ;check the number of clicking is 0 (+1)
	   CPFSEQ 0x00 
	   GOTO check2     ;the number of clicking isn't 0 (+1)
	   BTG LATD,0       ;toggle the bulb 0
	   INCF 0x00        ;increase the number of clicking
	   BCF PORTB, 0, 0  ;clear for next click
	   GOTO lastlightup 
	   
    check2: MOVLW 0x01     ;check the number of clicking is 1 (+1)
	   CPFSEQ 0x00  
	    GOTO check3    ;the number of clicking isn't 1 (+1)
	   BTG LATD, 1      ;toggle the bulb 1
	   INCF 0x00        ;increase the number of clicking
	   BCF PORTB, 0, 0  ;clear for next click
	   GOTO lastlightup
	    
   check3: MOVLW 0x02      ;check the number of clicking is 2 (+1)
	   CPFSEQ 0x00  
	    GOTO check4    ;the number of clicking isn't 2 (+1)
	   BTG LATD, 2      ;toggle the bulb 2
	   INCF 0x00        ;increase the number of clicking
	   BCF PORTB, 0, 0  ;clear for next click
	   GOTO lastlightup
	   
  check4: MOVLW 0x03       ;check the number of clicking is 3(+1)
           CPFSEQ 0x00     
	   GOTO nolight    ;the number of clicking isn't 3 (+1)
	   BTG LATD, 3      ;toggle the bulb 3
	   INCF 0x00         ;increase the number of clicking
	   BCF PORTB, 0, 0   ;clear for next click
	   GOTO lastlightup
   nolight:       
	    BTG LATD, 0 
	    BTG LATD, 1 
	    BTG LATD, 2 
	    BTG LATD, 3 
	    CLRF 0x00
    lastlightup:
	DELAY d'200', d'180' ;delay 0.25s
	BRA check_process
end
