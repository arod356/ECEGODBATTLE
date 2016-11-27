; Print.s
; Student names: change this to your names or look very silly
; Last modification date: change this to the last modification date or look very silly
; Runs on LM4F120 or TM4C123
; EE319K lab 7 device driver for any LCD
;
; As part of Lab 7, students need to implement these LCD_OutDec and LCD_OutFix
; This driver assumes two low-level LCD functions
; ST7735_OutChar   outputs a single 8-bit ASCII character
; ST7735_OutString outputs a null-terminated string 

n 				EQU 0			
asterisk		EQU 4
period			EQU 8
asteriskSt		EQU 1
periodSt		EQU 2
	
    IMPORT   ST7735_OutChar
    IMPORT   ST7735_OutString
    EXPORT   LCD_OutDec
    EXPORT   LCD_OutFix

    AREA    |.text|, CODE, READONLY, ALIGN=2
    THUMB
	PRESERVE8

  

;-----------------------LCD_OutDec-----------------------
; Output a 32-bit number in unsigned decimal format
; Input: R0 (call by value) 32-bit unsigned number
; Output: none
; Invariables: This function must not permanently modify registers R4 to R11
LCD_OutDec
		PUSH {R4,LR}				;save registers AAPCS
		SUB SP, SP, #4				;allocate
		MOV R4, SP					;stack frame pt
		MOV R1, #10 
		STR R0, [R4, #n]			;n=input
		;MOV R5, #0					;counter
		LDR R0, [R4, #n]
check	CMP R0, R1					;n<10?
		BLO out
		
		UDIV R2, R0, R1				;n/10
		MUL R3, R2, R1				
		SUB R3, R0, R3				;modulo
		MOV R0, R2					;outdec(n/10)
		BL LCD_OutDec
		LDR R0, [R4, #n]			;base case
		MOV R1, #10
		UDIV R2, R0, R1				;n/10
		MUL R3, R2, R1				
		SUB R3, R0, R3				;modulo
		ADD R0, R3, #0x30
		BL 	ST7735_OutChar
		B done

out 	ADD R0, R0, #0x30
		BL 	ST7735_OutChar
done	ADD SP, SP, #4				;deallocate 1 word
		POP {R4, PC}
		BX  LR

      BX  LR
;* * * * * * * * End of LCD_OutDec * * * * * * * *

; -----------------------LCD _OutFix----------------------
; Output characters to LCD display in fixed-point format
; unsigned decimal, resolution 0.001, range 0.000 to 9.999
; Inputs:  R0 is an unsigned 32-bit number
; Outputs: none
; E.g., R0=0,    then output "0.000 "
;       R0=3,    then output "0.003 "
;       R0=89,   then output "0.089 "
;       R0=123,  then output "0.123 "
;       R0=9999, then output "9.999 "
;       R0>9999, then output "*.*** "
; Invariables: This function must not permanently modify registers R4 to R11
LCD_OutFix
		PUSH {R4-R6,LR}				;save registers AAPSC
		SUB SP, SP, #12				;allocate 3 word
		MOV R4, SP					;stack frame pt
		STR R0, [R4, #n]			;x=input
		MOV R5, #0x2A				;*
		STR R5, [R4, #asterisk]
		MOV R5, #0x2E				;.
		STR R5, [R4, #period]
		MOV R5, #0					;counter
		LDR R0, [R4, #n]
		MOV R1, #9999
		CMP R0, R1
		BHS max
		MOV R1, #1000 
		UDIV R2, R0, R1				;x/1000 = R2
		MUL R3, R2, R1				
		SUB R5, R0, R3				;modulo	= R3
		ADD R0, R2, #0x30
		BL 	ST7735_OutChar
		LDR R0, =0x2E
		BL 	ST7735_OutChar			;output decimal point
		MOV R1, #100
		MOV R0, R5					;x=remainder
		UDIV R2, R0, R1				;x/100
		MUL R3, R2, R1				
		SUB R5, R0, R3				;modulo	
		ADD R0, R2, #0x30			
		BL 	ST7735_OutChar
		MOV R0, R5					;x=remainder
		MOV R1, #10
		UDIV R2, R0, R1				;x/10
		MUL R3, R2, R1				
		SUB R5, R0, R3				;modulo	
		ADD R0, R2, #0x30			
		BL 	ST7735_OutChar
		MOV R0, R5					;x=remainder
		MOV R1, #1
		UDIV R2, R0, R1				;x/1
		MUL R3, R2, R1				
		SUB R5, R0, R3				;modulo	
		ADD R0, R2, #0x30
		BL 	ST7735_OutChar
		ADD SP, SP, #12				;deallocate
		POP {R4-R6, PC}
		BX  LR
		
max		LDR R0, [R4, #asterisk]		;output *.*** because I'm too stupid to use OutString
		BL ST7735_OutChar
		LDR R0, [R4, #period]
		BL ST7735_OutChar
		LDR R0, [R4, #asterisk]
		BL ST7735_OutChar
		LDR R0, [R4, #asterisk]
		BL ST7735_OutChar
		LDR R0, [R4, #asterisk]
		BL ST7735_OutChar
		ADD SP, SP, #12				;deallocate
		POP {R4-R6, PC}
		BX  LR
     BX   LR
 
     ALIGN
;* * * * * * * * End of LCD_OutFix * * * * * * * *

     ALIGN                           ; make sure the end of this section is aligned
     END                             ; end of file
