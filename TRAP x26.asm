;number to print in decimal (base 10) is in R0.
.ORIG 	x0520
;save all registers
		ST		R0,SAVE_R0
		ST		R1,SAVE_R1
		ST		R2,SAVE_R2
		ST		R3,SAVE_R3
		ST		R4,SAVE_R4
		ST		R5,SAVE_R5
		ST		R7,SAVE_R7
;your program starts here
		ADD 	R3,R0,#0	; R3 <- R0
;check if number is negative. If so, print a '-' first
		BRn  	PT_NEG
AGIA	AND		R4,R4,#0
		ADD		R4,R4,#10
		JSR		DIV
		ADD		R0,R0,#0
		BRz		PRINT
		ADD		R3,R0,#0
		ADD		R0,R1,#0
		JSR		PUSH
		BRnzp	AGIA
; functionality of PT_NEG: If R0 < 0, print '-' and set R3 to be positive
PT_NEG	LD		R0,ASCII_NEG
		OUT
		NOT		R3,R3
		ADD		R3,R3,#1
		BRnzp	AGIA
PRINT	ADD		R0,R1,#0
		JSR		PUSH
HERE	LD		R1,STACK_TOP
		LD		R2,STACK_START
		NOT		R2,R2
		ADD		R2,R2,#1
		ADD		R3,R2,R1
		BRz		DONE
		JSR		POP
		LD		R2,ASCII_0
		ADD		R0,R2,R0
		OUT
		BRnzp	HERE
;load all registers
DONE	LD		R0,SAVE_R0
		LD		R1,SAVE_R1
		LD		R2,SAVE_R2
		LD		R3,SAVE_R3
		LD		R4,SAVE_R4
		LD		R5,SAVE_R5
		LD		R6,SAVE_R6
		LD		R7,SAVE_R7
		RET
ASCII_0 	.FILL x30
ASCII_NEG   .FILL x2D
SAVE_R0		.BLKW #1
SAVE_R1		.BLKW #1
SAVE_R2		.BLKW #1
SAVE_R3		.BLKW #1
SAVE_R4		.BLKW #1
SAVE_R5		.BLKW #1
SAVE_R7		.BLKW #1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;input R3, R4 (R3/R4)
;out R0-quotient, R1-remainder
DIV
	ST R2,DIV_R2
	ST R3,DIV_R3
	NOT R2,R4
	ADD R2,R2,#1
	AND R0,R0,#0
	ADD R0,R0,#-1
DIV_LOOP	
	ADD R0,R0,#1
	ADD R3,R3,R2
	BRzp DIV_LOOP
	ADD R1,R3,R4
	LD R2,DIV_R2
	LD R3,DIV_R3
	RET

DIV_R2 .BLKW #1
DIV_R3 .BLKW #1


;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH	
	ST R3, PUSH_SaveR3	;save R3
	ST R4, PUSH_SaveR4	;save R4
	AND R5, R5, #0		;
	LD R3, STACK_END	;
	LD R4, STACK_TOP	;
	ADD R3, R3, #-1		;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz OVERFLOW		;stack is full
	STR R0, R4, #0		;no overflow, store value in the stack
	ADD R4, R4, #-1		;move top of the stack
	ST R4, STACK_TOP	;store top of stack pointer
	BRnzp DONE_PUSH		;
OVERFLOW
	ADD R5, R5, #1		;
DONE_PUSH
	LD R3, PUSH_SaveR3	;
	LD R4, PUSH_SaveR4	;
	RET


PUSH_SaveR3	.BLKW #1	;
PUSH_SaveR4	.BLKW #1	;


;OUT: R0, OUT R5 (0-success, 1-fail/underflow)
;R3 STACK_START R4 STACK_TOP
;
POP	
	ST R3, POP_SaveR3	;save R3
	ST R4, POP_SaveR4	;save R3
	AND R5, R5, #0		;clear R5
	LD R3, STACK_START	;
	LD R4, STACK_TOP	;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz UNDERFLOW		;
	ADD R4, R4, #1		;
	LDR R0, R4, #0		;
	ST R4, STACK_TOP	;
	BRnzp DONE_POP		;
UNDERFLOW
	ADD R5, R5, #1		;
DONE_POP
	LD R3, POP_SaveR3	;
	LD R4, POP_SaveR4	;
	RET


POP_SaveR3	.BLKW #1	;
POP_SaveR4	.BLKW #1	;
STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;

.END
