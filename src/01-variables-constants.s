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
.eqv DSP_TOP, 0x10208000                
.eqv RSP_TOP, 0x10207f00                
.eqv TIB_TOP, 0x10207e00                
.eqv TIB,     0x10207d00                

# variables
.eqv STATE,   0x10207cfc                
.eqv TOIN,    0x10207cf8                
.eqv HERE,    0x10207cf4                
.eqv LATEST,  0x10207cf0                
.eqv NOOP,    0x10207cec                
.eqv PAD,     0x10307bec                

.eqv REAL_SP  0x7fffeffc

# dictionary grows upward from the RAM base address
.eqv FORTH_SIZE, 0x00006bec             

.eqv SAVE_A0,     0x10200004
.eqv SAVE_A1,     0x10200008

.eqv SAVE_LINK_A1 0x1020000c

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