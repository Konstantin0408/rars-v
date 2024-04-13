##
# Variables and constants
##

.eqv FORTH_VERSION, 3

.eqv CELL, 4                            
.eqv RAM_BASE, 0x10301000               
.eqv STACK_SIZE, 256                    
.eqv ALIGN_TO_CELL, .align 2


##
# Memory map
##

# DSP, RSP, TIB stacks grow downward from the top of memory
.eqv CSP_TOP, 0x10208100                
.eqv DSP_TOP, 0x10208000                
.eqv RSP_TOP, 0x10207f00                
.eqv TIB_TOP, 0x10207e00                
.eqv TIB,     0x10207d00     

.eqv REAL_SP  0x7fffeffc
           

# variables
.eqv STATE,       0x10207cfc                
.eqv TOIN,        0x10207cf8          # end of current token relative to TIB     
.eqv HERE,        0x10207cf4                
.eqv LATEST,      0x10207cf0                
.eqv NOOP,        0x10207cec                
.eqv PAD,         0x103f1000                

.eqv SAVE_A0,     0x10200004
.eqv SAVE_A1,     0x10200008
.eqv SAVE_LINK_A1 0x1020000c

.eqv SKIP_BRANCH, 0x10200010

.eqv IF_ADDRESS,  0x10200014
.eqv ELSE_ADDRESS 0x10200018
.eqv THEN_ADDRESS 0x1020001c

.eqv SAVE_CURRLP  0x10200020
.eqv SAVE_DOJUMP  0x10200024

.eqv ARG_COUNT,   0x10201000
.eqv ARGS,        0x10201004
.eqv CURRENT_ARG, 0x10201008
.eqv CURR_FILEDSC 0x1020100c


# dictionary grows upward from the RAM base address


##
# Characters
##

.eqv CHAR_NEWLINE, 0x0a          
.eqv CHAR_CARRIAGE, 0x0d         
.eqv CHAR_SPACE, 0x20            
.eqv CHAR_BACKSPACE, 0x08        
.eqv CHAR_COMMENT, 0x5c          
.eqv CHAR_COMMENT_OPARENS, 0x28  
.eqv CHAR_COMMENT_CPARENS, 0x29  
.eqv CHAR_MINUS, 0x2d 
.eqv CHAR_UPPERCASE_A, 0x41
.eqv CHAR_UPPERCASE_Z, 0x5a
.eqv CASE_DIFFERENCE, 0x20
