                                                                              
;    Notes: In the MPLAB X Help, refer to the MPASM Assembler documentation    *
;    for information on assembly instructions.                                 *

;    Known Issues: This template is designed for relocatable code.  As such,   *
;    build errors such as "Directive only allowed when generating an object    *
;    file" will result when the 'Build in Absolute Mode' checkbox is selected  *
;    in the project properties.  Designing code in absolute mode is            *
;    antiquated - use relocatable mode.                                        *
;                                                                              *


;-------------------------------------------------------------------------------
; Processor Inclusion
;
; TODO Step #1 Open the task list under Window > Tasks.  Include your
; device .inc file - e.g. #include <device_name>.inc.  Available
; include files are in C:\Program Files\Microchip\MPLABX\mpasmx
; assuming the default installation path for MPLAB X.  You may manually find
; the appropriate include file for your device here and include it, or
; simply copy the include generated by the configuration bits
; generator (see Step #2).

; PROCESSOR
LIST P=PIC16F877A
#include p16F877a.inc
    
;-------------------------------------------------------------------------------
;
; TODO Step #2 - Configuration Word Setup
;
; The 'CONFIG' directive is used to embed the configuration word within the
; .asm file. MPLAB X requires users to embed their configuration words
; into source code.  See the device datasheet for additional information
; on configuration word settings.  Device configuration bits descriptions
; are in C:\Program Files\Microchip\MPLABX\mpasmx\P<device_name>.inc
; (may change depending on your MPLAB X installation directory).
;
; MPLAB X has a feature which generates configuration bits source code.  Go to
; Window > PIC Memory Views > Configuration Bits.  Configure each field as
; needed and select 'Generate Source Code to Output'.  The resulting code which
; appears in the 'Output Window' > 'Config Bits Source' tab may be copied
; below.

; CONFIG 0xFFF1
__CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF

;-------------------------------------------------------------------------------
;
; TODO Step #3 - Variable Definitions
;
; Refer to datasheet for available data memory (RAM) organization assuming
; relocatible code organization (which is an option in project
; properties > mpasm (Global Options)).  Absolute mode generally should
; be used sparingly.
;
; Example of using GPR Uninitialized Data
;
;   GPR_VAR        UDATA
;   MYVAR1         RES        1      ; User variable linker places
;   MYVAR2         RES        1      ; User variable linker places
;   MYVAR3         RES        1      ; User variable linker places
;
;   ; Example of using Access Uninitialized Data Section (when available)
;   ; The variables for the context saving in the device datasheet may need
;   ; memory reserved here.
;   INT_VAR        UDATA_ACS
;   W_TEMP         RES        1      ; w register for context saving (ACCESS)
;   STATUS_TEMP    RES        1      ; status used for context saving
;   BSR_TEMP       RES        1      ; bank select used for ISR context saving
;
;-------------------------------------------------------------------------------

; TODO PLACE VARIABLE DEFINITIONS GO HERE
UDATA          0x20
W_TEMP         RES        1      ; w register for context saving (ACCESS)
STATUS_TEMP    RES        1      ; status used for context saving
BSR_TEMP       RES        1      ; bank select used for ISR context saving
rA             RES        1   
rB             RES	  1  
;-------------------------------------------------------------------------------
; Reset Vector
;-------------------------------------------------------------------------------

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

;-------------------------------------------------------------------------------
; TODO Step #4 - Interrupt Service Routines
;
; There are a few different ways to structure interrupt routines in the 8
; bit device families.  On PIC18's the high priority and low priority
; interrupts are located at 0x0008 and 0x0018, respectively.  On PIC16's and
; lower the interrupt is at 0x0004.  Between device families there is subtle
; variation in the both the hardware supporting the ISR (for restoring
; interrupt context) as well as the software used to restore the context
; (without corrupting the STATUS bits).
;
; General formats are shown below in relocatible format.
;
;------------------------------PIC16's and below--------------------------------
;
; ISR       CODE    0x0004           ; interrupt vector location
;
;     <Search the device datasheet for 'context' and copy interrupt
;     context saving code here.  Older devices need context saving code,
;     but newer devices like the 16F#### don't need context saving code.>
;
;     RETFIE

;-------------------------------------------------------------------------------
; MAIN PROGRAM
;-------------------------------------------------------------------------------

MAIN_PROG CODE                      ; let linker place main program
START
 
;-------------------------------------------------------------------------------

DATA_REPSENTATION_AND_TRANSFER

    ; 'MOV'e 'L'iteral value to 'W'orking Register WREG (Accumulator)
    
    ; hexadecimal literal (base 16) 0x  0X  h' H' Xh 
    movlw 20    ; MPASM default !
    movlw 0x20
    movlw h'20'
    movlw 20h
    movlw 0xAF
    movlw 0xaf
    movlw h'af'
    
    ; decimal literal (base 10) .  d' D'
    movlw .32
    movlw d'32'

    ; octal literal   (base 8)  o'  O'
    movlw o'40'

    ; binary literal  (base 2)  b'  B'
    movlw b'00100000'

    ; char literal    (ASCII)   a' A' ''
    movlw a'Z'
    movlw 'Z'

    ; positive value 
    movlw 5
    movlw +5

    ; negative value (2's complement)
    movlw -5
    movlw 0xFB
    movlw .251
    movlw b'11111011'
   
VALUE_TRANSFER_TO_DATA_MEMORY
 
    ; move literal 1 to WREG.  1 -> W
    movlw 1    
    
    ; 'MOV'e value of 'W'orking regisrer to 'F'ile register 0x20  W -> f
    movwf 0x20
 
    ; move literal 0 to WREG.  0 -> W
    movlw 0
    
    ; move value of working register to f[20h].  W -> f[20h]
    movwf 0x20
    
VALUE_TRANSFER_FROM_DATA_MEMORY
        
    movlw 1      ; 1 -> W
    movwf 0x20   ; W -> f[20h]
    
    ; 'MOV'e value of 'F'ile register 0x20 to WREG.  f[20h] -> W 
    ; 0:WREG  1:f 
    movf 0x20,0   ; destination WREG
    movf 0x20,w   ; destination WREG
    movf 0x20     ; destination WREG
    
    ; move value of file register 0x20 to file register 0x20.  f[20h] -> f[20h] 
    ; 0:WREG  1:f 
    movf 0x20,1   ; destination f[20h]
    movf 0x20,f   ; destination f[20h]

    ; movf affects the 'Zero' flag
    movlw 0       ; 1 -> W 
    movwf 0x20    ; W -> f[20h]
    movf  0x20,f  ; f[20h] -> f[20h]
   

    ;------------------------------
    
    ; STATUS Register f[3] -> W
    movf 3,w

    ; change STATUS Register value. FFh -> W -> f[3]
    movlw b'11111111'
    movwf 3
    
;-------------------------------------------------------------------------------

STATUS_REGISTER
   
    ; zero WREG 
    movlw 0
   
    ; move value of the status register f[3] to WREG
    movf  3 
   
    ; zero WREG
    movlw 0
   
    ; move WREG to status register f[3]. Clear all changeable flags of the status register 
    movwf 3
   
    ; set all changeable flags of the status register f[3]
    movlw b'11111111'
    movwf STATUS

    ; clear all changeable flags of the status register f[3]
    movlw 0
    movwf STATUS
  
;-------------------------------------------------------------------------------

BASIC_BIT_MANIPULATION_1

    ; do "AND" operation on WREG content with the literal value
    movlw b'11110000'
    andlw b'00001111'

    ; clearing bits with and-mask 
    movlw b'10011111'
    andlw b'11111011'
   
    ; do "INCLUSIVE OR" operation on WREG content with the literal value
    movlw b'11110000'
    iorlw b'00001111'

    ; setting bits with the or-mask
    movlw b'11110001'
    iorlw b'00000100'

    ;---------------------
   
    ; set all status bits 
    movlw b'11111111'
    movwf STATUS
   
    ; clear bit 0 (Carry flag) with the and-mask
    movlw b'11111110'
    andwf STATUS,w
    movwf STATUS

    ; set bit 0 (Carry flag) with the or-mask
    movlw b'00000001'
    iorwf STATUS,w
    movwf STATUS   
  
    ;---------------------
   
    ; 'B'it 'C'lear 'F'ile register bit 0
    bcf STATUS, 0
   
    ; 'B'it 'S'et 'F'ile register bit 0
    bsf STATUS, 0
   
    ; Bit Set File register STATUS (f[3]) Zero flag (bit 0) = 1
    bcf STATUS, 0
   
    ; Bit Clear File register STATUS (f[3]) Zero flag (bit 1) = 0
    bcf STATUS, 0
      
   ; ---------------------
   
    ; move does not affects Zero flag
    bcf STATUS, 3
    movlw 0
    movlw 0xFF
   
    ; clear affects (sets) the Zero flag (Z = 1)
    clrw
   
    ; Z = 0
    bcf STATUS, 3

    ; clear file register affects (sets) the Zero flag (Z=1)
    clrf 0x20
   
;-------------------------------------------------------------------------------

FLAGS    
    ; Setting and clearing ALU FLAGS: Carry, DigitCarry, Zero 

    movlw b'11111111'
    movwf STATUS
    
    ; clear flag bits C, DC, Z keep the rest
    movlw b'11111000'
    andwf STATUS,w
    movwf STATUS
    
    ; set flag bits C, DC, Z keep the rest
    movlw b'00000111'
    iorwf STATUS,w
    movwf STATUS

    ; clear flag bits with bit clear C, DC, Z
    bcf STATUS, 0
    bcf STATUS, 1
    bcf STATUS, 2
    
    ; set flag bits with bit set C, DC, Z
    bsf STATUS, C
    bsf STATUS, DC
    bsf STATUS, Z
      
;-------------------------------------------------------------------------------  
   
FILE_BANKS_AND_BANK_ACCESS    
  
    movlw b'00000000'
    movwf STATUS
    
    movlw 1
    movwf 0x20

    bsf STATUS, 5
    
    movlw 2
    movwf 0x20

    bsf STATUS, 6
    bcf STATUS, 5
    
    movlw 3
    movwf 0x20

    bsf STATUS, 6
    bsf STATUS, 5
    
    movlw 4
    movwf 0x20
    
;--------------------- 
    
    ; BANK 0
    bcf STATUS, RP1
    bcf STATUS, RP0

    movlw 11h
    movwf 0x20
    
    ; BANK 1
    bcf STATUS, RP1
    bsf STATUS, RP0

    movlw 22h
    movwf 0x20

    ; BANK 2
    bsf STATUS, RP1
    bcf STATUS, RP0

    movlw 33h
    movwf 0x20
    
    ; BANK 3
    bsf STATUS, RP1
    bsf STATUS, RP0
    
    movlw 44h
    movwf 0x20
    
;-------------------------------------------------------------------------------

BANK_EXPERIMENT
    
    ; select bank 0. RP<6:5> = 00
    bcf STATUS, RP1
    bcf STATUS, RP0
    
    ; fill bank local memory with B0
    movlw h'B0'
    movwf 0x20
    movwf 0x21
    movwf 0x22
    movwf 0x23
    movwf 0x24
    movwf 0x25
    movwf 0x26
    movwf 0x27

    ; mark last byte of bank0
    movlw h'0E'
    movwf 0x6F

    ; select bank 1. RP<6:5> = 01
    bcf STATUS, RP1
    bsf STATUS, RP0

    ; fill bank local memory with B1
    movlw h'B1'
    movwf 0x20
    movwf 0x21
    movwf 0x22
    movwf 0x23
    movwf 0x24
    movwf 0x25
    movwf 0x26
    movwf 0x27

    ; mark last byte of bank1
    movlw 0x1E
    movwf 0xEF
    
    ; select bank 2. RP<6:5> = 10
    bsf STATUS, RP1
    bcf STATUS, RP0
    
    ; fill bank local memory with B2
    movlw h'B2'
    movwf 0x20
    movwf 0x21
    movwf 0x22
    movwf 0x23
    movwf 0x24
    movwf 0x25
    movwf 0x26
    movwf 0x27

    ; mark last byte of bank2
    movlw h'2E'
    movwf 0x16F
    
    ; select bank 3 RP<6:5> = 11
    bsf STATUS, RP1
    bsf STATUS, RP0
    
    ; fill bank local memory with B3
    movlw h'B3'
    movwf 0x20
    movwf 0x21
    movwf 0x22
    movwf 0x23
    movwf 0x24
    movwf 0x25
    movwf 0x26
    movwf 0x27

    ; mark last byte of bank3
    movlw h'3E'
    movwf 0x1EF
    
    ;----------------------------------
    
    ; interbank shared (global) memory
    movlw h'AA'
    movwf 0x70
    movwf 0x71
    movwf 0x72
    movwf 0x73
    movwf 0x74
    movwf 0x75
    movwf 0x76
    movwf 0x77
    movwf 0x78
    movwf 0x79
    movwf 0x7A
    movwf 0x7B
    movwf 0x7C
    movwf 0x7D
    movwf 0x7E
    movwf 0x7F
   
;-------------------------------------------------------------------------------
    
    ; ? purpose ? 
    bcf 3, 6
    bcf 3, 5
    
BASIC_BIT_MANIPULATION_2
    
    movlw b'10101010'
    movwf 0x20
    
    ; COMPLEMENT bits of 'F'ile register 
    comf 0x20
    movf 0x20,w
    
    comf 0x20
    movf 0x20,w

    ;----------------
    
    movlw b'11110000'
    xorlw b'00001111'

    movlw b'00000000'
    xorlw b'00000000'

    movlw b'11111111'
    xorlw b'11111111'

    movlw b'00000000'
    xorlw b'11111111'
    
    ;----------------
    
    movlw b'10101010'
    xorlw b'11111111'

    xorlw b'11111111'
    xorlw 0xFF
    xorlw .255
    
    ; XORLW 0xFF -> poormans "COMW" :) 

;-------------------------------------------------------------------------------

INDIRECT_ADDRESSING 
    
    ; select bank0 ( clear STATUS bits RP<6:5> = 00 )
    bcf 3,6
    bcf 3,5

    ; clear File Select Register
    clrf FSR
    
    ; put target memory address start 0x20 into FSR
    movlw 0x20
    movwf FSR
    ; value to fill 
    movlw h'CC'
    
    ; fill loop (loops 16 times)
NEXT
    movwf INDF
    incf  FSR
    btfss FSR, 4   ; 2^4 -> 16
    goto  NEXT 

    ; step back and clear WREG
    decf FSR
    clrw
    
    ; indirect read from INDF (result in WREG) (w:0)
    movf INDF,0

    ; same as above (w:0)
    clrw
    movf INDF,w
    
    ; no effect on WREG, but sets the Zero flag
    clrw
    movf INDF    

    ; same as above (f:1)
    clrw
    movf INDF,1    
    
    ; same as above (f:1)
    clrw
    movf INDF,f    
    
;-------------------------------------------------------------------------------

COMPARE_USING_SUB
    
    ; reset flags C, DC, Z
    bcf STATUS, C
    bcf STATUS, DC
    bcf STATUS, Z
    
IS_EQUAL ; ? RAM[20h] == WREG  ( 5 == 5 )  ->  5 - 5
    ; compare literal 5 with RAM(20) value 5 for equality
    movlw 5
    movwf 0x20
    movlw 5
    subwf 0x20,w
    
    ; check Z flag, if set skip the next instruction
    btfss STATUS, Z
    goto  NOT_EQUAL
    ; YES IT IS EQUAL
    nop
    nop
    nop
    goto CONTINUE_A
    
NOT_EQUAL    
    ; NO IT IS NOT EQUAL
    nop
    nop
    nop
 
;-------------------------------------------------------------------------------    
    
CONTINUE_A    
    ; reset flags C, DC, Z
    bcf STATUS, C
    bcf STATUS, DC
    bcf STATUS, Z
    
IS_GREATER ; ? RAM[20h] > WREG  ( 6 < 5 )  ->  6 - 5
    movlw 6
    movwf 0x20 
    movlw 5
    subwf 0x20,w

    ; check C flag, if set skip the next instruction
    btfss STATUS, C
    goto  NOT_GREATER
    ; YES IT IS GREATER
    nop
    nop
    nop
    goto CONTINUE_B
    
NOT_GREATER
    nop
    nop
    nop

;-------------------------------------------------------------------------------    

CONTINUE_B    
    ; reset flags C, DC, Z 
    bcf STATUS, C
    bcf STATUS, DC
    bcf STATUS, Z

IS_LESS ; ? RAM[20h] < WREG  ( 5 < 6 )  ->  5 - 6
    movlw 5
    movwf 0x20 
    movlw 6
    subwf 0x20,w

    ; check C flag, if clear skip the next instruction
    btfsc STATUS, C
    goto  NOT_LESS
    ; YES IT IS LESS
    nop
    nop
    nop
    goto CONTINUE_C
    
NOT_LESS
    nop
    nop
    nop

;-------------------------------------------------------------------------------
    
CONTINUE_C 

    movlw 5    
    movwf rA
    
    movlw 5    
    movwf rB
    
    movlw 0

    ; result code returns inside the WREG after the call.
    ; 0: rA and rB are equal,
    ; 1: rA greater than rB,
    ; 2: rB greater than rA   
    call  COMPARE    
    nop
    nop
    nop
    
;-------------------------------------------------------------------------------    

COMPARE    
    movf  rA,w
    subwf rB,w
   
    btfsc STATUS, Z
    goto  AB_EQUAL
   
    btfsc STATUS, C
    goto  B_GREATER
   
A_GREATER
    retlw 1
   
AB_EQUAL
    retlw 0
   
B_GREATER
    retlw 2
   
;-------------------------------------------------------------------------------    
   
    ; reset flags C, DC, Z keep the rest
    bcf STATUS, C
    bcf STATUS, DC
    bcf STATUS, Z
        
    nop
    nop
    nop
   
;-------------------------------------------------------------------------------

SWAP

    movlw 0xAB
    movwf 0x20

    swapf 0x20       
    swapf 0x20       

    swapf 0x20,f     
    swapf 0x20,w    

;-------------------------------------------------------------------------------
    
TEST_CONTEXT_SAVING      ;http://www.microchip.com/forums/m217951.aspx

    movwf W_TEMP         ;copy W to temp register,could be in either bank
    swapf STATUS,w       ;swap status to be saved into W
    bcf   STATUS,RP0     ;change to bank 0 regardless of current bank
    movwf STATUS_TEMP    ;save status to bank 0 register
   
    ; interupt code 
    
    swapf STATUS_TEMP,w  ;swap STATUS_TEMP register into W, sets bank to original state
    movwf STATUS         ;move W into STATUS register
    swapf W_TEMP,f       ;swap W_TEMP
    swapf W_TEMP,w       ;swap W_TEMP into W
    
    
    ;different approach almost the same as above 
    
    movwf W_TEMP         ;copy W to temp register,could be in either bank
    movf  STATUS,w       ;w gets virgin copy of STATUS, which changes after being copied
    bcf   STATUS,RP0     ;change to bank 0 regardless of current bank
    movwf STATUS_TEMP    ;save status to bank 0 register
   
    ; interupt code 
    
    movf  STATUS_TEMP,w  ;put original copy of STATUS into W
    movwf STATUS         ;move W into STATUS register
    swapf W_TEMP,f       ;swap W_TEMP
    swapf W_TEMP,w       ;swap W_TEMP into W
 
;-------------------------------------------------------------------------------
    
TEST_TMR0_AND_OPTION
    ; select bank0 RP<6:5> = 00
    bcf 3,6
    bcf 3,5
    ; set TMR0 11
    movlw 0x11
    movwf 1;TMR0 

    ; select bank2 RP<6:5> = 10
    bsf 3,6
    bcf 3,5
    ; set TMR0 22
    movlw 0x22
    movwf 1;TMR0 
    
    ; select bank1 RP<6:5> = 01
    bcf 3,6
    bsf 3,5
    ; set OPTION 33
    movlw 0x33
    movwf 1;OPTION_REG 

    ; select bank3 RP<6:5> = 11
    bsf 3,6
    bsf 3,5
    ; set OPTION 44
    movlw 0x44
    movwf 1;OPTION_REG 
  
TEST_PORT_A    
    ; select reg. page 1  RP<6:5> = 01
    bcf STATUS,6   
    bsf STATUS,5
    ; clear TRISA bits ( configure PORTA pins as output)
    clrf TRISA

    ; select reg. page 0 RP<6:5> = 00
    bcf 3,6
    bcf 3,5

    movlw b'0000'
    movf PORTA

    movlw b'1111'
    movf PORTA

END