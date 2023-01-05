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

sec EQU D'61'
hsec EQU D'61'
hhsec EQU D'30'
SECVALUE EQU 0x10
HSECVALUE EQU 0x11
HHSECVALUE EQU 0x12
HIGHINT EQU 0x20
LOWINT EQU 0x21
    org 0x00
goto Initial	
 
;HIGH PRIORITY INTERRUPT ADDRESS VECTOR				
    org 0x08                
    MOVLW 0x01
    MOVWF 0x20 ; HIGHINT
    BCF INTCON, INT0IF
    BCF PIR1, TMR2IF 
    RETFIE
;LOW PRIORITY INTERRUPT ADDRESS VECTOR
    org 0x18
    MOVLW 0x01
    MOVWF 0x21 ; LOWINT
    BCF PIR1, TMR2IF 
    RETFIE
    
Initial:	
    org 0x100
    MOVLW 0x0F
    MOVWF ADCON1
    CLRF TRISD
    CLRF LATD
    
    BSF RCON, IPEN             ; enable priority interrupt  開始接收不一樣優先權的interrupt
    BSF INTCON, GIEH           ; enable global high interrupt
    BSF INTCON, GIEL           ; enable global low interrupt
    
    BSF TRISB, 0               ; B is input
    BSF INTCON, INT0IE         ; enable external interrupt int0
    BCF INTCON, INT0IF        
    
    BSF PIE1 , TMR2IE          ; enable timer2
    BCF PIR1, TMR2IF		; 為了使用TIMER2，所以要設定好相關的TMR2IF、TMR2IE、TMR2IP。
    BCF IPR1, TMR2IP

    MOVLW b'11111111'	        ; 將Prescale與Postscale都設為1:16，意思是之後每256個週期才會將TIMER2+1
    MOVWF T2CON		; 而由於TIMER本身會是以系統時脈/4所得到的時脈為主
    MOVLW D'244'		; 因此每256 * 4 = 1024個cycles才會將TIMER2 + 1
    MOVWF PR2			; 若目前時脈為250khz，想要Delay 0.5秒的話，代表每經過125000cycles需要觸發一次Interrupt
				; 因此PR2應設為 125000 / 1024 = 122.0703125， 約等於122。
    MOVLW D'00100000'
    MOVWF OSCCON	        ; 記得將系統時脈調整成250kHz
    
    MOVFF sec,SECVALUE
    MOVFF hsec,HSECVALUE
    MOVFF hhsec,HHSECVALUE
    CLRF HIGHINT
    CLRF LOWINT
    
    CLRF 0x00 ; if 0 : increase , 1 : decrease
    MOVLW 0x01
    MOVWF 0x01 ; 紀錄現在要亮哪個燈泡
    BSF 0x02,1 ; set
    CLRF 0x03 ; 紀錄現在的時間 0 : 1s || 1 : 0.5s || 2 : 0.25s
main:
    MOVF HIGHINT
    BNZ HIGH_INT_ISR
    MOVF LOWINT
    BNZ LOW_INT_ISR
    
    MOVF 0x02	; check if need to set bulb
    BZ main
    CLRF 0x02 
    MOVFF 0x01,LATD
    GOTO main

;SERVICE ROUTINE FOR HIGH PRIORITY    
HIGH_INT_ISR:
    CLRF HIGHINT
timezero:
    MOVLW 0x00
    CPFSEQ 0x03
	GOTO timeone
    MOVLW D'122'
    MOVWF PR2
    GOTO setbulb
timeone: 
    MOVLW 0x01
    CPFSEQ 0x03
	GOTO timetwo
    MOVLW D'61'
    MOVWF PR2
    GOTO setbulb
timetwo: 
    MOVLW D'244'
    MOVWF PR2
setbulb:
    BTG 0x00,0    
    
;SERVICE ROUTINE FOR LOW PRIORITY 
LOW_INT_ISR:
    CLRF LOWINT
    BSF 0x02,1 ; set bulb
    BTFSS 0x00,0
	GOTO increase ; 0
decrease: ;1
    BCF STATUS,C
    RRCF 0x01
    BNC main
    BSF 0x01,3
    GOTO main
increase:
    RLNCF 0x01
    BTFSS 0x01 ,4
	GOTO main
    CLRF 0x01
    BSF 0x01,0
    GOTO main
end



