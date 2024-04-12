variable arr
9 cells allot
'.' arr 1 cells + !
'1' arr 2 cells + !
'1' arr 4 cells + !
'2' arr 7 cells + !
'3' arr 0 cells + !
'4' arr 3 cells + !
'5' arr 5 cells + !
'6' arr 8 cells + !
'9' arr 6 cells + !

: print_arr 9 0 begin arr over cells + @ emit 1 + over over = until ;
print_arr
