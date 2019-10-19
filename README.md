# LC3-Trap-x26
LC-3 (Little Computer Third Version) was developed by Yale N. Patt at the University of Texas at Austin and Sanjay J. Patel at the University of Illinois at Urbana–Champaign. The LC-3 specifies a word size of 16 bits for its registers and uses a 16-bit addressable memory with a 216-location address space. The register file contains eight registers, referred to by number as R0 through R7. All data in the LC-3 is assumed to be stored in a two's complement representation; there is no separate support for unsigned arithmetic. The I/O devices operate on ASCII characters. The LC-3 has no native support for floating-point numbers.

This program uses assembly language, and LC-3 has altogether 15 operation codes (0000 to 1111, in which opcode 1101 is undefined)

LC-3 has 6 predesigned TRAPs (TRAP x20 to x25). A TRAP is a subroutine that can be called by the caller. For instance, TRAP x20, or GETC, reads a single character from the keyboard. The character is not echoed onto the console. Its ASCII code is copied into R0. The high eight bits of R0 are cleared.

This TRAP x26 is a TRAP designed by Hunan Old Zhang, which prints 2’s complement number in decimal stored in R0.

In fill x26.asm, we fill x0520 into the address x0026. We don't have to use JSR to make PC jump to a specific address; we only fill it some address and PC will be directed into that (the micro-architecture of LC-3 about addresses x0000 to x0100 is designed in this way) Also, x0000 to x0FFF is called the TRAP vector table, in which all the TRAP subroutines and specific TRAP instructions are within these addresses. 

At address x0520, TRAP x26.asm performs the task of printing 2’s complement number in decimal stored in R0. Using the callee-saved approach, it stores all registers that will be modified in the subroutine and load them back before the subroutine finishes. It then determines if R0 is negaitve or not to decide whether to print a '-' character. (One thing to note is that within TRAP x26, we called TRAP x21, or OUT, to print the value stored in R0. TRAP x21 uses the polling method including the usage of Data Status Register (DSR) and Data Display Register (DDR).) The basic algorithm using stack is as follows:

Algorithm
1) Divide value stored in R3 by 10. Store quotient in R3 and push remainder to stack.
2) If quotient (value in R3) is not 0, go to step 1
3) Pop values off the stack one at a time till the stack is empty.

Stack starts at x4000 and ends at x3FF0, which means the first available spot on the stack is at x4000 and the last
available spot at x3FF0.

In the main function call trap x26.asm, it simply stores the decimal value of -1999 in R0 and calls TRAP x26. 
By calling the TRAP, -1999 will be echoed onto the display console.
