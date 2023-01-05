#include "p18f4520.inc"

; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
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
sec EQU D'244'
halfsec EQU D'122'
goto Initial			    
ISR:				
    org 0x08                ; every 0.5 second will enter interrupt
    CLRF LATD               ; interrupt will turn off LATA
    INCF 0x01
test: MOVLW 0x04
    CPFSEQ 0x01
	GOTO NOTchange
change:
    BTFSC 0x00 , 0     
	MOVFF 0x11,PR2 ;1 second
    BTFSS 0x00 , 0  
	MOVFF 0x10,PR2 ;0.5 second
    BTG 0x00,0
    CLRF 0x01
NOTchange:
    BTG 0x02 , 0
    BCF PIR1, TMR2IF        ; before leabing clear TMR2IF flag bit
    RETFIE
    
Initial:			
    MOVLW 0x0F
    MOVWF ADCON1
    CLRF TRISD
    CLRF LATD
    
    BSF RCON, IPEN
    BSF INTCON, GIE
    BCF PIR1, TMR2IF		; to use TIMER2,set TMR2IF?TMR2IE?TMR2IP
    BSF IPR1, TMR2IP
    BSF PIE1 , TMR2IE
    MOVLW b'11111111'	        ; ?Prescale?Postscale???1:16???????256??????TIMER2+1
    MOVWF T2CON		; ???TIMER?????????/4????????
    MOVLW D'122'		; ???256 * 4 = 1024?cycles???TIMER2 + 1
    MOVWF PR2			; ??????250khz???Delay 0.5?????????125000cycles??????Interrupt
				; ??PR2??? 125000 / 1024 = 122.0703125? ???122?
    MOVLW D'00100000'
    MOVWF OSCCON	        ; ??????????250kHz
    CLRF 0x00                  ; ????run?????0
    CLRF 0x01                  ; ???run ?????
    MOVLW 0x01
    MOVWF 0x02                  ; need to set;
    MOVLW halfsec
    MOVWF 0x10
    MOVLW sec
    MOVWF 0x11
main:
    MOVF 0x02                 ; if need to set got to set
    BZ main
    BTG 0x02 ,0
zero: MOVLW 0x00
    CPFSEQ 0x01
	GOTO one
    BSF LATD,0
    GOTO main
one: MOVLW 0x01
    CPFSEQ 0x01
	GOTO two
    BSF LATD,1 
    GOTO main
two: MOVLW 0x02
    CPFSEQ 0x01
	GOTO three
    BSF LATD,2
    GOTO main
three:MOVLW 0x03
    BSF LATD,3
    GOTO main
    
end



