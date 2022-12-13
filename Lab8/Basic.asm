; PIC18F4520 Configuration Bit Settings

; Assembly source line config statements

#include "p18f4520.inc"

; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = ON            ; Brown-out Reset Enable bits (Brown-out Reset enabled and controlled by software (SBOREN is enabled))
  CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)


org 0x00
delay macro num1,num2
    local loop1
    local loop2
    movlw num2
    movwf 0x10
  loop2:
    movlw num1
    movwf 0x11
  loop1:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    decfsz 0x11
    goto loop1
    decfsz 0x10
    goto loop2;
endm  
    
goto Initial			
ISR:				
    org 0x08	
    BSF 0x00,0            
    BCF INTCON, INT0IF
    RETFIE                     

set0:
    MOVLW b'00000100'
    MOVWF CCPR1L
    BCF CCP1CON, DC1B1
    BCF CCP1CON, DC1B0
    return
set1:
    MOVLW 0x0b
    MOVWF CCPR1L
    BCF CCP1CON,DC1B0
    BSF CCP1CON,DC1B1
    return
set2:
    MOVLW 0x12
    MOVWF CCPR1L
    BSF CCP1CON,DC1B0
    BSF CCP1CON,DC1B1
    return
    
Initial:				
    ;RB0 to digital output
    MOVLW 0x0F               	
    MOVWF ADCON1	
    ;????
    BSF TRISB,  0
    BSF RCON, IPEN
    BCF INTCON, INT0IF		
    BSF INTCON, GIE		
    BSF INTCON, INT0IE		
    ;?????
    BSF T2CON,2  ;Timer2 -> On
    BCF T2CON,1  ;prescaler -> 4
    BSF T2CON,0
    ;Internal Oscillator Frequency, Fosc = 125 kHz, Tosc = 8 µs
    MOVLW 0x10
    MOVWF OSCCON
    ;PWM mode, P1A, P1C active-high; P1B, P1D active-high
    BSF CCP1CON, CCP1M3 
    BSF CCP1CON, CCP1M2
    BCF CCP1CON, CCP1M1
    BCF CCP1CON, CCP1M0
    ;CCP1/RC2 -> Output
    CLRF TRISC
    CLRF LATC
    ;PWM period           
    MOVLW 0x9b
    MOVWF PR2
    ;Duty cycle
    ;MOVLW b'00000100'
    ;MOVWF CCPR1L
    ;BCF CCP1CON, DC1B1
    ;BCF CCP1CON, DC1B0
    
    CLRF 0x00             
    CLRF 0x01 ; 0:-90 1:0 2:90
    INCF 0x01
    CLRF 0x02 ; 0 : ????1 : ???
    rcall set0
check:
    MOVF 0x00
    BZ check
    MOVF 0x02
    BNZ counter
    
notcounter:
    CLRF 0x00  
pos_test2:
    BTFSS 0x01, 1
	GOTO pos_test1
    BSF 0x02,0  ;???
    DECF 0x01
    rcall set2
    delay d'20', d'50'
    BRA check
pos_test1:
    INCF 0x01
    rcall set1
    delay d'20', d'50'
    BRA check
	
counter:	
    CLRF 0x00
neg_test1:
    BTFSS 0x01, 0
	GOTO neg_test0
    DECF 0x01
    rcall set1
    delay d'20', d'50'
    BRA check
neg_test0:
	INCF 0x01
	BCF 0x02,0  ;???
	rcall set0
	delay d'20', d'50'
	BRA check
end






